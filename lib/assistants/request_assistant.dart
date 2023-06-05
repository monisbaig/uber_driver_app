import 'dart:convert';

import 'package:http/http.dart' as http;

class RequestAssistant {
  static Future<dynamic> receiveRequest(String url) async {
    final response = await http.get(Uri.parse(url));
    try {
      if (response.statusCode == 200) {
        var decodedResponse = jsonDecode(response.body);
        return decodedResponse;
      } else {
        return 'Something went wrong';
      }
    } catch (e) {
      return 'Error Occurred';
    }
  }
}
