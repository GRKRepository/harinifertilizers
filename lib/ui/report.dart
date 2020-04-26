import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:harinifertilizers/database/readregisteredfarmers.dart';
import 'package:harinifertilizers/database/transactions.dart';
import 'package:harinifertilizers/ui/utilities.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import 'dart:ui' as ui;

import 'package:progress_dialog/progress_dialog.dart';

class Report extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ReportState();
}

class ReportState extends State<Report> {
  final transactionFormKey = GlobalKey<FormState>();
  final alphanumeric = RegExp(r'^[a-zA-Z0-9]+$');
  DateFormat dateFormat = DateFormat('dd/MM/yyyy');
  String selectedFarmerValue;
  String selectedInterestRateValue;
  TextEditingController billNoController = TextEditingController();
  /*TextEditingController totalAmountController = TextEditingController();
  TextEditingController interestAmountController = TextEditingController();
  TextEditingController totalAmountWithInterestController =
      TextEditingController();*/
  TextEditingController interestTillDateController = TextEditingController();
  TextEditingController totalAnamathAmountWithInterestController = TextEditingController();
  TextEditingController totalCreditAmountWithInterestController = TextEditingController();
  TextEditingController netAmountController = TextEditingController();
  TextEditingController totalCashReceivedAmountWithInterestController = TextEditingController();

  List<String> famerNames;
  List<Widget> children;
  List<Map<String, dynamic>> listOfBillsByFarmerName =
      new List<Map<String, dynamic>>();
  ProgressDialog progressdialog;

  @override
  void initState() {
    super.initState();
    famerNames = new ReadRegisteredFarmers().fetchFarmerNames(this);
  }

  @override
  Widget build(BuildContext context) {
    children = renderChildren();
    progressdialog = Utilities.renderProgressDial(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Farmer Report",
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
          child: renderPrintButton()),
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
        decoration: InputDecoration(
            hintText: 'Interest Till Date',
            suffixIcon: const Icon(Icons.calendar_today, size: 30.0)),
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

  renderPrintButton() {
    return RaisedButton.icon(
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(18.0),
            side: BorderSide(color: Colors.blue)),
        icon: Icon(
          Icons.print,
          size: 30.0,
        ),
        label: const Text('Print'),
        color: Theme.of(context).primaryColorDark,
        textColor: Theme.of(context).primaryColorLight,
        onPressed: () async {
          progressdialog.show();
          new Transactions().fetchBillsByFarmerName(
              selectedFarmerValue.toLowerCase().replaceAll(" ", ""),
              selectedInterestRateValue,
              interestTillDateController,
              this,
              context,
              progressdialog);
        });
  }

  renderPDFBillsList(pdf) async {
    final ByteData bytes = await rootBundle.load('fertilizersassets/logo.jpg');
    final Uint8List list = bytes.buffer.asUint8List();

    final image = PdfImage.file(
      pdf.document,
      bytes: list,
    );

    return pdf.addPage(
      pw.MultiPage(
          build: (context) => [
                pw.Image(image),
                pw.Container(
                    //padding: pw.EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
                    child: pw.Text('Name      : ' + selectedFarmerValue.toString(),
                        style: pw.TextStyle(
                          fontSize: 15,
                          fontWeight: pw.FontWeight.bold,
                        ))),
                pw.Text(
                    'Interest   : ' + selectedInterestRateValue.toString() + "%",
                    style: pw.TextStyle(
                      fontSize: 15,
                      fontWeight: pw.FontWeight.bold,
                    )),
                pw.Text(
                    'Till Date  : ' +
                        ((interestTillDateController != null &&
                                interestTillDateController.text
                                    .toString()
                                    .isNotEmpty)
                            ? interestTillDateController.text.toString()
                            : dateFormat.format(DateTime.now())),
                    style: pw.TextStyle(
                      fontSize: 15,
                      fontWeight: pw.FontWeight.bold,
                    )),
                pw.Container(
                    padding: pw.EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                    child: pw.Table(
                      border: pw.TableBorder(width: 1.0),
                      children: renderTableRows(listOfBillsByFarmerName),
                    )),
                pw.Container(
                    padding: pw.EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                    child: pw.Text(
                        'Total Anamath Amount With Interest           : ' +
                            totalAnamathAmountWithInterestController.text.toString(),
                        style: pw.TextStyle(
                          fontSize: 15,
                          fontWeight: pw.FontWeight.bold,
                        ))),
                pw.Text(
                    'Total Credit Amount With Interest                : ' +
                        totalCreditAmountWithInterestController.text.toString(),
                    style: pw.TextStyle(
                      fontSize: 15,
                      fontWeight: pw.FontWeight.bold,
                    )),
            pw.Text(
                'Total Cash Received Amount With Interest : ' +
                    totalCashReceivedAmountWithInterestController.text.toString(),
                style: pw.TextStyle(
                  fontSize: 15,
                  fontWeight: pw.FontWeight.bold,
                )),
            pw.Text(
                'Balance Amount                                             : ' +
                    netAmountController.text.toString(),
                style: pw.TextStyle(
                  fontSize: 15,
                  fontWeight: pw.FontWeight.bold,
                )),
              ]),
    );
  }

  renderTableRows(listOfBillsByFarmerName) {
    DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    listOfBillsByFarmerName.sort((a,b) {
      DateTime adate = dateFormat.parse(a['billdate']);
      DateTime bdate = dateFormat.parse(b['billdate']);
      return -adate.compareTo(bdate);
    });

    List<pw.TableRow> rows = new List<pw.TableRow>();
    rows.add(pw.TableRow(children: [
      pw.Column(children: [
        pw.Text("Bill Date",
            style: pw.TextStyle(
              fontSize: 13,
              fontWeight: pw.FontWeight.bold,
            ))
      ]),
      pw.Column(children: [
        pw.Text("Bill No",
            style: pw.TextStyle(
              fontSize: 13,
              fontWeight: pw.FontWeight.bold,
            ))
      ]),
      pw.Column(children: [
        pw.Text("Bill Amount",
            style: pw.TextStyle(
              fontSize: 13,
              fontWeight: pw.FontWeight.bold,
            ))
      ]),
      pw.Column(children: [
        pw.Text("Bill Type",
            style: pw.TextStyle(
              fontSize: 13,
              fontWeight: pw.FontWeight.bold,
            ))
      ]),
      // you can have more properties of course
    ]));

    listOfBillsByFarmerName.forEach((item) => {
          rows.add(pw.TableRow(children: [
            pw.Column(children: [pw.Text(item['billdate'])]),
            pw.Column(children: [pw.Text(item['billno'])]),
            pw.Column(children: [pw.Text(item['amount'])]),
            pw.Column(children: [pw.Text(item['type'])]),
            // you can have more properties of course
          ]))
        });
    return rows;
  }

  renderImage(pdf) async {
    final ByteData bytes = await rootBundle.load('fertilizersassets/logo.jpg');
    final Uint8List list = bytes.buffer.asUint8List();

    final image = PdfImage.file(
      pdf.document,
      bytes: list,
    );

    return image;
  }

  generateReport() async {
    final pdf = pw.Document();
    renderPDFBillsList(pdf);
    final output = await getExternalStorageDirectory();
    final file = File("${output.path}/example.pdf");
    await file.writeAsBytes(pdf.save());
  }
}
