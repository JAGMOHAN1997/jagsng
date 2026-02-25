# 3-Tier Sample Application

Simple reference app aligned to your Terraform infra:
- Frontend: React (Vite)
- Backend: Python (Flask)
- Data tier: PostgreSQL (AWS RDS in deployment)

## Structure

- `backend/`: Flask API for task CRUD
- `frontend/`: React UI calling the API
- `docker-compose.yml`: local dev stack (uses local Postgres)

## Backend API

- `GET /health`
- `GET /api/tasks`
- `POST /api/tasks`
- `PATCH /api/tasks/:id`
- `DELETE /api/tasks/:id`

## Run locally (Docker)

From `app/`:

```bash
docker compose up --build
```

- Frontend: `http://localhost:5173`
- Backend: `http://localhost:8000`

## Run with AWS RDS

Use these backend env vars (map from Terraform outputs/values):

- `DB_HOST` -> RDS endpoint
- `DB_PORT` -> `5432`
- `DB_NAME` -> DB name
- `DB_USER` -> DB username
- `DB_PASSWORD` -> DB password
- `DB_SSLMODE` -> `require`

Or set a single `DATABASE_URL`.

Example:

```text
DATABASE_URL=postgresql://adminuser:<password>@<rds-endpoint>:5432/appdb?sslmode=require
```

## Frontend env var

- `VITE_API_BASE_URL` -> backend base URL (for example ALB URL)

Example:

```text
VITE_API_BASE_URL=http://<alb-dns-name>
```
