class ItemSize {
  ItemSize.fromMap(Map<String, dynamic> document) {
    name = document['name'] as String;
    price = document['price'] as num;
    stock = document['stock'] as int;
  }

  String? name;
  num? price;
  int? stock;

  bool get hasStock => stock! > 0;

  @override
  String toString() {
    return 'ItemSize{name: $name, price: $price, stock: $stock}';
  }
}
