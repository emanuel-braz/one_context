## [4.1.0] - Jan 14, 2025
- Fix error when using restorationScopeId
  - In order to load theme, it should be initialized manually [loadThemeMode()]

## [4.0.0] - Feb 27, 2023
- Update Flutter 3.19.1

## [3.0.0-rc-1] - August 02, 2023
* Update dialogs parameters
* Update dart version 3.0.0

## [2.1.0] - Jul 30, 2022
* Update dialogs parameters

## [2.0.0] - May 23, 2022
* Update flutter version 3.0.0

## [1.1.1] - August 22, 2021
* Fix snackbar deprecated methods
* Break changes dismissSnackBar is no longer available

## [1.1.0] - April 3, 2021 ( Flutter 2.0.2 )
* Close Dialog and ModalBottomSheets on back button tap (android)

## [1.0.0] - Mar 16, 2021 ( Flutter 2.0.2 • Null safety)
* Migrate to null-safety.

## [0.5.0] - Dec 22, 2020 ( Flutter 1.22.5 • channel stable )
* Fix Scaffold logic
* Breaking changes on OneContext().showSnackBar (now it returns a `Future`)
* Breaking changes on OneContext().showBottomSheet (now it returns a `Future`)
* Now it is possible to show dialogs inside StatefulWidget > State > initState method or inside StatelessWidget constructor method (experimental yet, dark mode issues)
* Production mode will not crash when there is no context loaded in OneContext()
* General improvements

## [0.4.0] - May 29, 2020
* Breaking changes on OneHotReload (check README to upgrade)
* OneHotReload becomes OneNotification, providing a top most generic feature.

## [0.3.0] - May 25, 2020
* Add OneHotReload to reload widget tree (useful for theme, locale, etc...)
* Add dark and light theme mode changer (Auto save)
* Add themeData and darkThemeData changer
* Add reload, restart and reboot app
* Add boot another app with setUp feature

## [0.2.3] - May 6, 2020
* fix generics

## [0.2.2] - May 6, 2020
* Linter fixes

## [0.2.1] - May 5, 2020
* Add MediaQuery
* Add Theme
* Add TextTheme

## [0.1.1] - Update description

## [0.1.0] - Initial release

* add showDialog
* add showModalBottomSheet
* add showBottomSheet
* add showSnackBar
* add dismissSnackBar
* add showOverlay
* add addOverlay
* add showProgressIndicator
* add all Flutter Navigator methods (push, pushNamed, ...) - Flutter 1.12.13+hotfix.9 • channel stable • Dart 2.7.2