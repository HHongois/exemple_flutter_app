import 'package:webfeed/webfeed.dart';
import 'package:http/http.dart' as http;

class Parser {
  final url = "http://www.france24.com/fr/actualites/rss";
  final client = http.Client();

  Future chargerRss() async {
    final response = await client.get(url);
    if (response.statusCode == 200) {
      final data = new RssFeed.parse(response.body);
      return data;
    } else {
      print("erreur: ${response.statusCode}");
    }
  }
}
