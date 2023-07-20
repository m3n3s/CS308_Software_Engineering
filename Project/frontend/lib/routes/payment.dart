import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';
import '../models/bill.dart';
import '../main.dart';

class Payment extends StatefulWidget {
  const Payment({
    this.quantity,
    this.price,
    this.total,
    this.info,
    this.event,
  });

  final Bill info;
  final String total;
  final String quantity;
  final String price;
  final String event;

  static String routeName = "/payment";
  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  final _formKey = GlobalKey<FormState>();
  String creditCardNum, expiredDate, cvv, holder;

  Future<void> showAlertDialog(String title, String message) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                    size: 50,
                  ),
                  Text(message),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.popAndPushNamed(context, "/home");
                },
              )
            ],
          );
        });
  }

  Future<void> purchase() async {
    // Local host for django and endpoint for details
    final url = Uri.parse('http://127.0.0.1:8000/api/purchase');

    final requestBody = {
      "user-email": currentUser.email,
      "eventname": widget.event,
      "price": widget.price,
      "quantity": widget.quantity,
      "total": widget.total,
      "name": widget.info.name,
      "surname": widget.info.surname,
      "address": widget.info.address,
      "country": widget.info.country,
      "city": widget.info.city,
      "zipcode": widget.info.zipcode,
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

        showAlertDialog("Successfull!",
            "Thank you for choosing us! Your reservation details are sent to event's managers.");
      }
    } catch (error) {
      print("Error: $error");

      // An error occured, please try again later.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(
          "Step 2: Payment",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 15),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CircleAvatar(
                      child: Image.asset('assets/images/justicket.jpeg'),
                      radius: 80,
                      backgroundColor: Colors.transparent),
                  Text(
                    "Please enter you credit card information: ",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Please note that we only accept MasterCard and Visa",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    width: 300,
                    height: 100,
                    child: TextFormField(
                      decoration: InputDecoration(
                        //icon: Icon(Icons.home),
                        labelText: 'Card Holder',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: Colors.blueGrey[800]),
                          gapPadding: 1,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: Colors.blueGrey[800]),
                          gapPadding: 1,
                        ),
                      ),
                      keyboardType: TextInputType.text,
                      validator: CardHolderFieldValidator.validate,
                      onSaved: (String value) {
                        holder = value;
                      },
                    ),
                  ),
                  Container(
                    width: 300,
                    height: 100,
                    child: TextFormField(
                      decoration: InputDecoration(
                        //icon: Icon(Icons.home),
                        labelText: 'Credit Card Number',
                        hintText: "XXXX XXXX XXXX XXXX",
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: Colors.blueGrey[800]),
                          gapPadding: 1,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: Colors.blueGrey[800]),
                          gapPadding: 1,
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      validator: CardNumberFieldValidator.validate,
                      onSaved: (String value) {
                        creditCardNum = value;
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 150,
                        height: 100,
                        child: TextFormField(
                          decoration: InputDecoration(
                            //icon: Icon(Icons.home),
                            labelText: 'Expiration Date',
                            hintText: "MM/YYYY",
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide:
                                  BorderSide(color: Colors.blueGrey[800]),
                              gapPadding: 1,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide:
                                  BorderSide(color: Colors.blueGrey[800]),
                              gapPadding: 1,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          validator: ExpirationDateFieldValidator.validate,
                          onSaved: (String value) {
                            expiredDate = value;
                          },
                        ),
                      ),
                      SizedBox(width: 5),
                      Container(
                        width: 150,
                        height: 100,
                        child: TextFormField(
                          decoration: InputDecoration(
                            //icon: Icon(Icons.home),
                            labelText: 'CVV',
                            hintText: "XXX",
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide:
                                  BorderSide(color: Colors.blueGrey[800]),
                              gapPadding: 1,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide:
                                  BorderSide(color: Colors.blueGrey[800]),
                              gapPadding: 1,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          validator: CVVFieldValidator.validate,
                          onSaved: (String value) {
                            cvv = value;
                          },
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 150,
                    height: 50,
                    child: RawMaterialButton(
                      shape: const StadiumBorder(),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          purchase();
                        }
                      },
                      fillColor: kPrimaryColor,
                      child: Text(
                        "Purchase",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/mastercard-2.png'),
                      SizedBox(
                        width: 8,
                      ),
                      Image.asset('assets/images/visa.png'),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CardHolderFieldValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return "Cannot leave empty ";
    } else if (!value.contains(' ')) {
      return "Invalid name ";
    }
    return null;
  }
}

class CardNumberFieldValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return "Cannot leave empty ";
    }
    if (value.length != 16) {
      return "Credit Card number is not valid";
    }
    String input = getCleanedNumber(value);
    int sum = 0;
    int length = input.length;
    for (var i = 0; i < length; i++) {
      // get digits in reverse order
      int digit = int.parse(input[length - i - 1]);

      // every 2nd number multiply with 2
      if (i % 2 == 1) {
        digit *= 2;
      }
      sum += digit > 9 ? (digit - 9) : digit;
    }
    if (!(sum % 10 == 0)) {
      return 'Credit Card number is not valid';
    } else {
      return null;
    }
  }
}

class ExpirationDateFieldValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return "Cannot leave empty ";
    }
    int year;
    int month;
    if (value.contains(new RegExp(r'(/)'))) {
      var split = value.split(new RegExp(r'(/)'));
      // The value before the slash is the month while the value to right of
      // it is the year.
      month = int.parse(split[0]);
      year = int.parse(split[1]);
    } else {
      // Only the month was entered
      month = int.parse(value.substring(0, (value.length)));
      year = -1; // Lets use an invalid year intentionally
    }

    if ((month < 1) || (month > 12)) {
      // A valid month is between 1 (January) and 12 (December)
      return 'Expiry month is invalid';
    }

    var fourDigitsYear = convertYearTo4Digits(year);
    if ((fourDigitsYear < 1) || (fourDigitsYear > 2099)) {
      // We are assuming a valid should be between 1 and 2099.
      // Note that, it's valid doesn't mean that it has not expired.
      return 'Expiry year is invalid';
    }

    if (!hasDateExpired(month, year)) {
      return "Card has expired";
    }

    return null;
  }
}

class CVVFieldValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return "Cannot leave empty ";
    }
    if (value.length < 3 || value.length > 4) {
      return "CVV is invalid";
    }
    return null;
  }
}

//Below functions are taken from : https://github.com/wilburt/Payment-Card-Validation/blob/master/lib/payment_card.dart

int convertYearTo4Digits(int year) {
  if (year < 100 && year >= 0) {
    var now = DateTime.now();
    String currentYear = now.year.toString();
    String prefix = currentYear.substring(0, currentYear.length - 2);
    year = int.parse('$prefix${year.toString().padLeft(2, '0')}');
  }
  return year;
}

bool hasDateExpired(int month, int year) {
  return isNotExpired(year, month);
}

bool isNotExpired(int year, int month) {
// It has not expired if both the year and date has not passed
  return !hasYearPassed(year) && !hasMonthPassed(year, month);
}

bool hasMonthPassed(int year, int month) {
  var now = DateTime.now();
// The month has passed if:
// 1. The year is in the past. In that case, we just assume that the month
// has passed
// 2. Card's month (plus another month) is more than current month.
  return hasYearPassed(year) ||
      convertYearTo4Digits(year) == now.year && (month < now.month + 1);
}

bool hasYearPassed(int year) {
  int fourDigitsYear = convertYearTo4Digits(year);
  var now = DateTime.now();
// The year has passed if the year we are currently is more than card's
// year
  return fourDigitsYear < now.year;
}

String getCleanedNumber(String text) {
  RegExp regExp = new RegExp(r"[^0-9]");
  return text.replaceAll(regExp, '');
}
