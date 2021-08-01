import 'package:flutter/material.dart';
import 'package:localauth/models/user_transaction.dart';
import 'package:localauth/presentation/screens/details/details_list.dart';
import 'package:localauth/services/transaction_services.dart';

class SearchDialog extends StatefulWidget {
  List<User> userList;
  SearchDialog(this.userList);
  @override
  _SearchDialogState createState() => _SearchDialogState();
}

class _SearchDialogState extends State<SearchDialog> {
  // final TransactionService _transactionService =
  //     TransactionService.getTransactionServiceInstance;
   String
      _searchValue; //I'm force to use it for now i'll try to see what happen later ohk
  String name = '';
  TextEditingController _textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
          content: Container(
              height: MediaQuery.of(context).size.height * .65,
              child: Column(
                children: [
                  TextFormField(
                    validator: (String value) {
                      if (value.isEmpty) return 'Fill that input';
                      return null;
                    },
                    controller: _textController,
                    onEditingComplete: () {
                      this.setState(() {
                        this._searchValue = _textController.text;
                      });
                    },
                    decoration: InputDecoration(
                      hintText:
                          'Search a user ',
                    ),
                  ),
                  Builder(builder: (context)=> _addList(widget.userList))
                ],
              )),
        );
  }
  void _pushToDetailsScreen(BuildContext context, User user) => Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetailsList(user: user)));


  Widget _addList(List<User> userList){
    List<User> _usersList = userList.where((user) {
                          if (user.name
                              .toLowerCase()
                              .contains(this._searchValue.toString().toLowerCase())) {
                                print('here');
                                print(user.name);
                                print(this._searchValue.toString());
                            return true;
                          }
                          return false;
                        }).toList();
                        print(_usersList.length);
                        if(_usersList.length==0) return Center(child:Text('Not found user'));
                        return Expanded(
                           child: Container(
                            child: ListView.builder(
                              physics: BouncingScrollPhysics(),
                              itemCount: _usersList.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () => _pushToDetailsScreen(
                                      context, _usersList[index]),
                                  child: ListTile(
                                      leading: Icon(Icons.person),
                                      title: Text(
                                        _usersList[index].name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1
                                            .copyWith(color: Colors.blueAccent),
                                      )),
                                );
                              },
                            ),
                          ),
                        );
                      
  }
}