import 'dart:html';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
class MetamaskErrorCustomDialogBox extends StatelessWidget {
  const MetamaskErrorCustomDialogBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Stack(
        children: [
          CardDialog(),
          Positioned(
              top: 0,
              right: 0,
              height: 25,
              width: 25,
              child: OutlinedButton(
            onPressed: (){
              Navigator.of(context).pop();
            },
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.all(0),
              shape: CircleBorder(),
              elevation: 0,
              backgroundColor:Colors.white,
            ),
            child: Icon(Icons.cancel,color: Colors.red[500],size: 25,),
          ))
        ],
      ),
    );
  }
}

class CardDialog extends StatelessWidget {
  const CardDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
      decoration: BoxDecoration(
          color: Colors.grey[800], borderRadius: BorderRadius.circular(15)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('images/alert_symbol2.png', width: 120
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            "Alert",
            style: TextStyle(
                color: Colors.red[500],
                fontSize: 30,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 30,
          ),
          RichText(
            text: TextSpan(children: [
              TextSpan(
                  text: "Metamask",
                  style: TextStyle(
                      color: Colors.red[500], fontWeight: FontWeight.bold, fontSize: 20)),
              TextSpan(text:" is not installed please install the extension ",style: TextStyle(color: Colors.white)),
              TextSpan(text: ":)",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 20))
            ]),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 10,
          ),
          InkWell(
              child: Text("For more details click here",textAlign: TextAlign.center,style: TextStyle(color: Colors.blue,fontSize: 13),),
            onTap: ()=>launch('https://support.metamask.io/hc/en-us/articles/360015489531-Getting-started-with-MetaMask'),
          )
        ],
      ),
    );
  }
}
