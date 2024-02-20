import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' ;
import 'package:block_talk_v2/Services/metamask_connect.dart';
import 'package:block_talk_v2/components/metamask_error.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:block_talk_v2/pages/loginscreen.dart';
import 'profilescreen.dart';
import 'package:block_talk_v2/components/Home_page_body.dart';
import 'package:block_talk_v2/components/Select_user.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isregistered = false;
  bool isconnected_metamask = false;
  String? current_address,user_name;
  Homecontroller h = Homecontroller();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //check whether the metamask installed or not
    WidgetsBinding.instance.addPostFrameCallback((_) { Initialise(); });
  }

  void Initialise() async{
    final pref = await SharedPreferences.getInstance();
    await pref.setString("current_user_address", "");
    if (!h.isEnabled) {
      showDialog(
        context: context,
        builder: (context) => MetamaskErrorCustomDialogBox(),
      );
    }
    else{
      await h.connect();
      await Connected_to_Metamask();
      var result = await h.getcontract("checkUserExists",[current_address.toString()]);
      if(result == true){
        setState(() {
          isregistered = true;
        });
      }
      result = await h.getcontract("getUsername", [current_address.toString()]);
      setState(() {
        user_name = result.toString();
      });

    }
  }

  Future<void> Connected_to_Metamask() async {
    final pref = await SharedPreferences.getInstance();
    current_address = pref.getString("current_user_address");
    print("value is $current_address");
    if(current_address==""){
      isconnected_metamask = false;
    }
    else{
      isconnected_metamask = true;
    }
  }

  Future<void> Registered() async {
    final result = await h.getcontract("checkUserExists",[current_address.toString()]);
    if(result == true){
      isregistered = true;
    }
    else{
      isregistered = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appbar
      appBar: AppBar(
        leading: Icon(CupertinoIcons.home),
        title: const Text('Block Chat'),
        actions: [
          //search user button
          isregistered?MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: (){
                  showDialog(context: context, builder: (context)=>Profile(user_name: user_name,user_address: current_address,));
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.grey[300]
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: Row(
                      children: [Icon(Icons.person),Divider(color: Colors.black),Text(user_name.toString())],
                    ),
                  ),
                ),
              ),
            ),
          )
          :IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>Login(user_address:current_address)));

          }, icon: const Icon(Icons.app_registration))
        ],
      ),
      //floating button to add new user
      floatingActionButton: FloatingActionButton(onPressed: (){
          showDialog(context: context, builder: (context)=>UserList());
        },child: const Icon(Icons.add_comment_sharp)),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      body:MessageScreen(),
    );
  }
}


