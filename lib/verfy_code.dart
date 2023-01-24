import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sms_autofill/sms_autofill.dart';

class VerfPage extends StatefulWidget {
  final String id;

  const VerfPage({Key? key, required this.id}) : super(key: key);

  @override
  State<VerfPage> createState() => _VerfPageState();
}

class _VerfPageState extends State<VerfPage> {
  TextEditingController controller = TextEditingController();
  String? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tekshirish"),
      ),
      body: Column(
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: PinFieldAutoFill(
                controller: controller,
                cursor: Cursor(color: Colors.black, enabled: true, width: 2),
                decoration: BoxLooseDecoration(
                  gapSpace: 10,
                  bgColorBuilder: FixedColorBuilder(
                    Colors.white,
                  ),
                  strokeColorBuilder: FixedColorBuilder(
                    Colors.black,
                  ),
                ),
                onCodeSubmitted: (s) {},
                onCodeChanged: (s) {},
                currentCode: "",
              ),
            ),
          ),
          ElevatedButton(
              onPressed: () async {
                try {
                  FirebaseAuth auth = FirebaseAuth.instance;

                  PhoneAuthCredential credential = PhoneAuthProvider.credential(
                      verificationId: widget.id, smsCode: controller.text);
                  var data = await auth.signInWithCredential(credential);
                  print(data.additionalUserInfo?.isNewUser);
                } catch (e) {
                  print(e);
                  error = e.toString();
                  setState(() {});
                }
                // Create a PhoneAuthCredential with the code
              },
              child: Text("Check")),
          Text(error ?? "")
        ],
      ),
    );
  }
}
