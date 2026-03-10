# Autism Support Frontend

React frontend for the active doctor and parent workflows.

## What it includes

- Authentication and role-based routing
- Doctor patient list, analysis entry, AI result review, and treatment approval
- Parent child profiles, care plans, reviewed analysis history, and report downloads
- Shared result components for AI output, doctor review, and saved treatment plans

## Development

```bash
cd frontend
npm install
npm start
```

The frontend runs on `http://localhost:3000` and expects the backend API on port `5000`.

## Build

```bash
npm run build
```

## Main app flow

```text
React frontend -> Express API -> FastAPI AI service
```

The current UI is centered on text or voice analysis records, doctor-reviewed treatment plans, care-plan tracking, and report access. Older prototype-only audio input components were removed from this frontend.
