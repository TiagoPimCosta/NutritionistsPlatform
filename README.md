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
- [pnpm](https://pnpm.io/) - the project pins `pnpm@11.24.0` via the `packageManager` field
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
rails db:drop db:create db:migrate db:seed

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

## 🔒 Concurrency

Accepting a request is the one place in this application where two people can collide: two browser tabs, two clicks, one slot. The rule the challenge asks for - accepting a request rejects the others that overlap it - is a read followed by a write, and a read-then-write with nothing between them is a race.

It is defended three times over, because each layer covers what the one above it cannot:

1. **A transaction.** Accepting the request and rejecting the ones it conflicts with are one unit of work. A failure halfway through - the cascade raising, the process dying - leaves the diary exactly as it was, instead of an accepted appointment whose conflicts were never rejected.

2. **A row lock on the nutritionist.** `SELECT … FOR UPDATE` on the nutritionist row is taken before the appointment is read, so a second acceptance queues behind the first and then re-reads what the first one committed. The nutritionist is the right thing to lock because the invariant spans their whole diary, across every service they offer - locking the individual appointment rows would not help, since two racing acceptances touch two different rows. It also fixes the lock acquisition order: without it the two transactions grab each other's rows in opposite order, and Postgres kills one of them with a deadlock.

3. **An exclusion constraint.** The invariant is written into the schema itself, so it holds even against code that never goes through the service object:

   ```sql
   EXCLUDE USING gist (
     nutritionist_id WITH =,
     tsrange(starts_at, ends_at) WITH &&
   ) WHERE (status = 1)
   ```

`tsrange`, not `tstzrange`: the columns are `timestamp without time zone`, and casting those to a timestamptz depends on the session time zone, which is not immutable and therefore not indexable. The default `[)` bounds are what let a nutritionist take back to back appointments - one starting exactly when another ends is not an overlap.

Requesting an appointment has a smaller race of its own: the guest may only have one pending request, so two simultaneous requests could each cancel the other and leave the guest with none. A returning guest's row is locked for the duration; a brand new guest has no row to lock yet, so the unique index on `lower(email)` settles the tie and the loser retries against the guest that won.

The suite proves this rather than asserting it politely: `test/services/appointments_services/concurrency_test.rb` runs real threads on separate connections (transactional fixtures are turned off there - a thread on another connection cannot see data sitting inside an open transaction), releases them from a gate together, and asserts that exactly one of two overlapping acceptances wins. Removing the lock turns those tests red, with both requests accepted and Postgres reporting a deadlock. The constraint is tested by bypassing the application entirely with `update_column`.

## 🧪 Testing

### Strategy

The suite is written against behaviour the challenge specifies, not against implementation details, and it is layered so that each rule is asserted at the level where it lives:

- **Models** cover the invariants: `ends_at` derived from the duration of the requested service, bookings refused in the past, emails unique regardless of case, and the `overlapping` scope - including the boundary case where a booking starting exactly when another ends must _not_ collide, so a nutritionist can take consecutive appointments.
- **Service objects** cover the business rules: accepting a request rejects the other pending requests that overlap it, for that nutritionist only, across all of their services; and a new request cancels the guest's previous pending one without touching anyone else's.
- **Controllers** cover the HTTP contract: status codes, pagination, the search filters, and the payload the frontend depends on. Failures are distinguished rather than flattened into one 422 - a missing appointment is a 404, and answering a request that someone else already answered is a 409.
- **Concurrency** is covered by its own file, with threads and real connections, described under [Concurrency](#-concurrency) above.

There are no fixtures. The domain is small and every test builds exactly the records it needs through helpers in `test/test_helper.rb`, which keeps the setup visible next to the assertions instead of in a file nobody reads.

Database-level constraints are asserted too - an appointment cannot be forced to end before it starts even by bypassing validations - because the concurrency work depends on the database holding the line on its own.

### Running

```bash
cd backend
bin/rails db:test:prepare   # first run only
bin/rails test
```

### Frontend

The frontend suite covers the pieces that carry logic rather than layout: the date helper that builds the payload, the professional card that now renders real credentials instead of the placeholders it used to hardcode, and the scheduling form, which is asserted to block an incomplete submission and to post the contract the API expects.

```bash
cd frontend
pnpm test              # single run
pnpm test:watch        # watch mode
pnpm test:coverage
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
