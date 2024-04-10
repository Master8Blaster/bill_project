import 'package:bill_project/Database/tables/CartDbModel.dart';
import 'package:get/get.dart';

class ProductModel {
  String productKey = "";
  String imageUrl = "";
  String imageName = "";
  String name = "";
  double price = 0;
  int pQuantity = 0;
  RxInt quantity = 0.obs;

  ProductModel({
    required this.productKey,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.imageName,
    int quantity = 0,
    this.pQuantity = 0,
  }) {
    this.quantity = quantity.obs;
  }

  ProductModel.fromJson(Map<String, dynamic> json) {
    productKey = json[CartDbModel.productKey];
    name = json[CartDbModel.productName];
    price = json[CartDbModel.price];
    imageUrl = json[CartDbModel.imageUrl];
    imageName = json[CartDbModel.imageName];
    quantity = int.parse(json[CartDbModel.quantity].toString() ?? "0").obs;
    pQuantity = json[CartDbModel.pQuantity];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[CartDbModel.productKey] = productKey;
    data[CartDbModel.productName] = name;
    data[CartDbModel.price] = price;
    data[CartDbModel.imageUrl] = imageUrl;
    data[CartDbModel.imageName] = imageName;
    data[CartDbModel.quantity] = quantity.value;
    data[CartDbModel.pQuantity] = pQuantity;
    return data;
  }
}
