import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

class SoundRepo {
  final Map<String, AudioSource> _sounds = {};

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

  Future<SoundHandle?> play(String assetName,
      {double volume = 1.0, Duration? startLoopingAt}) {
    final source = _sounds[assetName];

    if (source != null) {
      return SoLoud.instance.play(source,
          volume: volume,
          looping: startLoopingAt != null,
          loopingStartAt: startLoopingAt ?? Duration.zero);
    }

    return Future.value(null);
  }

  void dispose() {
    for (final source in _sounds.values) {
      SoLoud.instance.disposeSource(source);
    }
    _sounds.clear();
    SoLoud.instance.deinit();
  }
}
