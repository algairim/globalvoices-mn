## Development

### Pre-requisites

You have either:
* Keycloak and PostgreSQL instances up and running at localhost,
* or a minimal docker compose template deployed:
    ```yaml
    version: '3.9'
    
    services:
      db:
        image: postgres:15-alpine
        restart: unless-stopped
        environment:
          POSTGRES_USER: app_user
          POSTGRES_PASSWORD: secret_db_password
          POSTGRES_DB: multilingual_notes
        ports:
          - "5433:5432"
        volumes:
          - postgres_data:/var/lib/postgresql/data
        healthcheck:
          test: ["CMD-SHELL", "pg_isready -U app_user -d multilingual_notes"]
          interval: 10s
          timeout: 5s
          retries: 5
    
      keycloak:
        image: keycloak/keycloak:26.4
        restart: unless-stopped
        command: ["start-dev", "--import-realm"]
        environment:
          KC_BOOTSTRAP_ADMIN_USERNAME: admin
          KC_BOOTSTRAP_ADMIN_PASSWORD: secret_admin_password
          KC_DB: postgres
          KC_DB_URL_HOST: db
          KC_DB_URL_DATABASE: multilingual_notes
          KC_DB_USERNAME: app_user
          KC_DB_PASSWORD: secret_db_password
          KC_HOSTNAME: localhost
        ports:
          - "8080:8080"
        volumes:
          - ./docker/keycloak/notes-realm.json:/opt/keycloak/data/import/realm.json
        depends_on:
          db:
            condition: service_healthy
    
    volumes:
      postgres_data:
        driver: local
    ```

### Start backend dev instance

Build backend first:

```bash
cd backend/
npm ci
npm run build
```

Then start `dev` NestJS instance with the following environment variables:

```bash
export NODE_ENV=production
export PORT=3000
export DATABASE_URL="postgresql://app_user:secret_db_password@localhost:5432/multilingual_notes?schema=public"
export KEYCLOAK_AUTH_URL=http://localhost:8080/realms/notes_realm
export KEYCLOAK_REALM=notes_realm
export KEYCLOAK_CLIENT_ID=notes_client
export TRANSLATION_API_URL=https://libretranslate.de/translate
npm run start
```

### Start frontend dev instance

Build frontend first:

```bash
cd frontend/
npm ci
npm run build
```

Then start `dev` Vite instance with the following environment variables:

```bash
export VITE_API_URL=http://localhost:3000
export VITE_KEYCLOAK_URL=http://localhost:8080
export VITE_KEYCLOAK_REALM=notes_realm
export VITE_KEYCLOAK_CLIENT_ID=notes_client
npm run dev
```

Look for URL to open in the console output.
