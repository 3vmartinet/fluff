# README

## Introduction
Welcome to FLUFF, the package that provides convenience functions to develop your Flutter app, based on packages from pub.dev.
FLUFF means Flutter Leveraging User Functions from Friends.

## Features

### Extensions

#### BuildContext Extensions
 - `isLargeScreen`: if the Adaptative Scaffold Breakpoint "large" is reached

#### DateTime Extensions
 - `ymd`
 - `yMMMMd({bool includeYear = true})`: e.g 2005 January 5, January 5
 - `monthCamelCaseLong`: e.g January
 - `monthCamelCaseShort`: e.g Jan
 - `ymdInt`
 - `hms`
 - `hmsInt`

#### Object Extensions
 - `logInfo(String message)`
 - `logSevere(String message)`
 - `logShout(String message)`
 - `logWarning(String message)`
 - `logFine(String message)`
 - `logFiner(String message)`
 - `logFinest(String message)`
 - `logConfig(String message)`

#### String Extensions
 - `typewriter(...)` : converts a `String` into an animated typewriter widget

### Repositories

#### `ConnectivityRepo` :
 - `hasConnectivity()`

#### `DeviceInfoRepo` :
 - `id` : Android/iOS device ID
 - `name` : Android/iOS device name
