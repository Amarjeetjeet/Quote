import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:quote/Category.dart';

import 'package:http/http.dart' as http;
import 'package:quote/list_screen.dart';

class CategoryScreen extends StatefulWidget {
  CategoryScreen({Key? key}) : super(key: key);

  @override
  _CategoryScreenState createState() {
    return _CategoryScreenState();
  }
}
//https://fitmuscle12.000webhostapp.com/Motivation_Quote/getQouteByID.php?id=3

Future<Category> fetchData() async {
  final response = await http.post(Uri.parse(
      'https://fitmuscle12.000webhostapp.com/Motivation_Quote/getCategory.php'));
  if (response.statusCode == 200) {
    return Category.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Unexpected error occured!');
  }
}

class _CategoryScreenState extends State<CategoryScreen> {
  late Future<Category> futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text('Quote'), backgroundColor: Colors.black),
      body: Center(
        child: buildFutureBuilder(),
      ),
    );
  }

  FutureBuilder<Category> buildFutureBuilder() {
    return FutureBuilder<Category>(
      future: futureData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Category? qoutedata = snapshot.data;
          return GridView.builder(
                gridDelegate:  const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemCount: qoutedata?.data?.length,
                itemBuilder: (BuildContext context, int index) {
                  final todo = ModalRoute.of(context)!.settings.arguments;
                  debugPrint(todo.toString());

                  return GestureDetector(
                      onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ListScreen(qoutedata.data![index].cId.toString())),
                    );
                  },
                    child: Card(
                      color: Colors.amber,
                      child: Center(child: Text(qoutedata!.data![index].cName.toString(),style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,),textAlign: TextAlign.center,)),
                    )
                  );
                }
                );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        // By default show a loading spinner.
        return CircularProgressIndicator();
      },
    );
  }

}