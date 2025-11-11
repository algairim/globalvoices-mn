#!/bin/bash

echo "Creating 'multilingual-notes' project structure..."

# Move to root directory
cd ..

# === Create Root Files ===
touch .dockerignore
touch .gitignore
touch docker-compose.yml
touch README.md

# === Create Backend Structure ===
mkdir -p backend/src/auth/guards
mkdir -p backend/src/notes/entities
mkdir -p backend/src/summarise/entities
mkdir -p backend/src/translate/entities
mkdir -p backend/src/audit/entities
mkdir -p backend/src/user/entities
mkdir -p backend/test

touch backend/.env.example
touch backend/Dockerfile
touch backend/package.json
touch backend/tsconfig.json
touch backend/nest-cli.json

touch backend/src/main.ts
touch backend/src/app.module.ts

touch backend/src/auth/auth.controller.ts
touch backend/src/auth/auth.service.ts
touch backend/src/auth/auth.module.ts
touch backend/src/auth/guards/jwt-auth.guard.ts

touch backend/src/notes/notes.controller.ts
touch backend/src/notes/notes.service.ts
touch backend/src/notes/notes.module.ts
touch backend/src/notes/entities/note.entity.ts

touch backend/src/summarise/summarise.controller.ts
touch backend/src/summarise/summarise.service.ts
touch backend/src/summarise/summarise.module.ts
touch backend/src/summarise/entities/note-summary.entity.ts

touch backend/src/translate/translate.controller.ts
touch backend/src/translate/translate.service.ts
touch backend/src/translate/translate.module.ts
touch backend/src/translate/entities/note-translation.entity.ts

touch backend/src/audit/audit.listener.ts
touch backend/src/audit/audit.module.ts
touch backend/src/audit/entities/audit-log.entity.ts

touch backend/src/user/entities/user.entity.ts

touch backend/test/jest-e2e.json
touch backend/test/notes.e2e-spec.ts

# === Create Frontend Structure ===
mkdir -p frontend/src/components/layout
mkdir -p frontend/src/components/notes
mkdir -p frontend/src/components/ui
mkdir -p frontend/src/pages
mkdir -p frontend/src/services
mkdir -p frontend/src/hooks
mkdir -p frontend/src/tests
mkdir -p frontend/public

touch frontend/.env.example
touch frontend/Dockerfile
touch frontend/package.json
touch frontend/tailwind.config.js
touch frontend/vite.config.ts
touch frontend/tsconfig.json

touch frontend/src/main.tsx
touch frontend/src/App.tsx
touch frontend/src/index.css

touch frontend/src/components/layout/Header.tsx
touch frontend/src/components/notes/NotesList.tsx
touch frontend/src/components/notes/CreateNoteForm.tsx
touch frontend/src/components/notes/SummaryModal.tsx
touch frontend/src/components/ui/Button.tsx
touch frontend/src/components/ui/Input.tsx
touch frontend/src/components/ui/Modal.tsx

touch frontend/src/pages/Login.tsx
touch frontend/src/pages/Register.tsx
touch frontend/src/pages/Dashboard.tsx

touch frontend/src/services/api.ts
touch frontend/src/services/notes.service.ts
touch frontend/src/hooks/useAuth.ts

touch frontend/src/tests/create-note.spec.ts

touch frontend/public/favicon.ico

echo "Done. Project structure created in 'multilingual-notes' directory."

