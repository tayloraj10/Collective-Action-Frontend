# Scripts

## Version (sync & bump)

The app version is read from `pubspec.yaml` and generated into `lib/app/version.g.dart` so the UI (e.g. app info menu) stays in sync. Run from **project root**.

### Regenerate from pubspec (sync only)

```bash
dart run scripts/version.dart generate
```

Use this after manually editing `version:` in `pubspec.yaml`.

### Bump version (updates pubspec + regenerates)

```bash
dart run scripts/version.dart bump <patch|build|minor|major>
```

| Command | Example |
|--------|--------|
| `bump patch` | 1.0.0+1 → 1.0.1+1 |
| `bump build` | 1.0.0+1 → 1.0.0+2 |
| `bump minor` | 1.0.0+1 → 1.1.0+1 |
| `bump major` | 1.0.0+1 → 2.0.0+1 |

After bumping, `lib/app/version.g.dart` is updated automatically.

---

## Success sounds (generate list from assets)

The app plays a random success sound from `assets/sounds/*.mp3`. The list of paths is generated into `lib/app/success_sounds.g.dart` so you don’t have to edit constants when adding new sounds.

**Regenerate after adding or removing .mp3 files in `assets/sounds/`:**

```bash
dart run scripts/generate_success_sounds.dart
```

Run from the **project root**. The script scans `assets/sounds/`, writes all `.mp3` paths to `lib/app/success_sounds.g.dart`, and the app uses that list for random success sounds.

---

## Google Maps API key (PowerShell)

These scripts keep your real Maps key out of the repo by using a placeholder in `web/index.html` and injecting the key at run time. Key is read from the `GOOGLE_MAPS_API_KEY` env var or from a `.env` file in the project root (`GOOGLE_MAPS_API_KEY=...`).

| Script | Purpose |
|--------|--------|
| **inject_maps_key.ps1** | Injects the key into `web/index.html`. Use as a **preLaunchTask** in VS Code/Cursor `launch.json` so the key is present when you run/debug. |
| **restore_maps_key.ps1** | Restores `web/index.html` so the Maps key is the placeholder again. Use as a **postDebugTask** so the key is never committed. |
| **serve_web.ps1** | Runs Flutter web locally with the key injected, then restores `web/index.html` on exit. Usage: `.\scripts\serve_web.ps1` or `.\scripts\serve_web.ps1 -Device chrome` |

---

## OpenAPI / API codegen (Node.js)

| Script | Purpose |
|--------|--------|
| **patch_photos_api_multipart.js** | Post-generation patch for `lib/api/lib/api/photos_api.dart`. The OpenAPI Dart generator emits invalid code for multipart array-of-files; this script replaces that block with correct handling. Run after `openapi-generator-cli generate` (e.g. after `generate_models.bat`). |
