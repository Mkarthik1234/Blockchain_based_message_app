import 'package:flutter/material.dart';
import 'package:block_talk_v2/Services/metamask_connect.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  final String name;
  final String accountAddress;

  User({
    required this.name,
    required this.accountAddress,
  });
}

Future<List<User>> fetchUsers() async {
  Homecontroller h = Homecontroller();
  // List<User> result = await h.getcontract("getAllAppUser", []) as List<User>;
  // return result;

  List<dynamic> userdata = await h.getcontract("getAllAppUser", []);
  print(userdata);

  List<List<dynamic>> userList = userdata.cast<List<dynamic>>();

  List<User> users = userList.map((data) {
    return User(name: data[0], accountAddress: data[1]);
  }).toList();

  return users;
}

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  late Future<List<User>> _futureUsers;

  @override
  void initState() {
    super.initState();
    _futureUsers = fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<User>>(
      future: _futureUsers,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          List<User> users = snapshot.data!;
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(20),
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  User user = users[index];
                  return UserCard(user: user);
                },
              ),
            ),
          );
        }
      },
    );
  }
}

addFriend(String address, String name) async {
  Homecontroller h = Homecontroller();
  await h.getcontract("addFriend", [address, name]);
}

Future<String?> getcurrentuser() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  final current_address = sharedPreferences.getString("current_user_address");
  return current_address;
}

class UserCard extends StatelessWidget {
  final User user;

  const UserCard({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: getcurrentuser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            print("inside");
            final String? currentUser = snapshot.data;
            bool isCurrentUser = currentUser?.toLowerCase() == user.accountAddress.toLowerCase();
            print("$currentUser,${user.accountAddress}");
            if (!isCurrentUser) {
              print("inside if");
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(
                    user.name,
                    style: const TextStyle(color: Colors.black),
                  ),
                  subtitle: Text(user.accountAddress),
                  trailing: IconButton(
                    onPressed: () async {
                      await addFriend(user.accountAddress, user.name);
                      const snackBar =
                      SnackBar(content: Text("Friend added successfully"),behavior: SnackBarBehavior.floating,);
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                    icon: const Icon(Icons.person_add_alt_1_rounded),
                  )// Add your button here if needed
                ),
              );
            } else {
              print("inside else");
              return Container();
            }
          }
        }
      },
    );
  }
}
