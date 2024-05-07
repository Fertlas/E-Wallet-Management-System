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

void tableBaru() {
  var table = querySelector('#makanan');
  var test = <dynamic>[];
  test = Transaction.getAllTransactions();
  var allTransactions = window.localStorage['allTransactions'];
  var jsonDecodedTransc = jsonDecode(allTransactions!) as List<dynamic>;
  var indexedTransactions = jsonDecodedTransc.asMap();
  for (var index in indexedTransactions.keys) {
    var transaction = indexedTransactions[index];
    final tableRow = document.createElement('tr');
    tableRow.id = 'tableRow$index';

    final userCell = document.createElement('td');
    const userCommonStyle = [
      "ml-4",
      "whitespace-nowrap",
      "py-4",
      "px-4",
      "text-sm",
      "font-medium",
      "text-gray-900",
      "sm:pl-6"
    ];
    userCell.className = userCommonStyle.join(' ');
    userCell.text = transaction['user'];
    tableRow.appendChild(userCell);

    final amountCell = document.createElement('td');
    const commonStyle = [
      "whitespace-nowrap",
      "py-4",
      "px-4",
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
    const editButtonStyle = [
      "bg-blue-500",
      "hover:bg-blue-700",
      "text-white",
      "font-bold",
      "py-2",
      "px-4",
      "mx-2",
      "rounded",
    ];
    editButton.className = editButtonStyle.join(' ');
    editButton.text = 'Edit';
    editButton.onClick.listen((event) {
      var dialog = querySelector('#edit-dialog') as DialogElement;
      dialog.showModal();

      var close = querySelector('#edit-cancel-button') as ButtonElement;
      close.onClick.listen((event) {
        dialog.close();
      });

      (querySelector('#edit-amount') as InputElement).value =
          transaction['amount'].toString();
      (querySelector('#edit-cashback') as InputElement).value =
          transaction['cashback'] == 'null'
              ? '0.0'
              : transaction['cashback'].toString();
      (querySelector('#edit-discount') as InputElement).value =
          transaction['discount'] == 'null'
              ? '0.0'
              : transaction['discount'].toString();

      handleEditSubmission(transaction, index);
      // form - edit-transaction
      // amount - edit-amount
      // cashback - edit-cashback
      // discount - edit-discount
      // final description = transaction['description'];
      // final amount = double.parse(
      //     (querySelector('#edit-amount') as InputElement).value.toString());
      // final date = transaction['date'];
      // final cashback = double.parse(
      //     (querySelector('#edit-cashback') as InputElement).value.toString());
      // final discount = double.parse(
      //     (querySelector('#edit-discount') as InputElement).value.toString());
      // final user = transaction['user'];
      // Transaction.editTransaction(
      //     index, description, amount, date, discount, cashback, user);
      // window.location.reload();
    });

    // Delete
    final deleteButton = document.createElement('button');
    const deleteButtonStyle = [
      "bg-blue-500",
      "hover:bg-blue-700",
      "text-white",
      "font-bold",
      "py-2",
      "px-4",
      "mx-2",
      "rounded",
    ];
    deleteButton.className = deleteButtonStyle.join(' ');
    deleteButton.text = 'Delete';
    deleteButton.onClick.listen((event) {
      Transaction.deleteTransaction(index);
      window.location.reload();
    });

    buttonCell.appendChild(editButton);
    buttonCell.appendChild(deleteButton);
    tableRow.appendChild(buttonCell);

    table!.appendChild(tableRow);
  }
}

void handleEditSubmission(dynamic transaction, int index) {
  final FormElement form = querySelector('#edit-transaction') as FormElement;
  final InputElement amountInput =
      querySelector('#edit-amount') as InputElement;
  final InputElement cashbackInput =
      querySelector('#edit-cashback') as InputElement;
  final InputElement discountInput =
      querySelector('#edit-discount') as InputElement;

  form.onSubmit.listen((event) {
    event.preventDefault();
    double amount = double.parse(amountInput.value.toString());
    double cashback = double.parse(cashbackInput.value.toString());
    double discount = double.parse(discountInput.value.toString());

    Transaction.editTransaction(
        index,
        transaction['description'],
        amount,
        DateTime.parse(transaction['date']),
        discount,
        cashback,
        transaction['user']);
    window.location.reload();
  });
}
