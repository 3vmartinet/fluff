import 'package:audioplayers/audioplayers.dart';
import 'package:fluff/repo/volume_repo.dart';

class AudioRepo {
  static final AudioRepo _instance = AudioRepo._init();

  AudioRepo._init() {
    _player1 = _createPlayer(_onFinishedPlayer1);
    _player2 = _createPlayer(_onFinishedPlayer2);
  }

  factory AudioRepo() => _instance;

  bool _playerStopped1 = true, _playerStopped2 = true;

  late final AudioPlayer _player1;
  late final AudioPlayer _player2;

  _createPlayer(void Function(void) onComplete) => AudioPlayer()
    ..setReleaseMode(ReleaseMode.stop)
    ..onPlayerComplete.listen(onComplete);

  void play(String assetPath) {
    if (VolumeRepo().muted) {
      return;
    }

    final source = AssetSource(assetPath);

    if (_playerStopped1) {
      _playerStopped1 = false;
      _player1.play(source);
    } else if (_playerStopped2) {
      _playerStopped2 = false;
      _player2.play(source);
    }
  }

  void _onFinishedPlayer1(void event) {
    _playerStopped1 = true;
  }

  void _onFinishedPlayer2(void event) {
    _playerStopped2 = true;
  }
}
