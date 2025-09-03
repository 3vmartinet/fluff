import 'package:url_launcher/url_launcher.dart';

extension UriExtensions on Uri {
  Future<bool> launch() async {
    if (await canLaunchUrl(this)) {
      return await launchUrl(this);
    } else {
      return false;
    }
  }
}
