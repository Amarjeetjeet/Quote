import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  // WidgetsToImageController to access widget
  WidgetsToImageController controllerImage = WidgetsToImageController();
  // to save image bytes of widget
  Uint8List? bytes;
  Uint8List? image;

  final controller = ScreenshotController();
  @override
  Widget build(BuildContext context) =>
      Screenshot(
        controller: controller,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Widgets To Image'),
        centerTitle: true,
    ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
            const Text(
            "Widgets",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
            WidgetsToImage(
              controller: controllerImage,
              child: cardWidget(),
          ),
            const Text(
            "Images",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          if (bytes != null) buildImage(bytes!),
        ],
    ),
        floatingActionButton:
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
                      child: const Icon(Icons.image_outlined),
                      onPressed: () async {
                      final image = await controller.capture();
                      debugPrint(image.toString());
                      final bytes = await controllerImage.capture();
                      if(image == null) return;
                        await saveImage(image);
                      setState(() {
                        this.bytes = bytes;
                        this.image = image;
                      });
                    },
                ),
            FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () async {
                final image =await controller.captureFromWidget(cardWidget());

                await saveImage(image);

              },
            ),
          ],
        )
        ),
      );

  Widget cardWidget() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(
              left: Radius.circular(16),
            ),
            child: Image.network(
              'https://mhtwyat.com/wp-content/uploads/2022/02/%D8%A7%D8%AC%D9%85%D9%84-%D8%A7%D9%84%D8%B5%D9%88%D8%B1-%D8%B9%D9%86-%D8%A7%D9%84%D8%B1%D8%B3%D9%88%D9%84-%D8%B5%D9%84%D9%89-%D8%A7%D9%84%D9%84%D9%87-%D8%B9%D9%84%D9%8A%D9%87-%D9%88%D8%B3%D9%84%D9%85-1-1.jpg',
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Titlfde",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  "Description",
                  style: TextStyle(fontSize: 16),
                ),

              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildImage(Uint8List bytes) => Image.memory(bytes);

  Future<String?> saveImage(Uint8List image) async{
  final time = DateTime.now()
  .toIso8601String()
  .replaceAll(".", "_")
  .replaceAll(":", "_");

  final name = "Screenshot_$time";

  final result = await ImageGallerySaver.saveImage(image,name: name);
  return result['filepath'];

  }


}