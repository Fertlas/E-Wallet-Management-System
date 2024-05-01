import 'dart:html';

import 'package:web/helpers.dart';

class Transaction {
  final String description;
  final double amount;
  final DateTime date;
  final String? type;
  final double? discount;
  final double? cashback;
  final String user;

  Transaction({
    required this.description,
    required this.amount,
    required this.date,
    this.type,
    this.discount,
    this.cashback,
    required this.user,
  });

  // @override
  // String toString() {
  //   return '$description, $amount, $date, $discount, $cashback, $user';
  // }
}

void main() {
  var transactions = <Transaction>[];

  final output = querySelector('#output') as DivElement;
  final button = querySelector('#button') as ButtonElement;

  // Save and load

  void save() {
    window.localStorage['transactions'] = transactions.toString();
  }

  void load() {
    final data = window.localStorage['transactions'];
    if (data != null) {
      transactions = data
          .split('\n')
          .map((line) => line.split(','))
          .map((parts) => Transaction(
                description: parts[0],
                amount: double.parse(parts[1]),
                date: DateTime.parse(parts[2]),
                discount: parts[3].isEmpty ? null : double.parse(parts[3]),
                cashback: parts[4].isEmpty ? null : double.parse(parts[4]),
                user: parts[5],
              ))
          .toList();
    }
  }

  // Transaction functions

  void topup(String type, double amount, String user) {
    // If type is 'Credit', add 0.5 cashback
    var cashback = type == 'Credit' ? 0.5 : 0.0;

    transactions.add(Transaction(
      description: 'Top up',
      amount: amount,
      date: DateTime.now(),
      type: type,
      cashback: cashback,
      user: user,
    ));
  }

  void pay(String type, double amount, String user) {
    // If type is 'Groceries', add 10% discount
    // If type is 'Toll' and date is between 5pm and 8am, add 5% discount
    var discount = type == 'Groceries' ? amount * 0.1 : 0.0;
    if (type == 'Toll' &&
        DateTime.now().hour >= 17 &&
        DateTime.now().hour < 8) {
      discount = amount * 0.05;
    }

    transactions.add(Transaction(
      description: 'Pay',
      amount: -amount,
      date: DateTime.now(),
      type: type,
      discount: discount,
      user: user,
    ));
  }

  // Admin functions

  void editTransaction(int index, String description, double amount,
      DateTime date, double? discount, double? cashback, String user) {
    transactions[index] = Transaction(
      description: description,
      amount: amount,
      date: date,
      discount: discount,
      cashback: cashback,
      user: user,
    );
  }

  void deleteTransaction(int index) {
    transactions.removeAt(index);
  }

  dynamic getUserTransactions(String user) {
    var userTransactions = transactions.where((t) => t.user == user).toList();
    // Calculate balance for each transaction
    var balance = 0.0;
    var calculatedTransactions = <dynamic>[];
    for (var transaction in userTransactions) {
      balance += transaction.amount +
          (transaction.cashback ?? 0) -
          (transaction.discount ?? 0);
      calculatedTransactions.add({
        'description': transaction.description,
        'amount': transaction.amount,
        'date': transaction.date,
        'type': transaction.type,
        'discount': transaction.discount,
        'cashback': transaction.cashback,
        'user': transaction.user,
        'balance': balance,
      });
    }
    return calculatedTransactions;
  }

  button.onClick.listen((event) {
    topup('Credit', 500, 'John Doe');
    pay('Groceries', 50, 'John Doe');
    pay('Toll', 30, 'John Doe');
    pay('Gas', 30, 'John Doe');
    topup('Cash', 80, 'John Doe');
    pay('Groceries', 10, 'John Doe');
    pay('Toll', 10, 'John Doe');
    pay('Gas', 10, 'John Doe');
    getUserTransactions('John Doe');
  });
}
