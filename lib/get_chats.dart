import 'package:auth_login/get_messages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GetChats extends StatelessWidget {
  const GetChats({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chats"),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection("users")
            .where("ids", arrayContainsAny: [3]).get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error.toString());
            return Text("Something went wrong");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            List<QueryDocumentSnapshot<Object?>> data = snapshot.data!.docs;

            return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) =>
                          GetMessages(documentId: data[index].id,)));
                    },
                    child: Container(
                      decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                      margin: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text(data[index]["sender"]["name"]),
                          Text(data[index]["resender"]["name"]),
                        ],
                      ),
                    ),
                  );
                });
          }

          return Text("loading");
        },
      ),
    );
  }
}
