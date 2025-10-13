import 'package:flutter/material.dart';
import 'package:mini_gallary/provider/gallery_image_provider.dart';
import 'package:provider/provider.dart';
import 'screen/sqflite/sqlite_home.dart';

void main() {
  runApp(

    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => GalleryImageProvider(),)
    ], child: const MyApp()),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: SqliteHome(),
    );
  }
}
