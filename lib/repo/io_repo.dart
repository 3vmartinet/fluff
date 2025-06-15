import 'package:path_provider/path_provider.dart';

class IoRepo {
  static final IoRepo _instance = IoRepo._init();

  IoRepo._init();
  factory IoRepo() => _instance;

  Future<String?> get cacheDirPath async {
    try {
      return (await getTemporaryDirectory()).path;
    } on Exception {
      return null;
    }
  }

  Future<String?> get extDirPath async {
    try {
      return (await getExternalStorageDirectory())?.path;
    } on Exception {
      return cacheDirPath;
    }
  }
}
