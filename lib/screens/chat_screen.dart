// Suggested code may be subject to a license. Learn more: ~LicenseLog:2336468650.
// Suggested code may be subject to a license. Learn more: ~LicenseLog:1509007251.
// Suggested code may be subject to a license. Learn more: ~LicenseLog:989453540.
// Suggested code may be subject to a license. Learn more: ~LicenseLog:1486904803.
// Suggested code may be subject to a license. Learn more: ~LicenseLog:1385513308.
// Suggested code may be subject to a license. Learn more: ~LicenseLog:3929000384.

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final gemini = Gemini.instance;
  final List<ChatMessage> _messages = [];
   

  final TextEditingController _messageController = TextEditingController();

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        _messages.add(
          ChatMessage(
            messageContent: _messageController.text,
            messageType: "sender",
          ),
        );
        _messageController.clear();
      });
      List<Content> _massage = [];

      for (var item in _messages) {
        _massage.add(Content(parts: [Part.text(item.messageContent)], role: item.messageType == "sender" ? "user" : "model"));
      }
      if(_massage.isEmpty){
        _massage = [
            Content(
              parts: [
                Part.text(
                  'Write the first line of a story about a magic backpack.',
                ),
              ],
              role: 'user',
            ),
        ];
      }
      gemini.chat(_massage).then((value) {
        setState(() {
          _messages.add(ChatMessage(messageContent: value!.output!, messageType: "receiver"));
        });

        log(value?.output ?? 'without output');
      })
          .catchError((e) => log('chat', error: e));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Navigation Drawer',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(title: Text('workout')),
            ListTile(title: Text('tetorial')),
            ListTile(title: Text('diet')),
            ListTile(title: Text('plain')),
          ],
        ),
      ),
      drawerScrimColor: theme.colorScheme.onSurface.withOpacity(0.5),

      appBar: AppBar(title: Text("Chat")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: false,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ChatBubble(message: _messages[index]);
              },
            ),
          ),
          _buildMessageComposer(),
        ],
      ),
    );
  }

  Widget _buildMessageComposer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      height: 70.0,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: "Send a message...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          IconButton(icon: Icon(Icons.send), onPressed: _sendMessage),
        ],
      ),
    );
  }
}

class ChatMessage {
  String messageContent;
  String messageType;
  ChatMessage({required this.messageContent, required this.messageType});
}

class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Align(
        alignment:
            message.messageType == "receiver"
                ? Alignment.topLeft
                : Alignment.topRight,
        child: Container(
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color:
                message.messageType == "receiver"
                    ? Colors.grey.shade300
                    : Colors.blue.shade200,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Text(message.messageContent),
        ),
      ),
    );
  }
}
