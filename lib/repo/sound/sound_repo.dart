import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

class SoundRepo {
  final Map<String, AudioSource> _sounds = {};
  final Map<int, SoundHandle> _playingSounds = {};

  SoLoud get _soLoud => SoLoud.instance;

  Future<void> init() async {
    await _soLoud.init();
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
        }
      }

      debugPrint('$runtimeType: pre-warmed assets ${assets.join(', ')}');
    } catch (e) {
      debugPrint('$runtimeType: Failed to initialize: $e');
    }
  }

  Future<int?> play(String assetName,
      {double volume = 1.0, Duration? startLoopingAt}) async {
    final source = _sounds[assetName];

    if (source != null) {
      final handle = _soLoud.play(source,
          volume: volume,
          looping: startLoopingAt != null,
          loopingStartAt: startLoopingAt ?? Duration.zero);

      _playingSounds[handle.id] = handle;
      return handle.id;
    } else {
      throw UnsupportedError("Audio source for '$assetName' not found");
    }
  }

  void pause(int handleId) {
    final handle = _playingSounds[handleId];

    if (handle != null) {
      _soLoud.setPause(handle, true);
      debugPrint('$runtimeType: paused sound $handleId');
    } else {
      throw UnsupportedError(
          "$runtimeType: Audio source for '$handleId' not found");
    }
  }

  void resume(int handleId) {
    final handle = _playingSounds[handleId];

    if (handle != null) {
      _soLoud.setPause(handle, false);
      debugPrint('$runtimeType: resumed sound $handleId');
    } else {
      throw UnsupportedError(
          "$runtimeType: Audio source for '$handleId' not found");
    }
  }

  Future<void> stop(int handleId) async {
    final handle = _playingSounds.remove(handleId);

    if (handle != null) {
      await _soLoud.stop(handle);
      debugPrint('$runtimeType: stopped sound $handleId');
    } else {
      throw UnsupportedError(
          "$runtimeType: Audio source for '$handleId' not found");
    }
  }

  Future<void> stopAll() async {
    if (_playingSounds.isEmpty) {
      debugPrint('$runtimeType: No sounds playing');
      return;
    }

    await Future.wait(_playingSounds.values.map((e) => _soLoud.stop(e)));
    _playingSounds.clear();
    debugPrint('$runtimeType: stopped all sounds');
  }

  void disposeAsset(String name) {
    final sound = _sounds[name];

    if (sound != null) {
      _soLoud.disposeSource(sound);
      _sounds.remove(name);
      debugPrint('$runtimeType: disposed asset $name');
    } else {
      debugPrint('$runtimeType: asset $name not found, nothing to dispose');
    }
  }

  Future<void> dispose() async {
    await stopAll();

    await Future.wait(_sounds.values.map((e) => _soLoud.disposeSource(e)));
    debugPrint('$runtimeType: disposed ${_sounds.length} assets');

    _sounds.clear();
    SoLoud.instance.deinit();
    debugPrint('$runtimeType: disposed');
  }
}
