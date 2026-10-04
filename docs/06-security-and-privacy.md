# Security and privacy

This repository is public. The app does not use external services or store data on a server.

**Last checked:** 2026-10-04

## What this app stores

| Data | Where it lives | Who can see it |
| --- | --- | --- |
| Class schedule | On the device (`shared_preferences`) | Only the user |
| Tasks | On the device (`shared_preferences`) | Only the user |
| Notes | On the device (`shared_preferences`) | Only the user |

## Secrets

- Values my app needs at run time: None
- Where they live locally: Not applicable; the app does not use a `.env` file
- Where the deploy workflow gets them: None; the deployment does not require secrets
- Anything my deployed web build carries that a visitor could read, and why that is acceptable: Nothing sensitive; the app does not use API keys or external backend services

## What protects the data on the service side

Nothing leaves the device. The app uses `shared_preferences` for local storage and does not use Firestore, Supabase, or another cloud database.

## Checklist

- [x] No `.env` or `env.json` is required by the app
- [x] No real API keys, secrets, passwords, or tokens are included in the repository
- [x] No service account file, keystore, or `service_role` key is included
- [x] No security rules or RLS policies are needed because there is no backend service
- [x] No real personal data in sample data, screenshots, or the video
- [x] No course or university credentials anywhere
- [x] Anyone whose data appears in a test was asked first
