import 'package:cloud_firestore/cloud_firestore.dart';

class SetCodeService{
  final CollectionReference _passCode = FirebaseFirestore.instance.collection('requiredPass');
  Future setPasscode(String newPassCode) async => await _passCode.doc('YZczjFOkxzcvq9ggpWof').update({'pass': newPassCode});
}