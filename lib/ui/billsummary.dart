import 'package:flutter/material.dart';
import 'package:harinifertilizers/database/readregisteredfarmers.dart';
import 'package:harinifertilizers/database/transactions.dart';
import 'package:harinifertilizers/ui/utilities.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';

class BillSummary extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BillSummaryState();
}

class BillSummaryState extends State<BillSummary> {
  final transactionFormKey = GlobalKey<FormState>();
  final alphanumeric = RegExp(r'^[a-zA-Z0-9]+$');
  String selectedFarmerValue;
  String selectedInterestRateValue;
  TextEditingController billNoController = TextEditingController();
  TextEditingController totalAmountController = TextEditingController();
  TextEditingController interestAmountController = TextEditingController();
  TextEditingController totalCashReceivedAmountWithInterestController = TextEditingController();
  TextEditingController totalAnamathAmountWithInterestController = TextEditingController();
  TextEditingController totalCreditAmountWithInterestController = TextEditingController();
  TextEditingController netAmountController = TextEditingController();
  TextEditingController totalAmountWithInterestController =
      TextEditingController();
  TextEditingController interestTillDateController = TextEditingController();
  List<String> famerNames;
  List<Widget> children;
  List<Map<String, dynamic>> listOfBillsByFarmerName;
  ProgressDialog progressdialog;

  @override
  void initState() {
    super.initState();
    famerNames = new ReadRegisteredFarmers().fetchFarmerNames(this);
  }

  @override
  Widget build(BuildContext context) {
    progressdialog = Utilities.renderProgressDial(context);
    children = renderChildren();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Bill Summary",
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
                children: children,
              ),
            )),
      ),
    );
  }

  renderChildren() {
    return <Widget>[
      renderName(),
      renderInterestRate(),
      //renderBillNo(),
      //renderAmount(),
      renderInterestTillDate(),
      Padding(
          padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
          child: renderSubmitButton()),

      Padding(
        padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
        child: renderAnamathWithInterest(),
      ),

      Padding(
        padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
        child: renderCreditWithInterest(),
      ),

      /*Padding(
        padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
        child: renderTotalAmountWithInterest(),
      ),*/

      Padding(
        padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
        child: renderTotalCashReceivedAmountWithInterest(),
      ),

      Padding(
        padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
        child: renderNetAmount(),
      ),
    ];
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
    return TextFormField(
        controller: billNoController,
        decoration: InputDecoration(hintText: 'Bill No'),
        keyboardType: TextInputType.text,
        validator: (value) {
          if (value.isEmpty) {
            return 'Please enter number';
          }
          if (!alphanumeric.hasMatch(value)) {
            return 'special characters are not allowed';
          }
          return null;
        });
  }

  renderTotalAmountWithInterest() {
    return TextField(
      enabled: false,
      controller: totalAmountWithInterestController,
      decoration: InputDecoration(
          labelText: 'Total Amount With Interest',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );
  }

  renderTotalAmount() {
    return TextField(
      enabled: false,
      controller: totalAmountController,
      decoration: InputDecoration(
          labelText: 'Total Amount',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );
  }

  renderInterestAmount() {
    return TextField(
      enabled: false,
      controller: interestAmountController,
      decoration: InputDecoration(
          labelText: 'Interest Amount',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );
  }

  renderTotalCashReceivedAmountWithInterest() {
    return TextField(
      enabled: false,
      controller: totalCashReceivedAmountWithInterestController,
      decoration: InputDecoration(
          labelText: 'Total Cash Received With Interest',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );
  }

  renderAnamathWithInterest() {
    return TextField(
      enabled: false,
      controller: totalAnamathAmountWithInterestController,
      decoration: InputDecoration(
          labelText: 'Total Anamath Amount With Interest',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );
  }

  renderCreditWithInterest() {
    return TextField(
      enabled: false,
      controller: totalCreditAmountWithInterestController,
      decoration: InputDecoration(
          labelText: 'Total Credit Amount With Interest',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );
  }

  renderNetAmount() {
    return TextField(
      enabled: false,
      controller: netAmountController,
      decoration: InputDecoration(
          labelText: 'Final Balance Amount',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );
  }

  renderInterestTillDate() {
    return TextFormField(
        readOnly: true,
        onTap: () {
          showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(DateTime.now().year - 5),
            lastDate: DateTime(DateTime.now().year + 5),
          ).then((date) {
            interestTillDateController.text =
                DateFormat('dd/MM/yyyy').format(date);
          });
        },
        controller: interestTillDateController,
        decoration: InputDecoration(hintText: 'Interest Till Date', suffixIcon: const Icon(Icons.calendar_today, size: 30.0)),
        validator: (value) {
          if (value.isEmpty) {
            return 'Please enter interest till date';
          }
          return null;
        });
  }

  renderInterestRate() {
    return DropdownButton<String>(
      isExpanded: true,
      value: selectedInterestRateValue,
      hint: Text('Please select Interest Rate  ',
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
          selectedInterestRateValue = newValue;
        });
      },
      items: <String>['0', '0.5', '1', '1.5', '2', '2.5', '3', '3.5']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value, style: TextStyle(fontFamily: 'Quicksand')),
        );
      }).toList(),
    );
  }

  renderSubmitButton() {
    return RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(18.0),
            side: BorderSide(color: Colors.blue)),
        child: Text(
          'Submit',
          textScaleFactor: 1.5,
        ),
        color: Theme.of(context).primaryColorDark,
        textColor: Theme.of(context).primaryColorLight,
        onPressed: () {
          progressdialog.show();
          new Transactions().billsSearchByFarmerName(
              selectedFarmerValue.toLowerCase().replaceAll(" ", ""),
              selectedInterestRateValue,
              interestTillDateController,
              this,
              context,
              progressdialog);
        });
  }
}
