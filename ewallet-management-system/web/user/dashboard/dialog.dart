import 'dart:html';

void main() {
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
