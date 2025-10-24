import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:fluff/repo/volume_repo.dart';

class AudioRepo {
  static final AudioRepo _instance = AudioRepo._init();
  factory AudioRepo() => _instance;

  AudioRepo._init() {
    _player = _createPlayer();
  }

  PlayerMode _mode = PlayerMode.lowLatency;

  late final AudioPlayer _player;

  Future? _pendingPlay;
  final List<String> _paths = [];
  final List<Duration> _durations = [];

  _createPlayer() {
    return AudioPlayer()..setReleaseMode(ReleaseMode.stop);
  }

  Future<void> loadAssets(List<String> paths, List<Duration> durations) async {
    assert(paths.length == durations.length);

    _paths
      ..clear()
      ..addAll(paths);

    _durations
      ..clear()
      ..addAll(durations);

    await _player.audioCache.loadAll(paths);
  }

  /// Set wether media playback is optimized for short and light audio files or for longer and heavier media files
  void setLowLatencyMode(bool lowLatency) {
    _mode = lowLatency ? PlayerMode.lowLatency : PlayerMode.mediaPlayer;
  }

  void play(String assetPath) async {
    _pendingPlay?.ignore();
    await _player.stop();

    if (VolumeRepo().muted) {
      return;
    }

    final index = _paths.indexOf(assetPath);

    if (index < 0) {
      log("Asset paths: ${_paths}");
      throw Exception("Asset '$assetPath' may not have been loaded upfront");
    }

    await _player.play(AssetSource(assetPath), mode: _mode);

    if (_mode == PlayerMode.lowLatency) {
      final duration = _durations[index];

      if (index < 0) {
        throw Exception("No duration supplied for asset '$assetPath' ");
      }
      _pendingPlay = Future.delayed(duration, _player.stop);
    }
  }

  Future<void> dispose() async {
    _pendingPlay?.ignore();
    await _player.dispose();
  }
}
