import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'add_number.dart';
import 'get_chats.dart';
import 'get_info.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GetChats(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String? avatar;
  String? name;
  String? email;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  Future<void> getInfo() async {
    final fb = FacebookLogin();
    debugPrint('===> login with23 face exceptio');
    try {
      final user = await fb.logIn();
      print(user.status.toString());
    } catch (e) {
      print("e");
      print(e);
    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  GoogleSignIn _googleSignIn = GoogleSignIn();
                  var data = await _googleSignIn.signIn();
                  print(data?.id);
                  print(data?.email);
                  print(data?.photoUrl);
                  print(data?.displayName);
                  avatar = data?.photoUrl;
                  name = data?.displayName;
                  email = data?.email;
                  setState(() {});
                  _googleSignIn.signOut();
                } catch (e) {
                  print(e);
                }
              },
              child: const Text("Google sign"),
            ),
            ElevatedButton(
                onPressed: () {
                  print("object");
                  getInfo();
                },
                child: Text("Facebook"))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
