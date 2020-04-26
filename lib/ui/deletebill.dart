import 'package:flutter/material.dart';
import 'package:harinifertilizers/database/readregisteredfarmers.dart';
import 'package:harinifertilizers/database/transactions.dart';
import 'package:harinifertilizers/ui/utilities.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';

class DeleteBill extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => DeleteBillState();
}

class DeleteBillState extends State<DeleteBill> {
  final transactionFormKey = GlobalKey<FormState>();
  final alphanumeric = RegExp(r'^[a-zA-Z0-9]+$');
  String selectedFarmerValue;
  String selectedTypeValue;
  String selectedBillNoValue;
  TextEditingController billNoController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController billDateController = TextEditingController();
  TextEditingController billsStartDateController = TextEditingController();
  TextEditingController billsEndDateController = TextEditingController();
  List<String> famerNames = new List<String>();
  List<String> famerBillNos = new List<String>();
  ProgressDialog progressdialog;

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
          "Delete Bill",
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
                  Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
                      child: renderDeleteByBillButton()),
                  renderBillsStartDateController(),
                  renderBillsEndDateController(),
                  Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
                      child: renderDeleteByRangeOfBillsButton()),
                ],
              ),
            )),
      ),
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

  renderBillsStartDateController() {
    return TextFormField(
      readOnly: true,
      onTap: () {
        showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(DateTime.now().year - 5),
          lastDate: DateTime(DateTime.now().year + 5),
        ).then((date) {
          billsStartDateController.text = DateFormat('dd/MM/yyyy').format(date);
        });
      },
      controller: billsStartDateController,
      decoration: InputDecoration(
          hintText: 'Bill Start Date',
          suffixIcon: const Icon(Icons.calendar_today, size: 30.0)),
    );
  }

  renderBillsEndDateController() {
    return TextFormField(
      readOnly: true,
      onTap: () {
        showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(DateTime.now().year - 5),
          lastDate: DateTime(DateTime.now().year + 5),
        ).then((date) {
          billsEndDateController.text = DateFormat('dd/MM/yyyy').format(date);
        });
      },
      controller: billsEndDateController,
      decoration: InputDecoration(
          hintText: 'Bill End Date',
          suffixIcon: const Icon(Icons.calendar_today, size: 30.0)),
    );
  }

  renderDeleteByBillButton() {
    return RaisedButton.icon(
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(18.0),
            side: BorderSide(color: Colors.blue)),
        icon: Icon(
          Icons.delete_forever,
          size: 30.0,
        ),
        label: const Text('Delete By Bill'),
        color: Theme.of(context).primaryColorDark,
        textColor: Theme.of(context).primaryColorLight,
        onPressed: () {
          if (isDeleteByBillValidationSuccess()) {
            if (transactionFormKey.currentState.validate()) {
              String contentMsg = "Are you sure You want to Delete the Bill: " +
                  selectedBillNoValue.toString() +
                  " ?";
              new Utilities().renderAlert(
                  context, contentMsg, deleteByBillAction, progressdialog);
            }
          }
        });
  }

  deleteByBillAction() {
    new Transactions().deleteByBill(
        selectedBillNoValue.toLowerCase().toString(),
        context,
        this,
        progressdialog);
  }

  renderDeleteByRangeOfBillsButton() {
    return RaisedButton.icon(
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(18.0),
            side: BorderSide(color: Colors.blue)),
        icon: Icon(
          Icons.delete_forever,
          size: 30.0,
        ),
        label: const Text('Delete By Date Range'),
        color: Theme.of(context).primaryColorDark,
        textColor: Theme.of(context).primaryColorLight,
        onPressed: () {
          if (isDeleteByDateRangeValidationSuccess()) {
            if (transactionFormKey.currentState.validate()) {
              String contentMsg =
                  "Are you sure You want to Delete the Bills From : " +
                      billsStartDateController.text.toString() +
                      " To : " +
                      billsEndDateController.text.toString() +
                      " ?";
              new Utilities().renderAlert(context, contentMsg,
                  deleteByRangeOfBillsAction, progressdialog);
            }
          }
        });
  }

  deleteByRangeOfBillsAction() {
    new Transactions().deleteByDateRange(
        selectedFarmerValue.replaceAll(" ", "").toLowerCase().toString(),
        billsStartDateController.text.toLowerCase().toString(),
        billsEndDateController.text.toLowerCase().toString(),
        context,
        this,
        progressdialog);
  }

  bool isDeleteByBillValidationSuccess() {
    if (selectedFarmerValue == null) {
      Utilities.showAlert(context, ' ooops!!!', 'Please select a farmer');
      return false;
    }
    if (selectedBillNoValue == null) {
      Utilities.showAlert(context, ' ooops!!!', 'Please select a Bill No');
      return false;
    }
    return true;
  }

  bool isDeleteByDateRangeValidationSuccess() {
    if (selectedFarmerValue == null) {
      Utilities.showAlert(context, ' ooops!!!', 'Please select a farmer');
      return false;
    }
    if (billsStartDateController.text.isEmpty) {
      Utilities.showAlert(context, ' ooops!!!', 'Please enter Start date');
      return false;
    }
    if (billsEndDateController.text.isEmpty) {
      Utilities.showAlert(context, ' ooops!!!', 'Please enter End date');
      return false;
    }
    return true;
  }
}
