class CartDbModel {
  static String tableName = 'cart';
  static String productKey = 'key';
  static String productName = 'Name';
  static String quantity = 'Quantity';
  static String pQuantity = 'PQuantity';
  static String price = 'Price';
  static String imageName = 'ImageName';
  static String imageUrl = 'ImageUrl';

  CartDbModel();

  static final String createTable = 'CREATE TABLE $tableName ('
      '$productKey TEXT PRIMARY KEY,'
      '$productName TEXT NOT NULL,'
      '$quantity INTEGER,'
      '$pQuantity INTEGER,'
      '$price REAL,'
      '$imageName TEXT,'
      '$imageUrl TEXT)';
}
