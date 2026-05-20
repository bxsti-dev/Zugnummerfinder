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
          //textTheme: TextTheme(bodyMedium: TextStyle(color: Colors.yellow.shade100))
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
  final searchbarController = TextEditingController();
  Map data = {};
  bool hasResult = false;
  String? name;
  int? minNumber;
  int? maxNumber;
  String? yearBuilt;
  int? retired;
  String? type;

  loadData()async{ //Future<void> loadData() async {}
    data = json.decode(await rootBundle.loadString("assets/traindata.json"));
  }

  setData(int i){
    setState(() {
      hasResult = true;
      name = data.keys.elementAt(i);
      minNumber = data.values.elementAt(i)["min"];
      maxNumber = data.values.elementAt(i)["max"];
      yearBuilt = data.values.elementAt(i)["year_built"];
      retired = data.values.elementAt(i)["retired"];
      type = data.values.elementAt(i)["type"];
    });
  }

  searchData(value, bool number){
    for(int i = 0;i<data.keys.length;i++){

      if(number == true){
        if(value >= data.values.elementAt(i)["min"] && value <= data.values.elementAt(i)["max"]){
          setData(i);
          break;
        }else{
          if(i == data.keys.length-1){
            setState(() {
              hasResult = false;
            });
          }
        }
      }

      if(number == false){
        if(value == data.keys.elementAt(i)){
          setData(i);
          break;
        }else{
          if(i == data.keys.length-1){
            setState(() {
              hasResult = false;
            });
          }
        }
      }

    }
  }

  searchbarUpdate(String value){
    if(value != "" && value.length >= 3){

      if(int.tryParse(value) != null){ // only number
        searchData(int.parse(value), true);
      }else{                           // with letters
        searchData(value.trim().toUpperCase(), false);
      }

    }else{
      setState(() {
        hasResult = false;
      });
    }
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:() => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(title: Text("Zugnummerfinder"), centerTitle: true),
      
        body: Center(
          child: Column(
            children: [
      
              /// SEARCHBAR ///
              Align(
                alignment: AlignmentGeometry.topCenter,
                child: Padding(padding: const EdgeInsets.all(24.0),
                  child: SearchBar(
                    controller: searchbarController,
                    hintText: "Search trainnumber/trainname...",
                    leading: Icon(Icons.search),
                    padding: WidgetStatePropertyAll(EdgeInsetsGeometry.only(left: 12, right: 12)),
                    onChanged: (value) {
                      searchbarUpdate(value);
                    },
                    trailing: [
                      if(searchbarController.text.isNotEmpty)
                        IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: (){
                            searchbarController.text = "";
                            searchbarUpdate("");
                          }
                        ),
                    ],
                  ),
                )
              ),
      
      
      
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  switchInCurve: Curves.easeInBack,
                  switchOutCurve: Curves.easeOutBack,
                  /// RESULT WIDGET ///
                  child: hasResult ? Padding(
                      padding: const EdgeInsets.only(left: 50, right: 50, top: 20, bottom: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        spacing: 8,
                        children: [
                          Text("$name",                     style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold)),
                          Text("($minNumber - $maxNumber)", style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal)),
                          Padding(padding: EdgeInsetsGeometry.all(20)),
                                
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                            Text("Year built:", style: TextStyle(fontWeight: FontWeight.bold)),
                            Text("$yearBuilt")
                          ]),
                      
                          Divider(),
                      
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                            Text("Retired:", style: TextStyle(fontWeight: FontWeight.bold)),
                            retired == null ? Text("No") : Text("$retired")
                          ]),
                                
                          type != null ? Divider():Container(),
                      
                          type != null ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                            Text("Type:", style: TextStyle(fontWeight: FontWeight.bold)),
                            Text("$type")
                          ]):Container(),
                        ]
                      ),
                  )
                  
      
                  
                  /// NOT SEARCHED PLACEHOLDER ///
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 8,
                        children: [
                          Icon(Icons.train, size: 100, color: ColorScheme.of(context).primary),
                          Text("Search for trains", style: TextStyle(fontSize: 20))
                        ],
                      )
                  ),
                  
                ),
              ),
      
            ]
          )
        )
      ),
    );
  }
}