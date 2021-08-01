// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:localauth/models/user_transaction.dart';
// import 'package:open_file/open_file.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:permission_handler/permission_handler.dart';

// class PdfCreator {
//   static Future createOneUserReport(User user) async {
//     print(user.transactionList.length);
//     final pdf =
//         pw.Document(author: 'Account Manager', creator: 'Account Manager');

//     //add Page
//     pdf.addPage(pw.MultiPage(
//         pageFormat: PdfPageFormat.a4,
//         orientation: pw.PageOrientation.portrait,
//         build: (pw.Context context) {
//           return <pw.Widget>[
//             pw.Header(
//                 level: 0,
//                 child:
//                     pw.Text('${user.name}', style: pw.TextStyle(fontSize: 35))),
//             pw.Header(
//                 level: 2,
//                 child: pw.Table(children: [
//                   pw.TableRow(children: [
//                     pw.Container(
//                       alignment: pw.Alignment.center,
//                       width: 300,
//                       child: pw.Text('Transaction Date',
//                           textAlign: pw.TextAlign.center,
//                           style: pw.TextStyle(
//                               fontWeight: pw.FontWeight.bold,
//                               color: PdfColor.fromInt(Colors.black.value))),
//                     ),
//                     pw.Container(
//                       alignment: pw.Alignment.center,
//                       width: 300,
//                       child: pw.Text('Particular',
//                           textAlign: pw.TextAlign.center,
//                           style: pw.TextStyle(
//                               fontWeight: pw.FontWeight.bold,
//                               color: PdfColor.fromInt(Colors.orange.value))),
//                     ),
//                     //Where were we  the pdf path, oikatsy  ok , i dont want it in report, its getting saved in
//                     // downloads thats fine. else will u fix? yeah let us try to fix to
//                     pw.Container(
//                       alignment: pw.Alignment.center,
//                       width: 300,
//                       child: pw.Text('Credit',
//                           textAlign: pw.TextAlign.center,
//                           style: pw.TextStyle(
//                               fontWeight: pw.FontWeight.bold,
//                               color: PdfColor.fromInt(Colors.green.value))),
//                     ),
//                     pw.Container(
//                       alignment: pw.Alignment.center,
//                       width: 300,
//                       child: pw.Text('Debit',
//                           textAlign: pw.TextAlign.right,
//                           style: pw.TextStyle(
//                               fontWeight: pw.FontWeight.bold,
//                               color: PdfColor.fromInt(Colors.red.value))),
//                     ),
//                   ])
//                 ])),
//             pw.Table(
//                 children: user.transactionList.map((dynamic transaction) {
//               return pw.TableRow(children: [
//                 pw.Container(
//                   alignment: pw.Alignment.center,
//                   width: 1000 / 4,
//                   child: pw.Text(transaction.transactionDate,
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(
//                           fontWeight: pw.FontWeight.bold,
//                           color: PdfColor.fromInt(Colors.black.value))),
//                 ),
//                 pw.Container(
//                   alignment: pw.Alignment.center,
//                   width: 1000 / 4,
//                   child: pw.Text(transaction.particular,
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(
//                           fontWeight: pw.FontWeight.bold,
//                           color: PdfColor.fromInt(Colors.black.value))),
//                 ),
//                 pw.Container(
//                   alignment: pw.Alignment.center,
//                   width: 1000 / 4,
//                   child: pw.Text('${transaction.credit.toString()}',
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(
//                           fontWeight: pw.FontWeight.bold,
//                           color: PdfColor.fromInt(Colors.black.value))),
//                 ),
//                 pw.Container(
//                   alignment: pw.Alignment.center,
//                   width: 1000 / 4,
//                   child: pw.Text('${transaction.debit.toString()}',
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(
//                           fontWeight: pw.FontWeight.bold,
//                           color: PdfColor.fromInt(Colors.black.value))),
//                 )
//               ]);
//             }).toList()),
//             pw.Footer(
//                 title: pw.Header(
//                     margin: pw.EdgeInsets.only(top: 15),
//                     level: 2,
//                     child: pw.Column(
//                         crossAxisAlignment: pw.CrossAxisAlignment.start,
//                         children: [
//                           pw.RichText(
//                             textAlign: pw.TextAlign.left,
//                             text: pw.TextSpan(
//                                 text: 'Credit Total Amount: ',
//                                 children: [
//                                   pw.TextSpan(
//                                       style: pw.TextStyle(
//                                         color: PdfColor.fromInt(
//                                             Colors.green.value),
//                                       ),
//                                       text:
//                                           '${_calculateCreditTotal(user)['credit']}')
//                                 ]),
//                           ),
//                           pw.RichText(
//                             textAlign: pw.TextAlign.left,
//                             text: pw.TextSpan(
//                                 text: 'Debit Total Amount:  ',
//                                 children: [
//                                   pw.TextSpan(
//                                       style: pw.TextStyle(
//                                         color: PdfColor.fromInt(
//                                             Colors.orange.value),
//                                       ),
//                                       text:
//                                           '${_calculateCreditTotal(user)['debit']}')
//                                 ]),
//                           ),
//                           pw.RichText(
//                             textAlign: pw.TextAlign.left,
//                             text: pw.TextSpan(
//                                 text: 'Balance Total Amount:  ',
//                                 children: [
//                                   pw.TextSpan(
//                                       style: pw.TextStyle(
//                                         color:
//                                             PdfColor.fromInt(Colors.red.value),
//                                       ),
//                                       text:
//                                           '${_calculateCreditTotal(user)['balance']}')
//                                 ]),
//                           ),
//                         ])))
//           ];
//         }));
//     if ((await Permission.storage.request()).isGranted) {
//       final Directory _rootDir = await getExternalStorageDirectory();
//       print(_rootDir.parent.parent.parent.parent
//           .path); // We will see more about the path it will be launhc
//       final Directory _specificFolder =
//           Directory('${_rootDir.parent.parent.parent.parent.path}/reports');
//       String directory;
//       if (await _specificFolder.exists()) {
//         directory = _specificFolder.path;
//       } else {
//         _specificFolder.create(recursive: true);
//         directory = _specificFolder.path;
//       }
//       print(directory);
//       final String path =
//           '$directory/${user.name}(${DateTime.now().month}_${DateTime.now().day}_${DateTime.now().year}(${DateTime.now().hour}:${DateTime.now().minute})).pdf';
//       final File file = File(path);
//       file.writeAsBytes(pdf.save());
//       //Open the PDF document in mobile
//       OpenFile.open(path);
//     }
//   }

//   static Future createAllUsersRapports(List<User> users) async {
//     final pdf =
//         pw.Document(author: 'Account Manager', creator: 'Account Manager');
//     // did u find what u wer looking ffor? ..? hello u there?
//     //add Page
//     pdf.addPage(pw.MultiPage(
//         pageFormat: PdfPageFormat.a4,
//         orientation: pw.PageOrientation.portrait,
//         header: (pw.Context context) {
//           return pw.Header(
//               level: 0,
//               child: pw.Text('Account Manager',
//                   style: pw.TextStyle(fontSize: 35)));
//         },
//         build: (pw.Context context) {
//           return _buildFullList(users);
//         }));
//     // I think all is go for testing now ok so u will see the outpt rght? u have time right? yes m runynou can run it
//     if ((await Permission.storage.request()).isGranted) {
//       final Directory _rootDir =
//           (await getExternalStorageDirectory()).parent.parent.parent.parent;
//       //The idea is to find the root parent i see
//       await _rootDir.list().forEach((dir) async {
//         // print(dir.path);
//         if (dir.path == '/storage/emulated/0/Download') {
//           //COrrect path here found
//           final Directory _downloadDir = dir;
//           final Directory _specificFolder =
//               Directory('${_downloadDir.path}/reports');
//           if (!(await _specificFolder.exists())) {
//             _specificFolder.create(recursive: true);
//           }
//           print(_specificFolder);
//           // final String path =
//           //     '$_specificFolder/account_full_report(${DateTime.now().month}_${DateTime.now().day}_${DateTime.now().year}(${DateTime.now().hour}:${DateTime.now().minute})).pdf';
//           final String path =
//               '$_specificFolder/account_full_report_${DateTime.now().hour}:${DateTime.now().minute}.pdf';
//           final File file = File(path);
//           file.writeAsBytes(pdf.save());
//           //Open the PDF document in mobile
//           OpenFile.open(path);
//           //CHechk if it has been create in the download forler n
//           //No go in the reports folder 
//           //Okay 
//           /// sorry to interrupt, i thibk lets just leave this for now what do u say, no problem later we will try to see it i mean to sy
//           /// let it b like that for now.... there is  a aproblrm in total c
//           /// aN/ /OKay what is the formula you use to calcul to calculate thze totla
//         }
//       }); //After save the hot reload will take place
//       // just a sec, it works like this too o, i just wanted a download option
//       //Try again
//       //there?o u there?
//       // u can click on it o u click
//       //Did you have the flutter plugin install ? yesokau so you don't have to always use the command line
//       //OR you use it for personnaly purpose right ? i dont other then that, i see le mee show you it
//       // print(_rootDir.parent.parent.parent.parent.path);
//       //This reflsh icon is for restart and the hot reload happend when you save a file
//       //All is done autmocatilcy   ooooooo oko, yes But you got more command line pratice , that is fine :)
//       //RUn it now
//       //GO in the app itself I wan to sdee the path beforer contiue any modifiction ok

//     }
//   }

//   ///For calculation purpose
//   static Map<String, double> _calculateCreditTotal(User user) {
//     double _creditTotalAmount = 0;
//     double _balanceTotalAmount = 0;
//     double _debitTotalAmount = 0;
//     user.transactionList.forEach((dynamic transaction) {
//       _creditTotalAmount += transaction.credit;
//       _debitTotalAmount += transaction.debit;
//       _balanceTotalAmount += (transaction.credit - transaction.debit);
//     });

//     return {
//       'credit': _creditTotalAmount,
//       'debit': _debitTotalAmount,
//       'balance': _balanceTotalAmount,
//     };
//   }

//   //Build Full List Widget
//   static List<pw.Widget> _buildFullList(List<User> users) {
//     return users.map((User user) {
//       return pw.Column(children: [
//         pw.Header(level: 2, child: pw.Text(user.name)),
//         pw.Header(
//             level: 2,
//             child: pw.Table(children: [
//               pw.TableRow(children: [
//                 pw.Container(
//                   alignment: pw.Alignment.center,
//                   width: 300,
//                   child: pw.Text('Transaction Date',
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(
//                           fontWeight: pw.FontWeight.bold,
//                           color: PdfColor.fromInt(Colors.black.value))),
//                 ),
//                 pw.Container(
//                   alignment: pw.Alignment.center,
//                   width: 300,
//                   child: pw.Text('Particular',
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(
//                           fontWeight: pw.FontWeight.bold,
//                           color: PdfColor.fromInt(Colors.orange.value))),
//                 ),
//                 pw.Container(
//                   alignment: pw.Alignment.center,
//                   width: 300,
//                   child: pw.Text('Credit',
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(
//                           fontWeight: pw.FontWeight.bold,
//                           color: PdfColor.fromInt(Colors.green.value))),
//                 ),
//                 pw.Container(
//                   alignment: pw.Alignment.center,
//                   width: 300,
//                   child: pw.Text('Debit',
//                       textAlign: pw.TextAlign.right,
//                       style: pw.TextStyle(
//                           fontWeight: pw.FontWeight.bold,
//                           color: PdfColor.fromInt(Colors.red.value))),
//                 ),
//               ])
//             ])),
//         pw.Table(
//             tableWidth: pw.TableWidth.max,
//             children: user.transactionList.map((dynamic transaction) {
//               return pw.TableRow(children: [
//                 pw.Text(
//                   transaction.transactionDate,
//                   textAlign: pw.TextAlign.center,
//                 ),
//                 pw.Text(
//                   transaction.particular,
//                   textAlign: pw.TextAlign.center,
//                 ),
//                 pw.Text(
//                   '${transaction.credit.toString()}',
//                   textAlign: pw.TextAlign.center,
//                 ),
//                 pw.Text(
//                   '${transaction.debit.toString()}',
//                   textAlign: pw.TextAlign.center,
//                 ),
//               ]);
//             }).toList()),
//         pw.Header(
//             margin: pw.EdgeInsets.only(top: 15, bottom: 25),
//             level: 2,
//             child: pw.Column(
//                 crossAxisAlignment: pw.CrossAxisAlignment.start,
//                 children: [
//                   pw.RichText(
//                     textAlign: pw.TextAlign.left,
//                     text: pw.TextSpan(text: 'Credit Total Amount: ', children: [
//                       pw.TextSpan(
//                           style: pw.TextStyle(
//                             color: PdfColor.fromInt(Colors.green.value),
//                           ),
//                           text: '${_calculateCreditTotal(user)['credit']}')
//                     ]),
//                   ),
//                   pw.RichText(
//                     textAlign: pw.TextAlign.left,
//                     text: pw.TextSpan(text: 'Debit Total Amount:  ', children: [
//                       pw.TextSpan(
//                           style: pw.TextStyle(
//                             color: PdfColor.fromInt(Colors.green.value),
//                           ),
//                           text: '${_calculateCreditTotal(user)['debit']}')
//                     ]),
//                   ),
//                   pw.RichText(
//                     textAlign: pw.TextAlign.left,
//                     text:
//                         pw.TextSpan(text: 'Balance Total Amount:  ', children: [
//                       pw.TextSpan(
//                           style: pw.TextStyle(
//                             color: PdfColor.fromInt(Colors.green.value),
//                           ),
//                           text: '${_calculateCreditTotal(user)['balance']}')
//                     ]),
//                   ),
//                 ]))
//       ]);
//     }).toList();
//   }
// }

 import 'dart:io';

 import 'package:flutter/material.dart';
 import 'package:localauth/models/user_transaction.dart';
 import 'package:open_file/open_file.dart';
 import 'package:path_provider/path_provider.dart';
 import 'package:pdf/pdf.dart';
 import 'package:pdf/widgets.dart' as pw;

 class PdfCreator {
  static int convertDateToNumber(String transaction) {
  String _month;
  String _day;
  print("transactons here............$transaction");
  List<int> transactions = transaction.split('-').map((e) => int.parse(e)).toList();
  print("............$transactions");
  //Ajust month
  if (transactions[0].toString().length > 1) {
    _month = transactions[0].toString();
  } else {
    _month = '0${transactions[0]}'.toString();
  }
  //Ajust day
  if (transactions[1].toString().length > 1) {
    _day = transactions[1].toString();
  } else {
    _day = '0${transactions[1]}'.toString();
  }
  int _dateFormNum = int.parse('${transactions[2]}${_month}${_day}');
  return _dateFormNum;
}

//This is for comparaison
static List<dynamic> compareDateStringfied(List<dynamic> transactionList) {
  List<dynamic> newTransactionsList = transactionList;
  //Sort
  for (var i = 0; i < newTransactionsList.length - 1; i++) {
    dynamic minObj = newTransactionsList[i];
    int _minPos = i;
    for (var j = i + 1; j < newTransactionsList.length; j++) {
      if (convertDateToNumber(minObj.transactionDate) >
          convertDateToNumber(newTransactionsList[j].transactionDate)) {
        minObj = newTransactionsList[j];
        _minPos = j;
      }
    }
    dynamic temp = newTransactionsList[i];
    newTransactionsList[i] = minObj;
    newTransactionsList[_minPos] = temp;
  }
  return newTransactionsList;
}

   static Future createOneUserRapport(User user) async {
     print(user.transactionList.length);
     List<dynamic> newTransactionList=compareDateStringfied(user.transactionList);
     final pdf =
         pw.Document(author: 'Account Manager', creator: 'Account Manager');

     //add Page
     pdf.addPage(pw.MultiPage(
         pageFormat: PdfPageFormat.a4,
         orientation: pw.PageOrientation.portrait,
         build: (pw.Context context) {
           return <pw.Widget>[
             pw.Header(
                 level: 0,
                 child: pw.Text('${user.name}',
                     style: pw.TextStyle(fontSize: 35,fontWeight: pw.FontWeight.bold,))),
             pw.Header(
                 level: 2,
                 child: pw.Table(children: [
                   pw.TableRow(children: [
                     pw.Container(
                   alignment: pw.Alignment.centerLeft,
                   width: 1000/4,
                   child: pw.Text('Transaction Date',
                     textAlign: pw.TextAlign.center,
                         style: pw.TextStyle(
                             fontWeight: pw.FontWeight.bold,
                             color: PdfColor.fromInt(Colors.black.value))),
                 ),
                    pw.Container(
                   alignment: pw.Alignment.center,
                   width: 1000/4,
                   child: pw.Text('Particular',
                     textAlign: pw.TextAlign.center,
                         style: pw.TextStyle(
                             fontWeight: pw.FontWeight.bold,
                             color: PdfColor.fromInt(Colors.orange.value))),
                 ),
                     pw.Container(
                   alignment: pw.Alignment.centerRight,
                   width: 1000/4,
                   child: pw.Text('Credit',
                     textAlign: pw.TextAlign.center,
                         style: pw.TextStyle(
                             fontWeight: pw.FontWeight.bold,
                             color: PdfColor.fromInt(Colors.green.value))),
                 ),
                     pw.Container(
                   alignment: pw.Alignment.centerRight,
                   width: 1000/4,
                   child: pw.Text('Debit',
                     textAlign: pw.TextAlign.center,
                         style: pw.TextStyle(
                             fontWeight: pw.FontWeight.bold,
                             color: PdfColor.fromInt(Colors.red.value))),
                 ),
                   ])
                 ])),
             pw.Table(
                 children: newTransactionList.map((dynamic transaction) {
               return pw.TableRow(children: [
                 pw.Container(
                   alignment: pw.Alignment.centerLeft,
                   width: 1000/4,
                   child: pw.Text(transaction.transactionDate,
                         style: pw.TextStyle(
                             fontWeight: pw.FontWeight.bold,
                             color: PdfColor.fromInt(Colors.black.value))),
                 ),
                 pw.Container(
                   alignment: pw.Alignment.centerLeft,
                   width: 1000/4,
                   child: pw.Text(transaction.particular,
                         style: pw.TextStyle(
                             fontWeight: pw.FontWeight.bold,
                             color: PdfColor.fromInt(Colors.black.value))),
                 ),
                 pw.Container(alignment: pw.Alignment.centerRight,width: 1000/4,child: pw.Text('${transaction.credit.toString()}',
                     
                         style: pw.TextStyle(
                             fontWeight: pw.FontWeight.bold,
                             color: PdfColor.fromInt(Colors.black.value))),),
                 pw.Container(alignment: pw.Alignment.centerRight,width: 1000/4,child: pw.Text('${transaction.debit.toString()}',
                         style: pw.TextStyle(
                             fontWeight: pw.FontWeight.bold,
                             color: PdfColor.fromInt(Colors.black.value))),)
               ]);
             }).toList()),
             pw.Footer(
                 title: pw.Header(
                     margin: pw.EdgeInsets.only(top: 15,left: 0),
                     level: 2,
                     child: pw.Column(
                         mainAxisAlignment: pw.MainAxisAlignment.end,
                         children: [
                           pw.RichText(
                             textAlign: pw.TextAlign.left,
                             text: pw.TextSpan(
                                 text: 'Credit Total Amount: ',
                                 children: [
                                   pw.TextSpan(
                                       style: pw.TextStyle(
                                         color: PdfColor.fromInt(
                                             Colors.green.value),
                                       ),
                                       text:
                                           '${_calculateCreditTotal(user)['credit']}')
                                 ]),
                           ),
                           pw.RichText(
                             textAlign: pw.TextAlign.left,
                             text: pw.TextSpan(
                                 text: 'Debit Total Amount:  ',
                                 children: [
                                   pw.TextSpan(
                                       style: pw.TextStyle(
                                         color: PdfColor.fromInt(
                                             Colors.orange.value),
                                       ),
                                       text:
                                           '${_calculateCreditTotal(user)['debit']}')
                                 ]),
                           ),
                           pw.RichText(
                             textAlign: pw.TextAlign.left,
                             text: pw.TextSpan(
                                 text: 'Balance Total Amount:  ',
                                 children: [
                                   pw.TextSpan(
                                       style: pw.TextStyle(
                                         color: PdfColor.fromInt(
                                             Colors.red.value),
                                       ),
                                       text:
                                           '${_calculateCreditTotal(user)['balance']}')
                                 ]),
                           ),
                         ])))
           ];
         }));
     final String directory = (await getApplicationDocumentsDirectory()).path;
     final String path = '$directory/account-${user.name}.pdf';
     final File file = File(path);
     file.writeAsBytes(pdf.save());
     //Open the PDF document in mobile
     OpenFile.open(path);
   }

   static Future createAllUsersRapports(List<User> users) async {
     final pdf =
         pw.Document(author: 'Account Manager', creator: 'Account Manager');

     //add Page
     pdf.addPage(pw.MultiPage(
         pageFormat: PdfPageFormat.a4,
         orientation: pw.PageOrientation.portrait,
         header: (pw.Context context) {
           return pw.Header(
               level: 0,
               child: pw.Text('Account Manager',
                   style: pw.TextStyle(fontSize: 35)));
         },
         build: (pw.Context context) {
           return _buildFullList(users);
         }));

    //Can we fix now the bug we got ? sure the,  download one? yes ok sure ur ,c ode is above
     final String directory = (await getExternalStorageDirectory()).path;
     final String path = '$directory/account-full-report.pdf';
     print(path);
     final File file = File(path);
     file.writeAsBytes(pdf.save());
     //Open the PDF document in mobile
     OpenFile.open(path);
   }

   ///For calculation purpose
   static Map<String, double> _calculateCreditTotal(User user) {
     double _creditTotalAmount = 0;
     double _balanceTotalAmount = 0;
     double _debitTotalAmount = 0;
     user.transactionList.forEach((dynamic transaction) {
       _creditTotalAmount += transaction.credit;
       _debitTotalAmount += transaction.debit;
       _balanceTotalAmount += (transaction.credit - transaction.debit);
     });

     return {
       'credit': _creditTotalAmount,
       'debit': _debitTotalAmount,
       'balance': _balanceTotalAmount,
     };
   }

   //Build Full List Widget
   static List<pw.Widget> _buildFullList(List<User> users) {
     return users.map((User user) {
       List<dynamic> newTransactionList=compareDateStringfied(user.transactionList);
       return pw.Column(children: [
         pw.Header(level: 2, child: pw.Text(user.name,style: pw.TextStyle(
                         fontWeight: pw.FontWeight.bold,fontSize: 25))),
         pw.Header(
             level: 2,
             child: pw.Table(children: [
               pw.TableRow(children: [
                 pw.Container(
                   alignment: pw.Alignment.centerLeft,
                   width: 1000/4,
                   child: pw.Text('Transaction Date',
                     style: pw.TextStyle(
                         fontWeight: pw.FontWeight.bold,
                         color: PdfColor.fromInt(Colors.black.value))),
                 ),
                 pw.Container(
                   alignment: pw.Alignment.center,
                   width: 1000/4,
                   child: pw.Text('Particular',
                     style: pw.TextStyle(
                         fontWeight: pw.FontWeight.bold,
                         color: PdfColor.fromInt(Colors.orange.value))),
                 ),
                 pw.Container(
                   alignment: pw.Alignment.centerRight,
                   width: 1000/4,
                   child: pw.Text('Credit',
                     style: pw.TextStyle(
                         fontWeight: pw.FontWeight.bold,
                         color: PdfColor.fromInt(Colors.green.value))),
                 ),
                 pw.Container(
                   alignment: pw.Alignment.centerRight,
                   width: 1000/4,
                   child: pw.Text('Debit',
                     style: pw.TextStyle(
                         fontWeight: pw.FontWeight.bold,
                         color: PdfColor.fromInt(Colors.red.value))),)
               ])
             ])),
         pw.Table(
             tableWidth: pw.TableWidth.max,
             children: newTransactionList.map((dynamic transaction) {
               return pw.TableRow(children: [
                 pw.Container(
                   alignment: pw.Alignment.centerLeft,
                   width: 1000/4,
                   child: pw.Text(
                   transaction.transactionDate,
                 ),
                 ),
                 pw.Container(
                   alignment: pw.Alignment.centerLeft,
                   width: 1000/4,
                   child: pw.Text(transaction.particular,
                         style: pw.TextStyle(
                             fontWeight: pw.FontWeight.bold,
                             color: PdfColor.fromInt(Colors.black.value))),
                 ),
                 pw.Container(alignment: pw.Alignment.centerRight,width: 1000/4,child: pw.Text('${transaction.credit.toString()}',
                     
                         style: pw.TextStyle(
                             fontWeight: pw.FontWeight.bold,
                             color: PdfColor.fromInt(Colors.black.value))),),
                 pw.Container(alignment: pw.Alignment.centerRight,width: 1000/4,child: pw.Text('${transaction.debit.toString()}',
                         style: pw.TextStyle(
                             fontWeight: pw.FontWeight.bold,
                             color: PdfColor.fromInt(Colors.black.value))),)
               ]);
             }).toList()),
         pw.Header(
             margin: pw.EdgeInsets.only(top: 15, bottom: 25),
             level: 2,
             child: pw.Column(
                 crossAxisAlignment: pw.CrossAxisAlignment.start,
                 children: [
                   pw.RichText(
                     textAlign: pw.TextAlign.left,
                     text: pw.TextSpan(text: 'Credit Total Amount: ', children: [
                       pw.TextSpan(
                           style: pw.TextStyle(
                             color: PdfColor.fromInt(Colors.green.value),
                           ),
                           text: '${_calculateCreditTotal(user)['credit']}')
                     ]),
                   ),
                   pw.RichText(
                     textAlign: pw.TextAlign.left,
                     text: pw.TextSpan(text: 'Debit Total Amount:  ', children: [
                       pw.TextSpan(
                           style: pw.TextStyle(
                             color: PdfColor.fromInt(Colors.green.value),
                           ),
                           text: '${_calculateCreditTotal(user)['debit']}')
                     ]),
                   ),
                   pw.RichText(
                     textAlign: pw.TextAlign.left,
                     text:
                         pw.TextSpan(text: 'Balance Total Amount:  ', children: [
                       pw.TextSpan(
                           style: pw.TextStyle(
                             color: PdfColor.fromInt(Colors.green.value),
                           ),
                           text: '${_calculateCreditTotal(user)['balance']}')
                     ]),
                   ),
                 ]))
       ]);
     }).toList();
   }
 }
