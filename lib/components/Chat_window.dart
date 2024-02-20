import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:block_talk_v2/Services/metamask_connect.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatPage extends StatefulWidget {
  final String contactName, contactAddress;

  const ChatPage(
      {Key? key, required this.contactName, required this.contactAddress})
      : super(key: key);

  @override
  _ChatPageState createState() =>
      _ChatPageState(contactAddress: contactAddress, contactName: contactName);
}

class _ChatPageState extends State<ChatPage> {
  String contactAddress, contactName;
  late String current_user;
  List<Message> messages = []; // a list of messages
  final TextEditingController _textController =
      TextEditingController(); // a controller for the text field

  _ChatPageState({required this.contactAddress, required this.contactName});

  Timer? _timer;

  @override
  void initState() {
    super.initState(); // Fetch messages when the page initializes
    // Start a timer to periodically fetch messages
  }

  @override
  void dispose() {
    _timer
        ?.cancel(); // Cancel the timer when the widget is disposed to prevent memory leaks
    super.dispose();
  }

  // Function to fetch messages asynchronously
  Future<void> fetchMessages() async {
    final pref = await SharedPreferences.getInstance();
    current_user = pref.getString("current_user_address")!;

    Homecontroller h = Homecontroller();
    List<dynamic> messagedata =
        await h.getcontract("readMessage", [widget.contactAddress]);

    List<List<dynamic>> messageList = messagedata.cast<List<dynamic>>();
    setState(() {
      messages = messageList.map((data) {
        bool issender = false;
        if (data[0].toString().toLowerCase().compareTo(current_user) == 0) {
          issender = true;
        }
        return Message(
            senderName: contactName, text: data[2], isSender: issender);
      }).toList();
    });
    if (!messages.isNotEmpty) {
      _timer?.cancel();
    }
  }

  Future<void> sendMessage() async {
    Homecontroller h = Homecontroller();
    await h.getcontract("sendMessage", [widget.contactAddress, _textController.text]);
    _textController.clear();
    setState(() {
      messages.clear();
    });
    _timer = Timer.periodic(Duration(seconds: 5), (Timer t) => fetchMessages());
  }

  @override
  Widget build(BuildContext context) {
    fetchMessages();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Container(
                height: 60,
                color: Colors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.contactName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: messages.isEmpty
                    ? const Center(
                        child: Text(
                          "No messages yet.",
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          Message message = messages[index];
                          return Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Container(
                              width: 1000,
                              height: 80,
                              child: ChatBubble(
                                padding: EdgeInsets.all(10),
                                clipper: message.isSender
                                    ? ChatBubbleClipper5(
                                        type: BubbleType.sendBubble)
                                    : ChatBubbleClipper5(
                                        type: BubbleType.receiverBubble),
                                alignment: message.isSender
                                    ? Alignment.topRight
                                    : Alignment.topLeft,
                                margin: const EdgeInsets.only(top: 20),
                                backGroundColor: message.isSender
                                    ? Colors.blue
                                    : Colors.grey.shade200,
                                child: Container(
                                  constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width * 0.7),
                                  child: Column(
                                    crossAxisAlignment: message.isSender
                                        ? CrossAxisAlignment.end
                                        : CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        message.isSender
                                            ? "You"
                                            : message.senderName,
                                        style: TextStyle(
                                          color: message.isSender
                                              ? Colors.white
                                              : Colors.black,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        message.text,
                                        style: TextStyle(
                                          color: message.isSender
                                              ? Colors.white
                                              : Colors.black,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
              Container(
                color: Colors.grey[300],
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        decoration: InputDecoration(// Background color
                          hintText: 'Type a message',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0), // Adjust the value as needed
                            borderSide: BorderSide.none, // No border
                          ),
                          // Add other InputDecoration properties as needed
                        ),
                      )
                    ),
                    IconButton(
                      icon: const Icon(Icons.send, color: Colors.blue),
                      onPressed: () {
                        setState(() async {
                          await sendMessage();
                        });
                        // Send the message and update the chat window
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Message {
  final String senderName;
  final String text;
  final bool isSender;

  Message({
    required this.senderName,
    required this.text,
    required this.isSender,
  });
}
