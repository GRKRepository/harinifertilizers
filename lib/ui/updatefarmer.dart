import 'package:flutter/material.dart';
import 'package:harinifertilizers/database/readregisteredfarmers.dart';
import 'package:harinifertilizers/database/writeregisteredfarmers.dart';
import 'package:harinifertilizers/ui/utilities.dart';
import 'package:progress_dialog/progress_dialog.dart';

class UpdateFarmer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => UpdateFarmerState();
}

class UpdateFarmerState extends State<UpdateFarmer> {
  final registerFormKey = GlobalKey<FormState>();
  final alphanumeric = RegExp(r'^[a-zA-Z0-9]+$');
  TextEditingController surNameController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  String selectedFarmerValue;
  List<String> famerNames = new List<String>();
  ProgressDialog progressdialog;
  final numeric = RegExp(r'^[0-9]{10}$');

  @override
  void initState() {
    super.initState();
    famerNames = new ReadRegisteredFarmers().fetchFarmerNames(this);
  }

  @override
  Widget build(BuildContext context) {
    progressdialog = Utilities.renderProgressDial(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Update Farmer",
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
                  renderName(),
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
                      child: new RaisedButton.icon(
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.blue)),
                          icon: Icon(
                            Icons.update,
                            size: 30.0,
                          ),
                          label: const Text('Update'),
                          /*child: Text(
                            'Submit',
                            textScaleFactor: 1.5,
                          ),*/
                          color: Theme.of(context).primaryColorDark,
                          textColor: Theme.of(context).primaryColorLight,
                          onPressed: () {
                            if (isFormValidationSuccess()) {
                              if (registerFormKey.currentState.validate()) {
                                String contentMsg =
                                    "Are you sure You want to Update the farmer: " +
                                        selectedFarmerValue.toString();
                                new Utilities().renderAlert(context, contentMsg,
                                    updateAction, progressdialog);
                              }
                            }
                          })),
                  Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
                      child: new RaisedButton.icon(
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.blue)),
                          icon: Icon(
                            Icons.delete_forever,
                            size: 30.0,
                          ),
                          label: const Text('Delete'),
                          /*child: Text(
                            'Submit',
                            textScaleFactor: 1.5,
                          ),*/
                          color: Theme.of(context).primaryColorDark,
                          textColor: Theme.of(context).primaryColorLight,
                          onPressed: () {
                            if (isFormValidationSuccess()) {
                              if (registerFormKey.currentState.validate()) {
                                String contentMsg =
                                    "Are you sure You want to Delete the farmer: " +
                                        selectedFarmerValue.toString();
                                new Utilities().renderAlert(context, contentMsg,
                                    deleteAction, progressdialog);
                              }
                            }
                          })),
                ],
              ),
            )),
      ),
    );
  }

  updateAction() {
    new WriteRegisteredFarmers().updateFarmerDetails(
        selectedFarmerValue.replaceAll(" ", "").toLowerCase(),
        phoneNumberController.text.toLowerCase().toString(),
        context,
        this,
        progressdialog);
  }

  deleteAction() {
    new ReadRegisteredFarmers().deleteFarmerByName(
        selectedFarmerValue.replaceAll(" ", "").toLowerCase().toString(),
        context,
        this,
        progressdialog);
  }

  renderName() {
    return DropdownButton<String>(
      isExpanded: true,
      value: selectedFarmerValue,
      hint: Text('Please select a farmer  ',
          style: TextStyle(fontFamily: 'Quicksand')),
      icon: Icon(Icons.arrow_drop_down),
      iconSize: 40.0,
      // elevation: 16,
      style: TextStyle(color: Colors.black),
      underline: Container(
        height: 2,
        color: Colors.grey,
      ),
      onChanged: (String newValue) {
        setState(() {
          selectedFarmerValue = newValue;
          String queryValue =
              selectedFarmerValue.toLowerCase().replaceAll(" ", "");
          new ReadRegisteredFarmers().fetchFarmerDetailsByName(
              queryValue, phoneNumberController, this);
          setState(() {});
        });
      },
      items: famerNames.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value, style: TextStyle(fontFamily: 'Quicksand')),
        );
      }).toList(),
    );
  }

  bool isFormValidationSuccess() {
    if (selectedFarmerValue == null) {
      Utilities.showAlert(context, ' ooops!!!', 'Please select a farmer');
      return false;
    }
    return true;
  }
}
