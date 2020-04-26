import 'package:flutter/material.dart';
import 'package:harinifertilizers/database/transactions.dart';

class Bills extends StatefulWidget {
  String selectedFarmerValue;
  String selectedTypeValue;
  String billNo;
  String billsStartDate;
  String billsEndDate;

  Bills(String selectedFarmerValue, String selectedTypeValue, String billNo,
      String billsStartDate, String billsEndDate) {
    this.selectedFarmerValue = selectedFarmerValue;
    this.selectedTypeValue = selectedTypeValue;
    this.billNo = billNo;
    this.billsStartDate = billsStartDate;
    this.billsEndDate = billsEndDate;
  }

  List<Map<String, dynamic>> listOfBills;

  @override
  State<StatefulWidget> createState() => BillsState(selectedFarmerValue,
      selectedTypeValue, billNo, billsStartDate, billsEndDate);
}

class BillsState extends State<Bills> {
  List<Map<String, dynamic>> listOfBills;

  String selectedFarmerValue;
  String selectedTypeValue;
  String billNo;
  String billsStartDate;
  String billsEndDate;

  BillsState(String selectedFarmerValue, String selectedTypeValue,
      String billNo, String billsStartDate, String billsEndDate) {
    this.selectedFarmerValue = selectedFarmerValue;
    this.selectedTypeValue = selectedTypeValue;
    this.billNo = billNo;
    this.billsStartDate = billsStartDate;
    this.billsEndDate = billsEndDate;
  }

  @override
  void initState() {
    super.initState();
    listOfBills = new Transactions().searchBills(
        selectedFarmerValue.toLowerCase().replaceAll(" ", ""),
        selectedTypeValue,
        billNo,
        billsStartDate,
        billsEndDate,
        this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Farmers Bills"),
        ),
        body: SafeArea(
            child: Scrollbar(
          child: ListView(children: <Widget>[
            Table(
              columnWidths: {
                0: FractionColumnWidth(.3),
                1: FractionColumnWidth(.3),
                2: FractionColumnWidth(.3)
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              border: TableBorder.all(width: 1.0, color: Colors.grey),
              children: renderTableRows(listOfBills),
            ),
          ]),
        )));
  }

  renderTableRows(listOfBills) {
    List<TableRow> rows = new List<TableRow>();
    rows.add(TableRow(children: [
      Column(children: [
        Container(
            decoration: BoxDecoration(color: Colors.lightGreen),
            padding: EdgeInsets.fromLTRB(6.0, 0.0, 0.0, 0.0),
            alignment: Alignment.center,
            child: Text("Bill Date",
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                )))
      ]),

      Column(children: [
        Container(
            decoration: BoxDecoration(color: Colors.lightGreen),
            padding: EdgeInsets.fromLTRB(6.0, 0.0, 0.0, 0.0),
            alignment: Alignment.center,
            child: Text("Bill No",
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                )))
      ]),
      Column(children: [
        Container(
            decoration: BoxDecoration(color: Colors.lightGreen),
            padding: EdgeInsets.fromLTRB(6.0, 0.0, 0.0, 0.0),
            alignment: Alignment.center,
            child: Text("Amount",
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                )))
      ]),
      // you can have more properties of course
    ]));

    int count = 2;
    Color bgColor;
    listOfBills.forEach((item) => {
          bgColor = (count % 2 == 0)
              ? Colors.white
              : Color.fromRGBO(210, 245, 210, 1.0),
          count++,
          rows.add(TableRow(children: [
            Column(children: [
              Container(
                  decoration: BoxDecoration(color: bgColor),
                  padding: EdgeInsets.fromLTRB(6.0, 0.0, 0.0, 0.0),
                  alignment: Alignment.centerLeft,
                  child: Text(item['billdate'],
                      style: TextStyle(
                        fontSize: 18,
                      )))
            ]),
            Column(children: [
              Container(
                  decoration: BoxDecoration(color: bgColor),
                  padding: EdgeInsets.fromLTRB(6.0, 0.0, 0.0, 0.0),
                  alignment: Alignment.centerLeft,
                  child: Text(item['billno'],
                      style: TextStyle(
                        fontSize: 18,
                      )))
            ]),
            Column(children: [
              Container(
                  decoration: BoxDecoration(color: bgColor),
                  padding: EdgeInsets.fromLTRB(6.0, 0.0, 0.0, 0.0),
                  alignment: Alignment.centerLeft,
                  child: Text(item['amount'],
                      style: TextStyle(
                        fontSize: 18,
                      )))
            ]),
            // you can have more properties of course
          ]))
        });
    return rows;
  }
}
