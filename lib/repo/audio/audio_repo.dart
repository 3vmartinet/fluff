abstract class AudioRepo {
  Future<void> play(String assetPath);
  Future<void> dispose();
}
