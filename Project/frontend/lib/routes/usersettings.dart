import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../utils/appbars.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../main.dart';

class UserSettings extends StatefulWidget {
  @override
  _UserSettingsState createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  String editedname = "";
  String editedusername = "";
  String editedpassword = "";
  String editedphonenumber = "";

  final _formkey = GlobalKey<FormState>();

  Future saveChanges() async {
    // Local host for django and endpoint for user settings
    final url = Uri.parse('http://127.0.0.1:8000/api/settings');

    final requestBody = {
      "email": currentUser.email,
      "username": editedusername,
      "name": editedname,
      "password": editedpassword,
      "phoneNumber": editedphonenumber,
      "isActive": "",
      "deleteAccount": "",
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

        Navigator.pushNamed(context, "/home");
      }
    } catch (error) {
      print("Error: $error");

      // An error occured, please try again later.
    }
  }

  Future deactivateAccount() async {
    // Local host for django and endpoint for user settings
    final url = Uri.parse('http://127.0.0.1:8000/api/settings');

    final requestBody = {
      "email": currentUser.email,
      "username": "",
      "name": "",
      "password": "",
      "phoneNumber": "",
      "isActive": "False",
      "deleteAccount": "",
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

        isLoggedIn = false;
        currentUser = null;

        Navigator.pushNamed(context, "/home");
      }
    } catch (error) {
      print("Error: $error");

      // An error occured, please try again later.
    }
  }

  Future deleteAccount() async {
    // Local host for django and endpoint for user settings
    final url = Uri.parse('http://127.0.0.1:8000/api/settings');

    final requestBody = {
      "email": currentUser.email,
      "username": "",
      "name": "",
      "password": "",
      "phoneNumber": "",
      "isActive": "",
      "deleteAccount": "True",
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

        isLoggedIn = false;
        currentUser = null;

        Navigator.pushNamed(context, "/home");
      }
    } catch (error) {
      print("Error: $error");

      // An error occured, please try again later.
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: finalAppbar(context),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
                  height: 10.0,
                ),
                InkWell(
                  onTap: () {
                    print("tapped on camera icon");
                  },
                  child: Container(
                    height: 100.0,
                    decoration: new BoxDecoration(
                      color: Colors.orange.shade400,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          //Image.file(
                          //imageFile,
                          //fit: BoxFit.cover,
                          //)
                          Icon(
                            Icons.camera_alt_rounded,
                            color: Colors.black,
                            size: 50.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5.0),
                Center(
                  child: InkWell(
                    onTap: () {
                      print("tapped on 'Set New Photo'");
                    },
                    child: Text(
                      "Set New Photo",
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                ),
                Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      Card(
                        margin:
                            const EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 8.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              title: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text('Username :'),
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      onSaved: (String value) {
                                        editedusername = value;
                                      },
                                      // your TextField's Content
                                      keyboardType: TextInputType.text,
                                      obscureText: false,
                                      enableSuggestions: false,
                                      autocorrect: false,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ListTile(
                              title: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text('Name :'),
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      onSaved: (String value) {
                                        editedname = value;
                                      },
                                      // your TextField's Content
                                      keyboardType: TextInputType.text,
                                      obscureText: false,
                                      enableSuggestions: false,
                                      autocorrect: false,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Card(
                        margin:
                            const EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 8.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        child: ListTile(
                          title: Row(
                            children: <Widget>[
                              Expanded(
                                child: Text('Phone Number :'),
                              ),
                              Expanded(
                                child: TextFormField(
                                  onSaved: (String value) {
                                    editedphonenumber = value;
                                  },
                                  // your TextField's Content
                                  keyboardType: TextInputType.text,
                                  obscureText: false,
                                  enableSuggestions: false,
                                  autocorrect: false,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        margin:
                            const EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 8.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        child: ListTile(
                          title: Row(
                            children: <Widget>[
                              Expanded(
                                child: Text('Password :'),
                              ),
                              Expanded(
                                child: TextFormField(
                                  onSaved: (String value) {
                                    editedpassword = value;
                                  },
                                  // your TextField's Content
                                  keyboardType: TextInputType.text,
                                  obscureText: false,
                                  enableSuggestions: false,
                                  autocorrect: false,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      OutlinedButton(
                        onPressed: () {
                          _formkey.currentState.save();
                          saveChanges();
                        },
                        child: Text("Save Changes"),
                        style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all(Colors.blueAccent),
                          textStyle: MaterialStateProperty.all(TextStyle(
                            fontWeight: FontWeight.w900,
                          )),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Center(
                        child: OutlinedButton(
                          onPressed: deactivateAccount,
                          child: Text("Deactivate Account"),
                          style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all(Colors.red),
                            textStyle: MaterialStateProperty.all(TextStyle(
                              fontWeight: FontWeight.w900,
                            )),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Center(
                        child: OutlinedButton(
                          onPressed: deleteAccount,
                          child: Text("Delete Account"),
                          style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all(Colors.red),
                            textStyle: MaterialStateProperty.all(TextStyle(
                              fontWeight: FontWeight.w900,
                            )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
