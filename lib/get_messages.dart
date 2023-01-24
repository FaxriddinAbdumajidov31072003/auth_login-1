import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GetMessages extends StatefulWidget {
  final String documentId;

  const GetMessages({Key? key, required this.documentId}) : super(key: key);

  @override
  State<GetMessages> createState() => _GetMessagesState();
}

class _GetMessagesState extends State<GetMessages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Messages"),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection("users")
            .doc(widget.documentId)
            .collection("chats")
            .get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error.toString());
            return Text("Something went wrong");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            List data = snapshot.data?.docs.first["messages"] ?? [];
            print(data.toString());
            return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black)),
                      margin: EdgeInsets.all(16),
                      child: Text(
                        data[index]["text"],
                        textAlign: data[index]["id"] != 3
                            ? TextAlign.start
                            : TextAlign.end,
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
