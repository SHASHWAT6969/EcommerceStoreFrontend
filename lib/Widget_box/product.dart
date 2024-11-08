class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final int stockQuantity;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String imageUrl;
  final double MRP;


  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stockQuantity,
    required this.createdAt,
    required this.updatedAt,
    required this.imageUrl,
    required this.MRP,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: (json['product_id'] is String) ? int.parse(json['product_id']) : json['product_id'],
      name: json['name'],
      description: json['description'],
      price: (json['price'] is String) ? double.parse(json['price']) : (json['price'] as num).toDouble(),
      stockQuantity: (json['stock_quantity'] is String) ? int.parse(json['stock_quantity']) : json['stock_quantity'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      imageUrl: json['image_url'],
      MRP: (json['MRP'] is String) ? double.parse(json['MRP']) : (json['MRP'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': id,
      'name': name,
      'description': description,
      'price': price,
      'stock_quantity': stockQuantity,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'image_url': imageUrl,
      'MRP':MRP,
    };
  }

  @override
  String toString() {
    return 'Product{id: $id, name: $name, price: $price, stock: $stockQuantity,MRP:$MRP}';
  }
}
