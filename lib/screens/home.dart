//import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/screens/add_task.dart';
import 'package:todo_app/screens/description.dart';

class Home extends StatefulWidget {
  const Home({ Key? key }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  String uid = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUid();
  }

  getUid() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser user = await auth.currentUser();
    setState(() {
      uid = user.uid;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(' My Tasks',
        style: GoogleFonts.montserrat(
          fontWeight: FontWeight.w700
        ),),
        actions: [
          IconButton(onPressed: () async {
            await FirebaseAuth.instance.signOut();
          },
           icon: Icon(Icons.logout))
        ],
      ),
      body: Container(
        color: Color(0xFF202020),
        padding: EdgeInsets.all(10),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: StreamBuilder<QuerySnapshot>(stream: Firestore.instance.collection('tasks').document(uid).collection('mytasks').snapshots(),builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
              return Container(
                child: Center(child: CircularProgressIndicator()),
              );
          }
          else{
            final docs = snapshot.data!.documents;
            return ListView.builder(itemCount: docs.length,
            itemBuilder: (context, index){
              var time = (docs[index]['timestamp'] as Timestamp).toDate();
              return InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Description(title: docs[index]['title'],
                  description: docs[index]['description'])));
                },

                child: Container(
                  margin: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Color(0xFFBEB8B8).withOpacity(.21),
                    borderRadius: BorderRadius.circular(10)),
                  height: 100,
                  
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        Container(
                          margin: EdgeInsets.only(left: 10, top: 10),
                          child: Text(docs[index]['title'],
                          style: GoogleFonts.montserrat(
                            fontSize: 17,
                            fontWeight: FontWeight.w500
                          ),)),
              
                          SizedBox(height: 12,),
              
                        Container(
                          margin: EdgeInsets.only(left: 10, ),
                          child: Text(DateFormat.yMd().add_jm().format(time),
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w300,
                            color: Colors.grey[400],
                          ),),
                        )
              
                      ],),
              
                      Container(
                        child: IconButton(icon: Icon(Icons.delete),onPressed: () async {
                          await Firestore.instance.collection('tasks').document(uid).collection('mytasks').document(docs[index]['time']).delete();
                        },),
                      ),
              
                    ],
                  ),
                ),
              );
            },);
          }
        },),
        ),

        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add, color: Colors.white,),
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>AddTask()));
          },),
    );
  }
}