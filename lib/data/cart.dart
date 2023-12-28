
import 'package:hive/hive.dart';

class ListCart {

  final _cartgBox = Hive.box('cart');
  List<Map<String, dynamic>> list = [];

  ListCart() {
    for (var i = 0; i < _cartgBox.length; i++) {
      list.add(_cartgBox.getAt(i));
    }
  }

  //function to add the  add to cart    
  void addCart(Map<String, dynamic> item) {
    _cartgBox.add(item);
    list.add(item);
  }

  //function to delete the  add to cart
  void deleteCart(int index) {
    _cartgBox.deleteAt(index);
    list.removeAt(index);
  }

  //function to update the  add to cart
  void updateCart(int index, Map<String, dynamic> item) {
    _cartgBox.putAt(index, item);
    list[index] = item;
  }
}