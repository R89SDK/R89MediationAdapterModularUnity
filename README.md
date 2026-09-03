# Refinery89 Modular Mediation SDK for Unity

Modular Unity distribution of the **Refinery89** Google Mobile Ads (AdMob) mediation stack.
Pick only the modules you need instead of pulling one monolithic package.

Each package here is a headless [EDM4U](https://github.com/googlesamples/unity-jar-resolver)
dependency resolver. It contains no C# runtime code; it only maps the native Android (Maven)
and iOS (CocoaPods) libraries into your build. Standard Google Mobile Ads SDK initialization
drives the mediation waterfall.

---

## Two ways to integrate

Refinery89 mediation ships through two independent distribution routes. Choose one.

### 1. Main SDK Route (all-in-one)

The original single package that bundles everything. Already published on OpenUPM.

```bash
openupm add com.refinery89.sdk.mediation
```

Use this when you want every adapter with zero decisions. See the
[Main SDK package on OpenUPM](https://openupm.com/packages/com.refinery89.sdk.mediation/).

### 2. Modular SDK Route (this repository)

A monorepo of independently-installable packages. Add only the base, addon, and adapter
modules you actually use. This keeps your app footprint smaller and your dependency tree
explicit. Everything below describes this route.

> You do not need both routes. The modular route replaces the all-in-one package for
> publishers who want fine-grained control.

---

## How the modular route is structured

You compose your integration from three layers:

1. **Base** - the core native libraries. Always required.
2. **Addon** - the R89 layer plus the Google (AdMob) bridge. Pick the R89 variant that fits.
3. **Adapters** - one package per mediation network. Add the ones you sell.

### R89 addon variants

There are two R89 addon packages. Add **one** of them:

| Package | Modular? | Use when |
| --- | --- | --- |
| `com.refinery89.sdk.mediation-addon-r89-base` | Yes | You want to hand-pick individual `gma*` adapter modules. |
| `com.refinery89.sdk.mediation-addon-r89` | No (all-in-one) | You want every adapter bundled without selecting them individually. |

You do not need to add individual adapter packages when using the non-modular
`mediation-addon-r89` - it already contains them all.

---

## Package matrix

### Base and addons

| Unity package | Android artifact | iOS pod | Purpose |
| --- | --- | --- | --- |
| `com.refinery89.sdk.mediation-base` | `com.refinery89.androidsdk:mediation-base` | `R89MediationBase` | Core native libraries. Always required. |
| `com.refinery89.sdk.mediation-addon-google` | `com.refinery89.androidsdk:mediation-addon-google` | `R89MediationAddonGoogle` | Bridges R89 mediation to the Google Mobile Ads (AdMob) SDK. |
| `com.refinery89.sdk.mediation-addon-r89-base` | `com.refinery89.androidsdk:mediation-addon-r89-base` | `R89MediationAddonR89Base` | Modular R89 addon. Supports optional `gma*` adapter modules. |
| `com.refinery89.sdk.mediation-addon-r89` | `com.refinery89.androidsdk:mediation-addon-r89` | `R89MediationAddonR89` | Non-modular R89 addon. Bundles every adapter. |

### Adapters

| Unity package | Android artifact | iOS pod | Extra Maven repo |
| --- | --- | --- | --- |
| `com.refinery89.sdk.adapters.gmaapplovin` | `com.refinery89.androidsdk.adapters:gmaAppLovin` | `R89GmaAppLovinAdapter` | - |
| `com.refinery89.sdk.adapters.gmadtexchange` | `com.refinery89.androidsdk.adapters:gmaDtExchange` | `R89GmaDtExchangeAdapter` | - |
| `com.refinery89.sdk.adapters.gmainmobi` | `com.refinery89.androidsdk.adapters:gmaInMobi` | `R89GmaInMobiAdapter` | - |
| `com.refinery89.sdk.adapters.gmaironsource` | `com.refinery89.androidsdk.adapters:gmaIronSource` | `R89GmaIronSourceAdapter` | - |
| `com.refinery89.sdk.adapters.gmaliftoff` | `com.refinery89.androidsdk.adapters:gmaLiftoff` | `R89GmaLiftoffAdapter` | - |
| `com.refinery89.sdk.adapters.gmameta` | `com.refinery89.androidsdk.adapters:gmaMeta` | `R89GmaMetaAdapter` | - |
| `com.refinery89.sdk.adapters.gmamoloco` | `com.refinery89.androidsdk.adapters:gmaMoloco` | `R89GmaMolocoAdapter` | - |
| `com.refinery89.sdk.adapters.gmatappx` | `com.refinery89.androidsdk.adapters:gmaTappx` | `R89GmaTappxAdapter` | - |
| `com.refinery89.sdk.adapters.gmaunity` | `com.refinery89.androidsdk.adapters:gmaUnity` | `R89GmaUnityAdapter` | - |
| `com.refinery89.sdk.adapters.gmapangle` | `com.refinery89.androidsdk.adapters:gmaPangle` | `R89GmaPangleAdapter` | Pangle |
| `com.refinery89.sdk.adapters.gmapubmatic` | `com.refinery89.androidsdk.adapters:gmaPubMatic` | `R89GmaPubMaticAdapter` | PubMatic |
| `com.refinery89.sdk.adapters.gmamintegral` | `com.refinery89.androidsdk.adapters:gmaMintegral` | `R89GmaMintegralAdapter` | Mintegral |

The "Extra Maven repo" column lists the third-party Android repository each adapter injects
into your Gradle resolution. Adapters without a listed repo resolve from Maven Central /
Google Maven only. All native modules are published at version `1.2.5-beta.2`.

---

## Worked examples

### R89 + Unity Ads only (modular)

Add exactly three packages:

```bash
openupm add com.refinery89.sdk.mediation-base
openupm add com.refinery89.sdk.mediation-addon-r89-base
openupm add com.refinery89.sdk.adapters.gmaunity
```

Want the Google AdMob bridge alongside it? Add the Google addon too:

```bash
openupm add com.refinery89.sdk.mediation-addon-google
```

### R89 + Unity Ads + Meta + AppLovin (modular)

```bash
openupm add com.refinery89.sdk.mediation-base
openupm add com.refinery89.sdk.mediation-addon-r89-base
openupm add com.refinery89.sdk.mediation-addon-google
openupm add com.refinery89.sdk.adapters.gmaunity
openupm add com.refinery89.sdk.adapters.gmameta
openupm add com.refinery89.sdk.adapters.gmaapplovin
```

### Everything, without selecting adapters (non-modular)

```bash
openupm add com.refinery89.sdk.mediation-base
openupm add com.refinery89.sdk.mediation-addon-r89
openupm add com.refinery89.sdk.mediation-addon-google
```

---

## Installation methods

Each package can be installed three ways.

### Option 1: OpenUPM CLI (recommended)

```bash
openupm add <package-name>
```

### Option 2: Unity Package Manager (scoped registry)

1. **Edit > Project Settings > Package Manager**.
2. Under **Scoped Registries**, add:
   * **Name**: `OpenUPM`
   * **URL**: `https://package.openupm.com`
   * **Scope(s)**: `com.refinery89`, `com.google.ads.mobile`, `com.google.external-dependency-manager`
3. **Window > Package Manager**, filter to **Packages: My Registries**, then install the modules you want.

### Option 3: Unity Package Manager (Git URL, subfolder)

Because this is a monorepo, target the specific package subfolder with `?path=`:

```text
https://github.com/R89SDK/R89MediationAdapterModularUnity.git?path=Packages/<package-name>
```

For example, the Unity Ads adapter:

```text
https://github.com/R89SDK/R89MediationAdapterModularUnity.git?path=Packages/com.refinery89.sdk.adapters.gmaunity
```

---

## Requirements

* **Unity**: `2021.3` (LTS) or higher
* **Google Mobile Ads Unity Plugin**: `v8.0.0`+ (tested with `v9.1.0`+)
* **External Dependency Manager for Unity (EDM4U)**: `v1.2.178`+
* **Android**: API level 23+
* **iOS**: 13.0+

---

## Native dependency resolution

### Android
Dependencies resolve during build, or via **Assets > External Dependency Manager >
Android Resolver > Resolve**. Each package injects only the Maven artifacts and third-party
repositories it needs, so your Gradle files stay lean.

### iOS
When building the iOS Xcode project, EDM4U generates the CocoaPods workspace (`.xcworkspace`)
containing the pods for the packages you installed. Open the `.xcworkspace` (not the
`.xcodeproj`) in Xcode and build.

---

## Unity C# integration

No custom C# ad-handling code is required. Standard Google Mobile Ads initialization brings up
the mediation waterfall:

```csharp
using UnityEngine;
using GoogleMobileAds.Api;

public class AdManager : MonoBehaviour
{
    private void Start()
    {
        MobileAds.Initialize(initStatus =>
        {
            Debug.Log("[AdManager] Google Mobile Ads & Refinery89 mediation waterfall initialized.");
        });
    }
}
```

---

## Publishing to OpenUPM

This repo is a monorepo. Each package is submitted to OpenUPM separately. Reference metadata
files live in [`.openupm/`](.openupm), one `<package-name>.yml` per package, along with a
submission checklist. See [.openupm/SUBMISSION.md](.openupm/SUBMISSION.md).

All packages share version `1.2.5-beta.2`, so a single Git tag `v1.2.5-beta.2` builds all of
them (synchronized versioning). If you ever need per-package versions, switch to prefixed tags
and set `gitTagPrefix` in each package's OpenUPM YAML.

---

## License

Apache-2.0. See [LICENSE](LICENSE).

## Support

[mobile_development@refinery89.com](mailto:mobile_development@refinery89.com) | [refinery89.com](https://refinery89.com)
