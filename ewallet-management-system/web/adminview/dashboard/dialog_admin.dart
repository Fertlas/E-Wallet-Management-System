import 'dart:html';
import 'package:web/helpers.dart';

class Dialog {
  static final DialogElement dialog =
    querySelector('#applyDiscount-dialog') as DialogElement;

  static void handleDialog() {
    final ButtonElement cancelButton =
      querySelector('#cancel-button') as ButtonElement;
    
    cancelButton.onClick.listen((event){
      dialog.close();
    }); 
    final ButtonElement discPopup =
      querySelector('#applyDiscountbtn') as ButtonElement;

    final ButtonElement removePopup =
      querySelector('#removeTransactionbtn') as ButtonElement;
      
    final ButtonElement refungPopup =
      querySelector('#refundTransactionbtn') as ButtonElement;

    discPopup.onClick.listen((event){
      dialog.showModal();
    });
    removePopup.onClick.listen((event){
      dialog.showModal();
    });
    refungPopup.onClick.listen((event){
      dialog.showModal();
    });
  }
}



