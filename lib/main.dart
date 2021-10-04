import 'package:firebase/widgets/AuthWidget.dart';
import 'package:firebase/widgets/hms_gms_widget.dart';
import 'package:firebase/mapandlocation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:huawei_location/location/fused_location_provider_client.dart';
import 'package:huawei_map/map.dart';

import 'Home.dart';
import 'auth_screen.dart';
// ignore: import_of_legacy_library_into_null_safe
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {


  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: mainLayout(),
      builder:  EasyLoading.init(),
    );
  }
}

class mainLayout extends StatefulWidget {
  const mainLayout({Key? key}) : super(key: key);

  @override
  _mainLayoutState createState() => _mainLayoutState();
}

class _mainLayoutState extends State<mainLayout> {
  late FirebaseAuth auth ;
  late Future<FirebaseApp> _initialization ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _initialization = Firebase.initializeApp();
      auth = FirebaseAuth.instance;
      print(auth.currentUser.toString()+"  magic");
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: auth.currentUser== null ?AuthWidget():Home(),
        ),
    );
  }
}



