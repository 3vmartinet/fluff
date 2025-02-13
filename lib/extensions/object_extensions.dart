import 'dart:developer';
import 'package:logging/logging.dart';

extension ObjectExtensions<T> on T {
  logInfo(String message) => _log(message, Level.INFO);
  logSevere(String message) => _log(message, Level.SEVERE);
  logShout(String message) => _log(message, Level.SHOUT);
  logWarning(String message) => _log(message, Level.WARNING);
  logFine(String message) => _log(message, Level.FINE);
  logFiner(String message) => _log(message, Level.FINER);
  logFinest(String message) => _log(message, Level.FINEST);
  logConfig(String message) => _log(message, Level.CONFIG);

  _log(String message, Level level) =>
      log(message, name: runtimeType.toString(), level: level.value);
}
