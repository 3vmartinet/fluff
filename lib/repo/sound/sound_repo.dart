import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:logging/logging.dart';

class SoundRepo {
  static void Function(Object error, StackTrace stack)? onError;

  final Map<String, AudioSource> _sounds = {};
  final Map<int, SoundHandle> _playingSounds = {};

  SoLoud get _soLoud => SoLoud.instance;

  late StreamSubscription<LogRecord> _subscription;
  final List<String> _debugLog = [];
  List<String> get debugLog => _debugLog;

  Future<void> init({int maxActiveVoiceCount = 16}) async {
    Logger.root.level = Level.FINE;
    _subscription = Logger.root.onRecord.listen((record) {
      _debugLog.add(
          '${record.time} - ${record.level.name} - ${record.loggerName} - ${record.message} - ${record.error} - ${record.stackTrace}');
    });
    await _soLoud.init();
    _soLoud.setMaxActiveVoiceCount(maxActiveVoiceCount);
    debugPrint('$runtimeType: initialized.');
  }

  Future<void> loadAssets({
    required List<String> assets,
    bool inMemory = true,
  }) async {
    try {
      final mode = inMemory ? LoadMode.memory : LoadMode.disk;

      for (final asset in assets) {
        if (!_sounds.containsKey(asset)) {
          _sounds[asset] = await _soLoud.loadAsset(asset, mode: mode);
          debugPrint('$runtimeType: pre-warmed asset $asset');
        } else {
          debugPrint('$runtimeType: Asset $asset already loaded');
        }
      }
    } catch (e, stack) {
      debugPrint('$runtimeType: Failed to load assets: $e');
      onError?.call(e, stack);
      rethrow;
    }
  }

  int play(
    String assetName, {
    double volume = 1.0,
    bool loop = false,
  }) {
    try {
      final source = _sounds[assetName];

      if (source != null) {
        final handle = _soLoud.play(source, volume: volume, looping: loop);
        _playingSounds[handle.id] = handle;
        return handle.id;
      } else {
        throw StateError(
            "$runtimeType: No active handle for asset '$assetName'");
      }
    } catch (e, stack) {
      debugPrint('$runtimeType: Failed to play sound $assetName: $e');
      onError?.call(e, stack);
      rethrow;
    }
  }

  void pause(int handleId) {
    try {
      final handle = _playingSounds[handleId];

      if (handle != null) {
        _soLoud.setPause(handle, true);
        debugPrint('$runtimeType: paused sound $handleId');
      } else {
        throw StateError("$runtimeType: No active handle '$handleId'");
      }
    } catch (e, stack) {
      debugPrint('$runtimeType: Failed to pause sound $handleId: $e');
      onError?.call(e, stack);
      rethrow;
    }
  }

  void resume(int handleId) {
    try {
      final handle = _playingSounds[handleId];

      if (handle != null) {
        _soLoud.setPause(handle, false);
        debugPrint('$runtimeType: resumed sound $handleId');
      } else {
        throw StateError("$runtimeType: No active handle '$handleId'");
      }
    } catch (e, stack) {
      debugPrint('$runtimeType: Failed to resume sound $handleId: $e');
      onError?.call(e, stack);
      rethrow;
    }
  }

  Future<void> stop(int handleId) async {
    try {
      final handle = _playingSounds[handleId];

      if (handle != null) {
        await _soLoud.stop(handle);
        _playingSounds.remove(handleId);
        debugPrint('$runtimeType: stopped sound $handleId');
      } else {
        throw StateError(
            "$runtimeType: Audio source for '$handleId' not found");
      }
    } catch (e, stack) {
      debugPrint('$runtimeType: Failed to stop sound $handleId: $e');
      onError?.call(e, stack);
      rethrow;
    }
  }

  Future<void> stopAll() async {
    try {
      if (_playingSounds.isEmpty) {
        debugPrint('$runtimeType: No sounds playing');
        return;
      }

      await Future.wait(_playingSounds.values.map((e) => _soLoud.stop(e)));
      debugPrint('$runtimeType: stopped all sounds');
    } catch (e, stack) {
      debugPrint('$runtimeType: Failed to stop all sounds: $e');
      onError?.call(e, stack);
      rethrow;
    } finally {
      _playingSounds.clear();
    }
  }

  Future<void> disposeAsset(String assetName) async {
    try {
      final handle = _sounds[assetName];

      if (handle != null) {
        await _soLoud.disposeSource(handle);
        _sounds.remove(assetName);
        debugPrint('$runtimeType: disposed sound $assetName');
      } else {
        debugPrint("$runtimeType: '$assetName' not found, ignore dispose");
      }
    } catch (e, stack) {
      debugPrint('$runtimeType: Failed to dispose sound $assetName: $e');
      onError?.call(e, stack);
      rethrow;
    }
  }

  Future<void> dispose() async {
    _subscription.cancel();

    try {
      await stopAll();
    } finally {
      SoLoud.instance.deinit();
      _sounds.clear();
      debugPrint('$runtimeType: disposed');
    }
  }
}
