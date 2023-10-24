import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg_image/flutter_svg_image.dart';
import 'package:trungtamgiasu/constants/color.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:trungtamgiasu/constants/style.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController message = TextEditingController();
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  User? loggedInUser;
  String? messageText;
  String? question1 = 'Làm thế nào để chuẩn bị cho thực tập thực tế?';
  String? question2 = 'Điều kiện để đi thực tập là gì?';
  String? question3 = 'Tôi có thể tìm kiếm nơi thực tập ở đâu?';
  String? question4 = 'Khi nào bắt đầu diễn ra thực tập thực tế?';
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    final user = _auth.currentUser;
    try {
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  Stream<QuerySnapshot> getChatMessagesStream() {
    return _firestore
        .collection('chats')
        .doc(loggedInUser!.uid)
        .collection('room')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  List<String> botResponses = [];
  Future<String> sendMessageToRasa(String message) async {
    final response = await http.post(
      Uri.parse('http://192.168.2.2:5005/webhooks/rest/webhook'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        {
          'message': message,
        },
      ),
    );
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final botResponse = responseData[0]['text'];
      return botResponse;
    } else {
      throw Exception('Failed to communicate with Rasa server');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        backgroundColor: whiteColor,
        title: const Text('Hỏi Đáp Thực Tập'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: getChatMessagesStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.data!.docs.isEmpty) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () async {
                          await _firestore
                              .collection('chats')
                              .doc(loggedInUser!.uid)
                              .collection('room')
                              .add({
                            'sender': loggedInUser!.email,
                            'text': question1,
                            'timestamp': FieldValue.serverTimestamp(),
                          });
                          await sendMessageToRasa(question1!).then((response) {
                            setState(() {
                              _firestore
                                  .collection('chats')
                                  .doc(loggedInUser!.uid)
                                  .collection('room')
                                  .add({
                                'sender': 'chatbot',
                                'text': response,
                                'timestamp': FieldValue.serverTimestamp(),
                              });
                            });
                          });
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            color: primaryColor,
                            child: Text(
                              question1!,
                              style: TextStyle(
                                fontSize: 15.0,
                                color: whiteColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      InkWell(
                        onTap: () async {
                          await _firestore
                              .collection('chats')
                              .doc(loggedInUser!.uid)
                              .collection('room')
                              .add({
                            'sender': loggedInUser!.email,
                            'text': question2,
                            'timestamp': FieldValue.serverTimestamp(),
                          });
                          await sendMessageToRasa(question2!).then((response) {
                            setState(() {
                              _firestore
                                  .collection('chats')
                                  .doc(loggedInUser!.uid)
                                  .collection('room')
                                  .add({
                                'sender': 'chatbot',
                                'text': response,
                                'timestamp': FieldValue.serverTimestamp(),
                              });
                            });
                          });
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            color: primaryColor,
                            child: Text(
                              question2!,
                              style: TextStyle(
                                fontSize: 15.0,
                                color: whiteColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      InkWell(
                        onTap: () async {
                          await _firestore
                              .collection('chats')
                              .doc(loggedInUser!.uid)
                              .collection('room')
                              .add({
                            'sender': loggedInUser!.email,
                            'text': question3,
                            'timestamp': FieldValue.serverTimestamp(),
                          });
                          await sendMessageToRasa(question3!).then((response) {
                            setState(() {
                              _firestore
                                  .collection('chats')
                                  .doc(loggedInUser!.uid)
                                  .collection('room')
                                  .add({
                                'sender': 'chatbot',
                                'text': response,
                                'timestamp': FieldValue.serverTimestamp(),
                              });
                            });
                          });
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            color: primaryColor,
                            child: Text(
                              question3!,
                              style: TextStyle(
                                fontSize: 15.0,
                                color: whiteColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      InkWell(
                        onTap: () async {
                          await _firestore
                              .collection('chats')
                              .doc(loggedInUser!.uid)
                              .collection('room')
                              .add({
                            'sender': loggedInUser!.email,
                            'text': question4,
                            'timestamp': FieldValue.serverTimestamp(),
                          });
                          await sendMessageToRasa(question4!).then((response) {
                            setState(() {
                              _firestore
                                  .collection('chats')
                                  .doc(loggedInUser!.uid)
                                  .collection('room')
                                  .add({
                                'sender': 'chatbot',
                                'text': response,
                                'timestamp': FieldValue.serverTimestamp(),
                              });
                            });
                          });
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            color: primaryColor,
                            child: Text(
                              question4!,
                              style: TextStyle(
                                fontSize: 15.0,
                                color: whiteColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                    ],
                  );
                }
                print(snapshot.data!.docs);
                final messages = snapshot.data!.docs;
                List<Widget> messageWidgets = [];
                for (var message in messages) {
                  final messageText = message.get('text');
                  final messageSender = message.get('sender');
                  final isMe = messageSender == loggedInUser!.email;
                  final messageWidget = Column(
                    crossAxisAlignment: isMe
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: <Widget>[
                      Material(
                        borderRadius: BorderRadius.circular(10.0),
                        elevation: 5.0,
                        color: isMe ? primaryColor : Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 15.0,
                          ),
                          child: Text(
                            '$messageText',
                            style: TextStyle(
                              color: isMe ? Colors.white : Colors.black87,
                              fontSize: 15.0,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      Text(
                        messageSender,
                        style: const TextStyle(
                          fontSize: 12.0,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                    ],
                  );
                  messageWidgets.add(messageWidget);
                }
                return Expanded(
                  child: ListView(
                    reverse: true,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 3.0, vertical: 3.0),
                    children: messageWidgets,
                  ),
                );
              },
            ),
            // Expanded(
            //   child: ListView.builder(
            //     reverse: true,
            //     itemCount: botResponses.length,
            //     itemBuilder: (context, index) {
            //       return ListTile(
            //         title: Text(botResponses[index]),
            //       );
            //     },
            //   ),
            // ),

            Container(
              padding: const EdgeInsets.only(left: 7),
              height: 55,
              decoration: BoxDecoration(
                  color: cardsLite,
                  border: Border.all(width: 1, color: Colors.grey),
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // const SizedBox(
                  //   width: 10,
                  // ),
                  Expanded(
                    child: TextFormField(
                      validator: (value) {
                        return null;
                      },
                      onChanged: (newValue) {},
                      controller: message,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Bạn có thắc mắc gì ?',
                        hintStyle: TextStyle(color: priceColor),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      await _firestore
                          .collection('chats')
                          .doc(loggedInUser!.uid)
                          .collection('room')
                          .add({
                        'sender': loggedInUser!.email,
                        'text': message.text,
                        'timestamp': FieldValue.serverTimestamp(),
                      });
                      await sendMessageToRasa(message.text).then((response) {
                        setState(() {
                          _firestore
                              .collection('chats')
                              .doc(loggedInUser!.uid)
                              .collection('room')
                              .add({
                            'sender': 'chatbot',
                            'text': response,
                            'timestamp': FieldValue.serverTimestamp(),
                          });
                        });
                      });
                      message.clear();
                    },
                    icon: const Icon(Icons.send),
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
