import 'dart:ffi';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myfirst/Pages/home.dart';
class  LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email, _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      body: Form(
        key: _formKey,
        child: Column(
           children: <Widget>[
            TextFormField(
              validator:(input){
              if (input.isEmpty) {
                  return 'Please type an email';
                }
              },
              onSaved: (input) => _email = input,
              decoration: InputDecoration(
                labelText: 'Email',
              ),

            ),
            TextFormField(
              validator: (input) {
                if (input.length < 6) {
                  return 'Your password need to be atleast 6 characters';
                }
              },
              onSaved: (input) => _password = input,
              decoration: InputDecoration(
                  labelText: 'Password'
              ),
              obscureText: true,

            ),
            RaisedButton(
              onPressed: signIn,
              child: Text('Sign In'),
            )
          ],
        ),
      ),
    ); // This trailing comma makes auto-formatting nicer for build methods.
  }
Future<void> signIn()async{
  final formState = _formKey.currentState;
  if(formState.validate()){

    }
    formState.save();
     try{
AuthResult result = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password);
FirebaseUser user = result.user;
   Navigator.push(context, MaterialPageRoute(builder: (context)=> Home(user: user)));
      }catch(e){
        print(e.message);

      }

  }

  }
