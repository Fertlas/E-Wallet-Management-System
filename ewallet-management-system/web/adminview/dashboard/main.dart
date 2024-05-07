import 'dart:convert';
import 'dart:html';
import 'package:web/helpers.dart';
import '../../transaction.dart';
import 'dialog_admin.dart';
import 'dart:js_interop';

void main() {
  //new transaction dialog
  // Dialog.handleDialog();
  tableBaru();
}

void tableBaru (){
  var table = querySelector('#makanan');
  var test = <dynamic>[];
  test = Transaction.getAllTransactions();
  var allTransactions = window.localStorage['allTransactions'];
  var jsonDecodedTransc = jsonDecode(allTransactions!) as List<dynamic>;
  var i = 0;
  for (var transaction in jsonDecodedTransc) {
    final tableRow = document.createElement('tr');
    tableRow.id = 'tableRow$i';

    final userCell = document.createElement('td');
    const userCommonStyle = [
      "ml-4",
      "whitespace-nowrap",
      "py-4",
      "pl-4",
      "pr-3",
      "text-sm",
      "font-medium",
      "text-gray-900",
      "sm:pl-6"
    ];
    userCell.text = transaction['user'];
    tableRow.appendChild(userCell);

    final amountCell = document.createElement('td');
    const commonStyle = [
      "whitespace-nowrap",
      "py-4",
      "pl-4",
      "pr-3",
      "text-sm",
      "font-medium",
      "text-gray-900",
      "sm:pl-6"
    ];
    var amountStyle = transaction['amount'] > 0
        ? ['text-green-500', ...commonStyle]
        : ['text-red-500', ...commonStyle];
    amountCell.className = amountStyle.join(' ');
    amountCell.text = transaction['amount'].toStringAsFixed(2);
    tableRow.appendChild(amountCell);

    // Create cells (TD) and populate with transaction data
    final descriptionCell = document.createElement('td');
    const descCommonStyle = [
      "whitespace-nowrap",
      "py-4",
      "px-3",
      "text-sm",
      "text-gray-500",
    ];
    descriptionCell.className = descCommonStyle.join(' ');
    descriptionCell.textContent =
        '${transaction['description']}  / ${transaction['type']}';
    tableRow.appendChild(descriptionCell);

    final dateCell = document.createElement('td');
    const dateCommonStyle = [
      "whitespace-nowrap",
      "py-4",
      "px-3",
      "text-sm",
      "text-gray-500",
    ];
    dateCell.className = dateCommonStyle.join(' ');
    dateCell.textContent = transaction['date'].toString();
    tableRow.appendChild(dateCell);

    if (transaction['discount'] == null) {
      transaction['discount'] = 0.0;
    }
    final discountCell = document.createElement('td');
    const discountCommonStyle = [
      "whitespace-nowrap",
      "py-4",
      "px-3",
      "text-sm",
      "text-gray-500",
    ];
    discountCell.className = discountCommonStyle.join(' ');
    discountCell.textContent = transaction['discount'].toStringAsFixed(2);
    tableRow.appendChild(discountCell);

    if (transaction['cashback'] == null) {
      transaction['cashback'] = 0.0;
    }

    final cashbackCell = document.createElement('td');
    const cashbackCommonStyle = [
      "whitespace-nowrap",
      "py-4",
      "px-3",
      "text-sm",
      "text-gray-500",
    ];
    cashbackCell.className = cashbackCommonStyle.join(' ');
    cashbackCell.textContent = transaction['cashback'].toStringAsFixed(2);
    tableRow.appendChild(cashbackCell);

    final balanceCell = document.createElement('td');
    const balanceCommonStyle = [
      "whitespace-nowrap",
      "py-4",
      "px-3",
      "text-sm",
      "text-gray-900",
    ];
    balanceCell.className = balanceCommonStyle.join(' ');
    balanceCell.textContent = transaction['balance'].toStringAsFixed(2);
    tableRow.appendChild(balanceCell);


    final buttonCell = document.createElement('td');

    // Edit
    final editButton = document.createElement('button');
    editButton.text = 'Edit';
    editButton.onClick.listen((event) {
      editButton.text = 'Edited';
    });

    // Delete
    final deleteButton = document.createElement('button');
    deleteButton.text = 'Delete';
    deleteButton.onClick.listen((event) {
      deleteButton.text = '$i';
      // Transaction.deleteTransaction(i);
      // print(Transaction.getAllTransactions());
    });

    buttonCell.appendChild(editButton);
    buttonCell.appendChild(deleteButton);
    tableRow.appendChild(buttonCell);


    table!.appendChild(tableRow);
    i++;
  }
}
