import 'package:flutter/material.dart';

double getMainHeight(BuildContext context){
  return MediaQuery.of(context).size.height;
}

double getMainWidth(BuildContext context){
  return MediaQuery.of(context).size.width;
}

Color mainColor = const Color(0xFFFFA62F);
Color secondaryColor = const Color(0xFFFFC96F);



String phoneFormated(String phone){
  if(phone.length==10){
    return '${phone.substring(0, 4)}-${phone.substring(4, 7)}-${phone.substring(7, 10)}';
  }else{return '';}
}

class InputFieldCustom extends StatelessWidget{

  final TextEditingController controller;
  final String hintText;
  final bool isObsucre;
  const InputFieldCustom({super.key, required this.controller, required this.hintText, required this.isObsucre});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(left: 10, right: 10),
      padding: const EdgeInsets.all(5),

      child: TextFormField(
        controller: controller,
        obscureText: isObsucre,

        decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            borderSide: BorderSide(color: secondaryColor, width: 1, style: BorderStyle.solid)
          ),
        ),
      ),
      
    );
  }

}