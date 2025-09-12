# NutritionistPlatform

This project is a full-stack application with:

- **Backend**: Ruby on Rails (`ruby 3.4.5`)
- **Frontend**: React

---

## 📦 Prerequisites

Make sure you have the following installed:

- [Ruby 3.4.5](https://www.ruby-lang.org/)
- [Rails](https://rubyonrails.org/)
- [Bundler](https://bundler.io/)
- [Node.js (LTS)](https://nodejs.org/)
- [npm](https://www.npmjs.com/) or [yarn](https://yarnpkg.com/)
- [PostgreSQL](https://www.postgresql.org/) (or the database configured in the backend)

---

## ⚙️ Setup

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

```bash
cd backend
bin/rails server
```

## Frontend

```bash
cd frontend
npm start
```

docker build -t nutritionists-frontend:prod --target prod .

docker run --rm -p 8080:80 nutritionists-frontend:prod
