abstract class AudioRepo {
  Future<void> cache(List<String> assetPaths);
  Future<void> play(String assetPath, {bool loop = false});
  Future<void> stop(String assetPath);
  Future<void> dispose();
}
