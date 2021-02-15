import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pds2/pages/LogIn.dart';
import 'package:pds2/pages/Pay.dart';
import 'package:pds2/pages/SignUp.dart';
import 'package:pds2/pages/profile.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: LogIn(),
  ));
}


