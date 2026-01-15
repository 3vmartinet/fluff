import 'dart:developer';
import 'package:logging/logging.dart';

extension ObjectExtensions<T> on T {
  void logInfo(String message) => _log(message, Level.INFO);
  void logSevere(String message) => _log(message, Level.SEVERE);
  void logShout(String message) => _log(message, Level.SHOUT);
  void logWarning(String message) => _log(message, Level.WARNING);
  void logFine(String message) => _log(message, Level.FINE);
  void logFiner(String message) => _log(message, Level.FINER);
  void logFinest(String message) => _log(message, Level.FINEST);
  void logConfig(String message) => _log(message, Level.CONFIG);

  void _log(String message, Level level) =>
      log(message, name: runtimeType.toString(), level: level.value);
}
