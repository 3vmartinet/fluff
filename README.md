# README

## Introduction
Welcome to FLUFF, the package that provides convenience functions to develop your Flutter app, based on packages from pub.dev.
FLUFF means Flutter Leveraging User Functions from Friends.

## Features
 - `ConnectivityRepo` : exposes `hasConnectivity()`
 - `DeviceIdRepo` : exposes `mobileUserId` (Android/iOS device ID)
 - `DateTImeExtensions` :
    - `ymd`
    - `yMMMMd({bool includeYear = true})`: e.g 2005 January 5, January 5
    - `monthCamelCaseLong`: e.g January
    - `monthCamelCaseShort`: e.g Jan
    - `ymdInt`
    - `hms`
    - `hmsInt`
 - Extensions:
    - `BuildContextExtension`:
        - `isLargeScreen`: if the Adaptative Scaffold Breakpoint "large" is reached
   