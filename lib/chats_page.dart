import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({Key? key}) : super(key: key);

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  final DatabaseReference ref = FirebaseDatabase.instance.ref("chat");
  TextEditingController textEditingController = TextEditingController();
  UserModel? sender;
  UserModel? reSender;
  List<MessageModel> messages = [];

  getInfo() {
    ref.onValue.listen((event) {
      reSender = UserModel.fromJson((event.snapshot.value as Map)["sender"]);
      sender = UserModel.fromJson((event.snapshot.value as Map)["resender"]);
      messages.clear();
      (event.snapshot.value as Map)["mess"].forEach((e) {
        messages.add(MessageModel.fromJson(e));
      });
      setState(() {});
    });
  }

  addInfo() async {
    await ref.set({
      "name": "John12345",
      "phone": 182345,
    });
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
        title: Text("Chats"),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("sender name : ${sender?.name ?? ""}"),
              Text("reSender name : ${reSender?.name ?? ""}"),
            ],
          ),
          ListView.builder(
              shrinkWrap: true,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    messages[index].title,
                    textAlign: messages[index].ownerId == sender?.id
                        ? TextAlign.right
                        : TextAlign.left,
                  ),
                );
              })
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: TextFormField(
        controller: textEditingController,
        decoration: InputDecoration(
          suffixIcon: IconButton(
            onPressed: () async {
              messages.add(
                  MessageModel(textEditingController.text, sender?.id ?? 0));
              await ref.set({
                "sender": reSender!.toJson(),
                "resender": sender!.toJson(),
                "mess": List<dynamic>.from(messages.map((x) => x.toJson()))
              });
            },
            icon: Icon(Icons.send),
          ),
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(),
        ),
      ),
    );
  }
}

class UserModel {
  final String name;
  final int id;

  UserModel(this.name, this.id);

  factory UserModel.fromJson(Map data) {
    return UserModel(data["name"], data["id"]);
  }

  Map toJson() {
    return {"name": name, "id": id};
  }
}

class MessageModel {
  final String title;
  final int ownerId;

  MessageModel(this.title, this.ownerId);

  factory MessageModel.fromJson(Map data) {
    return MessageModel(data["title"], data["id"]);
  }

  Map toJson() {
    return {"title": title, "id": ownerId};
  }
}
