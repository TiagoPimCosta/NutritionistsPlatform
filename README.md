# NutritionistPlatform

This project is a full-stack application with:

- **Backend**: Ruby on Rails (`ruby 3.4.5`)
- **Frontend**: React

---

## Running with Docker Compose

### 📦 Prerequisites

- Docker
- Docker Compose

In the terminal run:

```bash
docker compose up --build
```

This will:

- Start a Postgres database on port 5432
- Build and start the Rails backend on port 3000
- Start the Vite frontend on port 3030

To view the application just access http://localhost:3030

### 🔑 Credentials

Rails needs a `secret_key_base` to boot in production. It normally comes from
`config/credentials.yml.enc`, which requires `config/master.key` to decrypt.

That key is **not** committed here. Instead, compose passes `SECRET_KEY_BASE`
directly, so `docker compose up` works on a fresh clone with no key.

Running the backend manually in production mode outside Docker:

```bash
SECRET_KEY_BASE=any_value bin/rails server -e production
```

The manual setup below runs in development, which needs neither.

## Running Manually

### 📦 Prerequisites

Make sure you have the following installed:

- [Ruby 3.4.5](https://www.ruby-lang.org/)
- [Rails](https://rubyonrails.org/)
- [Bundler](https://bundler.io/)
- [Node.js (LTS)](https://nodejs.org/)
- [pnpm](https://pnpm.io/) — the project pins `pnpm@11.24.0` via the `packageManager` field
- [PostgreSQL](https://www.postgresql.org/) (or the database configured in the backend)

## ⚙️ Setup

## Postgresql

```bash
# brew starts a postgresql service
brew services start postgresql

# To stop this service after the test you need to run
brew services stop postgresql
```

## Backend

```bash
cd backend

# Install Ruby dependencies
bundle install

# Setup database
rails db:create db:migrate db:seed

# Start Rails server
bin/rails server
```

## Frontend

```bash
cd frontend

# Install Node dependencies
pnpm install

# Start the Vite development server
pnpm dev
```

## ⚙️ Run

## Backend

```bash
cd backend
bin/rails server
```

## Frontend

```bash
cd frontend
pnpm dev
```
