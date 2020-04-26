import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:harinifertilizers/database/writeregisteredfarmers.dart';
import 'package:harinifertilizers/ui/registeredfarmers.dart';
import 'package:intl/intl.dart';

class DropdownComponent extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => DropdownComponentState();
}

class DropdownComponentState extends State<DropdownComponent> {
  final registerFormKey = GlobalKey<FormState>();
  final alphanumeric = RegExp(r'^[a-zA-Z0-9]+$');
  TextEditingController surNameController = TextEditingController();
  String dropdownValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Registration Form",
        ),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        padding: EdgeInsets.all(15.0),
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Form(
              key: registerFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  renderDropDown(),
                ],
              ),
            )),
      ),
    );
  }

  renderDropDown() {
    return DropdownButton<String>(
      value: dropdownValue,
      hint: Text('Please select a farmer  '),
      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String newValue) {
        setState(() {
              dropdownValue = newValue;
        });
      },
      items: <String>['Rama Koteswararao', 'Rajeswarararo', 'Suneetha Gutta', 'Akshara Gutta']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
