import 'dart:convert';

import 'package:auth_login/dynamic_link.dart';
import 'package:auth_login/product_model.dart';
import 'package:auth_login/product_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:http/http.dart' as http;
import 'add_product.dart';

class GetProductPage extends StatefulWidget {
  const GetProductPage({Key? key}) : super(key: key);

  @override
  State<GetProductPage> createState() => _GetProductPageState();
}

class _GetProductPageState extends State<GetProductPage> {
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
  List<ProductModel> list = [];
  List listOfDoc = [];
  QuerySnapshot? data;
  bool isLoading = true;

  Future<void> initDynamicLinks() async {
    dynamicLinks.onLink.listen((dynamicLinkData) {
      print(dynamicLinkData);
      print(dynamicLinkData.link);
      print(dynamicLinkData.link
          .toString()
          .substring(dynamicLinkData.link.toString().lastIndexOf("/")+1));
      String docId = dynamicLinkData.link
          .toString()
          .substring(dynamicLinkData.link.toString().lastIndexOf("/")+1);
      Navigator.push(context, MaterialPageRoute(builder: (_)=>ProductPage(docId: docId,)));
    }).onError((error) {
      debugPrint(error.message);
    });

    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data?.link;

    if (deepLink != null) {
      print(deepLink
          .toString()
          .substring(deepLink.toString().lastIndexOf("/")+1));
      String docId = deepLink
          .toString()
          .substring(deepLink.toString().lastIndexOf("/")+1);
      // ignore: use_build_context_synchronously
      Navigator.push(context, MaterialPageRoute(builder: (_)=>ProductPage(docId: docId,)));
    }
  }

  Future<void> getInfo({String? text}) async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    // FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async {
    //   print("onBackgroundMessage");
    // });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("onMessageOpenedApp");
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("onMessage");
    });

    final fcmToken = await FirebaseMessaging.instance.getToken();
    print("fcm: $fcmToken");
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
    initDynamicLinks();
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
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        ProductPage(product: list[index])));
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                            ),
                            child: Row(
                              children: [
                                Column(
                                  children: [
                                    SizedBox(
                                      child: Image.network(
                                          list[index].image ?? ""),
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
                                    icon: const Icon(Icons.delete)),
                                IconButton(
                                    onPressed: () async {
                                      var productLink =
                                          'https://foodyman.org/${listOfDoc[index]}';

                                      const dynamicLink =
                                          'https://firebasedynamiclinks.googleapis.com/v1/shortLinks?key=AIzaSyD3iHcYYpc-dzP5WHizXdbsOqIiiLMBKbI';

                                      final dataShare = {
                                        "dynamicLinkInfo": {
                                          "domainUriPrefix":
                                              'https://lessonnt.page.link',
                                          "link": productLink,
                                          "androidInfo": {
                                            "androidPackageName":
                                                'com.example.auth_login',
                                          },
                                          "iosInfo": {
                                            "iosBundleId":
                                                "org.foodyman.customer",
                                          },
                                          "socialMetaTagInfo": {
                                            "socialTitle": list[index].name,
                                            "socialDescription":
                                                "Description: ${list[index].desc}",
                                            "socialImageLink":
                                                "${list[index].image}",
                                          }
                                        }
                                      };

                                      final res = await http.post(
                                          Uri.parse(dynamicLink),
                                          body: jsonEncode(dataShare));

                                      var shareLink =
                                          jsonDecode(res.body)['shortLink'];
                                      await FlutterShare.share(
                                        text: list[index].name,
                                        title:
                                            "Description: ${list[index].desc}",
                                        linkUrl: shareLink,
                                      );

                                      print(shareLink);
                                    },
                                    icon: const Icon(Icons.share))
                              ],
                            ),
                          ),
                        );
                      }),
                )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const DynamicLinkPage()));
            },
            child: const Icon(Icons.link),
          ),
          FloatingActionButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const AddProductPage()));
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
