import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:custom_progress_dialog/custom_progress_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:pds2/pages/LogIn.dart';
import 'package:pds2/service/payment_service.dart';

class Modules extends StatefulWidget {
  final String email,password;
  Modules({this.email,this.password});

  @override
  _ModulesState createState() => _ModulesState(email,password);
}

class _ModulesState extends State<Modules> {
  String email,password;
  _ModulesState(this.email,this.password);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    StripeService.init();
  }


  var newlevel;
  dynamic totalCost=0.0;
  //list of level of study
  List<String> levels = [
    '1st year mainstream',
    '1st year extended',
    '2nd year mainstream',
    '2nd year extended',
    '3rd year'
  ];

  //first year maintream modules
  List<String> oneMainstreamModules = [
    'Stats 1',
    'Maths 1',
    'Applied math 1',
    'Computer Science 1',
  ];

  //first year extended modules
  List<String> oneExtendedModules = [
    'Stats E1',
    'Maths E1',
    'Applied math E1',
    'Computer Science E1',
  ];

  //2nd year maintream modules
  List<String> twoMainstreamModules = [
    'Stats 2',
    'Maths 2',
    'Applied math 2',
    'Computer Science 2',
  ];

  //2nd year extended modules
  List<String> twoExtededModules = [
    'Stats E2',
    'Maths E2',
    'Applied math E2',
    'Computer Science E2',
  ];

  //3rd year extended modules
  List<String> threeModules = [
    'Stats 3',
    'Maths 3',
    'Applied math 3',
    'Computer Science 3',
  ];

  List subjects;
  final ref = FirebaseDatabase.instance.reference();
  onItemPress(BuildContext context) async{
        ArsProgressDialog progressDialog = new ArsProgressDialog(context,
            blur: 2,
            backgroundColor: Color(0x33000000),
            animationDuration: Duration(milliseconds: 500));
        progressDialog.show();
        var response = await StripeService.payWithNewCard(
            amount: totalCost.toString()+'00',
            curr: 'USD'
        );
        if(response.success==true){

          try{UserCredential user = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
          await ref.child('modulesOfAll').child(user.user.uid).child('modules').set(subjects);
          }catch(e){
            print(e);
          }
        }
        progressDialog.dismiss();
        _scaffoldKey.currentState.showSnackBar(
            SnackBar(
              content: Text(response.message),
              duration: Duration(milliseconds:response.success==true ? 1200 : 3000),
            )).closed.then((_){
          if(response.success==true){
            Navigator.pop(context);
          }
        });

  }



  //card and modules
  countCardModules(modules){
    return SingleChildScrollView(
      child: Column(
        children: [
          CheckboxGroup(
            labels: modules,
            onSelected: (List<String> checked){
              setState(() {
                subjects = checked;
                totalCost =50*checked.length;
              });
            },
            activeColor: Colors.redAccent[400],
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100.0),
            ),
            margin: EdgeInsets.only(left: 10),
            padding: EdgeInsets.all(0),
            width: 300,
            height: 50,
            child: Card(
              elevation: 0,
                child: Container(
                  margin: EdgeInsets.only(top: 13,left: 10),
                  child: Text(
                    'Total cost: USD$totalCost'
                  ),
                ),

            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20,left: 50),
            height: 60,
            width: MediaQuery.of(context).size.width * 0.7,
            child: RaisedButton(
              onPressed: totalCost==0? null : ()
              {
              onItemPress(context);
              },
              child: Text(
                'Pay',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20
                ),
              ),
              color: Colors.redAccent[400],
              shape: CircleBorder(
                side: BorderSide(
                  color: Colors.redAccent[400],
                ),
              ),
            ),
          )
      ]
      ),
    );
  }
  //render widget function
  renderWidget() {
    switch (newlevel) {
      case '1st year mainstream':
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(top: 20, right: 50),
            width: MediaQuery.of(context).size.width * 0.6,
            height: MediaQuery.of(context).size.height * 0.4,
            child: countCardModules(oneMainstreamModules)
        ));
        break;
      case '2nd year mainstream':
        return Expanded(
            child: Container(
                margin: EdgeInsets.only(top: 20, right: 50),
                width: MediaQuery.of(context).size.width * 0.6,
                height: MediaQuery.of(context).size.height * 0.4,
                child: countCardModules(twoMainstreamModules)
            ));
        break;
      case '1st year extended':
        return Expanded(
            child: Container(
                margin: EdgeInsets.only(top: 20, right: 50),
                width: MediaQuery.of(context).size.width * 0.6,
                height: MediaQuery.of(context).size.height * 0.4,
                child: countCardModules(oneExtendedModules)
            ));
        break;
      case '2nd year extended':
        return Expanded(
            child: Container(
                margin: EdgeInsets.only(top: 20, right: 50),
                width: MediaQuery.of(context).size.width * 0.6,
                height: MediaQuery.of(context).size.height * 0.4,
                child: countCardModules(twoExtededModules)
            ));
        break;
      case '3rd year':
        return Expanded(
            child: Container(
                margin: EdgeInsets.only(top: 20, right: 50),
                width: MediaQuery.of(context).size.width * 0.6,
                height: MediaQuery.of(context).size.height * 0.4,
                child: countCardModules(threeModules)
            ));
        break;
      default:
    }
  }

  //progress dialog
  ProgressDialog _progressDialog = ProgressDialog();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
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
                        'Course section',
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
                            margin: EdgeInsets.only(top: 20),
                            child: DropdownButton(
                              items: levels
                                  .map((level) => DropdownMenuItem(
                                        child: Text(level),
                                        value: level,
                                      ))
                                  .toList(),
                              onChanged: (selectedlevel) {
                                setState(() {
                                  newlevel = selectedlevel;
                                });
                              },
                              value: newlevel,
                              isExpanded: false,
                              hint: Text('Select level of study'),
                            ),
                          ),
                          Container(
                            child: renderWidget(),
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
