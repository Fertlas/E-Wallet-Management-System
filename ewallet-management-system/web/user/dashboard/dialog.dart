import 'dart:html';
import './../../main.dart';
import 'dart:convert' as convert;

void main() {
  final user = window.localStorage['loggedInUser'];
  handleDialog();
  handleFormSubmission();
  getTransaction(user);
}

void handleDialog() {
  final ButtonElement newTransc =
      querySelector('#new-transaction') as ButtonElement;
  final DialogElement dialog =
      querySelector('#transaction-dialog') as DialogElement;
  final ButtonElement cancelButton =
      querySelector('#cancel-button') as ButtonElement;

  newTransc.onClick.listen((event) {
    dialog.showModal();
  });

  cancelButton.onClick.listen((event) {
    dialog.close();
  });
}

void handleFormSubmission() {
  final FormElement form = querySelector('#add-transaction') as FormElement;
  final InputElement typeInput = querySelector('#type') as InputElement;
  final InputElement amountInput = querySelector('#amount') as InputElement;

  form.onSubmit.listen((event) {
    event.preventDefault();
    String? type = typeInput.value;
    String? amount = amountInput.value;
    print('Type: $type, Price: $amount');
  });
}

void getTransaction(String? user) {}

void loadTransactions() {
  final data = window.localStorage['transactions'];
  final calculatedTransactions;
  if (data != null) {
    final decoded = convert.jsonDecode(data) as List<dynamic>;
    calculatedTransactions = decoded
        .cast<Map<String, dynamic>>(); // Cast to List<Map<String, dynamic>>
  } else {
    calculatedTransactions =
        []; // Initialize with an empty list if no data exists
  }
}
