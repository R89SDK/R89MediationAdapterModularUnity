# .build

Maintenance tooling for this monorepo. Not shipped in any Unity package.

## generate.ps1

Regenerates all 16 modular packages under `Packages/` and their OpenUPM metadata under
`.openupm/`. It is idempotent and uses deterministic GUIDs (derived from each asset path), so
re-running it keeps `.meta` GUIDs stable.

Use it to bump the shared version or edit package definitions in one place instead of hand-editing
16 folders.

```powershell
powershell -ExecutionPolicy Bypass -File .build/generate.ps1
```

To change the version for every package, edit `$version` near the top of `generate.ps1` and
re-run. Package definitions (names, native artifacts, iOS pods, scoped Maven repos) live in the
`$packages` and `$adapters` arrays in the same file.
