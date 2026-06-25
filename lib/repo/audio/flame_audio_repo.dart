import 'package:flame_audio/flame_audio.dart';
import 'package:fluff/repo/audio/audio_repo.dart';

class FlameAudioRepo extends AudioRepo {
  final Map<String, AudioPlayer> _playing = {};

  FlameAudioRepo() {
    FlameAudio.updatePrefix("");
  }

  @override
  Future<void> cache(List<String> assetPaths) async {
    await FlameAudio.audioCache.loadAll(assetPaths);
  }

  @override
  Future<void> dispose() async {
    await FlameAudio.audioCache.clearAll();
  }

  @override
  Future<void> play(String assetPath, {bool loop = false}) async {
    if (loop) {
      _playing[assetPath] = await FlameAudio.loop(assetPath);
    } else {
      _playing[assetPath] = await FlameAudio.play(assetPath);
    }
  }

  @override
  Future<void> stop(String assetPath) async {
    await _playing[assetPath]?.stop();
    _playing.remove(assetPath);
  }
}
