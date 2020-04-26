import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

class Utilities {
  renderAlert(BuildContext context, String content, VoidCallback methodToExecute, progressdialog) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(18.0),
              side: BorderSide(color: Colors.blue)),
          title: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(
              Icons.warning,
              size: 25.0,
            ),
            Text("Alert",
                textAlign: TextAlign.center, style: TextStyle(fontSize: 22.0)),
          ]),
          content: Text(content.toString()),
          actions: <Widget>[
            FlatButton(
              child: Text("OK"),
              onPressed:  () {
                Navigator.of(context).pop();
                progressdialog.show();
                methodToExecute();
              }
              ,
            ),
            FlatButton(
              child: Text("CANCEL"),
              onPressed: () {
                //Put your code here which you want to execute on Cancel button click.
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static renderProgressDial(context){
    ProgressDialog pr;
    pr = new ProgressDialog(context);
    pr.style(
        message: 'Please Wait...',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600)
    );
    return pr;
  }
}
