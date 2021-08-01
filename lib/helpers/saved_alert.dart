//Show alert of the saved paasscode
import 'package:flutter/material.dart';

showPassCodeAlert(BuildContext context) {
  showDialog(
        context: context,
        child: AlertDialog(
          title: Text(
            'The Passcode is saved',
            style: TextStyle(
              fontSize: 20,
              color: Colors.red,
            ),
          ),
          content: Text(
            '',
            style: Theme.of(context)
                .textTheme
                .bodyText1
                .copyWith(color: Colors.black54),
          ),
          actions: [
            FlatButton(onPressed: (){Navigator.pop(context);}, child: Text('Ok'))
          ],
        ));
}
