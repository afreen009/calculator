import 'package:localauth/presentation/screens/loading/loading.dart';
import 'package:localauth/presentation/widgets/transaction_list_item.dart';
import '../error/error.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:localauth/helpers/appTheme.dart';
import 'package:localauth/models/user_transaction.dart';
import 'package:localauth/presentation/screens/home/home.dart';
import 'package:localauth/services/transaction_services.dart';

class DeleteScreen extends StatelessWidget {
  //Get our singleton firebaseService object
  final TransactionService _transactionService =
      TransactionService.getTransactionServiceInstance;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()=>Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Home())),
          child: Scaffold(
          bottomNavigationBar: BottomAppBar(
            child: StreamBuilder(
              stream: _transactionService.fetchAllUsersDeletedTransaction(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<QueryDocumentSnapshot> _docs = snapshot.data.docs;
                  double _creditTotalAmount = 0;
                  double _balanceTotalAmount = 0;
                  double _debitTotalAmount = 0;
                  _docs.forEach((userTransaction) {
                    User user = User.fromDocumentSnaphot(
                        userTransaction.id, userTransaction.data());
                    _creditTotalAmount += user.calculateCreditAmount;
                    _debitTotalAmount += user.calculateDebitAmount;
                    _balanceTotalAmount += user.calculateBalanceAmount;
                  });
                  return Container(
                    height: 50,
                    color: Colors.pink,
                    child: Row(
                      children: [
                        _buildCustomContainer('Credit',
                            _creditTotalAmount.toString(), AppTheme.creditColor),
                        _buildCustomContainer('Debit',
                            _debitTotalAmount.toString(), AppTheme.debitColor),
                        _buildCustomContainer('Balance',
                            _balanceTotalAmount.toString(), Colors.blue[100]),
                      ],
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
          backgroundColor: Colors.grey.shade200,
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Home())),
            ),
            title: Text('Deleted Users Dashboard'),
            centerTitle: true,
            // actions: [
            //   StreamBuilder(
            //     stream: _transactionService.fetchAllUsersDeletedTransaction(),
            //     builder: (context, snapshot) {
            //       if (snapshot.hasError)
            //         return Error();
            //       else if (snapshot.hasData) {
            //         //Get documents
            //         List<QueryDocumentSnapshot> _docs = snapshot.data.docs;

            //         if (_docs.length == 0) {
            //           return IconButton(
            //               onPressed: null, icon: Icon(Icons.print_disabled));
            //         }
            //         //Instead retuning the listView itself
            //         return IconButton(
            //             icon: Icon(
            //               Icons.print,
            //               color: Colors.white,
            //             ),
            //             onPressed: () async =>
            //                 await PdfCreator.createAllUsersRapports(
            //                         _docs.map((doc) {
            //                   User user =
            //                       User.fromDocumentSnaphot(doc.id, doc.data());
            //                   return user;
            //                 }).toList())
            //                     .then((value) => showPDFAlert(value, context)));
            //       }
            //       //Loading
            //       return Loading();
            //     },
            //   )
            // ],
          ),
          body: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.generalOutSpacing - 10,
              ),
              child: StreamBuilder<QuerySnapshot>(
                stream: _transactionService.fetchAllUsersDeletedTransaction(),
                builder: (context, snapshot) {
                  if (snapshot.hasError)
                    return Error();
                  else if (snapshot.hasData) {
                    //Get documents
                    List<QueryDocumentSnapshot> _docs = snapshot.data.docs;
                    if (snapshot.data.size == 0) {
                      return Center(child: Text('No User deleted yet'));
                    }

                    //Instead retuning the listView itself // did u see the time it took to get in?
                    //delete also works , !!!!!!!!!!! it works  in both screen delete and home ? yes it works
                    /// but there is a bprobblem the total amount differes someth
                    /// iN//g  continue, try also the pdf option ok sure np  
                    /// 5 mins ill prayy and come back toooo   there?
                    /// 
                    /// im here, take ur time np
                    /// //Pls there calling me I'll be bakc  ok sure
                    return ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: snapshot.data.size,
                      itemBuilder: (context, index) {
                        User user = User.fromDocumentSnaphot(
                            _docs[index].id, _docs[index].data());
                        return TransactionListItem(
                          user: user,
                          deleted: true,
                        );
                      },
                    );
                  }
                  //You 
                  //Loading
                  return Loading();
                },
              ))),
    );
  }

  //Build container
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
                      .copyWith(fontWeight: FontWeight.w100)),
              Text('$amount ₹', style: AppTheme.bottomTextStyle),
            ],
          )),
    );
  }
}
