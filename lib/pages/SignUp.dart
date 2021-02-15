import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pds2/pages/Modules.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'LogIn.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  int label =0;

  String _email,_password,_confirm;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final controller = TextEditingController();

  signUp() {
    final formState = _formKey.currentState;
    if(formState.validate()){
      formState.save();
      try{
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>Modules(email:_email,password:_password))).then((_) => formState.reset());
      } catch(e){
        print('wrong password or email');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: Card(
                      elevation: 5,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 50),
                            child: ToggleSwitch(
                              labels: ['Log In', 'Sign Up'],
                              minWidth: MediaQuery.of(context).size.width * 0.3,
                              minHeight: 30,
                              cornerRadius: 20,
                              activeBgColor: Colors.redAccent[400],
                              inactiveBgColor: Colors.white,
                              initialLabelIndex: 1,
                              onToggle: (index) {
                                setState(() {
                                  if(index==0){
                                    Navigator.pop(context);
                                  }
                                });

                              },
                            ),
                          ),
                          Container(
                            child: Form(
                              key: _formKey, child: Container(
                              margin: EdgeInsets.only(top: 30),
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(bottom: 20),
                                    child: TextFormField(
                                      validator: (input) {
                                        if (input.trim().isEmpty) {
                                          return 'Please enter some text';
                                        }
                                        return null;
                                      },
                                      onSaved: (input)=>_email=input.trim(),
                                      decoration: InputDecoration(
                                        contentPadding:
                                            EdgeInsets.only(top: 20, bottom: 5),
                                        labelText: 'Email',
                                        labelStyle: TextStyle(
                                          color: Colors.black87,
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.black87),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(bottom: 20),
                                    child: TextFormField(
                                      controller: controller,
                                      validator: (input) {
                                        if (input.length < 6) {
                                          return 'Password must be atleast 6 charactors';
                                        }
                                        return null;
                                      },
                                      onSaved: (input)=>_password=input,
                                      obscureText: true,
                                      decoration: InputDecoration(
                                        contentPadding:
                                        EdgeInsets.only(top: 20, bottom: 5),
                                        labelText: 'Password',
                                        labelStyle: TextStyle(
                                          color: Colors.black87,
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide:
                                          BorderSide(color: Colors.black87),
                                        ),
                                      ),
                                    ),
                                  ),
                                  TextFormField(
                                    validator: (input) {
                                      if (input!=controller.text) {
                                        return "Password don't match";
                                      }
                                      return null;
                                    },
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      contentPadding:
                                          EdgeInsets.only(top: 20, bottom: 5),
                                      labelText: 'Confirm password',
                                      labelStyle: TextStyle(
                                        color: Colors.black87,
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black87),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 20),
                            height: 60,
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: RaisedButton(
                              onPressed: (){
                                signUp();
                                controller.clear();
                              },
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                              ),
                              color: Colors.redAccent[400],
                              shape: CircleBorder(
                                side: BorderSide(
                                  color:Colors.redAccent[400],
                                ),
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
