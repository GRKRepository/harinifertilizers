import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:harinifertilizers/ui/bills.dart';
import 'package:harinifertilizers/ui/billsearch.dart';
import 'package:harinifertilizers/ui/utilities.dart';
import 'package:intl/intl.dart';

class Transactions {
  List<Map<String, dynamic>> listOfBills = new List<Map<String, dynamic>>();
  DateFormat dateFormat = DateFormat('dd/MM/yyyy');

  addBill(
      String selectedFarmerValue,
      TextEditingController billNoController,
      TextEditingController amountController,
      TextEditingController billDateController,
      String selectedTypeValue,
      BuildContext context,
      state,
      progressdialog) {
    if (selectedFarmerValue.isNotEmpty &&
        billNoController.text.isNotEmpty &&
        amountController.text.isNotEmpty &&
        billDateController.text.isNotEmpty &&
        selectedTypeValue.isNotEmpty) {
      DocumentReference documentReference = Firestore.instance
          .collection("bills")
          .document(billNoController.text.toLowerCase());
      documentReference.get().then((datasnapshot) {
        if (datasnapshot.exists) {
          progressdialog.hide();
          showAlert(context, 'ooops!!!', 'Bill No already existed');
        } else {
          Firestore.instance
              .collection('bills')
              .document(billNoController.text.toLowerCase())
              .setData({
                "name": selectedFarmerValue
                    .replaceAll(" ", "")
                    .toLowerCase()
                    .trim(),
                "billno": billNoController.text.toLowerCase().trim(),
                "amount": amountController.text.toLowerCase().trim(),
                "billdate": billDateController.text.toLowerCase().trim(),
                "type": selectedTypeValue.toLowerCase().trim(),
              })
              .then((result) => {
                    //      Navigator.pop(context),
                    billNoController.clear(),
                    amountController.clear(),
                    billDateController.clear(),
                    state.selectedFarmerValue = null,
                    state.selectedTypeValue = null,
                    state.setState(() {}),
                    progressdialog.hide(),
                    showAlert(context, 'Success!!!', 'Bill Saved Successfully')
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

  fetchAllBills(BillSearchState rf) {
    Firestore.instance.collection('bills').getDocuments().then((snapshot) => {
          snapshot.documents
              .forEach((document) => {listOfBills.add(document.data)}),
          rf.setState(() {})
        });
    return listOfBills;
  }

  onSuccess(listOfBills, filteredListOfBills, snapshot, bs, String billNo,
      selectedTypeValue, billsStartDate, billsEndDate) {
    snapshot.documents.forEach((document) => {listOfBills.add(document.data)});

    // filtering by Bill Type
    filteringByBillType(listOfBills, filteredListOfBills, selectedTypeValue);

    listOfBills.clear();
    filteredListOfBills.forEach((record) => {listOfBills.add(record)});

    // filtering by Bill
    filteringByBillNo(listOfBills, filteredListOfBills, billNo);

    listOfBills.clear();
    filteredListOfBills.forEach((record) => {listOfBills.add(record)});

    // filtering by Start Date
    filteringByBillStartDate(listOfBills, filteredListOfBills, billsStartDate);

    listOfBills.clear();
    filteredListOfBills.forEach((record) => {listOfBills.add(record)});

    // filtering by End Date
    filteringByBillEndDate(listOfBills, filteredListOfBills, billsEndDate);

    bs.setState(() {});

    filteredListOfBills.sort((a, b) {
      DateTime adate = dateFormat.parse(a['billdate']);
      DateTime bdate = dateFormat.parse(b['billdate']);
      return -adate.compareTo(bdate);
    });
  }

  filteringByBillType(listOfBills, filteredListOfBills, selectedTypeValue) {
    if (selectedTypeValue == null) {
      listOfBills.forEach((element) => {filteredListOfBills.add(element)});
    } else {
      listOfBills.forEach((element) => {
            if (selectedTypeValue != null &&
                selectedTypeValue.isNotEmpty &&
                element['type'] == selectedTypeValue.toString().toLowerCase())
              {filteredListOfBills.add(element)}
          });
    }
  }

  filteringByBillNo(listOfBills, filteredListOfBills, String billNo) {
    filteredListOfBills.clear();
    if (billNo != null && billNo.isEmpty) {
      listOfBills.forEach((element) => {filteredListOfBills.add(element)});
    } else {
      listOfBills.forEach((element) => {
            if (billNo != null &&
                billNo.isNotEmpty &&
                element['billno'] == billNo.toString().toLowerCase())
              {filteredListOfBills.add(element)}
          });
    }
  }

  filteringByBillStartDate(listOfBills, filteredListOfBills, billsStartDate) {
    filteredListOfBills.clear();
    if (billsStartDate != null && billsStartDate.isEmpty) {
      listOfBills.forEach((element) => {filteredListOfBills.add(element)});
    } else {
      listOfBills.forEach((element) => {
            if (billsStartDate != null &&
                billsStartDate.isNotEmpty &&
                (dateFormat.parse(element['billdate'])).isAfter(dateFormat
                    .parse(billsStartDate.toString().toLowerCase())
                    .subtract(new Duration(days: 1))))
              {filteredListOfBills.add(element)}
          });
    }
  }

  filteringByBillEndDate(listOfBills, filteredListOfBills, billsEndDate) {
    filteredListOfBills.clear();
    if (billsEndDate != null && billsEndDate.isEmpty) {
      listOfBills.forEach((element) => {filteredListOfBills.add(element)});
    } else {
      listOfBills.forEach((element) => {
            if (billsEndDate != null &&
                billsEndDate.isNotEmpty &&
                (dateFormat.parse(element['billdate'])).isBefore(dateFormat
                    .parse(billsEndDate.toString().toLowerCase())
                    .add(new Duration(days: 1))))
              {filteredListOfBills.add(element)}
          });
    }
  }

  searchBills(
      String selectedFarmerValue,
      String selectedTypeValue,
      String billNo,
      String billsStartDate,
      String billsEndDate,
      BillsState bs) {
    List<Map<String, dynamic>> listOfBills = new List<Map<String, dynamic>>();
    List<Map<String, dynamic>> sortedResults = new List<Map<String, dynamic>>();
    List<Map<String, dynamic>> filteredListOfBills =
        new List<Map<String, dynamic>>();
    CollectionReference query = Firestore.instance.collection('bills');
    query.where('name', isEqualTo: selectedFarmerValue).getDocuments().then(
        (snapshot) => onSuccess(listOfBills, filteredListOfBills, snapshot, bs,
            billNo, selectedTypeValue, billsStartDate, billsEndDate));

    return filteredListOfBills;
  }

  showAlert(BuildContext context, String title, String content) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(18.0),
              side: BorderSide(color: Colors.blue)),
          title: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(
              Icons.sentiment_satisfied,
              size: 40.0,
            ),
            Text(title,
                textAlign: TextAlign.center, style: TextStyle(fontSize: 22.0)),
          ]),
          /*Text(title, textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22.0
            )),*/
          content: Text(content,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.0,
              )),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                //Navigator.of(context,rootNavigator: true).pop();//close the dialoge
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  fetchBillsByFarmerName(selectedFarmerValue, selectedInterestRateValue,
      interestTillDateController, state, context, progressdialog) {
    DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    DateTime today;
    if (interestTillDateController.text.toString().isEmpty) {
      today = DateTime.now();
    } else {
      today = dateFormat.parse(interestTillDateController.text.toString());
    }
    DateTime billDate;
    int interestDays;
    double interestRate = double.parse(selectedInterestRateValue);
    state.listOfBillsByFarmerName.clear();
    double cashReceivedAmount = 0.0;
    double cashReceivedInterestAmount = 0.0;
    double anamathAmount = 0.0;
    double anamathInterestAmount = 0.0;
    double creditAmount = 0.0;
    double creditInterestAmount = 0.0;
    CollectionReference query = Firestore.instance.collection('bills');
    query
        .where('name', isEqualTo: selectedFarmerValue)
        .getDocuments()
        .then((snapshot) => {
              snapshot.documents.forEach((document) => {
                    state.listOfBillsByFarmerName.add(document.data),
                if (document.data['type'].toString().compareTo("anamath") ==
                    0)
                  {
                    billDate = dateFormat.parse(document.data['billdate']),
                    interestDays = today.difference(billDate).inDays,
                    anamathInterestAmount =
                        double.parse(document.data['amount']) *
                            (((interestRate / 100) / 30) * interestDays),
                    anamathAmount = anamathAmount +
                        (double.parse(document.data['amount']) +
                            anamathInterestAmount),
                    anamathInterestAmount = 0.0,
                  },
                if (document.data['type'].toString().compareTo("credit") ==
                    0)
                  {
                    billDate = dateFormat.parse(document.data['billdate']),
                    interestDays = today.difference(billDate).inDays,
                    creditInterestAmount =
                        double.parse(document.data['amount']) *
                            (((interestRate / 100) / 30) * interestDays),
                    creditAmount = creditAmount +
                        (double.parse(document.data['amount']) +
                            creditInterestAmount),
                    creditInterestAmount = 0.0,
                  },
                if (document.data['type']
                    .toString()
                    .compareTo("cash received") ==
                    0)
                  {
                    billDate = dateFormat.parse(document.data['billdate']),
                    interestDays = today.difference(billDate).inDays,
                    cashReceivedInterestAmount =
                        double.parse(document.data['amount']) *
                            (((interestRate / 100) / 30) * interestDays),
                    cashReceivedAmount = cashReceivedAmount +
                        (double.parse(document.data['amount']) +
                            cashReceivedInterestAmount),
                    cashReceivedInterestAmount = 0.0,
                  }
                  }),
              state.setState(() {

                state.totalAnamathAmountWithInterestController.text =
                    anamathAmount.toStringAsFixed(2);

                state.totalCreditAmountWithInterestController.text =
                    creditAmount.toStringAsFixed(2);

                state.totalCashReceivedAmountWithInterestController.text =
                    cashReceivedAmount.toStringAsFixed(2);

                state.netAmountController.text =
                    (anamathAmount + creditAmount - cashReceivedAmount)
                        .toStringAsFixed(2);

                state.generateReport();
                progressdialog.hide();
                showAlert(context, 'Success!!!', 'PDF saved!!!');
              }),
            })
        .catchError((err) => {
              progressdialog.hide(),
              new Transactions().showAlert(context, 'Failed!!!', err.toString())
            });
  }

  billsSearchByFarmerName(selectedFarmerValue, selectedInterestRateValue,
      interestTillDateController, state, context, progressdialog) {
    DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    DateTime today;
    if (interestTillDateController.text.toString().isEmpty) {
      today = DateTime.now();
    } else {
      today = dateFormat.parse(interestTillDateController.text.toString());
    }
    DateTime billDate;
    int interestDays;
    double interestRate = double.parse(selectedInterestRateValue);
    //state.listOfBillsByFarmerName.clear();
    double totalAmount = 0.0;
    double interestAmount = 0.0;
    double cashReceivedAmount = 0.0;
    double cashReceivedInterestAmount = 0.0;
    double anamathAmount = 0.0;
    double anamathInterestAmount = 0.0;
    double creditAmount = 0.0;
    double creditInterestAmount = 0.0;
    CollectionReference query = Firestore.instance.collection('bills');
    query
        .where('name', isEqualTo: selectedFarmerValue)
        .getDocuments()
        .then((snapshot) => {
              snapshot.documents.forEach((document) => {
                    if (document.data['type'].toString().compareTo("anamath") ==
                        0)
                      {
                        billDate = dateFormat.parse(document.data['billdate']),
                        interestDays = today.difference(billDate).inDays,
                        anamathInterestAmount =
                            double.parse(document.data['amount']) *
                                (((interestRate / 100) / 30) * interestDays),
                        anamathAmount = anamathAmount +
                            (double.parse(document.data['amount']) +
                                anamathInterestAmount),
                        anamathInterestAmount = 0.0,
                      },
                    if (document.data['type'].toString().compareTo("credit") ==
                        0)
                      {
                        billDate = dateFormat.parse(document.data['billdate']),
                        interestDays = today.difference(billDate).inDays,
                        creditInterestAmount =
                            double.parse(document.data['amount']) *
                                (((interestRate / 100) / 30) * interestDays),
                        creditAmount = creditAmount +
                            (double.parse(document.data['amount']) +
                                creditInterestAmount),
                        creditInterestAmount = 0.0,
                      },
                    if (document.data['type']
                            .toString()
                            .compareTo("cash received") ==
                        0)
                      {
                        billDate = dateFormat.parse(document.data['billdate']),
                        interestDays = today.difference(billDate).inDays,
                        cashReceivedInterestAmount =
                            double.parse(document.data['amount']) *
                                (((interestRate / 100) / 30) * interestDays),
                        cashReceivedAmount = cashReceivedAmount +
                            (double.parse(document.data['amount']) +
                                cashReceivedInterestAmount),
                        cashReceivedInterestAmount = 0.0,
                      }
                    /*else
                      {
                        billDate = dateFormat.parse(document.data['billdate']),
                        interestDays = today.difference(billDate).inDays,
                        totalAmount =
                            totalAmount + double.parse(document.data['amount']),
                        interestAmount = interestAmount +
                            double.parse(document.data['amount']) *
                                (((interestRate / 100) / 30) * interestDays),
                      }*/
                  }),
              state.setState(() {
                state.totalAnamathAmountWithInterestController.text =
                    anamathAmount.toStringAsFixed(2);

                state.totalCreditAmountWithInterestController.text =
                    creditAmount.toStringAsFixed(2);

                state.totalCashReceivedAmountWithInterestController.text =
                    cashReceivedAmount.toStringAsFixed(2);

                /*state.totalAmountController.text =
                    totalAmount.toStringAsFixed(2);
                state.interestAmountController.text =
                    interestAmount.toStringAsFixed(2);
                state.totalAmountWithInterestController.text =
                    (totalAmount + interestAmount).toStringAsFixed(2);*/

                state.netAmountController.text =
                    (anamathAmount + creditAmount - cashReceivedAmount)
                        .toStringAsFixed(2);
              }),
              progressdialog.hide()
            })
        .catchError((err) => {
              progressdialog.hide(),
              new Transactions().showAlert(context, 'Failed!!!', err.toString())
            });
  }

  fetchBillDetails(selectedFarmerValue, billNo, context, state) {
    CollectionReference query = Firestore.instance.collection('bills');
    query
        .where('name', isEqualTo: selectedFarmerValue)
        .getDocuments()
        .then((snapshot) => {
              snapshot.documents.forEach((document) => {
                    if (document.data['billno'].toString().compareTo(billNo) ==
                        0)
                      {
                        state.selectedTypeValue =
                            document.data['type'].toString(),
                        state.amountController.text =
                            document.data['amount'].toString(),
                        state.billDateController.text =
                            document.data['billdate'].toString(),
                      }
                  })
            });
  }

  updateBill(selectedFarmerValue, selectedBillNoValue, amountController,
      billDateController, selectedTypeValue, context, state, progressdialog) {
    if (selectedFarmerValue.isNotEmpty &&
        selectedBillNoValue.isNotEmpty &&
        amountController.text.isNotEmpty &&
        billDateController.text.isNotEmpty &&
        selectedTypeValue.isNotEmpty) {
      Firestore.instance
          .collection('bills')
          .document(selectedBillNoValue.toLowerCase())
          .updateData({
            "name": selectedFarmerValue
                .replaceAll(" ", "")
                .toLowerCase()
                .toString()
                .trim(),
            "billno": selectedBillNoValue.toLowerCase().trim(),
            "amount": amountController.text.toLowerCase().trim(),
            "billdate": billDateController.text.toLowerCase().trim(),
            "type": selectedTypeValue.toLowerCase().trim(),
          })
          .then((result) => {
                amountController.clear(),
                billDateController.clear(),
                state.selectedFarmerValue = null,
                state.selectedBillNoValue = null,
                state.selectedTypeValue = null,
                state.setState(() {}),
                progressdialog.hide(),
                showAlert(context, 'Success!!!', 'Bill Updated Successfully'),
              })
          .catchError((err) => {
                progressdialog.hide(),
                new Transactions()
                    .showAlert(context, 'Failed!!!', err.toString())
              });
    } else {
      progressdialog.hide();
      showAlert(context, 'Ooops!!!', 'Enter All fields');
    }
  }

  deleteByBill(billNo, context, state, progressdialog) {
    CollectionReference query = Firestore.instance.collection('bills');
    query
        .document(billNo.toString())
        .delete()
        .then((result) => {
              progressdialog.hide(),
              showAlert(context, 'Success!!!',
                  'Bill (' + billNo.toString() + ') Deleted Successfully'),
              state.setState(() {
                state.selectedFarmerValue = null;
                state.selectedBillNoValue = null;
                state.billsStartDateController.clear();
                state.billsEndDateController.clear();
              }),
            })
        .catchError((err) => {
              progressdialog.hide(),
              new Transactions().showAlert(context, 'Failed!!!', err.toString())
            });
  }

  deleteByDateRange(selectedFarmerValue, billsStartDate, billsEndDate, context,
      state, progressdialog) {
    DateTime fromDate =
        dateFormat.parse(billsStartDate).subtract(new Duration(days: 1));
    DateTime toDate = dateFormat.parse(billsEndDate).add(new Duration(days: 1));
    CollectionReference query = Firestore.instance.collection('bills');
    CollectionReference queryForDelete = Firestore.instance.collection('bills');
    query
        .where('name', isEqualTo: selectedFarmerValue)
        .getDocuments()
        .then((snapshot) => {
              snapshot.documents.forEach(
                (document) => {
                  if (dateFormat
                          .parse(document.data['billdate'])
                          .isAfter(fromDate) &&
                      dateFormat
                          .parse(document.data['billdate'])
                          .isBefore(toDate))
                    {
                      queryForDelete
                          .document(
                              document.data['billno'].toString().toLowerCase())
                          .delete()
                          .catchError((err) => {
                                progressdialog.hide(),
                                new Transactions().showAlert(
                                    context,
                                    'Failed!!!',
                                    'while deleting (' +
                                        document.data['billno']
                                            .toString()
                                            .toLowerCase() +
                                        ') ' +
                                        err.toString())
                              })
                    }
                },
              ),
              progressdialog.hide(),
              state.setState(() {
                state.selectedFarmerValue = null;
                state.selectedBillNoValue = null;
                state.billsStartDateController.clear();
                state.billsEndDateController.clear();
              }),
            })
        .catchError((err) => {
              progressdialog.hide(),
              new Transactions().showAlert(context, 'Failed!!!', err.toString())
            });
  }

/*  exportBills(){
    List<Map<String, String>> bills = [
      {"id": "sandhadiguravaiha", "surname": "sandhadi", "name": "guravaiha", "phonenumber": "6281220826"},
      {"id": "budhativenkatappareddy", "surname": "budhati", "name": "venkatappareddy", "phonenumber": "6281476348"}
    ];


    CollectionReference colRef = Firestore.instance
        .collection('farmers');
    int count = 1;

    bills.forEach((element) => {
      colRef.document(element['id'])
          .setData({
        "surname": element['surname'],
        "name": element['name'],
        "phonenumber": element['phonenumber'],
      }),

      print(count++)
    });
  }*/
}
