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

  void play(String assetName, {double volume = 0.6}) {
    final source = _sounds[assetName];
    if (source != null) {
      SoLoud.instance.play(source, volume: volume);
    }
  }

  void dispose() {
    SoLoud.instance.deinit();
  }
}
