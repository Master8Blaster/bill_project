// USER
import '../utils/constants.dart';

String keyUsers = isTest ? "Developer/ Users" : "Users";

// Transaction Records
const String keyTransaction = "transactions";
const String keyTransactionKey = "tKey";
const String keyTransactionProductIds = "tProductsIds";
const String keyTransactionProductQuantity = "tProductQuantity";
const String keyTransactionProductPrice = "tProductPrice";
const String keyTransactionTotalPrice = "totalPrice";
const String keyTransactionTotalProductCount = "totalPCount";
const String keyTransactionTotalQuantity = "totalPQuantity";
const String keyTransactionPaymentType = "paymentType ";
const String keyTransactionDateTime = "tDateTime";

// Product
const String keyProduct = "Products";
const String keyProductName = "Name";
const String keyProductQuantity = "Quantity";
const String keyProductPrice = "Price";
const String keyProductImageName = "ImageName";
const String keyProductImageUrl = "ImageUrl";

// Folders Name
const String keyFolderUsers = "Users";
const String keyFolderProductImages = "ProductImages";

enum PaymentType {
  CASH,
  CARD,
  ONLINE,
  OTHER;
}

extension PaymentTypes on PaymentType {
  static final values = {
    PaymentType.OTHER: 0,
    PaymentType.CASH: 1,
    PaymentType.CARD: 2,
    PaymentType.ONLINE: 3,
  };

  int? get value => values[this];
}
