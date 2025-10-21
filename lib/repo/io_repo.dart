import 'package:path_provider/path_provider.dart';

class IoRepo {
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
