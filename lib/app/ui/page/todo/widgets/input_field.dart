import 'package:flutter/material.dart';
import 'package:get/get.dart';

typedef OnTap = void Function();

class InputField extends StatefulWidget {

  const InputField(
      {Key? key,
        this.onTap,
        required this.label,
        this.controller,
        this.icondata,
        required this.hint,
        this.widget,
        required this.isEditable,
        required this.emptyText,
        this.isEnabled,
        this.fontSize,
        this.boldText,
      })
      : super(key: key);
  final String label;
  final TextEditingController? controller;
  final IconData? icondata;
  final String hint;
  final Widget? widget;
  final bool isEditable;
  final bool? isEnabled;
  final bool emptyText;
  final double? fontSize;
  final bool? boldText;
  final OnTap? onTap;

  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  @override
  Widget build(BuildContext context) {
    return  TextFormField(
      onTap: widget.onTap ?? (){},
      enabled: widget.isEnabled,
      readOnly: !widget.isEditable,
      controller: widget.controller,
      validator: (value) {
        if(widget.emptyText == false && widget.isEnabled != false){
          if (value.toString().isEmpty) {
            return 'Please Check ${widget.label}';
          }
        }
      },
      decoration: InputDecoration(
        labelStyle: TextStyle(height:0.1,fontSize: 20),
        labelText: widget.label,
        hintText: widget.hint,
        hintStyle:
        TextStyle(color: Get.isDarkMode ? Colors.white70 : Colors.grey,
          fontWeight: widget.boldText == true ? FontWeight.bold : null,),
      ),
    );
  }
}
