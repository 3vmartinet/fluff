import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

extension ObjectExtensions<T> on T {
  void logInfo(String Function() messageProvider) =>
      _log(messageProvider, Level.INFO);
  void logSevere(String Function() messageProvider) =>
      _log(messageProvider, Level.SEVERE);
  void logShout(String Function() messageProvider) =>
      _log(messageProvider, Level.SHOUT);
  void logWarning(String Function() messageProvider) =>
      _log(messageProvider, Level.WARNING);
  void logFine(String Function() messageProvider) =>
      _log(messageProvider, Level.FINE);
  void logFiner(String Function() messageProvider) =>
      _log(messageProvider, Level.FINER);
  void logFinest(String Function() messageProvider) =>
      _log(messageProvider, Level.FINEST);
  void logConfig(String Function() messageProvider) =>
      _log(messageProvider, Level.CONFIG);

  void _log(String Function() messageProvider, Level level) {
    if (kDebugMode) {
      log(messageProvider(), name: runtimeType.toString(), level: level.value);
    }
  }
}
