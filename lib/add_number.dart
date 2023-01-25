import 'dart:io';

import 'package:auth_login/verfy_code.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddNumber extends StatefulWidget {
  const AddNumber({Key? key}) : super(key: key);

  @override
  State<AddNumber> createState() => _AddNumberState();
}

class _AddNumberState extends State<AddNumber> {
  final TextEditingController controller = TextEditingController();
  String imageUrl = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: TextFormField(
            controller: controller,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final ImagePicker _picker = ImagePicker();
          // Pick an image
          final XFile? image =
              await _picker.pickImage(source: ImageSource.gallery);
          try {
            final storageRef = FirebaseStorage.instance.ref().child("file/");
            var res =  await storageRef.putFile(File(image?.path ?? ""));
            imageUrl = await res.ref.getDownloadURL();
          } on FirebaseException catch (e) {
            print(e);
          }
          var data = await FirebaseFirestore.instance.collection('users').add({

            'sender': {"id": 6, "name": "Mupza","image" : imageUrl}, // John Doe
            'resender': {"id": 3, "name": "Test3","image" : imageUrl}, // Stokes and Sons
            'ids': [6, 3] // 42
          });

          FirebaseFirestore.instance
              .collection('users')
              .doc(data.id)
              .collection("chats")
              .add({
            "messages": [
              {"id": 6, "text": "New Message"},
              {"id": 3, "text": "Last Message"},
            ]
          });

          // await FirebaseAuth.instance.verifyPhoneNumber(
          //   phoneNumber: controller.text,
          //   verificationCompleted: (PhoneAuthCredential credential) {
          //     print(credential.toString());
          //   },
          //   verificationFailed: (FirebaseAuthException e) {
          //     print(e.toString());
          //   },
          //   codeSent: (String verificationId, int? resendToken) {
          //     Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //             builder: (_) => VerfPage(
          //                   id: verificationId,
          //                 )));
          //   },
          //   codeAutoRetrievalTimeout: (String verificationId) {},
          // );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
