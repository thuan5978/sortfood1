

import 'package:flutter/material.dart';
import 'package:sortfood/model/aaconst.dart';
import 'package:sortfood/model/users.dart';
import 'package:sortfood/ui/auth/signIn.dart';
import 'package:sortfood/ui/home_page.dart';

class WaitingPage extends StatefulWidget{
  const WaitingPage({super.key});

  @override
  State<WaitingPage> createState() => _WaitingPage();
}

class _WaitingPage extends State<WaitingPage>{

  final user = Users();

  Future<bool> _checkData(BuildContext context) async{
    try{
      await Future.delayed(const Duration(seconds: 3));
      return false;
    }
    catch(e){
      rethrow;
    }
  }

  goPage(BuildContext context, Widget widget){
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => widget));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: getMainWidth(context),
      height: getMainHeight(context),
      padding: const EdgeInsets.all(10),
      color: mainColor,
      child: FutureBuilder<bool>(
        future: _checkData(context),
        builder: (context, snapshot) {
          if(snapshot.connectionState==ConnectionState.waiting){
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,

              children: [
                //icon title
                Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(color: Colors.white, offset: Offset(-10, 10), blurRadius: 20)
                    ]
                  ),

                  child: Image.asset('lib/assets/icon/logo.png', fit: BoxFit.cover,),
                ),
                const SizedBox(height: 50,),

                const Center(child: CircularProgressIndicator(backgroundColor: Colors.transparent, color: Colors.white,),),
              ],
            );
          }
          else if(snapshot.data==null){
            goPage(context, const SignIn());
            return const Center(child: SizedBox(),);
          }
          else if(snapshot.data!){
            goPage(context, const HomePage());
            return const Center(child: SizedBox(),);
          }
          else{
            goPage(context, const SignIn());
            return const Center(child: SizedBox(),);
          }
        },
      )
    );
  }

}