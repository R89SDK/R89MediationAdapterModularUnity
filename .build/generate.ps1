# Generator for R89 Modular Mediation Unity monorepo packages.
# Produces per-package: package.json (+meta), Editor/ (+meta), Editor/<Name>Dependencies.xml (+meta),
# README.md (+meta), CHANGELOG.md (+meta). Also emits OpenUPM .openupm/*.yml metadata.
# Idempotent: rewrites files each run. Deterministic GUIDs derived from a stable seed per path.

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$version = '1.2.5-beta.2'
$repoUrl = 'https://github.com/R89SDK/R89MediationAdapterModularUnity'
$repoGit = "$repoUrl.git"

# Deterministic GUID (32 hex) from a string, so re-runs keep stable .meta guids.
function New-StableGuid([string]$key) {
    $md5 = [System.Security.Cryptography.MD5]::Create()
    $bytes = $md5.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($key))
    ($bytes | ForEach-Object { $_.ToString('x2') }) -join ''
}

# Write text as UTF-8 without BOM (Unity dislikes BOMs in .meta / config files).
function Write-Text([string]$path, [string]$content) {
    $normalized = $content -replace "`r`n", "`n"
    if (-not $normalized.EndsWith("`n")) { $normalized += "`n" }
    $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($path, $normalized, $utf8NoBom)
}

function Write-Meta([string]$assetPath, [bool]$isFolder) {
    $guid = New-StableGuid $assetPath
    if ($isFolder) {
        $body = @"
fileFormatVersion: 2
guid: $guid
folderAsset: yes
DefaultImporter:
  externalObjects: {}
  userData: 
  assetBundleName: 
  assetBundleVariant: 
"@
    } else {
        $body = @"
fileFormatVersion: 2
guid: $guid
TextScriptImporter:
  externalObjects: {}
  userData: 
  assetBundleName: 
  assetBundleVariant: 
"@
    }
    Write-Text "$assetPath.meta" $body
}

# Repo constants
$repoPubmatic  = 'https://repo.pubmatic.com/artifactory/public-repos'
$repoPangle    = 'https://artifact.bytedance.com/repository/pangle'
$repoMintegral = 'https://dl-maven-android.mintegral.com/repository/mbridge_android_sdk_oversea'

# Package definitions.
# type: base|addon|adapter
# pkgName: UPM name (lowercase)
# display: displayName
# desc: description
# androidSpec: full android artifact spec (without version)
# iosPod: iOS pod name
# xmlName: Editor/<xmlName>Dependencies.xml
# repos: array of maven repo urls scoped to this package
$packages = @(
    @{ pkgName='com.refinery89.sdk.mediation-base'; display='Refinery89 Mediation Base'; type='base';
       desc='Base module for the Refinery89 Google Mobile Ads mediation stack. Resolves the core native Android and iOS libraries required by all other Refinery89 mediation modules.';
       androidSpec='com.refinery89.androidsdk:mediation-base'; iosPod='R89MediationBase'; xmlName='R89MediationBase'; repos=@() },

    @{ pkgName='com.refinery89.sdk.mediation-addon-google'; display='Refinery89 Mediation Addon - Google'; type='addon';
       desc='Google addon for the Refinery89 mediation stack. Resolves the native libraries that bridge Refinery89 mediation with the Google Mobile Ads (AdMob) SDK.';
       androidSpec='com.refinery89.androidsdk:mediation-addon-google'; iosPod='R89MediationAddonGoogle'; xmlName='R89MediationAddonGoogle'; repos=@() },

    @{ pkgName='com.refinery89.sdk.mediation-addon-r89-base'; display='Refinery89 Mediation Addon - R89 Base (Modular)'; type='addon';
       desc='Modular Refinery89 addon. This is the modular variant of the R89 mediation addon that supports optional adapter modules (Unity, AppLovin, Meta, and more). Pair it with the individual gma* adapter packages you need.';
       androidSpec='com.refinery89.androidsdk:mediation-addon-r89-base'; iosPod='R89MediationAddonR89Base'; xmlName='R89MediationAddonR89Base'; repos=@() },

    @{ pkgName='com.refinery89.sdk.mediation-addon-r89'; display='Refinery89 Mediation Addon - R89 (All-in-one)'; type='addon';
       desc='Non-modular Refinery89 addon. This variant bundles every supported mediation adapter in a single module. Use it when you want all adapters without selecting them individually.';
       androidSpec='com.refinery89.androidsdk:mediation-addon-r89'; iosPod='R89MediationAddonR89'; xmlName='R89MediationAddonR89'; repos=@($repoPubmatic,$repoPangle,$repoMintegral) }
)

