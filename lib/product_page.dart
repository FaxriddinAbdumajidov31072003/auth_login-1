import 'package:auth_login/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductPage extends StatefulWidget {
  final ProductModel? product;
  final String? docId;

  const ProductPage({Key? key, this.product, this.docId}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  ProductModel? newProduct;
  bool isLoading = false;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  void initState() {
    if (widget.product != null) {
      newProduct = widget.product;
    } else {
      getSingleProduct();
    }
    super.initState();
  }

  getSingleProduct() async {
    isLoading = true;
    setState(() {});
    var res =
        await firebaseFirestore.collection("product").doc(widget.docId).get();
    newProduct = ProductModel.fromJson(res.data());
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Product"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Image.network(newProduct?.image ?? ""),
                Text("Name: ${newProduct?.name}"),
                Text("Description: ${newProduct?.desc}"),
                Text("Price: ${newProduct?.price}"),
              ],
            ),
    );
  }
}
