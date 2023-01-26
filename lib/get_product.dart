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
  List listOfDoc = [];
  QuerySnapshot? data;
  bool isLoading = true;

  Future<void> getInfo({String? text}) async {
    isLoading = true;
    setState(() {});
    if (text == null) {
      data = await fireStore.collection("product").get();
    } else {
      data = await fireStore.collection("product").orderBy("name").startAt(
          [text.toLowerCase()]).endAt(["${text.toLowerCase()}\uf8ff"]).get();
    }
    list.clear();
    listOfDoc.clear();
    for (QueryDocumentSnapshot element in data?.docs ?? []) {
      list.add(ProductModel.fromJson(element));
      listOfDoc.add(element.id);
    }
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    getInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(labelText: "Search"),
              onChanged: (s) {
                getInfo(text: s);
              },
            ),
          ),
          isLoading
              ? CircularProgressIndicator()
              : Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                          ),
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  SizedBox(
                                      child: Image.network(list[index].image ?? ""),
                                  height: 50,
                                    width: 50,
                                  ),
                                  Text(
                                      "${list[index].name.substring(0, 1).toUpperCase()}${list[index].name.substring(1)}"),
                                  Text(list[index].desc),
                                  Text(list[index].price.toString()),
                                ],
                              ),
                              IconButton(
                                  onPressed: () {
                                    print(list.length);
                                    print(listOfDoc.length);
                                    fireStore
                                        .collection("product")
                                        .doc(listOfDoc[index])
                                        .delete()
                                        .then(
                                          (doc) => print("Document deleted"),
                                          onError: (e) => print(
                                              "Error updating document $e"),
                                        );
                                    list.removeAt(index);
                                    listOfDoc.removeAt(index);
                                    print(list.length);
                                    print(listOfDoc.length);
                                    //cloud firebase: 6
                                    //data: 6
                                    //list: 6

                                    // firebase delete
                                    // data remove
                                    // list remove

                                    //c: 5
                                    //d: 5
                                    //l: 5

                                    // firebase delete
                                    // data remove
                                    // list remove


                                    setState(() {});
                                  },
                                  icon: const Icon(Icons.delete))
                            ],
                          ),
                        );
                      }),
                )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const AddProductPage()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