# Adapters: name -> android artifact suffix (exact casing), iOS pod, scoped repo(s)
$adapters = @(
    @{ key='gmaapplovin';   android='gmaAppLovin';   ios='R89GmaAppLovinAdapter';   label='AppLovin';   repos=@() },
    @{ key='gmadtexchange'; android='gmaDtExchange'; ios='R89GmaDtExchangeAdapter'; label='DT Exchange'; repos=@() },
    @{ key='gmainmobi';     android='gmaInMobi';     ios='R89GmaInMobiAdapter';     label='InMobi';     repos=@() },
    @{ key='gmaironsource'; android='gmaIronSource'; ios='R89GmaIronSourceAdapter'; label='ironSource'; repos=@() },
    @{ key='gmaliftoff';    android='gmaLiftoff';    ios='R89GmaLiftoffAdapter';    label='Liftoff';    repos=@() },
    @{ key='gmameta';       android='gmaMeta';       ios='R89GmaMetaAdapter';       label='Meta';       repos=@() },
    @{ key='gmamoloco';     android='gmaMoloco';     ios='R89GmaMolocoAdapter';     label='Moloco';     repos=@() },
    @{ key='gmatappx';      android='gmaTappx';      ios='R89GmaTappxAdapter';      label='Tappx';      repos=@() },
    @{ key='gmaunity';      android='gmaUnity';      ios='R89GmaUnityAdapter';      label='Unity Ads';  repos=@() },
    @{ key='gmapangle';     android='gmaPangle';     ios='R89GmaPangleAdapter';     label='Pangle';     repos=@($repoPangle) },
    @{ key='gmapubmatic';   android='gmaPubMatic';   ios='R89GmaPubMaticAdapter';   label='PubMatic';   repos=@($repoPubmatic) },
    @{ key='gmamintegral';  android='gmaMintegral';  ios='R89GmaMintegralAdapter';  label='Mintegral';  repos=@($repoMintegral) }
)

foreach ($a in $adapters) {
    $packages += @{
        pkgName    = "com.refinery89.sdk.adapters.$($a.key)"
        display    = "Refinery89 GMA Adapter - $($a.label)"
        type       = 'adapter'
        desc       = "Refinery89 modular mediation adapter for $($a.label). Resolves the native Android and iOS libraries for the $($a.label) line item. Requires the Refinery89 mediation base and an R89 addon module."
        androidSpec= "com.refinery89.androidsdk.adapters:$($a.android)"
        iosPod     = $a.ios
        xmlName    = $a.ios
        repos      = $a.repos
    }
}

# --- Emit files ---
function Get-DepsXml($androidSpec, $iosPod, $repos) {
    $sb = [System.Collections.Generic.List[string]]::new()
    $sb.Add('<dependencies>')
    $sb.Add('  <androidPackages>')
    if ($repos.Count -gt 0) {
        $sb.Add('    <repositories>')
        foreach ($r in $repos) { $sb.Add("      <repository>$r</repository>") }
        $sb.Add('    </repositories>')
        $sb.Add("    <androidPackage spec=`"$androidSpec`:$version`">")
        $sb.Add('      <repositories>')
        foreach ($r in $repos) { $sb.Add("        <repository>$r</repository>") }
        $sb.Add('      </repositories>')
        $sb.Add('    </androidPackage>')
    } else {
        $sb.Add("    <androidPackage spec=`"$androidSpec`:$version`" />")
    }
    $sb.Add('  </androidPackages>')
    $sb.Add('')
    $sb.Add('  <iosPods>')
    $sb.Add("    <iosPod name=`"$iosPod`" version=`"$version`" minTargetSdk=`"13.0`">")
    $sb.Add('    </iosPod>')
    $sb.Add('  </iosPods>')
    $sb.Add('</dependencies>')
    ($sb -join "`n") + "`n"
}

$openupmDir = Join-Path $root '.openupm'
New-Item -ItemType Directory -Force -Path $openupmDir | Out-Null

