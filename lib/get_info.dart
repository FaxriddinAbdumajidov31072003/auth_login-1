import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GetUserName extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

    return SafeArea(
      child: Scaffold(
        body: FutureBuilder<dynamic>(
          future: _fireStore.collection('users').get(),
          builder:
              (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error.toString());
              return Text("Something went wrong");
            }

            if (snapshot.connectionState == ConnectionState.done) {
              List data = snapshot.data!.docs;
              print(data.first);
              data.forEach((element) {
                print(element["name"]);
              });
              return Text(
                  "Full Name: full_name last_name");
            }

            return Text("loading");
          },
        ),
      ),
    );
  }
}
