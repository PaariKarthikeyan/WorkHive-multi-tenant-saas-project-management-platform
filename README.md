# SaaS Project Management System

> Multi-tenant SaaS platform with role-based access control, attendance tracking, project/task management, leave approvals, and subscription billing.

![Version](https://img.shields.io/badge/version-1.0.0-blue)
![License](https://img.shields.io/badge/license-MIT-green)
![Node](https://img.shields.io/badge/node-v14+-brightgreen)
![MySQL](https://img.shields.io/badge/mysql-v5.7+-blue)

---

## Features

- **Multi-Tenant Architecture** — Isolated workspaces per organization
- **Role-Based Access Control** — Admin, Manager, Employee, Owner
- **Attendance Tracking** — Clock in/out with daily records
- **Leave Management** — Request, approve, and reject leaves
- **Project & Task Management** — Assign and track work
- **Notifications** — Real-time alerts
- **Subscription Billing** — Plan upgrades and management
- **Analytics** — Activity logs, metrics, monthly reports

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Runtime | Node.js v14+ |
| Framework | Express |
| Database | MySQL v5.7+ |
| Frontend | HTML5 + CSS3 + Alpine.js |
| Auth | JWT (jsonwebtoken) |
| Passwords | bcryptjs |
| Config | dotenv |
| Cross-Origin | CORS |

---

## Project Structure

```
saas-project/
├── backend/
│   ├── middleware/
│   │   ├── auth.js              # JWT verification
│   │   └── rbac.js              # Role-based access control
│   ├── routes/
│   │   ├── auth.js              # Login & Register
│   │   ├── admin.js             # Admin endpoints
│   │   ├── manager.js           # Manager endpoints
│   │   ├── employee.js          # Employee endpoints
│   │   ├── attendance.js        # Clock in/out, leave requests
│   │   ├── profile.js           # User profile
│   │   ├── owner.js             # SaaS owner routes
│   │   └── subscription.js      # Plan management
│   ├── server.js                # Main Express app entry point
│   ├── package.json             # Node dependencies
│   └── .env                     # ⚠️ YOU MUST CREATE THIS FILE (see below)
│
├── frontend/
│   ├── landing.html             # Home / marketing page
│   ├── login.html               # Login page
│   ├── register.html            # Sign up page
│   ├── dashboard.html           # Main app (all roles)
│   ├── profile.html             # Profile management
│   └── attendance.html          # Attendance page
│
└── database/
    ├── saas_pm_tenants.sql
    ├── saas_pm_roles.sql
    ├── saas_pm_teams.sql
    ├── saas_pm_team_members.sql
    ├── saas_pm_projects.sql
    ├── saas_pm_tasks.sql
    ├── saas_pm_task_files.sql
    ├── saas_pm_project_files.sql
    ├── saas_pm_notifications.sql
    ├── saas_pm_activity_logs.sql
    ├── saas_pm_leave_requests.sql
    ├── saas_pm_subscriptions.sql
    ├── saas_pm_billing_summary.sql
    ├── saas_pm_monthly_reports.sql
    ├── saas_pm_analytics_summary.sql
    ├── saas_pm_queries.sql
    ├── saas_pm_team_messages.sql
    └── saas_pm_tenant_metrics.sql
```

---

## Setting Up on a New PC

Follow these steps **in order**.

---

### Step 1 — Install Prerequisites

Download and install:

- **Node.js** (v14+) → https://nodejs.org
- **MySQL** (v5.7+) → https://dev.mysql.com/downloads/mysql/
- **Git** (optional) → https://git-scm.com

Verify installations:

```bash
node --version    # Must show v14.x.x or higher
npm --version     # Must show 6.x.x or higher
mysql --version   # Must show 5.7+ or 8.x
```

---

### Step 2 — Get the Project Files

```bash
git clone <your-repo-url> saas-project
cd saas-project
```

Or manually download and place all files in the folder structure shown above.

---

### Step 3 — Install Node Dependencies

```bash
cd backend
npm install
```

This installs Express, MySQL2, JWT, bcryptjs, dotenv, CORS, and all other packages listed in `package.json`.

---

### Step 4 — Create the `.env` File ⚠️

> **This step is required. The server will not start without it.**
> This file is never committed to Git — you must create it manually.

Create a file named `.env` inside the `backend/` folder:

```bash
# Windows
type nul > .env

# macOS / Linux
touch .env
```

Open `.env` in your editor and paste the following, replacing values where marked:

```env
# Server
PORT=3000
NODE_ENV=development

# Database (MySQL)
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=your_mysql_password_here       # ← CHANGE THIS
DB_NAME=saas_pm

# JWT Secret Key
# Generate one: node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"
JWT_SECRET=replace_with_a_long_random_string   # ← CHANGE THIS

# CORS (must match your frontend URL exactly)
CORS_ORIGIN=http://localhost:5500
```

**What to update:**

| Variable | What to set |
|----------|------------|
| `DB_PASSWORD` | Your MySQL root password |
| `JWT_SECRET` | A random 32+ character string |
| `DB_NAME` | Must be `saas_pm` (matches Step 5) |
| `CORS_ORIGIN` | `http://localhost:5500` or `http://127.0.0.1:5500` |

> ⚠️ Add `backend/.env` to your `.gitignore` so it is never committed.

---

### Step 5 — Create the Database

Open MySQL and run:

```sql
CREATE DATABASE saas_pm CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE saas_pm;
```

Then import all schema files from the `database/` folder:

```bash
cd database

# macOS / Linux — import all at once
for f in saas_pm_*.sql; do
  mysql -u root -p saas_pm < "$f"
done

# Windows — run each line individually
mysql -u root -p saas_pm < saas_pm_tenants.sql
mysql -u root -p saas_pm < saas_pm_roles.sql
mysql -u root -p saas_pm < saas_pm_teams.sql
mysql -u root -p saas_pm < saas_pm_team_members.sql
mysql -u root -p saas_pm < saas_pm_projects.sql
mysql -u root -p saas_pm < saas_pm_tasks.sql
mysql -u root -p saas_pm < saas_pm_task_files.sql
mysql -u root -p saas_pm < saas_pm_project_files.sql
mysql -u root -p saas_pm < saas_pm_notifications.sql
mysql -u root -p saas_pm < saas_pm_activity_logs.sql
mysql -u root -p saas_pm < saas_pm_leave_requests.sql
mysql -u root -p saas_pm < saas_pm_subscriptions.sql
mysql -u root -p saas_pm < saas_pm_billing_summary.sql
mysql -u root -p saas_pm < saas_pm_monthly_reports.sql
mysql -u root -p saas_pm < saas_pm_analytics_summary.sql
mysql -u root -p saas_pm < saas_pm_queries.sql
mysql -u root -p saas_pm < saas_pm_team_messages.sql
mysql -u root -p saas_pm < saas_pm_tenant_metrics.sql
```

Verify tables exist:

```bash
mysql -u root -p saas_pm -e "SHOW TABLES;"
```

---

### Step 6 — Start the Backend

Open **Terminal 1**:

```bash
cd backend
node server.js
```

Expected output:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 SaaS PM Server running
📡 http://localhost:3000
🌍 Environment: development
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

Verify it is alive:

```bash
curl http://localhost:3000/api/health
# → {"success":true,"message":"SaaS PM API is running"}
```

---

### Step 7 — Start the Frontend

Open **Terminal 2**:

```bash
cd frontend

# Option A — Python (easiest, no install needed)
python -m http.server 5500

# Option B — Node
npx http-server -p 5500

# Option C — VS Code
# Install "Live Server" extension → right-click landing.html → Open with Live Server
```

---

### Step 8 — Open the App

With both servers running, open your browser:

| Page | URL |
|------|-----|
| Landing | `http://localhost:5500/landing.html` |
| Register | `http://localhost:5500/register.html` |
| Login | `http://localhost:5500/login.html` |
| Dashboard | `http://localhost:5500/dashboard.html` |
| API Base | `http://localhost:3000/api` |

The first registered account automatically becomes **Admin**.

---

## API Endpoints

### Authentication (Public)

| Method | Endpoint | Description |
|--------|----------|-------------|
| `POST` | `/api/auth/register` | Create tenant + admin account |
| `POST` | `/api/auth/login` | Login, returns JWT token |
| `GET` | `/api/health` | Server health check |

### Attendance (JWT required)

| Method | Endpoint | Role |
|--------|----------|------|
| `POST` | `/api/attendance/clock-in` | Employee, Manager |
| `POST` | `/api/attendance/clock-out` | Employee, Manager |
| `GET` | `/api/attendance/my` | All roles |
| `GET` | `/api/attendance/team` | Manager, Admin |
| `GET` | `/api/attendance/all` | Admin |
| `POST` | `/api/attendance/leave-request` | Employee, Manager |
| `PATCH` | `/api/attendance/leave-request/:id` | Manager, Admin |
| `GET` | `/api/attendance/pending-leaves` | Manager, Admin |

### Admin (Admin JWT required)

| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/api/admin/users` | List all users |
| `GET` | `/api/admin/teams` | List all teams |
| `GET` | `/api/admin/projects` | List all projects |
| `GET` | `/api/admin/tasks` | List all tasks |
| `PATCH` | `/api/admin/user/:id/role` | Change user role |

### Profile & Subscriptions

| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/api/profile` | Get own profile |
| `PATCH` | `/api/profile` | Update own profile |
| `GET` | `/api/subscription` | Get current plan |

---

## Environment Variables Reference

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `PORT` | Backend port | `3000` | |
| `NODE_ENV` | Runtime mode | `development` | |
| `DB_HOST` | MySQL host | `localhost` | |
| `DB_PORT` | MySQL port | `3306` | |
| `DB_USER` | MySQL username | `root` | |
| `DB_PASSWORD` | MySQL password | — | ✅ |
| `DB_NAME` | Database name | `saas_pm` | ✅ |
| `JWT_SECRET` | JWT signing key (32+ chars) | — | ✅ |
| `CORS_ORIGIN` | Allowed frontend URL | `http://localhost:5500` | |

---

## Troubleshooting

### `Cannot find module 'express'`
You skipped `npm install`. Run:
```bash
cd backend && npm install
```

### `Error: connect ECONNREFUSED`
MySQL is not running or `.env` credentials are wrong. Test with:
```bash
mysql -u root -p -e "SELECT 1;"
```

### `405 Method Not Allowed` on API calls
Your frontend is calling the wrong port. All `fetch()` calls must point to `http://localhost:3000/api/...`, not port 5500. Set `API_BASE = "http://localhost:3000"` in your Alpine component.

### `Unexpected end of JSON input`
The server returned an error page (HTML) and the frontend tried to parse it as JSON. Add an `if (!r.ok)` check before calling `r.json()`.

### CORS error in browser
`CORS_ORIGIN` in `.env` must exactly match your frontend URL. VS Code Live Server uses `http://127.0.0.1:5500` — add both `localhost` and `127.0.0.1` to the origin array in `server.js`.

### `Invalid token` / Unauthorized
Make sure `JWT_SECRET` is set in `.env`. Clear `localStorage` in browser DevTools → Application tab, then log in again.

### Alpine: `x-if` can only be used on `<template>`
Use `x-show` on a regular element, or wrap the section in `<template x-if="...">`.

---

## Development Tips

Install `nodemon` for automatic server restart on file changes:

```bash
cd backend
npm install --save-dev nodemon
```

Update `package.json`:

```json
"scripts": {
  "start": "node server.js",
  "dev": "nodemon server.js"
}
```

Run with:

```bash
npm run dev
```

---

## Security Checklist

Before going to production:

- [ ] `backend/.env` is in `.gitignore` and never committed
- [ ] `JWT_SECRET` is a random 32+ character string
- [ ] `NODE_ENV` is set to `production`
- [ ] HTTPS is enabled (use Nginx + Certbot)
- [ ] `CORS_ORIGIN` is restricted to your real domain only
- [ ] Run `npm audit fix` to patch known vulnerabilities

---

## License

MIT License — see `LICENSE` for details.

---

**Version:** 1.0.0 &nbsp;|&nbsp; **Last Updated:** April 2026
