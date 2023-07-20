import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user.dart';
import '../main.dart';

Future getUser(String email) async {
// Local host for django and endpoint for getting user
  final url = Uri.parse('http://127.0.0.1:8000/api/get-user');

  final requestBody = {
    "email": email,
  };

  try {
    final response = await http.post(
      url,
      body: requestBody,
      encoding: Encoding.getByName("utf-8"),
    );

    // Succesfull transmission
    if (response.statusCode >= 200 && response.statusCode < 300) {
      print("Transmission was succesfull!!!");

      isLoggedIn = true;
      currentUser = User.fromJson(jsonDecode(response.body));
    }
  } catch (error) {
    print("Error: $error");

    // An error occured, please try again later.
  }
}
