import 'dart:convert';
import 'dart:html';
import 'package:web/helpers.dart';
import '../../transaction.dart';
import 'dialog_admin.dart';

void main() {
  //new transaction dialog
  Dialog.handleDialog();

}

void tableBaru (){
  var table = querySelector('#makanan');
  
  var data = Transaction.getAllTransactions();
  console.log(data);
}