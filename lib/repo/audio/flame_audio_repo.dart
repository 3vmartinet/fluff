import 'package:flame_audio/flame_audio.dart';
import 'package:fluff/repo/audio/audio_repo.dart';

class FlameAudioRepo extends AudioRepo {
  @override
  Future<void> cache(List<String> assetPaths) async {
    await FlameAudio.audioCache.loadAll(assetPaths);
  }

  @override
  Future<void> dispose() async {
    await FlameAudio.audioCache.clearAll();
  }

  @override
  Future<void> play(String assetPath) async {
    await FlameAudio.play(assetPath);
  }
}
