import 'dart:async';

import 'package:audioplayers/audioplayers.dart';

class AudioRepo {
  bool _playerStopped1 = true, _playerStopped2 = true;

  late final AudioPlayer _player1;
  late final AudioPlayer _player2;

  late final StreamSubscription _player1Subscription;
  late final StreamSubscription _player2Subscription;

  AudioRepo() {
    _player1 = _createPlayer();
    _player1Subscription = _player1.onPlayerComplete.listen(_onFinishedPlayer1);

    _player2 = _createPlayer();
    _player2Subscription = _player2.onPlayerComplete.listen(_onFinishedPlayer2);
  }

  AudioPlayer _createPlayer() {
    return AudioPlayer()..setReleaseMode(ReleaseMode.stop);
  }

  void _onFinishedPlayer1(void event) {
    _playerStopped1 = true;
  }

  void _onFinishedPlayer2(void event) {
    _playerStopped2 = true;
  }

  final List<String> _paths = [];
  final List<Duration> _durations = [];

  Future<void> loadAssets(List<String> paths, List<Duration> durations) async {
    assert(paths.length == durations.length);
    _paths.addAll(paths);
    _durations.addAll(durations);

    await _player1.audioCache.loadAll(paths);
    await _player2.audioCache.loadAll(paths);
  }

  Future<void> play(String assetPath) async {
    final source = AssetSource(assetPath);

    if (_playerStopped1) {
      _playerStopped1 = false;
      await _player1.play(source);
    } else if (_playerStopped2) {
      _playerStopped2 = false;
      await _player2.play(source);
    }
  }

  Future<void> dispose() async {
    await _player1Subscription.cancel();
    await _player2Subscription.cancel();
    await _player1.dispose();
    await _player2.dispose();
  }
}
