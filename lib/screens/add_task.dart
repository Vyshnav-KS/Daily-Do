import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/screens/home.dart';

class AddTask extends StatefulWidget {
  const AddTask({ Key? key }) : super(key: key);

  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {

  final maxLines = 5;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  addTaskToFirebase() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseUser user = await auth.currentUser();
    String uid = user.uid;
    var time = DateTime.now();
    await Firestore.instance.collection('tasks').document(uid).collection('mytasks').document(time.toString()).setData({'title': titleController.text, 
    'description':descriptionController.text,
    'time': time.toString(),
    'timestamp': time,
    });
    Fluttertoast.showToast(msg: 'Task added');
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        // foregroundColor: Theme.of(context).primaryColor,
        title: Text(
          'New Task', 
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w700
          ),),
          ),
          body: Container(
            padding: EdgeInsets.all(10),
            child: Column(children: [

              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  // labelText: 'Enter Title',
                  // labelStyle: GoogleFonts.montserrat(),
                  hintText: 'Enter Title',
                  hintStyle: GoogleFonts.montserrat(),
                  ),
                  
              ),

              SizedBox(height: 10,),

              Container(
                height: maxLines * 25.0,
                child: TextField(
                  controller: descriptionController,
                  maxLines: maxLines,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    hintText: 'Enter Description',
                    hintStyle: GoogleFonts.montserrat(),
                     //labelText: 'Enter Description',
                    // labelStyle: GoogleFonts.montserrat(),
                    ),
                ),
              ),

              SizedBox(height: 10,),

              Container(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(onPressed: () async{
                  await addTaskToFirebase();
                  Navigator.pop(context, MaterialPageRoute(builder: (context)=>Home()));
                }, 
                child: Text('Add',
                style: GoogleFonts.montserrat(),),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  primary: Theme.of(context).primaryColor,
                ),
                ),
              )

            ],),
          ),
    );
  }
}