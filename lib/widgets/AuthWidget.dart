import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:huawei_account/huawei_account.dart';

import '../Home.dart';
import '../mapandlocation.dart';

class AuthWidget extends StatefulWidget {
  const AuthWidget({Key? key}) : super(key: key);

  @override
  _AuthWidgetState createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {
  String email = "empty";
  String password = "empty";
  bool isLogin = false;

  late AuthAccount _account;

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
    return
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image(image: AssetImage(
            "assets/images/marker.png"
          )),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: TextField(
          //     onChanged: (val) {
          //       setState(() {
          //         this.email = val;
          //       });
          //     },
          //     decoration: InputDecoration(
          //         labelText: "Email",
          //         border: OutlineInputBorder(
          //           borderRadius: BorderRadius.circular(5.0),
          //         )),
          //   ),
          // ),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: TextField(
          //     onChanged: (val) {
          //       setState(() {
          //         this.password = val;
          //       });
          //     },
          //     decoration: InputDecoration(
          //         labelText: "password",
          //         border: OutlineInputBorder(
          //           borderRadius: BorderRadius.circular(5.0),
          //         )),
          //   ),
          // ),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: ElevatedButton(
          //     onPressed: () async {
          //       if(isLogin){
          //         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Home()));
          //       }else{
          //         await login(email,password);
          //       }
          //     },
          //     child: Text(isLogin?"Logout":"Login"),
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: HuaweiIdAuthButton(
                onPressed: _signIn,
                elevation: 0,
                borderRadius: AuthButtonRadius.SMALL,
                buttonColor: AuthButtonBackground.RED),
          )
        ]
      );
  }

  _signIn() async {
    final helper = AccountAuthParamsHelper();
    helper
      ..setProfile()
      ..setAccessToken()
      ..setEmail()
      ..setUid();

    try {
      _account = await AccountAuthService.signIn(helper);
      Map<String, dynamic> accountInfo = _account.toMap();
      print("FROM SIGN IN: " + _account.toMap().toString());
      EasyLoading.showSuccess('Huawei Success!');
      generateCustomToken(accountInfo);
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  void generateCustomToken(Map<String,dynamic> accountInfo) async {
    try {
      var response = await Dio().post('https://custom-token-huawei.herokuapp.com/createCustomToken',data:{
        "id_token":accountInfo["unionId"],
        "name":accountInfo["displayName"],
        "picture":accountInfo["avatarUri"],
        "email":accountInfo["email"]
      });

      print("generateCustomToken"+response.data["firebase_token"]);
      EasyLoading.dismiss();
      EasyLoading.showSuccess('CustomToken Success!');
      EasyLoading.dismiss();
      await auth.signInWithCustomToken(response.data["firebase_token"]);
      EasyLoading.showSuccess('Signing Success!');
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Home()));
    } catch (e) {
      print(e);
    }
    EasyLoading.dismiss();
  }

  Future<void> login(String _email,String _password) async {
    EasyLoading.show(status: 'hhh...');
    auth.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
        auth.signInWithEmailAndPassword(email: _email, password: _password)
            .then((value) => {
          print(value.user!.displayName),
          print(value.user!.photoURL),
          print(value.user!.email),
          print(value.user!.uid)
        });
      } else {
        isLogin = true;
        print('User is signed in!');
        EasyLoading.dismiss();
      }
    });

  }

  Future<void> Sign_up(
      {required String input_email, required String input_password}) async {
    print("${input_email}\n${input_password}");
    print(" done  => Firebase.initializeApp();");
    try {
      print(" done  => userCredential");
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: input_email, password: input_password);
      print(" done  => createUserWithEmailAndPassword");
      print("Success !!!!!!!!!!!!!!" + userCredential.user!.email.toString());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('Error : the password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('Error : The account already exists for that email.');
      } else {
        print(e);
      }
    } catch (e) {
      print("Error : " + e.toString());
    }
  }

}

