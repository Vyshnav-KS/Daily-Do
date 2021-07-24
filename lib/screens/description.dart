import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Description extends StatelessWidget {
final String title,description;

  const Description({Key? key, required this.title, required this.description}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Your task',
      style: GoogleFonts.montserrat(
        fontWeight: FontWeight.w700
      ),),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Container(
            margin: EdgeInsets.all(10),
            child: Text(title,
            style: GoogleFonts.montserrat(
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),),
          ),

          SizedBox(height: 10,),

          Container(
            margin: EdgeInsets.all(10),
            child: Text(description,
            style: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),),
          )

        ],),),
    );
  }
}