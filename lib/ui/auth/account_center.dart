// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:sortfood/model/aaconst.dart';
import 'package:sortfood/model/users.dart';
import 'package:sortfood/ui/list_settings.dart';

class AccountCenter2 extends StatefulWidget{
  const AccountCenter2({super.key});

  @override
  State<AccountCenter2> createState() => _AccountCenter();
}

class _AccountCenter extends State<AccountCenter2>{

  Users user = Users();

  TextEditingController userName = TextEditingController();
  TextEditingController passWord = TextEditingController();
  TextEditingController emailControl = TextEditingController();

  @override
  void initState() {
    user = Users(
      name: "Luu Chinh Thuan",
      email: "than@gmail.com",
      password: "123456789",
      phone: "0123456789",
      img: "lib/assets/icon/arvarta.png"
    );
    userName.text = user.name!;
    passWord.text = user.password!;
    emailControl.text = user.email!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.light(), 
      child: Scaffold(
        appBar: _header(context),
        body: const SettingsList(),
      )
    );
  }

  PreferredSize _header(BuildContext context){
    return PreferredSize(
      preferredSize: Size.fromHeight(getMainHeight(context)/3), 
      child: SafeArea(
        child: Container(
          width: getMainHeight(context),
          margin: const EdgeInsets.only(left: 10, right: 10),
          padding: const EdgeInsets.all(10),

          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(color: Colors.black26, width: 1)
            ),
          ),

          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,

              children: [
                //image
                Stack(
                  children: [
                    
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: SizedBox(
                        width: 150,
                        height: 150,

                        child: Image.asset(user.img!, fit: BoxFit.cover,),
                      ),
                    ),
                    Positioned(
                      bottom: -5,
                      right: 0,
                      child: IconButton(
                        onPressed: () {
                          _showEdit(context);
                        },

                        icon: Container(
                          width: 40,
                          height: 40,
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(100)),
                          child: const Center(child: Icon(Icons.edit, size: 20, color: Colors.white,),),
                        ),
                      )
                    ),

                  ],
                ),

                //username
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),

                  child: Center(
                    child: Text(user.name!, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 25),),
                  ),
                ),

                //phonenumber
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(left: 10, right: 10),

                  child: Center(
                    child: Text(phoneFormated(user.phone!), style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 17),),
                  ),
                )
              ],
            ),
          ),
        )
      )
    );
  }

  Future<dynamic> _showEdit(BuildContext context){
    return QuickAlert.show(
      context: context, 
      type: QuickAlertType.custom,
      confirmBtnText: 'Update',
      // customAsset: 'assets/logo_icon/noimg_1.png',
      widget: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: const ScrollPhysics(),
        child: Container(
          // width: getMainWidth(context),
          padding: EdgeInsets.zero,

          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              _imgEdit(context),
              const SizedBox(height: 20,),
              InputFieldCustom(controller: userName, hintText: 'Your username', isObsucre: false),
              InputFieldCustom(controller: passWord, hintText: 'Your password', isObsucre: false),
              InputFieldCustom(controller: emailControl, hintText: 'Your email', isObsucre: false),
            ],
          ),
        ),
      ),
      onConfirmBtnTap: () => setState(() {
        
      }),
    );
  } 

  Widget _imgEdit(BuildContext context){
    return Container(
      width: getMainWidth(context)-100,
      height: 200,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(width: double.infinity, child: Image.asset(user.img!, fit: BoxFit.cover,),),
          ),
          Positioned(
            bottom: 1,
            left: 1,
            child: Container(
              // width: double.infinity,
              height: 50,
              padding: const EdgeInsets.only(left: 20, right: 20),
              decoration: BoxDecoration(
                color: Colors.black12.withOpacity(0.5),
                borderRadius: BorderRadius.circular(10)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //img name
                  // Text(user.imgName!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),),
                  // const SizedBox(width: 20,),
                  //edit btn
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Colors.white),
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: const Text('Edit', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),),
                  )
                ],
              ),
            )
          )
        ],
      ),
    );
  }

}