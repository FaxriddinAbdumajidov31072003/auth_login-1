import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';

class DynamicLinkPage extends StatefulWidget {
  const DynamicLinkPage({Key? key}) : super(key: key);

  @override
  State<DynamicLinkPage> createState() => _DynamicLinkPageState();
}

class _DynamicLinkPageState extends State<DynamicLinkPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dynamic Link"),
      ),
      body: Center(
        child: Text("Genetare link"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final dynamicLinkParams = DynamicLinkParameters(
            link: Uri.parse("https://www.google.com/"),
            uriPrefix: "https://lessonnt.page.link",
            androidParameters:  AndroidParameters(packageName: "com.example.auth_login",fallbackUrl:  Uri.parse("https://www.figma.com/")),
            iosParameters:  IOSParameters(bundleId: "com.example.authLogin",fallbackUrl:  Uri.parse("https://www.figma.com/")),
            socialMetaTagParameters: SocialMetaTagParameters(
              title: "Title",
              description: "Desc",
              imageUrl: Uri.parse("https://media.istockphoto.com/id/1368264124/photo/extreme-close-up-of-thrashing-emerald-ocean-waves.jpg?b=1&s=170667a&w=0&k=20&c=qha_PaU54cu9QCu1UTlORP4-sW0MqLGERkdFKmC06lI="),
            )
          );
          final dynamicLink =
              await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);
          print(dynamicLink.shortUrl);
        },
        child: Text("+"),
      ),
    );
  }
}
