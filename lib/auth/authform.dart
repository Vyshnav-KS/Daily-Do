import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({ Key? key }) : super(key: key);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {

  final formKey = GlobalKey<FormState>();
  var email = '';
  var password = '';
  var username = '';
  bool isLoginPage = false;


  //authenrication_starting

  startAuthentication() {
    final validity = formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if(validity){
      formKey.currentState!.save();
      submitForm(username, email, password);
    }
  }

  submitForm(String username, String email, String password) async {
    final auth = FirebaseAuth.instance;
    AuthResult authResult;
    try{
      if(isLoginPage){
        authResult = await auth.signInWithEmailAndPassword(email: email, password: password);
      }
      else{
        authResult = await auth.createUserWithEmailAndPassword(email: email, password: password);
        String uid = authResult.user.uid;
        await Firestore.instance.collection('users').document(uid).setData({
          'username': username,
          'email': email,
        });
      }
    }
    catch(err){
      print(err);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF202020),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: ListView(
        children: [

          Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: Text('Daily Do',
            style: GoogleFonts.montserrat(
              fontSize: 24,
              fontWeight: FontWeight.w800,
            
            ),),
          ),

          Container(
            margin: EdgeInsets.all(10),
                    height: 200,
                    width: 200,
          child: Image.asset('assets/signUp_tP.png'),
          ),

          Container(
            padding: EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
              children: [

                if(!isLoginPage)
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  key: ValueKey('username'),
                  validator: (value){
                    if(value!.isEmpty)
                      {
                        return 'Incorrect Username';
                      }
                    else
                      return null;
                  },

                  onSaved: (value){
                    username = value!;
                  },
                  
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(10),
                      borderSide: new BorderSide(),
                      ),
                      labelText: 'Enter Username',
                      labelStyle: GoogleFonts.montserrat()
                  ),
                ),

               SizedBox(height: 15,),

                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  key: ValueKey('email'),
                  validator: (value){
                    if(value!.isEmpty || !value.contains('@'))
                      {
                        return 'Incorrect Email';
                      }
                    else
                      return null;
                  },

                  onSaved: (value){
                    email = value!;
                  },
                  
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(10),
                      borderSide: new BorderSide(),
                      ),
                      labelText: 'Enter email id',
                      labelStyle: GoogleFonts.montserrat()
                  ),
                ),

               SizedBox(height: 15,),

                TextFormField(
                  obscureText: true,
                  keyboardType: TextInputType.emailAddress,
                  key: ValueKey('password'),
                  validator: (value){
                    if(value!.isEmpty)
                      {
                        return 'Incorrect Password';
                      }
                    else
                      return null;
                  },

                  onSaved: (value){
                    password = value!;
                  },
                  
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(10),
                      borderSide: new BorderSide(),
                      ),
                      labelText: 'Enter password',
                      labelStyle: GoogleFonts.montserrat()
                  ),
                ),

               SizedBox(height: 15,),

                Container(
                  width: double.infinity,
                  height: 70,
                  padding: EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                  ),
                  child: ElevatedButton(

                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                    ),
                    primary: Theme.of(context).primaryColor,
                    ),

                    child: isLoginPage? Text('Log in',
                    style: GoogleFonts.montserrat(fontSize: 18,
                      fontWeight: FontWeight.w500),)
                      : Text('Sign Up',
                      style: GoogleFonts.montserrat(fontSize: 18,
                      fontWeight: FontWeight.w500),
                      ),
                    // shape: RoundedRectangleBorder(
                    //   borderRadius: BorderRadius.circular(10)
                    // ),
                    // color: Theme.of(context).primaryColor,
                    onPressed: (){
                      startAuthentication();
                    })
                    ),

                    SizedBox(height:10),

                    Container(
                    
                      child: TextButton(onPressed: (){
                        setState(() {
                          isLoginPage = !isLoginPage;
                        });
                      },
                      child: isLoginPage? Text('Not a member? Sign up now.',
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                      ),): Text('Already a member?',
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                      )),),
                    ),

              ],
            )),
          )
        ],
      ),
    );
  }
}