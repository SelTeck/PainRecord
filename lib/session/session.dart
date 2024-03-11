import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart' as http;
import 'package:pain_record/commmon/commons.dart';

class Session {
  // static const host = 'http://two-cats.iptime.org:3000';
  static const host = 'http://192.168.0.42:3000';
  static Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  };

  static Map<String, String> cookies = {};

  static Future<dynamic> get({required String url}) {
    return http.get(Uri.parse(url), headers: headers);

    // final response = await http.get(Uri.parse(url), headers: headers);

    // if (response.statusCode < 200 || response.statusCode > 400) {
    //   Commons.logger.e('response.statusCode is ${response.statusCode}');
    //   return null;
    // }

    // return jsonDecode(response.body);
  }

  static Future<dynamic> put({required String url, required dynamic body}) {
    return http.put(Uri.parse(url), body: body, headers: headers);
  }

  static Future<dynamic> post({required String url, required dynamic body}) {
    return http.post(Uri.parse(url), body: body, headers: headers);
  }

  static Future<dynamic> delete({required String url, required dynamic body}) {
    return http.delete(Uri.parse(url, body), body: body, headers: headers);
  }
}
