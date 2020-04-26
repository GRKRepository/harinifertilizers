import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:harinifertilizers/ui/registeredfarmers.dart';
import 'package:harinifertilizers/ui/utilities.dart';

class ReadRegisteredFarmers {
  List<Map<String, dynamic>> listOfRegisteredFarmers =
      new List<Map<String, dynamic>>();
  List<String> farmerNames = new List<String>();
  fetchRegisteredFarmers(RegisteredFarmersState rf, context) {
    Firestore.instance.collection('farmers').getDocuments().then((snapshot) => {
          snapshot.documents.forEach(
              (document) => {listOfRegisteredFarmers.add(document.data)}),
          rf.setState(() {})
        });
    return listOfRegisteredFarmers;
  }

  fetchFarmerNames(State rf) {
    Firestore.instance.collection('farmers').getDocuments().then((snapshot) => {
          snapshot.documents.forEach((document) => {
                farmerNames.add(
                    document.data['surname'] + " " + document.data['name']),
              }),
          rf.setState(() {})
        });
    return farmerNames;
  }

  fetchFarmerBillNos(selectedFarmerValue, famerBillNos, State rf) {
    famerBillNos.clear();
    Firestore.instance
        .collection('bills')
        .where('name', isEqualTo: selectedFarmerValue)
        .getDocuments()
        .then((snapshot) => {
              snapshot.documents.forEach((document) => {
                    famerBillNos.add(document.data['billno']),
                  }),
              rf.setState(() {})
            });
    //return farmerNames;
  }

  fetchFarmerBillNoBasedAmountAndDate(
      selectedFarmerValue, selectedBillNoValue, state) {
    Firestore.instance
        .collection('bills')
        .where('name', isEqualTo: selectedFarmerValue)
        .where('billno', isEqualTo: selectedBillNoValue)
        .getDocuments()
        .then((snapshot) => {
              snapshot.documents.forEach((document) => {
                    state.selectedTypeValue = document.data['type'].toString(),
                    state.amountController.text =
                        document.data['amount'].toString(),
                    state.billDateController.text =
                        document.data['billdate'].toString(),
                  }),
              state.setState(() {})
            });
    //return farmerNames;
  }

  Future<String> fetchFarmerDetailsByName(
      queryValue, phoneNumberController, state) {
    print(queryValue);
    CollectionReference query = Firestore.instance.collection('farmers');
    query.document(queryValue).get().then((document) {
      phoneNumberController.text = document.data['phonenumber'].toString();
      state.setState(() {});
    });
  }

  deleteFarmerByName(selectedFarmerValue, context, state, progressdialog) {
    CollectionReference query = Firestore.instance.collection('farmers');
    query
        .document(selectedFarmerValue)
        .delete()
        .then((result) => {
              state.setState(() {
                state.selectedFarmerValue = null;
                state.phoneNumberController.clear();
              }),
              progressdialog.hide(),
              Utilities.showAlert(
                  context, 'Success!!!', 'farmer deleted Successfully')
            })
        .catchError((err) => {
              progressdialog.hide(),
              Utilities.showAlert(context, 'Failed!!!', err.toString())
            });
  }
}
