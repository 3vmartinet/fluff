abstract class AudioRepo {
  Future<void> init();
  Future<void> cache(List<String> assetPaths);
  Future<void> play(String assetPath, {bool loop = false});
  Future<void> stop(String assetPath);
  Future<void> pause(String assetPath);
  Future<void> resume(String assetPath);
  Future<void> dispose();
  bool isPaused(String assetPath);
}
