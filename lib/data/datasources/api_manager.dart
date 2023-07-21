import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl;
  final http.Client httpClient;

  ApiClient({required this.baseUrl, required this.httpClient});

  Future<Map<String, dynamic>> get(String path) async {
    final response = await httpClient.get(Uri.parse('$baseUrl$path'));

    return _processResponse(response);
  }

  Future<Map<String, dynamic>> post(
    String path,
    {
      Map<String, dynamic> body = const {},
      Map<String, String> headers = const {}
    }
  ) async {
    print('URL $baseUrl$path');
    final response = await httpClient.post(
      Uri.parse('$baseUrl$path'),
      body: body,
      headers: headers
    );

    return _processResponse(response);
  }

  Map<String, dynamic> _processResponse(http.Response response) {
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else if (response.statusCode == 400) {
      throw Exception('Bad request');
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized');
    } else if (response.statusCode == 500) {
      throw Exception('Server error');
    } else {
      throw Exception('Failed to load data');
    }
  }
}