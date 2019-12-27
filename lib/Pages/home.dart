import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class Home extends StatefulWidget {
  static const String id = "CHAT";
  const Home({
    Key key,
        @required this.user
      }) : super(key: key);
  final FirebaseUser user;



  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;
  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();
  Future<void> callback()async{
    if(messageController.text.length > 0){
      await
    _firestore.collection('messages').add({
      'text' : messageController.text,
      'from': widget.user.email,
    });
      messageController.clear();
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
         curve: Curves.easeOut,
          duration: const Duration(microseconds: 300),
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home${widget.user.email}'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              _auth.signOut();
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          )

        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('messages').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(
                      child: CircularProgressIndicator(),

                    );
                  List<DocumentSnapshot> docs = snapshot.data.documents;

                  List<Widget> messages = docs.map((doc) => Message(
                  from: doc.data['from'],
                  text: doc.data['text'],
                  me: widget.user.email == doc.data['from'],
                  )).toList();
                  return ListView(
                  controller: scrollController,
                children: <Widget>[
                  ...messages,
                ],
                  );
                },
              ),
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      onSubmitted: (value)=> callback(),
                      decoration: InputDecoration(
                        hintText: " Enter a Message ...",
                        border: const OutlineInputBorder(),
                      ),
                      controller: messageController,

                    ),
                  ),
                  SendButton(
                    text: "Send",
                    callback: callback,

                  )

                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
class SendButton extends StatelessWidget{
  final String text;
  final VoidCallback callback;

  const SendButton({Key key, this.text, this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FlatButton(
      color: Colors.orange,
      onPressed: callback,
      child:  Text(text),
    );
  }

}
class Message extends StatelessWidget {
  final String from;
  final String text;
  final bool me;

  const Message({Key key, this.from, this.text, this.me}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Column(
        crossAxisAlignment:
        me ? CrossAxisAlignment.end: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            from,
          ),
          Material(
            color: me ? Colors.teal : Colors.red,
            borderRadius: BorderRadius.circular(10.0),
            elevation: 6.0,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
              child: Text(
                text,
              ),
            ),


          )
        ],


      ),
    );
  }
}
  /*
      StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance.collection('users')
            .document(widget.user.uid)
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          else if  (!snapshot.hasData) {
            return Text('Loading');
          } else {

            print(widget.user.uid);
            return Text(snapshot.data['name']);

            /*  }
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Text('Loading');
            default:*/
            //          return checkRole(snapshot.data);
          }
        },
      ),
    );
  }
}
/*
 Center checkRole(DocumentSnapshot snapshot) {
    if (snapshot.data['role'] == 'admin') {
      return adminPage(snapshot);
    } else {
      return userPage(snapshot);
    }
  }

  Center adminPage(DocumentSnapshot snapshot) {
    return Center(child: Text(snapshot.data['role'] + 'PAGE'));
  }

  Center userPage(DocumentSnapshot snapshot) {
    return Center(child: Text(snapshot.data['name']));
  }
}
*/
    */