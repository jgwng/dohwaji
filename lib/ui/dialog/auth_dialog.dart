import 'package:dohwaji/core/resources.dart';
import 'package:dohwaji/ui/widget/color_tft.dart';
import 'package:dohwaji/ui/widget/default_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

void showSignUpDialog(BuildContext context){
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return SignUpDialog();
    },
  );
}
class SignUpDialog extends StatefulWidget{
  @override
  _SignUpDialogState createState() => _SignUpDialogState();
}

class _SignUpDialogState extends State<SignUpDialog>{
  TextEditingController? pwConfirm;
  TextEditingController? email;
  TextEditingController? password;

  FocusNode? pwConfirmNode;
  FocusNode? emailNode;
  FocusNode? pwNode;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pwConfirm = TextEditingController();
    email = TextEditingController();
    password = TextEditingController();

    pwConfirmNode = FocusNode();
    emailNode = FocusNode();
    pwNode = FocusNode();

  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: Dialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))
          ),
          child: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(0),
                  margin: const EdgeInsets.only(top: 10,left: 10,right: 10),
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    splashColor: Colors.transparent,
                    child: SvgPicture.asset('assets/icons/ic_32_close.svg'),
                  )
                ),
                const Center(
                  child: Text('회원가입',style: TextStyle(
                      fontFamily: AppFonts.bold,
                      fontWeight : FontWeight.w700,fontSize: 20),),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15,bottom: 10),
                  child: Divider(color: Colors.grey[200],height: 1,thickness: 1),
                ),
                ColorTFT(labelText: '이메일', controller: email!,focusNode: emailNode,function: (String text) {},
                  submitFunction: (String? text) => emailNode!.requestFocus(pwNode),),
                ColorTFT(labelText: '비밀번호', controller: password!,focusNode: pwNode,function: (String text) {},obscureText: true,
                  submitFunction: (String? text) {},),
                ColorTFT(labelText: '비밀번호 확인', controller: pwConfirm!,focusNode: pwConfirmNode,function: (String text) {},
                  submitFunction: (String? text){},),
                const SizedBox(
                  height: 60,
                ),
                DefaultButton(
                    horizontalMargin: 20,
                    btnText: '회원가입',
                    onTap: () async{
                     Navigator.pop(context);
                }),
              ],
            ),
          )),
    );
  }

}