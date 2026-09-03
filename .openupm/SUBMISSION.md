# OpenUPM submission guide (modular monorepo)

This folder holds reference OpenUPM package-metadata YAML files, one per Unity package in this
monorepo. They mirror what you submit to the [OpenUPM registry](https://github.com/openupm/openupm).

> These YAML files are a local reference. OpenUPM stores the authoritative copies in its own
> repository under `data/packages/`. You submit each one there via pull request.

## Packages (16)

Base and addons:
- `com.refinery89.sdk.mediation-base`
- `com.refinery89.sdk.mediation-addon-google`
- `com.refinery89.sdk.mediation-addon-r89-base`
- `com.refinery89.sdk.mediation-addon-r89`

Adapters:
- `com.refinery89.sdk.adapters.gmaapplovin`
- `com.refinery89.sdk.adapters.gmadtexchange`
- `com.refinery89.sdk.adapters.gmainmobi`
- `com.refinery89.sdk.adapters.gmaironsource`
- `com.refinery89.sdk.adapters.gmaliftoff`
- `com.refinery89.sdk.adapters.gmameta`
- `com.refinery89.sdk.adapters.gmamoloco`
- `com.refinery89.sdk.adapters.gmatappx`
- `com.refinery89.sdk.adapters.gmaunity`
- `com.refinery89.sdk.adapters.gmapangle`
- `com.refinery89.sdk.adapters.gmapubmatic`
- `com.refinery89.sdk.adapters.gmamintegral`

## Versioning strategy: synchronized (recommended here)

Every package shares version `1.2.5-beta.2`. With synchronized versioning you create a single
Git tag and OpenUPM builds all 16 packages from it because each `package.json` is auto-detected
in its subfolder.

```bash
git tag v1.2.5-beta.2
git push origin v1.2.5-beta.2
```

Keep `gitTagPrefix: ''` in every YAML for this strategy.

### Alternative: per-package versioning

If you later want packages to move at different versions, switch to prefixed tags and set
`gitTagPrefix` in each YAML. For example, for `com.refinery89.sdk.adapters.gmaunity`:

```yaml
gitTagPrefix: 'com.refinery89.sdk.adapters.gmaunity/'
```

Then tag as `com.refinery89.sdk.adapters.gmaunity/1.2.5-beta.2`. OpenUPM strips nothing before
parsing, so the version after the prefix must be a clean semver.

## Submission steps

1. Push this repo to `https://github.com/R89SDK/R89MediationAdapterModularUnity` on the `main` branch.
2. Create and push the release tag `v1.2.5-beta.2`.
3. For each package, submit its YAML to OpenUPM. The easiest path is the
   [package add form](https://openupm.com/packages/add/) which generates the YAML and opens a PR.
4. PR title format for auto-merge: `Create <package-name>.yml`. Submitting all 16 in one PR is
   allowed but blocks auto-merge (a moderator merges it manually); one PR per package auto-merges.
5. After merge, OpenUPM discovers the tag and builds each package. Track progress on each
   package page: `https://openupm.com/packages/<package-name>`.

## Notes on the YAML fields

- `readme` points at each package's own README inside the monorepo
  (`main:Packages/<package-name>/README.md`).
- `topics` uses `utilities`; adjust to the closest valid slugs from
  https://github.com/openupm/openupm/blob/master/data/topics.yml if you want richer categorization.
- `hunter` is set to `R89SDK`; OpenUPM will set it to the submitting GitHub user automatically.
