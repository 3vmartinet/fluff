import 'package:http/http.dart' as http;

class HttpRepo {
  Future<String> fetchUrl(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      return response.body;
    } catch (e) {
      return 'Error occurred: $e';
    }
  }
}
