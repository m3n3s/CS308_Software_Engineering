import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import 'package:frontend/utils/constants.dart';
import 'package:email_validator/email_validator.dart';
import '../models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  String name, email, password;
  bool _passwordVisible;
  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
    passwordController.text = password;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final _key = GlobalKey<FormState>();

    Future loginUser() async {
      // print("email: $email, password: $password");

      // Local host for django and endpoint for logging in
      final url = Uri.parse('http://127.0.0.1:8000/api/log-in');

      final requestBody = {
        "email": email,
        "password": password,
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

          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("email", currentUser.email);
          prefs.setBool("isLoggedIn", true);

          // Redirect to home page where the user is signed in
          Navigator.pushNamed(context, '/home');
        }
      } catch (error) {
        print("Error: $error");

        // An error occured, please try again later.
      }
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(size.width > 770
              ? 64
              : size.width > 670
                  ? 32
                  : 16),
          child: Center(
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(25),
                ),
              ),
              child: Form(
                key: _key,
                child: Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[700],
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Container(
                            width: 30,
                            child: Divider(
                              color: kPrimaryColor,
                              thickness: 2,
                            ),
                          ),
                          SizedBox(
                            height: 32,
                          ),
                          SizedBox(
                            height: 32,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              hintText: 'E-mail',
                              labelText: 'E-mail',
                              suffixIcon: Icon(
                                Icons.mail_outline,
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Please don't leave e-mail address empty!";
                              }
                              if (!EmailValidator.validate(value)) {
                                return "Please enter a valid e-mail address!";
                              }

                              return null;
                            },
                            onSaved: (value) {
                              email = value;
                            },
                          ),
                          SizedBox(
                            height: 32,
                          ),
                          TextFormField(
                            controller: passwordController,
                            obscureText: !_passwordVisible,
                            decoration: InputDecoration(
                              hintText: 'Password',
                              labelText: 'Password',
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Theme.of(context).primaryColorDark,
                                ),
                                onPressed: () {
                                  // Update the state i.e. toogle the state of passwordVisible variable
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                    password = passwordController.text;
                                  });
                                },
                              ),
                            ),
                            keyboardType: TextInputType.visiblePassword,
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Please don't leave password empty!";
                              }
                              if (value.length < 8) {
                                return "Password must be at least 8 characters!";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              password = value;
                            },
                          ),
                          SizedBox(
                            height: 64,
                          ),
                          InkWell(
                            onTap: () {
                              if (_key.currentState.validate()) {
                                _key.currentState.save();
                                loginUser();
                              }
                            },
                            child: Container(
                              height: 50,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: kPrimaryColor,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(25),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: kPrimaryColor.withOpacity(0.2),
                                    spreadRadius: 4,
                                    blurRadius: 7,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 32,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account?",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    Navigator.pushNamed(context, '/signup');
                                  });
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      "Register",
                                      style: TextStyle(
                                        color: kPrimaryColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Icon(
                                      Icons.arrow_forward,
                                      color: kPrimaryColor,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Continue as a guest.",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    Navigator.pushNamed(context, '/home');
                                  });
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      "HomePage",
                                      style: TextStyle(
                                        color: kPrimaryColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Icon(
                                      Icons.arrow_forward,
                                      color: kPrimaryColor,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
