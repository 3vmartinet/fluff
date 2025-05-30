import 'package:http/http.dart' as http;

class HttpRepo {
  static final HttpRepo _instance = HttpRepo._init();

  HttpRepo._init();
  factory HttpRepo() => _instance;

  Future<String> fetchUrl(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      return response.body;
    } catch (e) {
      return 'Error occurred: $e';
    }
  }
}
