import 'package:bill_project/firebase/keys.dart';

class TransactionModel {
  String key;
  String productIds;
  String productQuantity;
  String productPrice;

  double totalPrice;

  int totalProductCount;
  int totalQuantity;
  PaymentType paymentType = PaymentType.OTHER;

  DateTime dateTime;

  TransactionModel({
    required this.key,
    required this.totalPrice,
    required this.totalProductCount,
    required this.totalQuantity,
    required int paymentType,
    required this.dateTime,
    this.productIds = "",
    this.productQuantity = "",
    this.productPrice = "",
  }) {
    this.paymentType = paymentType == PaymentType.CASH.value
        ? PaymentType.CASH
        : paymentType == PaymentType.CARD.value
            ? PaymentType.CARD
            : paymentType == PaymentType.ONLINE.value
                ? PaymentType.ONLINE
                : PaymentType.OTHER;
  }

// TransactionModel.fromJson(Map<String, dynamic> json) {
//   productKey = json[CartDbModel.productKey];
//   name = json[CartDbModel.productName];
//   price = json[CartDbModel.price];
//   imageUrl = json[CartDbModel.imageUrl];
//   imageName = json[CartDbModel.imageName];
//   quantity = int.parse(json[CartDbModel.quantity].toString() ?? "0").obs;
//   pQuantity = json[CartDbModel.pQuantity];
// }

// Map<String, dynamic> toJson() {
//   final Map<String, dynamic> data = <String, dynamic>{};
//   data[CartDbModel.productKey] = productKey;
//   data[CartDbModel.productName] = name;
//   data[CartDbModel.price] = price;
//   data[CartDbModel.imageUrl] = imageUrl;
//   data[CartDbModel.imageName] = imageName;
//   data[CartDbModel.quantity] = quantity.value;
//   data[CartDbModel.pQuantity] = pQuantity;
//   return data;
// }
}
