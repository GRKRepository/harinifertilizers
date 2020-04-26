import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:harinifertilizers/database/transactions.dart';
import 'package:harinifertilizers/ui/registerform.dart';
import 'package:harinifertilizers/ui/utilities.dart';

class WriteRegisteredFarmers {
  List<Map<String, dynamic>> listOfRegisteredFarmers =
      new List<Map<String, dynamic>>();
  writeRegisteredFarmers(
      TextEditingController surNameController,
      TextEditingController nameController,
      TextEditingController phoneNumberController,
      BuildContext context,
      state,
      progressdialog) {
    if (surNameController.text.isNotEmpty &&
        nameController.text.isNotEmpty &&
        phoneNumberController.text.isNotEmpty) {
      DocumentReference documentReference = Firestore.instance
          .collection("farmers")
          .document(surNameController.text.toLowerCase() +
              nameController.text.toLowerCase());
      documentReference.get().then((datasnapshot) {
        if (datasnapshot.exists) {
          progressdialog.hide();
          showAlert(context, 'ooops!!!', 'Farmer already existed');
        } else {
          Firestore.instance
              .collection('farmers')
              .document(surNameController.text.toLowerCase() +
                  nameController.text.toLowerCase())
              .setData({
                "surname": surNameController.text,
                "name": nameController.text,
                "phonenumber": phoneNumberController.text
              })
              .then((result) => {
                    //      Navigator.pop(context),
                    surNameController.clear(),
                    nameController.clear(),
                    phoneNumberController.clear(),
                    progressdialog.hide(),
                    new Transactions()
                        .showAlert(context, 'Success!!!', 'Saved Successfully')
                  })
              .catchError((err) => {
                    progressdialog.hide(),
                    new Transactions()
                        .showAlert(context, 'Failed!!!', err.toString())
                  });
        }
      });
    }
  }

  updateFarmerDetails(selectedFarmerValue, phoneNumber, context, state, progressdialog) {
    Firestore.instance
        .collection('farmers')
        .document(selectedFarmerValue)
        .updateData({"phonenumber": phoneNumber})
        .then((result) => {
              state.setState(() {
                state.selectedFarmerValue = null;
                state.phoneNumberController.clear();
              }),
      progressdialog.hide(),
              showAlert(context, 'Success!!!', 'updated Successfully')
            })
        .catchError((err) => {
      progressdialog.hide(),
              new Transactions().showAlert(context, 'Failed!!!', err.toString())
            });
  }

  showAlert(BuildContext context, String title, String content) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
