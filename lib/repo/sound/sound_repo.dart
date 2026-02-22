import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

class SoundRepo {
  final Map<String, AudioSource> _sounds = {};
  final Set<SoundHandle> _activeHandles = {};
  final Map<SoundHandle, StreamSubscription> _subscriptions = {};

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

  Future<void> play(String assetName, {double volume = 0.6}) async {
    final source = _sounds[assetName];
    if (source != null) {
      final handle = await SoLoud.instance.play(source, volume: volume);
      _activeHandles.add(handle);

      late final StreamSubscription sub;
      sub = source.soundEvents.listen((event) {
        if (event.handle == handle &&
            event.event == SoundEventType.handleIsNoMoreValid) {
          _activeHandles.remove(handle);
          _subscriptions.remove(handle);
          sub.cancel();
        }
      });
      _subscriptions[handle] = sub;
    }
  }

  void stop() {
    for (final sub in _subscriptions.values) {
      sub.cancel();
    }
    _subscriptions.clear();

    for (final handle in _activeHandles) {
      SoLoud.instance.stop(handle);
    }
    _activeHandles.clear();
  }

  void dispose() {
    stop();
    for (final source in _sounds.values) {
      SoLoud.instance.disposeSource(source);
    }
    _sounds.clear();
    SoLoud.instance.deinit();
  }
}
