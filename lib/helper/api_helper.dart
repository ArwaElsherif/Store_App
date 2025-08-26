// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiHelper {
  Future<dynamic> get({required String url, String? token}) async {
    Map<String, String> headers = {};
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    print('🌐 [GET] url= $url , token= $token');

    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        print('✅ [GET Response] ${jsonDecode(response.body)}');
        return jsonDecode(response.body);
      } else {
        throw Exception('❌ [GET Error] Status code ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('⚠️ [GET Exception] Error fetching data: $e');
    }
  }

  Future<dynamic> post({
    required String url,
    required dynamic body,
    String? token,
  }) async {
    Map<String, String> headers = {'Content-Type': 'application/json'};
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    print('📤 [POST] url= $url , body= $body , token= $token');

    try {
      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode(body),
        headers: headers,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ [POST Response] ${jsonDecode(response.body)}');
        return jsonDecode(response.body);
      } else {
        throw Exception(
          '❌ [POST Error] Status code ${response.statusCode}, body: ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('⚠️ [POST Exception] Error posting data: $e');
    }
  }

  Future<dynamic> put({
    required String url,
    required dynamic body,
    String? token,
  }) async {
    Map<String, String> headers = {'Content-Type': 'application/json'};
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    print('✏️ [PUT] url= $url , body= $body , token= $token');

    try {
      final response = await http.put(
        Uri.parse(url),
        body: jsonEncode(body),
        headers: headers,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ [PUT Response] ${jsonDecode(response.body)}');
        return jsonDecode(response.body);
      } else {
        throw Exception(
          '❌ [PUT Error] Status code ${response.statusCode}, body: ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('⚠️ [PUT Exception] Error updating data: $e');
    }
  }
}
