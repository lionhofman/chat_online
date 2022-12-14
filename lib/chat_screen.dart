import 'dart:io';
import 'package:chat_online/chat_message.dart';
import 'package:chat_online/text_composer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoggedIn = false;
  bool isLoading = false;
  User? _currentUser;
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((user) {
      setState(() {
        _currentUser = user;
        isLoggedIn = checkUserIsLoggedIn();
      });
    });
  }

  bool checkUserIsLoggedIn() {
    return _currentUser != null;
  }

  Future<User?> _getUser() async {
    if (_currentUser != null) return _currentUser;
    try {
      //get user Google sign in data
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      // Google authentication data
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      // firebase credential data
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken,
      );
      // firebase login
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      //Firebase user data
      final User? user = userCredential.user;
      return user;
    } catch (error) {
      return null;
    }
  }

  //input message in firebase
  void _sendMessage(
      {String? text,
      PickedFile? imgFile,
      required BuildContext context}) async {
    final User? user = await _getUser();
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("N??o foi poss??vel fazer o Login. Tente novamente!"),
        backgroundColor: Colors.red,
      ));
    }
    Map<String, dynamic> data = {
      "uid": user!.uid,
      "senderName": user.displayName,
      "senderPhotoUrl": user.photoURL,
      "time": Timestamp.now(),
    };
    if (imgFile != null) {
      File io = File(imgFile.path);
      UploadTask task = FirebaseStorage.instance
          .ref()
          .child(user.uid + DateTime.now().microsecondsSinceEpoch.toString())
          .putFile(io);
      setState(() {
        isLoading = true;
      });
      await task.whenComplete(() async {
        data['imgUrl'] = await task.snapshot.ref.getDownloadURL();
      });

      setState(() {
        isLoading = false;
      });
    }
    if (text != null) data['text'] = text;
    FirebaseFirestore.instance.collection("messages").add(data);
  }

  //read msg from firebase in real time
  StreamBuilder<QuerySnapshot> _streamBuilder() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('messages')
          .orderBy('time', descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
            reverse: true,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: ((context, index) {
              Map<String, dynamic> data =
                  snapshot.data!.docs[index].data()! as Map<String, dynamic>;
              return ChatMessage(
                data: data,
                mine: data['uid'] == _currentUser?.uid,
              );
            }));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title:
            Text(isLoggedIn ? 'Ol??, ${_currentUser!.displayName}' : 'Chat App'),
        elevation: 0,
        centerTitle: true,
        actions: [
          isLoggedIn
              ? IconButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    googleSignIn.signOut();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Voc?? saiu com sucesso!"),
                    ));
                  },
                  icon: const Icon(Icons.exit_to_app))
              : Container(),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: _streamBuilder()),
          isLoading ? const LinearProgressIndicator() : Container(),
          TextComposer(
            sendMessage: _sendMessage,
          ),
        ],
      ),
    );
  }
}
