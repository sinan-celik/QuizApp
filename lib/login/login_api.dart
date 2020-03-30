import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginApi {
  Future<bool> registerUserWithEmail(
      {String email, String name, String pass, String phone}) async {
    const url = 'http://10.0.2.2:81/api/Auth/register';
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
    print('response login');
    print(response.body);

    return true;
  }
}
