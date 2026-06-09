import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

class SoundRepo {
  final Map<String, AudioSource> _sounds = {};
  final Map<int, SoundHandle> _playingSounds = {};

  Future<void> init(List<String> assets) async {
    try {
      await SoLoud.instance.init();

      for (final asset in assets) {
        final source = await SoLoud.instance.loadAsset(asset);
        _sounds[asset] = source;
      }

      debugPrint('AudioService: Engine initialized and assets pre-warmed.');
    } catch (e) {
      debugPrint('AudioService: Failed to initialize: $e');
    }
  }

  Future<int?> play(String assetName,
      {double volume = 1.0, Duration? startLoopingAt}) async {
    final source = _sounds[assetName];

    if (source != null) {
      final handle = await SoLoud.instance.play(source,
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
      SoLoud.instance.setPause(handle, true);
    } else {
      throw UnsupportedError("Audio source for '$handleId' not found");
    }
  }

  void resume(int handleId) {
    final handle = _playingSounds[handleId];

    if (handle != null) {
      SoLoud.instance.setPause(handle, false);
    } else {
      throw UnsupportedError("Audio source for '$handleId' not found");
    }
  }

  Future<void> stop(int handleId) async {
    final handle = _playingSounds.remove(handleId);

    if (handle != null) {
      await SoLoud.instance.stop(handle);
    } else {
      throw UnsupportedError("Audio source for '$handleId' not found");
    }
  }

  Future<void> stopAll() async {
    for (final handle in _playingSounds.values) {
      await SoLoud.instance.stop(handle);
    }
    _playingSounds.clear();
  }

  Future<void> dispose() async {
    await stopAll();

    for (final source in _sounds.values) {
      await SoLoud.instance.disposeSource(source);
    }

    _sounds.clear();
    SoLoud.instance.deinit();
  }
}
