import 'package:flutter/material.dart';
import 'package:harinifertilizers/database/readregisteredfarmers.dart';
import 'package:harinifertilizers/ui/bills.dart';
import 'package:harinifertilizers/ui/utilities.dart';
import 'package:intl/intl.dart';

class BillSearch extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BillSearchState();
}

class BillSearchState extends State<BillSearch> {
  final transactionFormKey = GlobalKey<FormState>();
  final alphanumeric = RegExp(r'^[a-zA-Z0-9]+$');
  String selectedFarmerValue;
  String selectedTypeValue;
  TextEditingController billNoController = TextEditingController();
  TextEditingController billsStartDateController = TextEditingController();
  TextEditingController billsEndDateController = TextEditingController();
  List<Map<String, dynamic>> listOfBills;
  List<String> famerNames = new List<String>();

  @override
  void initState() {
    super.initState();
    famerNames = new ReadRegisteredFarmers().fetchFarmerNames(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Bills Search",
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
                  renderType(),
                  renderBillNo(),
                  renderBillsStartDateController(),
                  renderBillsEndDateController(),
                  Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
                      child: renderSearchButton(this)),
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
      decoration: InputDecoration(
          hintText: 'Bill No', suffixIcon: const Icon(Icons.edit, size: 30.0)),
      keyboardType: TextInputType.text,
      /*validator: (value) {
          if (value.isEmpty) {
            return 'Please enter number';
          }
          if (!alphanumeric.hasMatch(value)) {
            return 'special characters are not allowed';
          }
          return null;
        }*/
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
      /*validator: (value) {
          if (value.isEmpty) {
            return 'Please enter bill date';
          }
          return null;
        }*/
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
      /*validator: (value) {
          if (value.isEmpty) {
            return 'Please enter bill date';
          }
          return null;
        }*/
    );
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
      items: <String>['Anamath', 'Credit', 'Cash Received']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value, style: TextStyle(fontFamily: 'Quicksand')),
        );
      }).toList(),
    );
  }

  renderSearchButton(BillSearchState bs) {
    return RaisedButton.icon(
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(18.0),
            side: BorderSide(color: Colors.blue)),
        icon: Icon(
          Icons.search,
          size: 30.0,
        ),
        label: const Text('Search'),
        color: Theme.of(context).primaryColorDark,
        textColor: Theme.of(context).primaryColorLight,
        onPressed: () {
          if (isFormValidationSuccess()) {
            Navigator.of(context).push(new MaterialPageRoute(
                builder: (context) => new Bills(
                    selectedFarmerValue.toLowerCase(),
                    selectedTypeValue,
                    billNoController.text.toString(),
                    billsStartDateController.text.toString(),
                    billsEndDateController.text.toString()),
                maintainState: true));
          }
        });
  }

  bool isFormValidationSuccess() {
    if (selectedFarmerValue == null) {
      Utilities.showAlert(context, ' ooops!!!', 'Please select a farmer');
      return false;
    }
    return true;
  }
}
