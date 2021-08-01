import 'package:flutter/material.dart';
import 'package:localauth/services/setpass_service.dart';
import 'package:passcode_screen/keyboard.dart';

import 'home/home.dart';

class PassCode extends StatefulWidget {
  @override
  _PassCodeState createState() => _PassCodeState();
}

class _PassCodeState extends State<PassCode> {
  TextEditingController _usernameController = new TextEditingController();
    TextEditingController _confirmusernameController = new TextEditingController();
    final GlobalKey<FormState> _form = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => Home())),
          ),
          title: Text('Passcode'),
          centerTitle: true,
      ),
          body: Container(
        child: Center(
          child: Form(
             key: _form,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.only(left:28.0),
                    child: Row(
                      children: [
                        Text(' Passcode'),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(8.0),
                    width: MediaQuery.of(context).size.width/1.2,
                    decoration: BoxDecoration(
                      border:Border.all(),
                      borderRadius: BorderRadius.all(Radius.circular(8.0))
                    ),
                    child: Center(
                      child: TextFormField(
                        keyboardType: TextInputType.phone,
                        controller: _usernameController,
                        maxLengthEnforced: true,
                        maxLength:6,
                        // decoration: InputDecoration(labelText: 'passcode :'),
                        validator: (val){
                                        if(val.isEmpty || !(val.length==6))
                                             return '6 digits needed';
                                        return null;
                                        }
                      ),
                    ),
                  ),
                  SizedBox(height:20),
                  Container(
                    padding: EdgeInsets.only(left:28.0),
                    child: Row(
                      children: [
                        Text('Confirm Passcode'),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(8.0),
                    width: MediaQuery.of(context).size.width/1.2,
                    decoration: BoxDecoration(
                  border:Border.all(),
                  borderRadius: BorderRadius.all(Radius.circular(8.0))
                    ),
                    child: TextFormField(
                      keyboardType: TextInputType.phone,
                controller: _confirmusernameController,
                maxLengthEnforced: true,
                        maxLength:6,
                // decoration: InputDecoration(labelText: 'Confirm passcode :'),
                validator: (val){
                                      if(val.isEmpty)
                                           return 'Empty';
                                      if(val != _usernameController.text)
                                           return 'enter correct passcode';
                                      return null;
                                      }
            ),
                  ),
            FlatButton(
              onPressed: () async {
              if( _form.currentState.validate()){
                _deleteUserHandler(context);
               SetCodeService _setCodeService = SetCodeService();
               _setCodeService.setPasscode(_usernameController.text);
               print(_usernameController.text);
               
              }}, child: Text('save'),
            color: Colors.blueAccent)
                ],
                
            ),
          ),
          
        ),
      ),
    );
  }
}
 _deleteUserHandler(context)  {
    print('inside delete');
    showDialog(
      context: context,
          builder: (context) => AlertDialog(
        content: Text("Your passscode is saved"),
        actions: [
          FlatButton(
                onPressed: ()  {
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Home()));}, child: Text('Ok')),
                      ],
                    ),
    );
    
  }