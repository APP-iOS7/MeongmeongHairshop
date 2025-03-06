import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> searchPlace(String query) async {
  final url = Uri.parse(
      'https://openapi.naver.com/v1/search/local.json?query=$query&display=5&start=1&sort=random');

  final response = await http.get(
    url,
    headers: {
      'X-Naver-Client-Id': 'yd79jdvpdg',  // 네이버 API Client ID
      'X-Naver-Client-Secret': 'lgryqtHmN5wwoHgoar6qYyx0RnaNE2IljYpIGSFX',  // 네이버 API Client Secret
    },
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    print(data);  // 미용실/애견미용샵 정보 출력
  } else {
    print('Error: ${response.statusCode}');
  }
}