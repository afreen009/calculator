import 'package:flutter/material.dart';
import 'package:localauth/helpers/appTheme.dart';
import 'package:localauth/models/user_transaction.dart';
import 'package:localauth/presentation/screens/details/details_list.dart';
import 'package:localauth/services/transaction_services.dart';

class TransactionListItem extends StatelessWidget {
  //DId you alreay added the icon of ther restr   no not added, no porlbme let us do it now ok
  final bool deleted;
  final User user;
  final TransactionService _transactionService =
      TransactionService.getTransactionServiceInstance;

  TransactionListItem({@required this.user, this.deleted: false})
      : assert(user != null);

  @override
  Widget build(BuildContext context) {
    print(user.transactionList);
    return GestureDetector(
      onTap: () => (!this.deleted) ? _pushToDetailsScreen(context) : null,
      child: Container(
        color: Colors.white,
        margin: const EdgeInsets.only(top: AppTheme.generalOutSpacing),
        padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.generalOutSpacing - 15),
        height: AppTheme.listItemHeight,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                      '${user.name[0].toUpperCase()}${user.name.substring(1)}',
                      style: AppTheme.userStyle
                          .copyWith(color: Colors.blue.shade300)),
                ),
                Container(
                  child:Row(children: [
                    (this.deleted)
                ? IconButton(
                    onPressed: () {
                      _restoreUserHandler(context);
                    },
                    icon: Icon(Icons.refresh, color: Colors.blue),
                  )
                : Container(),
                IconButton(
                  onPressed: () {
                    _deleteUserHandler(context, fromDelete: deleted);
                  },
                  icon: Icon(Icons.delete_outline, color: Colors.blue),
                )
                  ],)
                )
              ],
            ),
            Expanded(
              child: Row(
                children: [
                  _buildCustomContainer(
                      'Credit',
                      (double.parse(user.calculateCreditAmount.toString()).toStringAsFixed(2)).toString(),
                      AppTheme.creditColor),
                  _buildCustomContainer(
                      'Debit',
                      user.calculateDebitAmount.toString(),
                      AppTheme.debitColor),
                  _buildCustomContainer('Balance',
                  (double.parse(user.calculateCreditAmount.toString()).toStringAsFixed(2)).toString(),
                       Colors.blue[100]),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  //Build container
  Expanded _buildCustomContainer(
      String nameOfField, String amount, Color color) {
    return Expanded(
        child: Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(blurRadius: 7, color: color, offset: Offset(1.1, 3.3))
      ], borderRadius: BorderRadius.circular(15), color: color),
      margin: const EdgeInsets.only(
          left: AppTheme.smallSpacing - 2,
          right: AppTheme.smallSpacing - 2,
          bottom: (AppTheme.smallSpacing + 2)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(nameOfField, style: AppTheme.generalTextStyle),
          Text('₹ $amount', style: AppTheme.generalTextStyle),
        ],
      ),
    ));
  }

  //Handler to delete user;
  Future _deleteUserHandler(context, {@required bool fromDelete}) async {
    print('inside delete');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text("Confirm delete"),
        actions: [
          FlatButton(
              onPressed: () async {
                _transactionService
                    .deleteAUser(docId: user.userID, fromDelete: fromDelete)
                    .then((value) => Navigator.pop(context));
              },
              child: Text('Yes')),
          FlatButton(
              onPressed: () => Navigator.pop(context), child: Text('Cancel'))
        ],
      ),
    );
  }

// await _transactionService.deleteAUser(docId: user.userID);
  //Handler to restore a user;
  // It is all for that function
  Future _restoreUserHandler(context) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text("Confirm restore"),
        actions: [
          FlatButton(
              onPressed: () async {
                await _transactionService.restoreUser(docId: user.userID);
                Navigator.pop(context);
              },
              //You can run it now to see can i save them first/ save what ?
              child: Text('Yes')),
          FlatButton(
              onPressed: () => Navigator.pop(context), child: Text('Cancel'))
        ],
      ),
    );
  }

//O I took time to fix the { } problem
  //Push to another screen(the details screen)
  void _pushToDetailsScreen(BuildContext context) => Navigator.push(context,
      MaterialPageRoute(builder: (context) => DetailsList(user: user)));
}
