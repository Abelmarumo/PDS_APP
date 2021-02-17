import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ResetScreen extends StatefulWidget {
  @override
  _ResetScreenState createState() => _ResetScreenState();
}

class _ResetScreenState extends State<ResetScreen> {
  String _email;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final scaffold = GlobalKey<ScaffoldState>();

  reset() async{
    final formState = _formKey.currentState;
    if(formState.validate()){
      formState.save();
      ArsProgressDialog progressDialog = new ArsProgressDialog(context,
          blur: 2,
          backgroundColor: Color(0x33000000),
          animationDuration: Duration(milliseconds: 500));
      try{
        progressDialog.show();
        await FirebaseAuth.instance.sendPasswordResetEmail(email: _email);
        progressDialog.dismiss();
        scaffold.currentState.showSnackBar(
            SnackBar(
              content: Text("Reset link sent to your email"),
              duration: Duration(milliseconds:3000),
            )).closed.then((value) => Navigator.pop(context));
      } catch(e){
        scaffold.currentState.showSnackBar(
            SnackBar(
              content: Text("Something went wrong!"),
              duration: Duration(milliseconds:3000),
            ));
      }
      formState.reset();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffold,
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100.0),
          ),
          width: MediaQuery.of(context).size.width*0.8,
          height: MediaQuery.of(context).size.height*0.5,
          child: Card(
            elevation: 5,
            color: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))
            ),
            child: Column(
              children: <Widget>[
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
                                onSaved: (input)=>_email=input.trim(),
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
                          ],
                        ),
                      )
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  width: MediaQuery.of(context).size.width*0.4,
                  height: 60,
                  child: RaisedButton(
                    onPressed: reset,
                    child: Icon(Icons.send,color: Colors.white,),
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
    );
  }
}
