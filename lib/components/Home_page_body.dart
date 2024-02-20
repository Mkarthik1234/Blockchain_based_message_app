import 'dart:js_util';

import 'package:flutter/material.dart';
import 'package:block_talk_v2/Services/metamask_connect.dart';
import 'Chat_window.dart';

class User {
  late String address, name;

  User({required this.address, required this.name});
}

class MessageScreen extends StatefulWidget {
  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  late Future<List<User>> _futureUsers;
  bool freinds_exists = false;
  var selectedFriend;
  Homecontroller h = Homecontroller();

  Future<List<User>> fetchUsers() async {
    List<User> users = [];
    Homecontroller h = Homecontroller();
    List<dynamic> userdata = await h.getcontract("getMyFriendList", []);
    print("user data is $userdata");
    if (!userdata.isEmpty) {
      print("inside if");
      freinds_exists = true;
      print("Inside fetchuser else");
      List<List<dynamic>> userList = userdata.cast<List<dynamic>>();
      users = userList.map((data) {
        return User(address: data[0], name: data[1]);
      }).toList();
      print("Inside fetchuser");
    }
    return users;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _futureUsers = fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: <Widget>[
          FutureBuilder<List<User>>(
              future: _futureUsers,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text("Error ${snapshot.error}"),
                  );
                } else if (freinds_exists == true) {
                  List<User> Friends = snapshot.data!;
                  print(Friends[0].name);
                  return Expanded(
                    flex: 2,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[300],
                      ),
                      child: ListView.builder(
                        padding: const EdgeInsets.all(10),
                        itemCount: Friends.length,
                        itemBuilder: (context, index) {
                          final friend = Friends[index];
                          print(friend.name);
                          return FriendCard(
                            name: friend.name,
                            address: friend.address,
                            setStateCallback: () {
                              setState(() {
                                selectedFriend = friend;
                              });
                            },
                          );
                        },
                      ),
                    ),
                  );
                } else if (freinds_exists == false) {
                  return Container(
                      color: Colors.grey[500],
                      child: const Text(
                        "",
                        style: TextStyle(color: Colors.black),
                      ));
                } else {
                  return const Text("null");
                }
              }),
          SizedBox(width: 10,),
          Expanded(
            flex: 5,
            child: Container(
              color: Colors.white,
              child: selectedFriend != null
                  ? ChatPage(
                      contactName: selectedFriend.name,
                      contactAddress: selectedFriend.address)
                  : freinds_exists
                      ? const Center(
                          child: Text(
                            'Select a friend to start chatting',
                            style: TextStyle(fontSize: 20.0),
                          ),
                        )
                      : const Center(
                        child: Text(
                            'No Friends',
                            style: TextStyle(fontSize: 20.0),
                          ),
                      ),
            ),
          ),
        ],
      ),
    );
  }
}

class FriendCard extends StatelessWidget {
  String name;
  String address;
  VoidCallback setStateCallback;

  FriendCard(
      {required this.name,
      required this.address,
      required this.setStateCallback});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.person),
        title: Text(name),
        onTap: setStateCallback,
      ),
    );
  }
}
