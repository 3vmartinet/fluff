import 'package:fluff/repo/audio/audio_repo.dart';
import 'package:just_audio/just_audio.dart';

class JustAudioRepo extends AudioRepo {
  bool get _playerStopped1 => !_player1.playing;
  bool get _playerStopped2 => !_player2.playing;

  final _player1 = AudioPlayer();
  final _player2 = AudioPlayer();

  @override
  Future<void> play(String assetPath) async {
    if (_playerStopped1) {
      await _player1.setAsset(assetPath);
      await _player1.play();
    } else if (_playerStopped2) {
      await _player2.setAsset(assetPath);
      await _player2.play();
    }
  }

  @override
  Future<void> dispose() async {
    await _player1.dispose();
    await _player2.dispose();
  }
}
