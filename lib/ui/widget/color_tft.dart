import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ColorTFT extends StatefulWidget {

  final TextEditingController? controller;
  final String labelText;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final Icon? suffixIcon;
  final bool obscureText;
  final FocusNode? focusNode;
  final Function(String)? function;
  final Function(String)? submitFunction;

  const ColorTFT({required this.labelText, this.validator,this.controller,this.focusNode,this.submitFunction,
    this.function, this.suffixIcon, this.obscureText = false, this.keyboardType});

  @override
  _ColorTFTState createState() => _ColorTFTState();
}

class _ColorTFTState extends State<ColorTFT>{
  bool? isObscureText;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isObscureText = widget.obscureText;
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56,
      margin: EdgeInsets.only(top:20,left:20,right:20),
      child: TextFormField(
        obscureText: isObscureText!,
        keyboardType: widget.keyboardType,
        controller: widget.controller ?? TextEditingController(),
        focusNode: widget.focusNode ?? FocusNode(),
        cursorColor: Colors.black,
        validator: widget.validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: widget.function,
        onFieldSubmitted: widget.submitFunction,
        decoration: InputDecoration(
          labelText: widget.labelText,
          suffixIcon: isObscureText! ? InkWell(
            onTap: () {
              setState(() {
                isObscureText = !isObscureText!;
              });
            },
            child: Container(
              width: 24,
              height: 24,
              margin: const EdgeInsets.only(right: 8),
              alignment: Alignment.center,
              child: SvgPicture.asset(
                isObscureText! ? 'assets/icons/ic_visibility_off.svg' : 'assets/icons/ic_visibility_on.svg',
                fit: BoxFit.scaleDown,
                width: 24,
                height: 24,
              ),
            ),
          ) : null,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: Colors.black),
          ),
        ),
      ),
    );
  }
}