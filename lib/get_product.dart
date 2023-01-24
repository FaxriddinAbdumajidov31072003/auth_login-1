import 'package:auth_login/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'add_product.dart';

class GetProductPage extends StatefulWidget {
  const GetProductPage({Key? key}) : super(key: key);

  @override
  State<GetProductPage> createState() => _GetProductPageState();
}

class _GetProductPageState extends State<GetProductPage> {
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  List<ProductModel> list = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
      ),
      body: FutureBuilder(
        future: fireStore.collection("product").get(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            list.clear();
            snapshot.data?.docs.forEach((element) {
              list.add(ProductModel.fromJson(element));
            });
            return ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                    ),
                    child: Column(
                      children: [
                        Text(list[index].name),
                        Text(list[index].desc),
                        Text(list[index].price.toString()),
                      ],
                    ),
                  );
                });
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => const AddProductPage()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
