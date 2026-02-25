from __future__ import annotations

import os
import time
from contextlib import closing
from typing import Any

import psycopg2
from flask import Flask, jsonify, request
from flask_cors import CORS


def build_db_config() -> dict[str, Any]:
    database_url = os.getenv("DATABASE_URL")
    if database_url:
        return {"dsn": database_url}

    return {
        "host": os.getenv("DB_HOST", "localhost"),
        "port": int(os.getenv("DB_PORT", "5432")),
        "dbname": os.getenv("DB_NAME", "appdb"),
        "user": os.getenv("DB_USER", "appuser"),
        "password": os.getenv("DB_PASSWORD", "changeme"),
        "sslmode": os.getenv("DB_SSLMODE", "require"),
    }


def get_connection():
    return psycopg2.connect(**build_db_config())


def init_db() -> None:
    with closing(get_connection()) as conn:
        with conn, conn.cursor() as cur:
            cur.execute(
                """
                CREATE TABLE IF NOT EXISTS tasks (
                    id SERIAL PRIMARY KEY,
                    title TEXT NOT NULL,
                    done BOOLEAN NOT NULL DEFAULT FALSE,
                    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
                );
                """
            )


def wait_for_db() -> None:
    attempts = int(os.getenv("DB_CONNECT_RETRIES", "30"))
    delay_seconds = float(os.getenv("DB_CONNECT_DELAY_SECONDS", "2"))

    last_error = None
    for _ in range(attempts):
        try:
            with closing(get_connection()) as conn:
                with conn.cursor() as cur:
                    cur.execute("SELECT 1;")
                    cur.fetchone()
            return
        except Exception as exc:
            last_error = exc
            time.sleep(delay_seconds)

    raise RuntimeError(f"Database not reachable after {attempts} attempts: {last_error}")


def row_to_task(row):
    return {
        "id": row[0],
        "title": row[1],
        "done": row[2],
        "created_at": row[3].isoformat(),
    }


app = Flask(__name__)
CORS(app, resources={r"/api/*": {"origins": os.getenv("CORS_ORIGINS", "*").split(",")}})


@app.get("/health")
def health():
    try:
        with closing(get_connection()) as conn:
            with conn.cursor() as cur:
                cur.execute("SELECT 1;")
                cur.fetchone()
        return jsonify({"status": "ok"}), 200
    except Exception as exc:
        return jsonify({"status": "error", "detail": str(exc)}), 500


@app.get("/api/tasks")
def list_tasks():
    with closing(get_connection()) as conn:
        with conn.cursor() as cur:
            cur.execute(
                """
                SELECT id, title, done, created_at
                FROM tasks
                ORDER BY created_at DESC;
                """
            )
            rows = cur.fetchall()

    return jsonify([row_to_task(row) for row in rows]), 200


@app.post("/api/tasks")
def create_task():
    payload = request.get_json(silent=True) or {}
    title = (payload.get("title") or "").strip()
    if not title:
        return jsonify({"error": "title is required"}), 400

    with closing(get_connection()) as conn:
        with conn, conn.cursor() as cur:
            cur.execute(
                """
                INSERT INTO tasks (title)
                VALUES (%s)
                RETURNING id, title, done, created_at;
                """,
                (title,),
            )
            row = cur.fetchone()

    return jsonify(row_to_task(row)), 201


@app.patch("/api/tasks/<int:task_id>")
def update_task(task_id: int):
    payload = request.get_json(silent=True) or {}
    title = payload.get("title")
    done = payload.get("done")

    updates = []
    values = []

    if title is not None:
        title = str(title).strip()
        if not title:
            return jsonify({"error": "title cannot be empty"}), 400
        updates.append("title = %s")
        values.append(title)

    if done is not None:
        if not isinstance(done, bool):
            return jsonify({"error": "done must be boolean"}), 400
        updates.append("done = %s")
        values.append(done)

    if not updates:
        return jsonify({"error": "no valid fields to update"}), 400

    values.append(task_id)

    with closing(get_connection()) as conn:
        with conn, conn.cursor() as cur:
            cur.execute(
                f"""
                UPDATE tasks
                SET {", ".join(updates)}
                WHERE id = %s
                RETURNING id, title, done, created_at;
                """
                ,
                tuple(values),
            )
            row = cur.fetchone()

    if not row:
        return jsonify({"error": "task not found"}), 404

    return jsonify(row_to_task(row)), 200


@app.delete("/api/tasks/<int:task_id>")
def delete_task(task_id: int):
    with closing(get_connection()) as conn:
        with conn, conn.cursor() as cur:
            cur.execute("DELETE FROM tasks WHERE id = %s RETURNING id;", (task_id,))
            deleted = cur.fetchone()

    if not deleted:
        return jsonify({"error": "task not found"}), 404

    return "", 204


wait_for_db()
init_db()


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=int(os.getenv("PORT", "8000")))
