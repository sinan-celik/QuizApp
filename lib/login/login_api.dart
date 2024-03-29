import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quiz_app/src/globals.dart' as globals;

class LoginApi {
  Future<http.Response> registerUserWithEmail(
      {String email, String name, String pass, String phone}) async {
    final url = '${globals.apiUrl}/api/Auth/register';
    final _body = json.encode({
      'email': email,
      'password': pass,
      'name': name,
      'phone': phone,
    });

    final Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    final response = await http.post(
      url,
      body: _body,
      headers: headers,
    );
    // print('response login');
    // print(response.body);

    return response;
  }


    Future<http.Response> loginUserWithEmail({String email, String pass}) async {
    final url = '${globals.apiUrl}/api/Auth/login';
    final _body = json.encode({
      'email': email,
      'password': pass,
    });

    final Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    final response = await http.post(
      url,
      body: _body,
      headers: headers,
    );
    // print('response login');
    // print(response.body);

    return response;
  }
}
