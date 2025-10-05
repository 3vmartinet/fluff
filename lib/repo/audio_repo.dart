import 'package:audioplayers/audioplayers.dart';
import 'package:fluff/repo/volume_repo.dart';

class AudioRepo {
  static final AudioRepo _instance = AudioRepo._init();
  factory AudioRepo() => _instance;

  AudioRepo._init() {
    _player1 = _createPlayer();
    _player2 = _createPlayer();
  }

  PlayerMode _mode = PlayerMode.lowLatency;

  late final AudioPlayer _player1;
  late final AudioPlayer _player2;

  _createPlayer() {
    return AudioPlayer()..setReleaseMode(ReleaseMode.stop);
  }

  Future<void> loadAssets(List<String> paths) async {
    await _player1.audioCache.loadAll(paths);
    await _player2.audioCache.loadAll(paths);
  }

  /// Set wether media playback is optimized for short and light audio files or for longer and heavier media files
  void setLowLatencyMode(bool lowLatency) {
    _mode = lowLatency ? PlayerMode.lowLatency : PlayerMode.mediaPlayer;
  }

  Future<void> play(String assetPath) async {
    if (VolumeRepo().muted) {
      return;
    }

    final source = AssetSource(assetPath);

    if (_player1.state == PlayerState.stopped) {
      await _player1.play(source, mode: _mode);
      await _player1.stop();
    } else if (_player2.state == PlayerState.stopped) {
      await _player2.play(source, mode: _mode);
      await _player2.stop();
    }
  }

  Future<void> dispose() async {
    await _player1.dispose();
    await _player2.dispose();
  }
}
