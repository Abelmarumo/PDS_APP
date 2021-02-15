import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  final UserCredential user;
  final List <String>firebaseSubjects;
  Profile({this.firebaseSubjects,this.user});
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          IconButton(
              icon:Icon(
                Icons.logout,
                color: Colors.redAccent[400],
              ),
            onPressed: (){
                Navigator.pop(context);
            },
          )
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage('https://www.xovi.com/wp-content/plugins/all-in-one-seo-pack/images/default-user-image.png'),
                        ),
                      ),
                    ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      child: Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 4,
                          color: Colors.white
                        ),
                        color: Colors.redAccent[400],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: Text(
                  widget.user.user.email,
                style: TextStyle(
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            Divider(
              color: Colors.black12,

            ),
            SizedBox(height: 20,),
            Container(
              margin: EdgeInsets.only(left: 20,right: 20),
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemBuilder: (context,index){
                  return Card(
                    elevation: 5,
                    child: ListTile(
                      onTap: (){},
                      title: Text(
                        widget.firebaseSubjects[index],
                      ),
                    ),
                  );
                },
                itemCount: widget.firebaseSubjects.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

