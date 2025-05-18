import 'package:path_provider/path_provider.dart';

class IoRepo {
  static final IoRepo _instance = IoRepo._init();

  IoRepo._init();
  factory IoRepo() => _instance;

  Future<String> get cacheDirPath async => (await getTemporaryDirectory()).path;
}
