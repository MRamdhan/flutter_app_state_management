import 'package:flutter/material.dart';
import '../models/book.dart';

class CartItem {
  final Book book;
  int quantity;

  CartItem({
    required this.book,
    this.quantity = 1,
  });
}

class CartProvider extends ChangeNotifier{
  final Map<int, CartItem> _items = {};
  List<CartItem> get items => _items.values.toList();

  int get totalItems => _items.values.fold(
    0,
    (total, item) => total + item.quantity,
  );

  double get totalPrice => _items.values.fold(
    0,
    (total, item) => total + (item.book.price * item.quantity),
  );

  void addItem(Book book){
    if (_items.containsKey(book.id)){
      _items[book.id]!.quantity++;
    } else {
      _items[book.id] = CartItem(book: book);
    }
    notifyListeners();
  }

  void removeItem(int bookId){
    if(!_items.containsKey(bookId)) return;

    if(_items[bookId]!.quantity > 1){
      if (_items[bookId]!.quantity > 1) {
        _items[bookId]!.quantity--;
      } else {
        _items.remove(bookId);
      }
    }
    notifyListeners();
  }

  void deleteItem(int bookId) {
    if (_items.remove(bookId) != null) {
      notifyListeners();
    }
  }

  void clearCart(){
    _items.clear();
    notifyListeners();
  }

}

