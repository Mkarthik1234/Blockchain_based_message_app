import 'package:flutter/material.dart' ;
import 'package:block_talk_v2/Services/metamask_connect.dart';

class Login extends StatefulWidget {
  String? user_address;
  Login({this.user_address});

  @override
  State<Login> createState() => _LoginState(user_address: user_address);
}

class _LoginState extends State<Login> {

  String? user_address;
  _LoginState({this.user_address});

  TextEditingController usernamecontroller=new TextEditingController();
  TextEditingController addresscontroller=new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(

      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Colors.blue,
                Colors.red
              ]
          )
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
            padding: const EdgeInsets.fromLTRB(100, 50, 100, 20),
            child: _Page()),
      ),
    );
  }

  Widget _Page() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _Icon(),
          const SizedBox(
            height: 50,
          ),
          _Input("Enter User name",usernamecontroller),
          const SizedBox(
            height: 20,
          ),
          _Input("",addresscontroller)
          ,const SizedBox(
            height: 50,
          ),
          _Button("Register")
        ],

      ),
    );
  }
  Widget _Icon() {
    return Container(
      child: const Icon(
        Icons.message_rounded,
        size: 250,
        color: Colors.white,
      ),
    );
  }

  Widget _Input(String hinttext,TextEditingController controller,{ispassword=false}){
    addresscontroller.text = user_address.toString();
    var border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: const BorderSide(color:Colors.white),
    );
    return TextField(
      obscureText: ispassword,
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hinttext,
        hintStyle: const TextStyle(color: Colors.white),
        enabledBorder: border,
        focusedBorder: border,
      ),
    );
  }

  Widget _Button(String text){
    return  SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async{
          Homecontroller h = Homecontroller();
          print("[registration] User address is $user_address");
          await h.getcontract("createAccount", [usernamecontroller.text]);
          print("account created");
        },
        child:Text(text,
          style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold
          ),),
        style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            primary: Colors.white,
            onPrimary: Colors.blue,
            padding: const EdgeInsets.symmetric(vertical: 16)
        ),
      ),
    );
  }

}