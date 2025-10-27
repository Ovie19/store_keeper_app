class Product {
  const Product({
    this.id,
    required this.name,
    required this.imagePath,
    required this.quantity,
    required this.price,
  });

  final int? id;
  final String name;
  final String imagePath;
  final int quantity;
  final double price;

  static Product fromMap(Map<String, dynamic> data) => Product(
    id: data['id'] as int,
    name: data['name'] as String,
    imagePath: data['imagePath'] as String,
    quantity: data['quantity'] as int,
    price: data['price'] as double,
  );

  Map<String, dynamic> toMap() => {
    'name': name,
    'imagePath': imagePath,
    'quantity': quantity,
    'price': price,
  };
}
