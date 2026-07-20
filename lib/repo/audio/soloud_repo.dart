import 'dart:async';

import 'package:fluff/repo/audio/audio_repo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:logging/logging.dart';

class SoLoudRepo extends AudioRepo {
  static void Function(Object error, StackTrace stack)? onError;

  final Map<String, AudioSource> _sounds = {};
  final Map<String, SoundHandle> _playingSounds = {};

  SoLoud get _soLoud => SoLoud.instance;

  late StreamSubscription<LogRecord> _subscription;
  final List<String> _debugLogs = [];
  List<String> get debugLogs => _debugLogs;

  @override
  Future<void> init() async {
    Logger.root.level = Level.FINE;
    _subscription = Logger.root.onRecord.listen((record) {
      _debugLogs.add(
          '${record.time} - ${record.level.name} - ${record.loggerName} - ${record.message} - ${record.error} - ${record.stackTrace}');
    });
    await _soLoud.init();
    _soLoud.setMaxActiveVoiceCount(128);
    debugPrint('$runtimeType: initialized.');
  }

  void setMaxActiveVoiceCount(int count) {
    _soLoud.setMaxActiveVoiceCount(count);
    debugPrint('$runtimeType: max active voice count set to $count');
  }

  int getMaxActiveVoiceCount() {
    return _soLoud.getMaxActiveVoiceCount();
  }

  int getActiveVoiceCount() {
    return _soLoud.getActiveVoiceCount();
  }

  @override
  Future<void> cache(List<String> assets) async {
    try {
      for (final asset in assets) {
        if (!_sounds.containsKey(asset)) {
          _sounds[asset] =
              await _soLoud.loadAsset(asset, mode: LoadMode.memory);
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

  @override
  Future<void> play(String assetPath, {bool loop = false}) async {
    try {
      final source = _sounds[assetPath];

      if (source != null) {
        _debugLogs.add("Playing sound $assetPath");
        final handle = _soLoud.play(source, volume: 1.0, looping: loop);
        _playingSounds[assetPath] = handle;
        await source.allInstancesFinished.first;
        debugPrint('$runtimeType: sound $assetPath finished playing');
      } else {
        throw StateError(
            "$runtimeType: No active handle for asset '$assetPath'");
      }
    } catch (e, stack) {
      debugPrint('$runtimeType: Failed to play sound $assetPath: $e');
      onError?.call(e, stack);
      rethrow;
    }
  }

  void logActiveVoices() {
    _debugLogs.add(
        "Active/Max voices : ${_soLoud.getActiveVoiceCount()}/${_soLoud.getMaxActiveVoiceCount()}");
  }

  @override
  Future<void> pause(String assetPath) async {
    try {
      final handle = _playingSounds[assetPath];

      if (handle != null) {
        _soLoud.setPause(handle, true);
        debugPrint('$runtimeType: paused sound $assetPath');
      } else {
        debugPrint("$runtimeType: No active handle '$assetPath'");
      }
    } catch (e, stack) {
      debugPrint('$runtimeType: Failed to pause sound $assetPath: $e');
      onError?.call(e, stack);
      rethrow;
    }
  }

  @override
  Future<void> resume(String assetPath) async {
    try {
      final handle = _playingSounds[assetPath];

      if (handle != null) {
        _soLoud.setPause(handle, false);
        debugPrint('$runtimeType: resumed sound $assetPath');
      } else {
        debugPrint("$runtimeType: No active handle '$assetPath'");
      }
    } catch (e, stack) {
      debugPrint('$runtimeType: Failed to resume sound $assetPath: $e');
      onError?.call(e, stack);
      rethrow;
    }
  }

  @override
  Future<void> stop(String assetPath) async {
    try {
      final handle = _playingSounds[assetPath];

      if (handle != null) {
        await _soLoud.stop(handle);
        _playingSounds.remove(assetPath);
        debugPrint('$runtimeType: stopped sound $assetPath');
      } else {
        debugPrint("$runtimeType: No active handle '$assetPath'");
      }
    } catch (e, stack) {
      debugPrint('$runtimeType: Failed to stop sound $assetPath: $e');
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

  @override
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
