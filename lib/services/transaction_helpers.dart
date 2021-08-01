import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

mixin TransactionHelpers {
  //Getting transaction reference
  final CollectionReference _transactions =
      FirebaseFirestore.instance.collection('transactions');
  final CollectionReference _deletedUsers =
      FirebaseFirestore.instance.collection('deletedUsers');
  //Create a user
  Future<void> createAUser({@required Map<String, dynamic> userData}) {
    assert(userData != null);
    try {
      _transactions.add(userData);
      return null;
    } catch (e) {
      rethrow;
    }
  }
//restore a user
  Future<void> restoreUser({@required String docId}) async{
    //Get back the data of the user from the deleteUsers collection
    //thanks can u remove that tab this one here yes, is it good  don't run it now plsok, we have to try to finish many things before run it 
    //ok thaknks 
    DocumentSnapshot _userData=await _deletedUsers.doc(docId).get();
    //Add it in the transactionCollection now
    _transactions.doc(docId).set(_userData.data());
    //Now delete it from the delteUsersCollection
    _deletedUsers.doc(docId).delete();
    //That is all for the restoration feature just a sec ok?yes
  }
  //Delete a user
  //True for from the deleteUser and false for the transaction collection ; there ?yes
  Future<void> deleteAUser({@required String docId,@required bool fromDelete}) async{
    assert(docId != null);
    try {
      if(!fromDelete){
        final DocumentSnapshot _userData = await _transactions.doc(docId).get();
      _deletedUsers.doc(docId).set(_userData.data());
      _transactions.doc(docId).delete();
      return null;
      }
      else{
      _deletedUsers.doc(docId).delete();
      return null;
      }
    } catch (e) {
      rethrow;
    }
  }
  //Can I change the color of the editor ? pls ? I think I'll like like as you like  actually those colors wer clients
  //so lets keep it
  //I'm talking about color o the vs code cods , ohri ght sure o sure this computer is al urs change it as u like
  //Oo Thanks a lot , I'm really sorry to ask all that thing hey change o let me aslo make it like a propoer coder
  //ik nothing about all this , s plz go ahead, okay 
  // Shortcut shift+ctrl+p
  //I see you don't have other color theme installed that is not a problem : )
  //we can do that if u have time, im free i can watch u do it, take complete access
  //Oo It's too much privileges for me, 
  //I'll use it like that I like it too, don't worry after I'll show how to do it ok as u say
 
  ///Update  and add userTransaction
  ///{dynamic} here stand for Map<String, dynamic>
  Future<String> addAndUpdateuserTransactionsList(
      {@required String docId,
      @required List<dynamic> newTransactionList,
      String operationType: 'add'}) async {
    //Assertion chechings
    assert(docId != null);
    assert(newTransactionList != null);
    assert(operationType != null);
    try {
      await _transactions
          .doc(docId)
          .update({'transactionList': newTransactionList});
      final DocumentSnapshot _deletedData = await _deletedUsers.doc(docId).get();
      _deletedUsers.doc(docId).set(_deletedData.data());
      // await _deletedUsers
      //     .doc(docId)
      //     .update({'transactionList': newTransactionList});
      return operationType == 'add'
          ? 'Transaction has been added'
          : 'Transaction has be edited';
    } on FirebaseException catch (e) {
      print(e.message);
      return 'An error Occured, sure of your connection';
    } catch (e) {
      return 'An internal error occured';
    }
  }

  //Get all usersTransaction
  Stream<QuerySnapshot> fetchAllUsersTransaction({String userID}) =>
      _transactions.snapshots(includeMetadataChanges: true);

  Stream<QuerySnapshot> fetchAllUsersDeletedTransaction({String userID}) =>
      _deletedUsers.snapshots(includeMetadataChanges: true);
  
  //Get one userTransaction
  Stream<DocumentSnapshot> fetchOneUsersTransaction(
          {@required String userID}) =>
      _transactions.doc(userID).snapshots(includeMetadataChanges: true);
}
