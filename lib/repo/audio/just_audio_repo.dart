import 'dart:async';
import 'dart:developer';

import 'package:fluff/repo/audio/audio_repo.dart';
import 'package:just_audio/just_audio.dart';

class JustAudioRepo extends AudioRepo {
  bool _playerStopped1 = true;
  final bool _playerStopped2 = true;

  late final AudioPlayer _player1;
  late final AudioPlayer _player2;

  late final StreamSubscription _player1Subscription;
  late final StreamSubscription _player2Subscription;

  JustAudioRepo({bool interruptOthers = false}) {
    _player1 = AudioPlayer(handleAudioSessionActivation: interruptOthers);
    _player2 = AudioPlayer(handleAudioSessionActivation: interruptOthers);

    _player1Subscription = _player1.playerStateStream.listen(
      (state) => _playerStopped1 = state.isStopped,
    );
    _player2Subscription = _player2.playerStateStream.listen(
      (state) => _playerStopped1 = state.isStopped,
    );
  }
  @override
  Future<void> play(String assetPath) async {
    try {
      if (_playerStopped1) {
        await _player1.setAsset(assetPath);
        await _player1.play();
      } else if (_playerStopped2) {
        await _player2.setAsset(assetPath);
        await _player2.play();
      }
    } catch (e, s) {
      log("Failed to play audio asset: $assetPath", error: e, stackTrace: s);
    }
  }

  @override
  Future<void> dispose() async {
    await _player1Subscription.cancel();
    await _player2Subscription.cancel();
    await _player1.dispose();
    await _player2.dispose();
  }

  @override
  Future<void> cache(List<String> assetPaths) async {}
}

extension _PlayerStateExtension on PlayerState {
  bool get isStopped =>
      processingState == ProcessingState.idle ||
      processingState == ProcessingState.completed;
}
