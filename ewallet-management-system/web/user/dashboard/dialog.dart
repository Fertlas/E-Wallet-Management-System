import 'dart:html';

void main() {
  handleDialog();
  handleFormSubmission();
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
