


import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import '../../../../global/common/toast.dart';
import '../widgets/footer.dart';
import 'login.dart';


class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _textController = TextEditingController();
  String _message = '';
  bool _isLoading = false; // Add this line

  Future<void> _sendMessage(String text) async {
    setState(() {
      _isLoading = true; // Show the loader
    });
    _textController.clear();

    final response = await http.get( Uri.parse('https://merd-api.merakilearn.org/developers/chatbot?message=$text'));
    if (response.statusCode == 200) {
      setState(() {
        _isLoading = false; // Hide the loader
        _message = response.body; // Update the message with the response
      });
    } else {
      throw Exception('Failed to send message');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        actions: [
          Card(
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.logout),
                    tooltip: "Log-out",
                    onPressed: () {
                      Hive.box('user').delete('user');
                      Hive.box('user').delete('ai_course');
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder:(context) => const LoginPage() ), (route)=> false);
                      showToast(message: 'Logout Successfull');
                    },
                  ),
                ],
              )
          )
        ],
        title: const  Text('Abhyas AI ( ask questions )', style: TextStyle( color: Colors.black54 , fontSize: 20, fontWeight: FontWeight.bold,fontFamily: AutofillHints.familyName),),
      ),
    body:SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: <Widget>[
              Text(
                "AI🤖: $_message", // Display the message
                style: const TextStyle(
                  fontSize: 20.0,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (_isLoading) const CircularProgressIndicator(), // Add this line
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _textController,
                  onSubmitted: _sendMessage,
                  decoration: InputDecoration(
                    hintText: "Send a message",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11.0),
                    ),
                    contentPadding: const EdgeInsets.all(15.0),
                  ),
                  style: const TextStyle(
                    fontSize: 18.0,
                    color: Colors.black,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () => _sendMessage(_textController.text),
              ),
            ],
          ),
        ),
      ),
    bottomNavigationBar: const FooterWidget()
    );
  }
}