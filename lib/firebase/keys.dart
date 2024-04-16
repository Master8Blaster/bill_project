import '../utils/constants.dart';

String mainKeyPath = isTest ? "$keyDeveloper/$keyUsers" : keyUsers;

// User Name
const String keyDeveloper = "Developer";
const String keyUsers = "Users";
const String keyProductImages = "ProductImages";

//Business Keys
getBusinessDetailsPath(String userId) =>
    "$mainKeyPath/$userId/$keyBusinessDetails";

getBusinessDetailsImagePath(String userId) =>
    "$mainKeyPath/$userId/$keyBusinessImages";

const String keyBusinessDetails = "BusinessDetails";
const String keyBusinessImages = "BusinessImages";
const String keyBusinessName = "BName";
const String keyBusinessUpi = "BUpi";
const String keyBusinessGstNumber = "BGSTNumber";
const String keyBusinessContactNumber = "BCNumber";
const String keyBusinessTagLine = "BTagLine";
const String keyBusinessAddress = "BAddress";
const String keyBusinessImageUrl = "BImageUrl";
const String keyBusinessImageName = "BImageName";

// Transaction Records
getTransactionPath(String userId) => "$mainKeyPath/$userId/$keyTransaction";

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
getProductsPath(String userId) => "$mainKeyPath/$userId/$keyProduct";

getProductsImagePath(String userId) => "$mainKeyPath/$userId/$keyProductImages";

const String keyProduct = "Products";
const String keyProductName = "Name";
const String keyProductQuantity = "Quantity";
const String keyProductPrice = "Price";
const String keyProductImageName = "ImageName";
const String keyProductImageUrl = "ImageUrl";

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
