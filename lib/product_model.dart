import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String name;
  final String desc;
  final num price;

  ProductModel({required this.name, required this.desc, required this.price});

  factory ProductModel.fromJson(QueryDocumentSnapshot data) {
    return ProductModel(
        name: data["name"], desc: data["desc"], price: data["price"]);
  }
}
