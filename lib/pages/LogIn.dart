import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'SignUp.dart';
import 'package:pds2/pages/profile.dart';
class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  String _email,_password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final scaffold = GlobalKey<ScaffoldState>();

  List <String> firebaseSubjects;

  Future<void>signIn() async{
    final formState = _formKey.currentState;
    if(formState.validate()){
      formState.save();
      ArsProgressDialog progressDialog = new ArsProgressDialog(context,
          blur: 2,
          backgroundColor: Color(0x33000000),
          animationDuration: Duration(milliseconds: 500));
      try{
        progressDialog.show();
        UserCredential user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password);
        if(user.user.isAnonymous==false){
          await FirebaseDatabase.instance
              .reference()
              .child("modulesOfAll")
              .child(user.user.uid)
              .once()
              .then((DataSnapshot snapshot){
            Map<dynamic, dynamic>.from(snapshot.value).forEach((key,values) {
              setState(() {
                firebaseSubjects=snapshot.value['modules'].cast<String>();
              });
            });
          });
          progressDialog.dismiss();
          Navigator.push(context, MaterialPageRoute(builder: (context) => Profile(firebaseSubjects: firebaseSubjects,user:user),fullscreenDialog: true));
        }else{
          progressDialog.dismiss();
          scaffold.currentState.showSnackBar(
              SnackBar(
                content: Text("The user doesn't exist!"),
                duration: Duration(milliseconds:3000),
              ));
        }
        }catch(e){
        progressDialog.dismiss();
        scaffold.currentState.showSnackBar(
            SnackBar(
              content: Text("Something went wrong!"),
              duration: Duration(milliseconds:3000),
            ));
        print(e);
      }

        formState.reset();
      }
    }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffold,
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white, Colors.white],
              ),
            ),
            child: Stack(
              children: <Widget>[
                Container(
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 100),
                      child: Text(
                        'Welcome to PDS',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                    margin: EdgeInsets.only(top: 80),
                    width: MediaQuery.of(context).size.width*0.8,
                    height: MediaQuery.of(context).size.height*0.8,
                    child: Card(
                      elevation: 5,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 50),
                            child: ToggleSwitch(
                                labels: ['Log In','Sign Up'],
                                minWidth: MediaQuery.of(context).size.width*0.3,
                                minHeight: 30,
                                cornerRadius: 20,
                                activeBgColor: Colors.redAccent[400],
                                inactiveBgColor: Colors.white,
                                onToggle: (index){
                                  setState(() {
                                    if(index==1){
                                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>SignUp()));
                                    }
                                  });
                                },
                            ),
                          ),
                          Container(
                            child: Form(
                                key: _formKey,
                                child: Container(
                                  margin: EdgeInsets.only(top: 30),
                                  width: MediaQuery.of(context).size.width*0.6,
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(bottom: 20),
                                        child: TextFormField(
                                          validator: (input) {
                                            if (input.isEmpty) {
                                              return 'Please enter some text';
                                            }
                                            return null;
                                          },
                                          onSaved: (input)=>_email=input,
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.only(top: 20,bottom: 5),
                                            labelText: 'Email',
                                            labelStyle: TextStyle(
                                              color: Colors.black87,
                                            ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.black87
                                            ),
                                          ),

                                          ),
                                        ),
                                      ),
                                      TextFormField(
                                        validator: (input) {
                                          if (input.length < 6) {
                                            return 'Password must be atleast 6 charactors';
                                          }
                                          return null;
                                        },
                                        onSaved: (input)=>_password=input,
                                        obscureText: true,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.only(top: 20,bottom: 5),
                                          labelText: 'Password',
                                          labelStyle: TextStyle(
                                            color: Colors.black87,
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black87
                                            ),
                                          ),

                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.bottomLeft,
                                        margin: EdgeInsets.only(left: 100),
                                        child: TextButton(
                                            onPressed: (){},
                                            child: Text(
                                                'Forgot password?',
                                              style: TextStyle(
                                                color: Colors.black87
                                              ),
                                            ),
                                          ),
                                      ),
                                    ],
                                  ),
                                )),
                          ),
                         Container(
                            margin: EdgeInsets.only(top: 20),
                            width: MediaQuery.of(context).size.width*0.4,
                            child: RaisedButton(
                                onPressed: signIn,
                                child: Text('Log in',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                color: Colors.redAccent[400],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}