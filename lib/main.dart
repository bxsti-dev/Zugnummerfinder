import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const Home(),
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow, brightness: Brightness.dark),
        ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}
class _HomeState extends State<Home> {
  Map data = {};

  loadData()async{ //Future<void> loadData() async {}
    data = json.decode(await rootBundle.loadString("assets/traindata.json"));
  }


  @override
  void initState() {
    loadData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: Column(
          children: [

            Align(
              alignment: AlignmentGeometry.topCenter,
              child: Padding(padding: const EdgeInsets.all(24.0),
                child: SearchBar(
                  hintText: "Search for trainnumber...",
                  //leading: Icon(Icons.manage_search),
                  padding: WidgetStatePropertyAll(EdgeInsetsGeometry.only(left: 12, right: 12)),
                  trailing: [IconButton.filledTonal(onPressed: (){}, icon: Icon(Icons.search))],
                ),
              )
            ),

            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 8,
                  children: [
                    Icon(
                      Icons.train,
                      size: 100,
                      color: ColorScheme.of(context).primary,
                    ),
                    Text("No train searched", style: TextStyle(fontSize: 20))
                  ],
                )
              ),
            )

          ]
        )
      )
    );
  }
}