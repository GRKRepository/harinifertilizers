import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:harinifertilizers/database/writeregisteredfarmers.dart';
import 'package:harinifertilizers/ui/registeredfarmers.dart';
import 'package:harinifertilizers/ui/updatefarmer.dart';
import 'package:harinifertilizers/ui/utilities.dart';
import 'package:progress_dialog/progress_dialog.dart';

class RegisterForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RegisterFormState();
}

class RegisterFormState extends State<RegisterForm> {
  final registerFormKey = GlobalKey<FormState>();
  final alphanumeric = RegExp(r'^[a-zA-Z0-9]+$');
  final numeric = RegExp(r'^[0-9]{10}$');
  TextEditingController surNameController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  RaisedButton addButton;
  ProgressDialog progressdialog;

  @override
  Widget build(BuildContext context) {
    progressdialog = Utilities.renderProgressDial(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Registration Form",
        ),
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
                  TextFormField(
                      controller: surNameController,
                      decoration: InputDecoration(
                          hintText: 'surname',
                          suffixIcon: const Icon(Icons.person, size: 30.0)),
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter surname';
                        }
                        if (!alphanumeric.hasMatch(value)) {
                          return 'special characters are not allowed';
                        }
                        return null;
                      }),
                  TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                          hintText: 'name',
                          suffixIcon: const Icon(Icons.person, size: 30.0)),
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter name';
                        }
                        if (!alphanumeric.hasMatch(value)) {
                          return 'special characters are not allowed';
                        }
                        return null;
                      }),
                  TextFormField(
                      controller: phoneNumberController,
                      decoration: InputDecoration(
                          hintText: 'phone number',
                          suffixIcon:
                              const Icon(Icons.local_phone, size: 30.0)),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter phone number';
                        }
                        if (value.isNotEmpty && value.length != 10) {
                          return 'phone number must be 10 digits';
                        }
                        if (!numeric.hasMatch(value)) {
                          return 'only digits are allowed';
                        }
                        return null;
                      }),
                  Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
                      child: renderAddButton()),
                ],
              ),
            )),
      ),
      floatingActionButton: renderFloatingButton(),
    );
  }

  renderAddButton() {
    addButton = new RaisedButton.icon(
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(18.0),
            side: BorderSide(color: Colors.blue)),
        icon: Icon(
          Icons.person_add,
          size: 30.0,
        ),
        label: const Text('Add'),
        /*child: Text(
                            'Submit',
                            textScaleFactor: 1.5,
                          ),*/
        color: Theme.of(context).primaryColorDark,
        textColor: Theme.of(context).primaryColorLight,
        onPressed: () {
          if (registerFormKey.currentState.validate()) {
            String contentMsg = "Are you sure You want to Add the farmer: " +
                surNameController.text.toString() +
                " " +
                nameController.text.toString() +
                " ?";
            new Utilities()
                .renderAlert(context, contentMsg, addAction, progressdialog);
          }
        });

    return addButton;
  }

  addAction() {
    new WriteRegisteredFarmers().writeRegisteredFarmers(surNameController,
        nameController, phoneNumberController, context, this, progressdialog);
  }

  renderFloatingButton() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.of(context).push(new MaterialPageRoute(
            builder: (context) => new UpdateFarmer(), maintainState: true));
      },
      child: Icon(
        Icons.mode_edit,
      ),
      foregroundColor: Colors.white,
    );
  }
}
