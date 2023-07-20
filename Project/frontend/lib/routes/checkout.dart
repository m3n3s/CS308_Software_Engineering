import 'package:flutter/material.dart';
import 'package:frontend/main.dart';
import '../utils/countdown.dart';
import '../models/bill.dart';
import 'payment.dart';
import 'package:frontend/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Bill info = Bill();
final _billingKey = GlobalKey<FormState>();

class CheckOut extends StatefulWidget {
  const CheckOut(
      {Key key,
      this.eventname,
      this.date,
      this.type,
      this.number,
      this.price,
      this.total})
      : super(key: key);

  final String eventname;
  final String date;
  final String type;
  final String number;
  final String price;
  final String total;

  @override
  _CheckOutState createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  Bill info;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(
          "Step 1: Billing Information",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        margin: media.width > 900
            ? EdgeInsets.fromLTRB(150, 20, 150, 20)
            : EdgeInsets.fromLTRB(50, 20, 50, 20),
        child: media.width > 900
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Billing information
                  Expanded(child: BillingForm()),

                  // Timer box with selected details
                  Expanded(
                    child: Details(
                      eventname: widget.eventname,
                      date: widget.date,
                      type: widget.type,
                      number: widget.number,
                      price: widget.price,
                      total: widget.total,
                    ),
                  ),
                ],
              )
            : ListView(
                children: [
                  // Billing information
                  BillingForm(),

                  SizedBox(height: 50),

                  // Timer box with selected details
                  Details(
                    eventname: widget.eventname,
                    date: widget.date,
                    type: widget.type,
                    number: widget.number,
                    price: widget.price,
                    total: widget.total,
                  ),
                ],
              ),
      ),
    );
  }
}

class Details extends StatefulWidget {
  Details({
    Key key,
    this.eventname = " ",
    this.date = " ",
    this.type = " ",
    this.number = " ",
    this.price = " ",
    this.total = " ",
  }) : super(key: key);

  final String eventname;
  final String date;
  final String type;
  final String number;
  final String price;
  String total;

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  final _discountKey = GlobalKey<FormState>();
  TextEditingController discountController = TextEditingController();
  String discountCode = "";
  bool disableDiscount = false;

  Future checkCode() async {
    // Local host for django and endpoint for discount codes
    final url = Uri.parse('http://127.0.0.1:8000/api/discount');

    final requestBody = {
      "code": discountCode,
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
        var rsp = json.decode(response.body);

        double discount = rsp["discount"];
        double oldTotal = double.parse(widget.total);
        double newTotal = oldTotal - oldTotal * discount;

        // Valid code, update total price:
        setState(() {
          widget.total = newTotal.toString();
          disableDiscount = true;
          FocusScope.of(context).unfocus();
          discountController.clear();
        });
      } else {
        // Not a valid code:
      }
    } catch (error) {
      print("Error: $error");

      // An error occured, please try again later.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              "Details",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          Text(widget.eventname),
          Text(widget.date),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Type:"),
              Text(widget.type),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Price:"),
              Text("${widget.price} x ${widget.number}"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total:"),
              Text(widget.total),
            ],
          ),
          SizedBox(height: 30),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text("Remaining Time:"),
              Timer(),
            ],
          ),
          SizedBox(height: 20),
          Text("Discount Code:"),
          Form(
            key: _discountKey,
            child: TextFormField(
              controller: discountController,
              readOnly: disableDiscount,
              decoration: InputDecoration(
                suffixIcon: !disableDiscount
                    ? IconButton(
                        icon: Icon(
                          Icons.send,
                        ),
                        onPressed: () {
                          if (_discountKey.currentState.validate()) {
                            _discountKey.currentState.save();
                            checkCode();
                          }
                        },
                      )
                    : Container(),
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return "Please enter the code before submitting!";
                }
                return null;
              },
              onSaved: (value) {
                discountCode = value;
              },
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () {
                if (_billingKey.currentState.validate()) {
                  _billingKey.currentState.save();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Payment(
                        event: widget.eventname,
                        quantity: widget.number,
                        price: widget.price,
                        total: widget.total,
                        info: info,
                      ),
                    ),
                  );
                }
              },
              child: Text("Continue"),
              style: ElevatedButton.styleFrom(
                primary: kPrimaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BillingForm extends StatefulWidget {
  const BillingForm({Key key}) : super(key: key);

  @override
  _BillingFormState createState() => _BillingFormState();
}

class _BillingFormState extends State<BillingForm> {
  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    final contWidth = media.width - 300;

    return Container(
      child: Form(
        key: _billingKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "Billing Information",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              Text("Name"),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please don't leave this space empty!";
                  }
                  return null;
                },
                onSaved: (value) {
                  info.name = value;
                },
              ),
              SizedBox(height: 20),
              Text("Surname"),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please don't leave this space empty!";
                  }
                  return null;
                },
                onSaved: (value) {
                  info.surname = value;
                },
              ),
              SizedBox(height: 20),
              Text("Address"),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please don't leave this space empty!";
                  }
                  return null;
                },
                onSaved: (value) {
                  info.address = value;
                },
              ),
              SizedBox(height: 20),
              Text("Country"),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please don't leave this space empty!";
                  }
                  return null;
                },
                onSaved: (value) {
                  info.country = value;
                },
              ),
              SizedBox(height: 20),
              Text("City"),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please don't leave this space empty!";
                  }
                  return null;
                },
                onSaved: (value) {
                  info.city = value;
                },
              ),
              SizedBox(height: 20),
              Text("Zip Code"),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please don't leave this space empty!";
                  }
                  return null;
                },
                onSaved: (value) {
                  info.zipcode = value;
                },
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
