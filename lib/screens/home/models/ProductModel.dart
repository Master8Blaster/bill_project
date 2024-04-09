class ProductModel {
  String productKey;
  String imageUrl;
  String imageName;
  String name;
  double price;
  int quantity;

  ProductModel({
    required this.productKey,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.imageName,
    this.quantity = 0,
  });

}
