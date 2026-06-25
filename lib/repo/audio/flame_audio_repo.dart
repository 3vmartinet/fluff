import 'package:flame_audio/flame_audio.dart';
import 'package:fluff/repo/audio/audio_repo.dart';

class FlameAudioRepo extends AudioRepo {
  final Map<String, AudioPlayer> _playing = {};

  @override
  Future<void> init() async {
    FlameAudio.updatePrefix("");
    await FlameAudio.bgm.initialize();
  }

  @override
  Future<void> cache(List<String> assetPaths) async {
    await FlameAudio.audioCache.loadAll(assetPaths);
  }

  @override
  Future<void> dispose() async {
    await FlameAudio.bgm.dispose();
    await FlameAudio.audioCache.clearAll();
  }

  @override
  Future<void> play(String assetPath, {bool loop = false}) async {
    if (loop) {
      await FlameAudio.bgm.stop();
      await FlameAudio.bgm.play(assetPath);
    } else {
      _playing[assetPath] = await FlameAudio.play(assetPath);
    }
  }

  @override
  Future<void> stop(String assetPath) async {
    if (_playing.containsKey(assetPath)) {
      await _playing[assetPath]?.stop();
      _playing.remove(assetPath);
    } else {
      await FlameAudio.bgm.stop();
    }
  }
}