foreach ($p in $packages) {
    $pkgDir = Join-Path $root "Packages\$($p.pkgName)"
    $editorDir = Join-Path $pkgDir 'Editor'
    New-Item -ItemType Directory -Force -Path $editorDir | Out-Null

    # package.json (hand-formatted for clean, conventional 2-space indentation)
    $descJson = $p.desc -replace '\\','\\' -replace '"','\"'
    $pjText = @"
{
  "name": "$($p.pkgName)",
  "version": "$version",
  "displayName": "$($p.display)",
  "description": "$descJson",
  "unity": "2021.3",
  "unityRelease": "0f1",
  "author": {
    "name": "Refinery89",
    "email": "mobile_development@refinery89.com",
    "url": "https://refinery89.com"
  },
  "keywords": [
    "admob",
    "google-mobile-ads",
    "mediation",
    "refinery89",
    "ads",
    "monetization",
    "edm4u"
  ],
  "dependencies": {
    "com.google.external-dependency-manager": "1.2.178",
    "com.google.ads.mobile": "9.1.0"
  },
  "openupm": {
    "dependencies": [
      "com.google.external-dependency-manager",
      "com.google.ads.mobile"
    ]
  },
  "license": "Apache-2.0",
  "repository": {
    "type": "git",
    "url": "$repoGit"
  }
}
"@
    $pjPath = Join-Path $pkgDir 'package.json'
    Write-Text $pjPath $pjText
    Write-Meta $pjPath $false

    # Editor folder meta
    Write-Meta $editorDir $true

    # Dependencies.xml
    $xmlPath = Join-Path $editorDir "$($p.xmlName)Dependencies.xml"
    Write-Text $xmlPath (Get-DepsXml $p.androidSpec $p.iosPod $p.repos)
    Write-Meta $xmlPath $false

    # Per-package README
    $androidArtifact = "$($p.androidSpec):$version"
    $reposMd = if ($p.repos.Count -gt 0) { ($p.repos | ForEach-Object { "* ``$_``" }) -join "`n" } else { '_None. This module pulls only from Maven Central / Google Maven._' }
    $readme = @"
# $($p.display)

Part of the **Refinery89 Modular Mediation SDK** for Unity - the modular distribution route.
This package is a headless [EDM4U](https://github.com/googlesamples/unity-jar-resolver) dependency
resolver. It contains no C# runtime code; it only maps native Android and iOS libraries into your build.

## What it resolves

| Platform | Native module |
| --- | --- |
| Android | ``$androidArtifact`` |
| iOS | ``$($p.iosPod)`` ``$version`` (minTargetSdk 13.0) |

### Extra Maven repositories injected

$reposMd

## Installation

### OpenUPM CLI

``````bash
openupm add $($p.pkgName)
``````

### Git URL (subfolder)

Open **Window > Package Manager > + > Add package from git URL** and enter:

``````text
$repoGit`?path=Packages/$($p.pkgName)
``````

## Requirements

* Unity 2021.3 (LTS) or higher
* Google Mobile Ads Unity Plugin v8.0.0+ (tested with v9.1.0+)
* External Dependency Manager for Unity (EDM4U) v1.2.178+

## License

Apache-2.0. See the repository [LICENSE]($repoUrl/blob/main/LICENSE).

## Support

[mobile_development@refinery89.com](mailto:mobile_development@refinery89.com) | [refinery89.com](https://refinery89.com)
"@
    $readmePath = Join-Path $pkgDir 'README.md'
    Write-Text $readmePath $readme
    Write-Meta $readmePath $false

    # Per-package CHANGELOG
    $changelog = @"
# Changelog

All notable changes to **$($p.display)** are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [$version] - 2026-08-19

### Added
- Initial modular release.
- EDM4U dependency mapping for Android (``$androidArtifact``).
- EDM4U dependency mapping for iOS (``$($p.iosPod):$version``).
"@
    $changelogPath = Join-Path $pkgDir 'CHANGELOG.md'
    Write-Text $changelogPath $changelog
    Write-Meta $changelogPath $false

    # OpenUPM submission metadata (reference copy)
    $descYaml = $p.desc -replace '"','\"'
    $yaml = @"
# OpenUPM package metadata for $($p.pkgName)
# Submit as a separate PR to https://github.com/openupm/openupm (data/packages/).
name: $($p.pkgName)
displayName: $($p.display)
description: "$descYaml"
repoUrl: '$repoUrl'
parentRepoUrl: null
licenseSpdxId: Apache-2.0
licenseName: Apache License 2.0
topics:
  - utilities
gitTagPrefix: ''
gitTagIgnore: ''
minVersion: '$version'
readme: 'main:Packages/$($p.pkgName)/README.md'
hunter: R89SDK
"@
    $yamlPath = Join-Path $openupmDir "$($p.pkgName).yml"
    Write-Text $yamlPath $yaml

    Write-Host "Generated $($p.pkgName)"
}

Write-Host "Done. $($packages.Count) packages."
