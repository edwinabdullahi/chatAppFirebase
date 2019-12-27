import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myfirst/Setup/signIn.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
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
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) => _email = value,
              validator: (input) {
                if (input.isEmpty) {
                  return 'Please type an email';
                }
              },
              onSaved: (input) => _email = input,
              decoration: InputDecoration(
                hintText: 'Enter Your Email ...',
                labelText: 'Email',
              ),

            ),
            TextFormField(
              autocorrect: false,


              onChanged: (value)=> _password = value,
              validator: (input) {
                if (input.length < 6) {
                  return 'Your password need to be atleast 6 characters';
                }
              },
              onSaved: (input) => _password = input,
              decoration: InputDecoration(
                hintText: 'Enter Your Password ...',
                  labelText: 'Password'
              ),
              obscureText: true,

            ),
            RaisedButton(
              onPressed: signUp,
              child: Text('Sign up'),
            )
          ],
        ),
      ),
    ); // This trailing comma makes auto-formatting nicer for build methods.
  }

  void signUp() async {
    //final formState = _formKey.currentState;
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _email, password: _password);
        //FirebaseUser user = result.user;
        // user.sendEmailVerification();
//      Navigator.of(context).pop();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      } catch (e) {
        print(e.message);
      }
    }
  }
}