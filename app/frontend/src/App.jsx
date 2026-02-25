import { useEffect, useMemo, useState } from "react";

const API_BASE_URL = import.meta.env.VITE_API_BASE_URL || "";

async function parseJsonResponse(response) {
  if (response.status === 204) {
    return null;
  }
  const data = await response.json();
  if (!response.ok) {
    throw new Error(data.error || "Request failed");
  }
  return data;
}

export default function App() {
  const [tasks, setTasks] = useState([]);
  const [title, setTitle] = useState("");
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");

  const pendingCount = useMemo(() => tasks.filter((task) => !task.done).length, [tasks]);

  async function loadTasks() {
    setLoading(true);
    setError("");
    try {
      const response = await fetch(`${API_BASE_URL}/api/tasks`);
      const data = await parseJsonResponse(response);
      setTasks(data);
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  }

  useEffect(() => {
    loadTasks();
  }, []);

  async function addTask(event) {
    event.preventDefault();
    const nextTitle = title.trim();
    if (!nextTitle) {
      return;
    }

    try {
      const response = await fetch(`${API_BASE_URL}/api/tasks`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ title: nextTitle }),
      });
      const created = await parseJsonResponse(response);
      setTasks((prev) => [created, ...prev]);
      setTitle("");
    } catch (err) {
      setError(err.message);
    }
  }

  async function toggleDone(task) {
    try {
      const response = await fetch(`${API_BASE_URL}/api/tasks/${task.id}`, {
        method: "PATCH",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ done: !task.done }),
      });
      const updated = await parseJsonResponse(response);
      setTasks((prev) => prev.map((item) => (item.id === updated.id ? updated : item)));
    } catch (err) {
      setError(err.message);
    }
  }

  async function removeTask(taskId) {
    try {
      const response = await fetch(`${API_BASE_URL}/api/tasks/${taskId}`, {
        method: "DELETE",
      });
      await parseJsonResponse(response);
      setTasks((prev) => prev.filter((item) => item.id !== taskId));
    } catch (err) {
      setError(err.message);
    }
  }

  return (
    <main className="page">
      <section className="card">
        <h1>3-Tier Task App</h1>
        <p className="subtitle">
          React frontend + Python API + PostgreSQL on AWS RDS
        </p>

        <form onSubmit={addTask} className="task-form">
          <input
            type="text"
            value={title}
            onChange={(event) => setTitle(event.target.value)}
            placeholder="Add a task"
            maxLength={120}
          />
          <button type="submit">Add</button>
        </form>

        <div className="meta">
          <span>Total: {tasks.length}</span>
          <span>Pending: {pendingCount}</span>
          <button type="button" onClick={loadTasks}>Refresh</button>
        </div>

        {loading ? <p>Loading tasks...</p> : null}
        {error ? <p className="error">{error}</p> : null}

        <ul className="list">
          {tasks.map((task) => (
            <li key={task.id} className={task.done ? "done" : ""}>
              <label>
                <input
                  type="checkbox"
                  checked={task.done}
                  onChange={() => toggleDone(task)}
                />
                <span>{task.title}</span>
              </label>
              <button type="button" onClick={() => removeTask(task.id)}>
                Delete
              </button>
            </li>
          ))}
        </ul>
      </section>
    </main>
  );
}
