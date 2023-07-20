class Cart {
  String cartID;
  String userID;
  String sessionID;
}

class CartItem {
  String cartItemID;
  String cartID;
  String eventID;
  int quantity;
  double cost;
  String status;
}
