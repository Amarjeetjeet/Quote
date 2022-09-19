import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quote/QuoteList.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

Future<QuoteList> fetchData(String something) async {
  //ok
  final response = await http.post(Uri.parse('https://fitmuscle12.000webhostapp.com/Motivation_Quote/getQouteByID.php?id=$something'));
  if (response.statusCode == 200) {
    return QuoteList.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Unexpected error occured!');
  }
}

class ListScreen extends StatefulWidget {
  String something;
  ListScreen(this.something, {Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState(this.something);
}

class _MyAppState extends State<ListScreen> {
  String something;
  _MyAppState(this.something);

  late Future<QuoteList> futureData;
  var selectedIndex;

  Uint8List? image;

  final controller = ScreenshotController();

  @override
  void initState() {
    super.initState();
    futureData = fetchData(something);
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(something);
    return Screenshot(
      controller: controller,
      child: Scaffold(
        drawer: buildDrawer(),
        appBar: AppBar(title: Text('Quote'), backgroundColor: Colors.black),
        body: Center(
          child: buildFutureBuilder(),
        ),
      ),
    );
  }

  FutureBuilder<QuoteList> buildFutureBuilder() {
    final todo = ModalRoute.of(context)!.settings.arguments;
    debugPrint(todo.toString() + "para");

    return FutureBuilder<QuoteList>(
      future: futureData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          QuoteList? qoutedata = snapshot.data;
          return ListView.builder(
              itemCount: qoutedata?.data?.length,
              itemBuilder: (BuildContext context, int index) {
                return buildContainerImage(index, qoutedata);
              });
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        // By default show a loading spinner.
        return CircularProgressIndicator();
      },
    );
  }

  GestureDetector buildContainerImage(int index, QuoteList? qoutedata) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
          debugPrint('movieTitle: $index');
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: SizedBox(
          height: 350,
          width: double.infinity,
          child: Column(
            children: [
              buildContainer(index, qoutedata),
              Row(
                children:
                [
                  shareBtn(index, qoutedata),
                  Spacer(),
                  downloadBtn(index, qoutedata)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget shareBtn(int index, QuoteList? qoutedata) {
    return TextButton.icon(
      onPressed: () async {
        final image = await controller
            .captureFromWidget(buildContainer(index, qoutedata));

        setState(() {
          this.image = image;
        });
        debugPrint(image.toString());
        debugPrint(selectedIndex.toString());
        await saveAndShare(image);
      },
      icon: Image.asset(
        "assets/images/share.png",
        height: 20,
      ),
      label: Text("Share"),
    );
  }

  Widget downloadBtn(int index, QuoteList? qoutedata) {
    return TextButton.icon(
      onPressed: () async {
        final image = await controller
            .captureFromWidget(buildContainer(index, qoutedata));

        setState(() {
          this.image = image;
        });
        debugPrint(image.toString());
        debugPrint(selectedIndex.toString());
        await saveImage(image);

        final snackBar = SnackBar(
          content: const Text('Image Saved in Gallery!'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              // Some code to undo the change.
            },
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      icon: Image.asset(
        "assets/images/download.png",
        height: 20,
      ),
      label: Text("Download"),
    );
  }

  Container buildContainer(int index, QuoteList? qoutedata) {
    return Container(
        height: 275,
        width: double.infinity,
        color: selectedIndex == index ? generateRandomColor() : Colors.cyanAccent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 48.0),
              child: Text(
                qoutedata!.data![index].quoteData.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Text("------"),
            Text(qoutedata!.data![index].quoteName.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w500)),
          ],
        ));
  }

  Drawer buildDrawer() {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('Quote Application'),
          ),
          ListTile(
            title: const Text('Rate Us'),
            onTap: () {},
          ),
          ListTile(
              title: const Text('Upload Quote(Coming soon)'),
              onTap: () => print("Click")),
        ],
      ),
    );
  }

  Color? generateRandomColor() {
    final _random = Random();
    return Colors.primaries[_random.nextInt(Colors.primaries.length)]
        [_random.nextInt(9) * 100];
  }

  Widget buildImage(Uint8List bytes) => Image.memory(bytes);

  Future<String?> saveImage(Uint8List image) async {
    final time = DateTime.now()
        .toIso8601String()
        .replaceAll(".", "_")
        .replaceAll(":", "_");

    final name = "Screenshot_$time";

    final result = await ImageGallerySaver.saveImage(image, name: name);
    return result['filepath'];
  }

  Future saveAndShare(Uint8List byte) async {
    final directory = await getApplicationDocumentsDirectory();
    final image = File('${directory.path}/flutter.png');
    image.writeAsBytesSync(byte);
    final text = "Check Out this Awesome App";
    await Share.shareFiles([image.path],text: text);
  }
}
