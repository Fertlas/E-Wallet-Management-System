import 'dart:convert';
import 'dart:js_interop';
import 'package:web/helpers.dart';

class Transaction {
  static var transactions = <Transaction>[];
  final String description;
  final double amount;
  final DateTime date;
  final String? type;
  final double? discount;
  final double? cashback;
  final String user;
  final double? balance;

  Transaction({
    required this.description,
    required this.amount,
    required this.date,
    this.type,
    this.discount,
    this.cashback,
    required this.user,
    this.balance = 0.0,
  });

//to create fake transaction
  static void fakeTransaction(String? user) {
    topup('Credit', 500, 'JohnDoe');
    pay('Groceries', 50, 'JohnDoe');
    pay('Toll', 30, 'JohnDoe');
    pay('Gas', 30, 'JohnDoe');
    topup('Cash', 80, 'JohnDoe');
    pay('Groceries', 10, 'JohnDoe');
    pay('Toll', 10, 'JohnDoe');
    pay('Gas', 10, 'JohnDoe');
    getUserTransactions(user);
  }

  //topup method
  static void topup(String type, double amount, String user) {
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

    save();
  }

//pay method
  static void pay(String type, double amount, String user) {
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

    save();
  }

//to get only specific user transactions
  static dynamic getUserTransactions(String? user) {
    var transact = window.localStorage['transactions'];
    if (transact == null) {
      fakeTransaction(user);
    } else {
      load();
    }

    console.log(transactions as JSAny?);
    var userTransactions = transactions.where((t) => t.user == user).toList();
    // Calculate balance for each transaction
    var balance = 0.0;
    var calculatedTransactions = <dynamic>[];
    for (var transaction in userTransactions) {
      balance += transaction.amount +
          (transaction.cashback ?? 0) +
          (transaction.discount ?? 0);
      calculatedTransactions.add({
        'description': transaction.description,
        'amount': transaction.amount,
        'date': transaction.date.toString(),
        'type': transaction.type,
        'discount': transaction.discount,
        'cashback': transaction.cashback,
        'user': transaction.user,
        'balance': balance,
      });
    }

    print("lmao");
    console.log(calculatedTransactions as JSAny?);

    window.localStorage['calculatedTransactions'] =
        jsonEncode(calculatedTransactions);
    return calculatedTransactions;
  }

//save method
  static void save() {
    var saveTransaction = transactions.toList();
    var saveData = <dynamic>[];
    for (var transaction in saveTransaction) {
      saveData.add(
          '${transaction.description},${transaction.amount},${transaction.date},${transaction.type},${transaction.discount},${transaction.cashback},${transaction.user}|');
    }
    window.localStorage['transactions'] = saveData.toString();
    var test = window.localStorage['transactions'];
    print('testsave : $test');
  }

//load method
  static dynamic load() {
    var data = window.localStorage['transactions'];
    print('load : $data');

    if (data != null) {
      if (data.startsWith('[')) {
        data = data.substring(1);
      }
      transactions = data
          .split('|,')
          .map((line) => line.split(','))
          .map((parts) => Transaction(
                description: parts[0].trim(),
                amount: double.parse(parts[1]),
                date: DateTime.parse(parts[2]),
                type: parts[3].trim() == 'null' ? null : parts[3],
                discount:
                    parts[4].trim() == 'null' ? null : double.parse(parts[4]),
                cashback:
                    parts[5].trim() == 'null' ? null : double.parse(parts[5]),
                user: parts[6].split('|').first.trim(),
              ))
          .toList();
    }
    print('load succesfull');
    return data;
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

  dynamic getAllTransactions() {
    return transactions;
  }
}
