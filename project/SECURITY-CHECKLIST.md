# Security checklist template

Copy this into your workspace `project/SECURITY-CHECKLIST.md` and fill it in
before you make your project repository public.

Every row gets one of **Yes**, **No** or **N/A**, and one line of evidence in
your own words: what you checked, where, and what you found. "N/A" is a correct
answer when it is true, but it needs its reason. A blank row scores nothing, and
a Yes your repository contradicts scores nothing either.

Replace the example evidence with your own.

## Secrets and credentials

| # | Check | Yes / No / N/A | Evidence |
| --- | --- | --- | --- |
| 1 | No API key, token or password is hardcoded in `lib/`, including in comments and commented-out code |Yes|	The project was checked for keys, secrets, passwords, and tokens. No sensitive credentials were found, and the app does not make its own network calls. |
| 2 | Anything private is in a gitignored config or passed with `--dart-define`, with an example file committed |N/A |The app does not use .env files or private values, so no secrets need to be configured. .env, .env.*, and env.json are also protected by .gitignore, while the unused .env.example is only a template. |
| 3 | No keystore, `key.properties` or signing credential is in the repository |Yes |No .keystore, .jks, key.properties, service-account JSON or google-services file exists on public main or in any path ever committed. The project is web-only and has no android/ folder. |
| 4 | Git history is clean: I searched `git log -p` for password, secret, api key and token |Yes |All commits were scanned for passwords, secrets, API keys, tokens, and common key patterns. No real credentials were found; only template comments and references in the .env.example, workflow, and documentation appeared. |
| 5 | Any credential that was ever committed has been rotated |N/A |No credential was ever committed (row 4), so there is nothing to rotate. |

## GitHub Actions

If your project has no workflows, mark every row N/A and say so once.

| # | Check | Yes / No / N/A | Evidence |
| --- | --- | --- | --- |
| 6 | No secret value is written literally in any workflow YAML file |Yes |The workflow contains no real secrets or API keys. The only secret-related lines are commented-out placeholders and a harmless unused dummy value. |
| 7 | Secrets are stored in repository Actions secrets and read with `${{ secrets.NAME }}` |N/A |The workflow currently uses no secrets because the app does not need any. The two secret references are only commented-out placeholders for future use. |
| 8 | No workflow step echoes, dumps or debug-prints a secret, and I opened a recent run's log to confirm |Yes |The workflow and GitHub Actions logs were checked for exposed secrets. No actual keys or passwords were found; the only matches were GitHub’s built-in masked GITHUB_TOKEN, permissions, and workflow comments. The web build only shows normal compiler output and completed successfully. |
| 9 | If I build a signed APK: the keystore is a base64 secret decoded to a file at build time, never printed |N/A |The workflow runs flutter build web for Pages, not a signed APK. There is no keystore anywhere in the project. |
| 10 | Uploaded build artifacts contain no key file, keystore or generated config |Yes |The only artifact is build/web, uploaded with upload-pages-artifact. No --dart-define values are passed and the repo contains no key files to leak. A scan of the local build/ folder found no secret-shaped strings. |
| 11 | Third-party actions are pinned to a commit SHA, not a moveable tag |No |All four GitHub Actions use version tags, with their corresponding commit SHAs verified on October 5, 2026. This confirms which exact commits those action tags pointed to at the time of checking. |
| 12 | Secret scanning and push protection are enabled on the repository |Yes |Settings > Advanced Security shows Secret Protection and Push protection both enabled, each offers a Disable button, meaning it is currently on. |

## Backend and security rules

If your app is fully local with no backend, mark every row N/A and say so once.

| # | Check | Yes / No / N/A | Evidence |
| --- | --- | --- | --- |
| 13 | Firestore and Storage rules are not left open to anyone; they require an authenticated user |N/A |No backend and no Firestore,  everything stays on the device. |
| 14 | Rules restrict a user to their own documents where that makes sense |N/A |No backend, so no server-side rules. See row 13. |
| 15 | If Supabase: Row Level Security is on for every table |N/A |Supabase is not used. The SUPABASE_* lines in .env.example are unused template placeholders. |
| 16 | Firebase and Google API keys are restricted in the Google Cloud console to the APIs and app they are for |N/A |The project has no Firebase or Google API keys. |
| 17 | I opened the app signed out and confirmed I could not read or write data I should not |N/A |	There is no sign-in and no server data, so every user only ever sees their own local storage. |
| 18 | Seed and sample data is invented, not real people's data |Yes |The sample classes, tasks, and notes are fictional, and the app use a generic “Student” greeting. No personal names or personal data are included, the SJH room codes are only campus location labels. |

## Input and app surface

| # | Check | Yes / No / N/A | Evidence |
| --- | --- | --- | --- |
| 19 | Input is validated before it is written, not only styled as valid in the UI |No |The app currently has basic validation only: required fields cannot be empty, but there are no format or length checks. Corrupt saved data is handled safely with sample data fallback. |
| 20 | Nothing secret is recoverable from the built app, since a shipped binary can be unpacked |Yes |There are no keys or secrets in the source code or build output. The only external resource is the Poppins font from google_fonts, which does not require a key. |

## Repository and privacy

| # | Check | Yes / No / N/A | Evidence |
| --- | --- | --- | --- |
| 21 | No student number, personal email, phone number or home address in the repository or in commit messages |No |No student number, phone number, or address was found. However, some personal information is exposed through commit metadata, tracked Flutter logs containing user profile paths, a pubspec.yaml comment, and the PDF’s author metadata. |
| 22 | No classmate's personal data in the repository |Yes |All tracked text files and available screenshots were checked, with no classmates’ personal information found. |
| 23 | Dependencies come from pub.dev, and `build/` and `.dart_tool/` are gitignored |Yes |All hosted packages in pubspec.lock come from the official pub.dev registry, while the remaining packages are from the Dart/Flutter SDK. The generated build/ and .dart_tool/ folders are properly ignored and are not tracked. |
| 24 | Images, fonts and other assets are mine, licensed, or credited |Yes |The project uses the author’s own screenshots and design PDF, along with Poppins (google_fonts, SIL OFL) and Material Icons (Apache-2.0). No other external assets are bundled, and the README Credits and LICENSE have now been updated. |
| 25 | Repository visibility is deliberate, and I checked it after my last push |Yes |The repository is intentionally public. As of October 5, 2026, an anonymous check confirmed that the main branch is accessible and currently points to commit adcbcc5. |

## Anything I found and fixed

The secret checks came back clean: no key, token, or password was ever committed in any of the 32 commits, and the app has no private values to protect. The checklist identified personal information in two accidentally committed Flutter crash logs, a pubspec.yaml comment, and commit author metadata. 
These issues have now been addressed, and the README Credits and LICENSE template text have also been updated. The workflow actions remain tag-based, and form input uses basic non-empty validation.
