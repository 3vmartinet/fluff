import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:fluff/repo/audio/audio_repo.dart';

class AudioplayersRepo extends AudioRepo {
  bool _playerStopped1 = true, _playerStopped2 = true;

  late final AudioPlayer _player1;
  late final AudioPlayer _player2;

  late final StreamSubscription _player1Subscription;
  late final StreamSubscription _player2Subscription;

  AudioplayersRepo() {
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

  Future<void> loadAssets(List<String> paths) async {
    _paths.addAll(paths);

    await _player1.audioCache.loadAll(paths);
    await _player2.audioCache.loadAll(paths);
  }

  @override
  Future<void> play(String assetPath) async {
    final source = AssetSource(assetPath);

    if (_playerStopped1) {
      _playerStopped1 = false;
      await _player1.setSource(source);
      await _player1.resume();
    } else if (_playerStopped2) {
      await _player2.setSource(source);
      await _player2.resume();
    }
  }

  @override
  Future<void> dispose() async {
    await _player1Subscription.cancel();
    await _player2Subscription.cancel();
    await _player1.dispose();
    await _player2.dispose();
  }
}
