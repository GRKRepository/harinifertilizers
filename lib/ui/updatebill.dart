import 'package:flutter/material.dart';
import 'package:harinifertilizers/database/readregisteredfarmers.dart';
import 'package:harinifertilizers/database/transactions.dart';
import 'package:harinifertilizers/ui/utilities.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'deletebill.dart';

class UpdateBill extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => UpdateBillState();
}

class UpdateBillState extends State<UpdateBill> {
  final transactionFormKey = GlobalKey<FormState>();
  final alphanumeric = RegExp(r'^[a-zA-Z0-9]+$');
  String selectedFarmerValue;
  String selectedTypeValue;
  String selectedBillNoValue;
  TextEditingController amountController = TextEditingController();
  TextEditingController billDateController = TextEditingController();
  List<String> famerNames = new List<String>();
  List<String> famerBillNos = new List<String>();
  bool isUpdateButtonEnabled = true;
  ProgressDialog progressdialog;
  final decimalRegExp = RegExp('^\$|^(0|([1-9][0-9]{0,}))(\\.[0-9]{0,})?\$');
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
          "Update Bill",
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(15.0),
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Form(
              key: transactionFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  renderName(),
                  renderBillNo(),
                  renderType(),
                  renderAmount(),
                  renderBillDate(),
                  Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
                      child: renderUpdateButton()),
                ],
              ),
            )),
      ),
      floatingActionButton: renderFloatingButton(),
    );
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
          new ReadRegisteredFarmers().fetchFarmerBillNos(
              selectedFarmerValue.replaceAll(" ", "").toLowerCase().toString(),
              famerBillNos,
              this);
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

  renderBillNo() {
    return DropdownButton<String>(
      isExpanded: true,
      value: selectedBillNoValue,
      hint: Text('Please select a Bill No  ',
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
          selectedBillNoValue = newValue;
          new ReadRegisteredFarmers().fetchFarmerBillNoBasedAmountAndDate(
              selectedFarmerValue.replaceAll(" ", "").toLowerCase().toString(),
              selectedBillNoValue.toLowerCase().toString(),
              this);
          setState(() {});
        });
      },
      items: famerBillNos.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value, style: TextStyle(fontFamily: 'Quicksand')),
        );
      }).toList(),
    );
  }

  renderAmount() {
    return TextFormField(
        controller: amountController,
        decoration: InputDecoration(
            hintText: 'Bill Amount',
            suffixIcon: const Icon(Icons.edit, size: 30.0)),
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value.trim().isEmpty) {
            return 'Please enter bill amount';
          }
          if (!decimalRegExp.hasMatch(value) ||
              value.trim().startsWith(".", 0) ||
              value.trim().endsWith(".")) {
            return 'Enter Amount with decimals properly';
          }
          return null;
        });
  }

  renderBillDate() {
    return TextFormField(
        readOnly: true,
        onTap: () {
          showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(DateTime.now().year - 5),
            lastDate: DateTime(DateTime.now().year + 5),
          ).then((date) {
            billDateController.text = DateFormat('dd/MM/yyyy').format(date);
          });
        },
        controller: billDateController,
        decoration: InputDecoration(
            hintText: 'Bill Date',
            suffixIcon: const Icon(Icons.calendar_today, size: 30.0)),
        validator: (value) {
          if (value.isEmpty) {
            return 'Please enter bill date';
          }
          return null;
        });
  }

  renderType() {
    return DropdownButton<String>(
      isExpanded: true,
      value: selectedTypeValue,
      hint: Text('Please select Bill Type  ',
          style: TextStyle(fontFamily: 'Quicksand')),
      icon: Icon(Icons.arrow_drop_down),
      iconSize: 40.0,
      elevation: 16,
      style: TextStyle(color: Colors.black),
      underline: Container(
        height: 2,
        color: Colors.grey,
      ),
      onChanged: (String newValue) {
        setState(() {
          selectedTypeValue = newValue;
        });
      },
      items: <String>['anamath', 'credit', 'cash received']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value, style: TextStyle(fontFamily: 'Quicksand')),
        );
      }).toList(),
    );
  }

  renderUpdateButton() {
    return RaisedButton.icon(
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(18.0),
            side: BorderSide(color: Colors.blue)),
        icon: Icon(
          Icons.update,
          size: 30.0,
        ),
        label: const Text('Update'),
        color: Theme.of(context).primaryColorDark,
        textColor: Theme.of(context).primaryColorLight,
        onPressed: () {
          if (isFormValidationSuccess()) {
            if (transactionFormKey.currentState.validate()) {
              String contentMsg = "Are you sure You want to Update the Bill: " +
                  selectedBillNoValue.toString() +
                  " ?";
              new Utilities().renderAlert(
                  context, contentMsg, updateBillAction, progressdialog);
            }
          }
        });
  }

  updateBillAction() {
    new Transactions().updateBill(
        selectedFarmerValue,
        selectedBillNoValue,
        amountController,
        billDateController,
        selectedTypeValue,
        context,
        this,
        progressdialog);
  }

  renderFloatingButton() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.of(context).push(new MaterialPageRoute(
            builder: (context) => new DeleteBill(), maintainState: true));
      },
      child: Icon(
        Icons.delete_forever,
      ),
      foregroundColor: Colors.white,
    );
  }

  bool isFormValidationSuccess() {
    if (selectedFarmerValue == null) {
      Utilities.showAlert(context, ' ooops!!!', 'Please select a farmer');
      return false;
    }
    if (selectedBillNoValue == null) {
      Utilities.showAlert(context, ' ooops!!!', 'Please select a Bill No');
      return false;
    }
    if (selectedTypeValue == null) {
      Utilities.showAlert(context, ' ooops!!!', 'Please select a Bill Type');
      return false;
    }
    return true;
  }
}
