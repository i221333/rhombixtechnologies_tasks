//import 'package:fhgfgfggh/chatbot/view.dart';
import 'package:fhgfgfggh/shoppingcart/cartprovider.dart';
import 'package:fhgfgfggh/shoppingcart/frontpage.dart';
import 'package:fhgfgfggh/shoppingcart/subfrontpage.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


void main() async{
  //WidgetsFlutterBinding.ensureInitialized();
  //await TaskDatabase.instance.deleteDatabaseFile();

  /*runApp(
      MyApp()
  );*/

  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(),
      child: const MyApp(),
    ),
  );

  /*runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    home: ChatbotPage(),
  ));*/
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Subfrontpage(),
      color: Colors.white
    );
  }
}
