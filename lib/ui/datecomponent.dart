import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateComponent extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => DateComponentState();
}

class DateComponentState extends State<DateComponent> {
  final registerFormKey = GlobalKey<FormState>();
  final alphanumeric = RegExp(r'^[a-zA-Z0-9]+$');
  TextEditingController surNameController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

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
                  renderDate(),
                ],
              ),
            )),
      ),
    );
  }

  renderDate() {
    TextFormField(
        readOnly: true,
        onTap: () {
          showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(DateTime.now().year - 5),
            lastDate: DateTime(DateTime.now().year + 5),
          ).then((date) {
            surNameController.text = DateFormat('dd/MM/yyyy').format(date);
          });
        },
        controller: surNameController,
        decoration: InputDecoration(hintText: 'surname'),
        validator: (value) {
          if (value.isEmpty) {
            return 'Please enter surname';
          }
          if (!alphanumeric.hasMatch(value)) {
            return 'special characters are not allowed';
          }
          return null;
        });
  }
}
