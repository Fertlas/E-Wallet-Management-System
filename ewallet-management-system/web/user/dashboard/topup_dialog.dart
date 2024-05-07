import 'dart:html';
import '../../transaction.dart';
import 'package:web/helpers.dart';

class TopupDialog {
  static final DialogElement dialog =
      querySelector('#topup-dialog') as DialogElement;

  static void handleDialog() {
    final ButtonElement newTransc =
        querySelector('#topup-balance') as ButtonElement;

    final ButtonElement cancelButton =
        querySelector('#cancel-button-topup') as ButtonElement;

    newTransc.onClick.listen((event) {
      dialog.showModal();
    });

    cancelButton.onClick.listen((event) {
      dialog.close();
    });
  }

  static void handleFormSubmission(String? user) {
    final FormElement form = querySelector('#add-topup') as FormElement;
    final SelectElement typeInput =
        querySelector('#topup-method') as SelectElement;
    final InputElement amountInput =
        querySelector('#topup-amount') as InputElement;

    form.onSubmit.listen((event) {
      event.preventDefault();
      String type = typeInput.value.toString();
      double amount = double.parse(amountInput.value.toString());
      Transaction.topup(type, amount, user as String);

      dialog.close();
      var calculatedTransactions = <dynamic>[];
      calculatedTransactions = Transaction.getUserTransactions(user);
      updateDesign(calculatedTransactions);
      updateBalanceDisplay(calculatedTransactions);
      print("Topup should be successful");
    });
  }

  static void updateDesign(List<dynamic> transacts) {
    if (transacts.isEmpty) {
      return;
    }

    var table = querySelector('#transaction-table-body');
    var transaction = transacts.last; // Get the last transaction

    final tableRow = document.createElement('tr');

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

    table!.appendChild(tableRow);
  }

  static void updateBalanceDisplay(List<dynamic> transacts) {
    var currentBalance = transacts.last['balance'];
    var balanceDisplay = querySelector('#balance-placeholder');
    // ignore: prefer_interpolation_to_compose_strings
    balanceDisplay!.text = 'MYR ' + currentBalance.toStringAsFixed(2);
  }
}
