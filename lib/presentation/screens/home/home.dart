import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:localauth/cubit/search_cubit.dart';
import 'package:localauth/helpers/appTheme.dart';
import 'package:localauth/models/user_transaction.dart';
import 'package:localauth/presentation/screens/delete/delete_screen.dart';
import 'package:localauth/presentation/screens/home/search_dialog.dart';
import 'package:localauth/presentation/screens/loading/loading.dart';
import 'package:localauth/presentation/widgets/transaction_list_item.dart';
import 'package:localauth/presentation/widgets/user_create_alert.dart';
import 'package:localauth/services/pdf/pdf_creator.dart';
import 'package:localauth/services/transaction_services.dart';
import 'package:localauth/presentation/screens/error/error.dart';
import '../passcode.dart';

class Home extends StatefulWidget {
  final SearchCubit _searchCubit = SearchCubit('');
  //Get our singleton firebaseService object
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TransactionService _transactionService =
      TransactionService.getTransactionServiceInstance;
  String
      _searchValue; //I'm force to use it for now i'll try to see what happen later ohk
  String name = '';
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TextEditingController _usernameController = new TextEditingController();
    // TextEditingController _confirmusernameController = new TextEditingController();
    // final GlobalKey<FormState> _form = GlobalKey<FormState>();
    return WillPopScope(
      onWillPop: ()=> exit(0),
          child: Scaffold(
        drawer: _buildDrawer(context),
        bottomNavigationBar: BottomAppBar(
          child: StreamBuilder(
            stream: _transactionService.fetchAllUsersTransaction(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<QueryDocumentSnapshot> _docs = snapshot.data.docs;
                double _creditTotalAmount = 0.0;
                double _balanceTotalAmount = 0.0;
                double _debitTotalAmount = 0.0;
                print(_debitTotalAmount);
                _docs.forEach((userTransaction) {
                  User user = User.fromDocumentSnaphot(
                      userTransaction.id, userTransaction.data());
                  _creditTotalAmount += user.calculateCreditAmount;
                  _debitTotalAmount += user.calculateDebitAmount;
                  _balanceTotalAmount += user.calculateBalanceAmount;
                });
                return Container(
                  height: 50,
                  child: Row(
                    //Are you there ?
                    children: [
                      _buildCustomContainer(
                          'Credit',
                          _creditTotalAmount.toStringAsFixed(2),
                          AppTheme.creditColor),
                      _buildCustomContainer(
                          'Debit',
                          _debitTotalAmount.toStringAsFixed(2),
                          AppTheme.debitColor),
                      _buildCustomContainer(
                          'Balance',
                          _balanceTotalAmount.toStringAsFixed(2),
                          AppTheme.balanceColor),
                    ],
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
        ),
        //sorry to interrupt, u can continue, no probnlem, there? yes now
        /// i think i deletd, no problem so let us create one now
        //Let us start now with what ? hahaha search option o, okay no problem, have you already place your search iconByutton ?yes
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          title: Text('Dashboard'),
          actions: [
            StreamBuilder(
              stream: _transactionService.fetchAllUsersTransaction(),
              builder: (context, snapshot) {
                if (snapshot.hasError)
                  return Error();
                else if (snapshot.hasData) {
                  //Get documents
                  List<QueryDocumentSnapshot> _docs = snapshot.data.docs;

                  if (_docs.length == 0) {
                    return IconButton(
                        onPressed: null, icon: Icon(Icons.print_disabled));
                  }
                  return IconButton(
                      icon: Icon(
                        Icons.print,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        await PdfCreator.createAllUsersRapports(_docs.map((doc) {
                          User user =
                              User.fromDocumentSnaphot(doc.id, doc.data());
                          return user;
                        }).toList());
                      });
                }
                return Loading();
              },
            ),
            StreamBuilder(
              stream: _transactionService.fetchAllUsersTransaction(),
              builder: (context, snapshot) {
                if (snapshot.hasError)
                  return Error();
                else if (snapshot.hasData) {
                  //Get documents
                  List<QueryDocumentSnapshot> _docs = snapshot.data.docs;
                  if (_docs.length == 0) {
                    return IconButton(
                        onPressed: null, icon: Icon(Icons.search));
                  }
                  return IconButton(
                      icon: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        List<User> userList =_docs.map((doc) {
                          User user =
                              User.fromDocumentSnaphot(doc.id, doc.data());
                          return user;
                        }).toList();
                        _showSearchDialog(context,userList);
                      });
                }
                return Loading();
              },
            ),
          ],
        ),
        //   appBar: AppBar(
        //     title: Text('Dashboard'),
        //     centerTitle: true,
        //     actions: [
        //       GestureDetector(child: Padding(padding: EdgeInsets.only(right:8) ,child: Icon(Icons.settings)),onTap: (){print('tapped');
        //       showDialog(
        //       context: context,
        //                 builder: (context) => AlertDialog(
        // content: Form(
        //    key: _form,
        //           child: Column(
        //             mainAxisSize: MainAxisSize.min,
        //       children: [
        //         TextFormField(
        //           controller: _usernameController,

        //           decoration: InputDecoration(labelText: 'passcode'),
        //           validator: (val){
        //                           if(val.isEmpty || !(val.length==6))
        //                                return '6 digits needed';
        //                           return null;
        //                           }
        //         ),
        //         TextFormField(
        //       controller: _confirmusernameController,
        //       decoration: InputDecoration(labelText: 'Confirm passcode'),
        //       validator: (val){
        //                           if(val.isEmpty)
        //                                return 'Empty';
        //                           if(val != _usernameController.text)
        //                                return 'Not Match';
        //                           return null;
        //                           }
        //   ),
        //       ],
        //   ),
        // ),
        // actions: [
        //   FlatButton(
        //         onPressed: () async {if( _form.currentState.validate()){
        //           final prefs = await SharedPreferences.getInstance();
        //           prefs.setString('counter', _usernameController.text);
        //           var counter =  prefs.getString('counter');
        //           print(counter);
        //           Navigator.pop(context);
        //         }},
        //child: Text('Add')),
        //                 FlatButton(
        //                     onPressed: () => Navigator.pop(context), child: Text('Cancel'))
        //               ],
        //             ),
        //     );},),
        //     ],draw
        //               ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showDialog(context),
          child: Icon(Icons.add, color: Colors.white),
          tooltip: 'Create a user',
        ),
        body: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.generalOutSpacing - 10,
            ),
            child: StreamBuilder<QuerySnapshot>(
              stream: _transactionService.fetchAllUsersTransaction(),
              builder: (context, snapshot) {
                if (snapshot.hasError)
                  return Error();
                else if (snapshot.hasData) {
                  //Get documents
                  List<QueryDocumentSnapshot> _docs = snapshot.data.docs;
                  if (snapshot.data.size == 0) {
                    return Center(child: Text('No User yet'));
                  }

                  //Instead retuning the listView itself
                  return ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: snapshot.data.size,
                    itemBuilder: (context, index) {
                      User user = User.fromDocumentSnaphot(
                          _docs[index].id, _docs[index].data());
                      return TransactionListItem(user: user);
                    },
                  );
                }
                //Loading
                return Loading();
              },
            )),
      ),
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Container(
          color: Colors.grey.withOpacity(0.1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(color: Colors.white),
                child: CircleAvatar(
                    radius: 50, child: Image.asset('assets/cal.png')),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: InkWell(
                  onTap: () => Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => Home())),
                  child: ListTile(
                    leading: Icon(Icons.stacked_line_chart_sharp),
                    title: Text('Current Transaction'),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 8),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: InkWell(
                  onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => DeleteScreen())),
                  child: ListTile(
                    leading: Icon(Icons.delete_outline_outlined),
                    title: Text('Deleted Transactions'),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 8),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => PassCode()));
                  },
                  child: ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('Set Passcode'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _showDialog(BuildContext context) {
    showDialog(context: context, child: UserCreateAlert());
  }

  Expanded _buildCustomContainer(
      String nameOfField, String amount, Color color) {
    return Expanded(
      child: Container(
          decoration: BoxDecoration(boxShadow: [], color: color),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(nameOfField,
                  style: AppTheme.generalTextStyle
                      .copyWith(fontWeight: FontWeight.bold)),
              Text('₹ $amount', style: AppTheme.bottomTextStyle),
            ],
          )),
    );
  }
  _showSearchDialog(BuildContext context,List<User> userList) {
    showDialog(
        context: context,
        child: SearchDialog(userList),);
  }
}