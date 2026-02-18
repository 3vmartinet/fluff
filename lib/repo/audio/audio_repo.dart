abstract class AudioRepo {
  Future<void> cache(List<String> assetPaths);
  Future<void> play(String assetPath);
  Future<void> dispose();
}
