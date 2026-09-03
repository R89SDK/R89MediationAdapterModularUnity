# Refinery89 GMA Adapter - ironSource

Part of the **Refinery89 Modular Mediation SDK** for Unity - the modular distribution route.
This package is a headless [EDM4U](https://github.com/googlesamples/unity-jar-resolver) dependency
resolver. It contains no C# runtime code; it only maps native Android and iOS libraries into your build.

## What it resolves

| Platform | Native module |
| --- | --- |
| Android | `com.refinery89.androidsdk.adapters:gmaIronSource:1.2.5-beta.2` |
| iOS | `R89GmaIronSourceAdapter` `1.2.5-beta.2` (minTargetSdk 13.0) |

### Extra Maven repositories injected

_None. This module pulls only from Maven Central / Google Maven._

## Installation

### OpenUPM CLI

```bash
openupm add com.refinery89.sdk.adapters.gmaironsource
```

### Git URL (subfolder)

Open **Window > Package Manager > + > Add package from git URL** and enter:

```text
https://github.com/R89SDK/R89MediationAdapterModularUnity.git?path=Packages/com.refinery89.sdk.adapters.gmaironsource
```

## Requirements

* Unity 2021.3 (LTS) or higher
* Google Mobile Ads Unity Plugin v8.0.0+ (tested with v9.1.0+)
* External Dependency Manager for Unity (EDM4U) v1.2.178+

## License

Apache-2.0. See the repository [LICENSE](https://github.com/R89SDK/R89MediationAdapterModularUnity/blob/main/LICENSE).

## Support

[mobile_development@refinery89.com](mailto:mobile_development@refinery89.com) | [refinery89.com](https://refinery89.com)
