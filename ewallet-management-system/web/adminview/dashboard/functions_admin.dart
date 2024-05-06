import 'dart:html';

void main() {
  // Get the buttons
  var applyDiscountButton = querySelector('#applyDiscount');
  var removeTransactionButton = querySelector('#removeTransaction');
  var refundTransactionButton = querySelector('#refundTransaction');

  // Get the pop-up windows
  var discountPopup = querySelector('#discountPopup');
  var removePopup = querySelector('#removePopup');
  var refundPopup = querySelector('#refundPopup');

  // Function to display the pop-up window
  void showPopup(Element popup) {
    popup.style.display = 'block';
  }

  // Function to close the pop-up window
  void closePopup(Event e) {  
    (e.target as Element).parent!.style.display = 'none';
  }

  // Add event listeners to the buttons
  applyDiscountButton?.onClick.listen((_) {
    showPopup(discountPopup!);
  });

  removeTransactionButton?.onClick.listen((_) {
    showPopup(removePopup!);
  });

  refundTransactionButton?.onClick.listen((_) {
    showPopup(refundPopup!);
  });

  // Add event listeners to the close buttons
  var closeButtons = querySelectorAll('.close');
  for (var closeButton in closeButtons) {
    closeButton.onClick.listen(closePopup);
  }
}
