import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String name;
  final String desc;
  final String? image;
  final num price;

  ProductModel({
    required this.name,
    required this.desc,
    required this.price,
    required this.image,
  });

  factory ProductModel.fromJson(dynamic data) {
    return ProductModel(
        name: data["name"],
        desc: data["desc"],
        price: data["price"],
        image: data["image"]);
  }

  toJson() {
    return {"name": name, "desc": desc, "price": price, "image": image};
  }
}
