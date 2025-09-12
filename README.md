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

## Running Manually

### 📦 Prerequisites

Make sure you have the following installed:

- [Ruby 3.4.5](https://www.ruby-lang.org/)
- [Rails](https://rubyonrails.org/)
- [Bundler](https://bundler.io/)
- [Node.js (LTS)](https://nodejs.org/)
- [npm](https://www.npmjs.com/) or [yarn](https://yarnpkg.com/)
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
npm install
# or
yarn install

# Start React development server
npm start
# or
yarn start
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
npm start
```
