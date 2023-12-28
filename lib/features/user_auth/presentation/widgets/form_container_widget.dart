// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

class FormContainerWidget extends StatefulWidget{
  final TextEditingController? controller;
  final Key? fieldKey;
  final bool? isPasswordField;
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? OnFieldSubmitted;
  final TextInputType? inputType;
  const FormContainerWidget({
    Key? key,
    this.controller,
    this.fieldKey,
    this.isPasswordField,
    this.hintText,
    this.labelText,
    this.helperText,
    this.onSaved,
    this.validator,
    this.OnFieldSubmitted,
    this.inputType,
  }) : super(key: key);  
  @override
  State<FormContainerWidget> createState() => _FormContainerWidgetState();
}

class _FormContainerWidgetState extends State<FormContainerWidget> {
  
  bool _obscureText = true;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width:double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 7,
            offset: Offset(0, 5),
          )
        ],
      ),
    child: TextFormField(
      style: const TextStyle(color: Colors.black ),
      controller: widget.controller,
      keyboardType: widget.inputType,
      key: widget.fieldKey,
      obscureText: widget.isPasswordField == true? _obscureText : false,
      onSaved: widget.onSaved,
      validator: widget.validator,
      onFieldSubmitted: widget.OnFieldSubmitted,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: widget.hintText,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 15 ),
        suffixIcon:  GestureDetector(
          onTap: (){
            setState(() {
              _obscureText =! _obscureText;
            });
          },
          child: widget.isPasswordField == true? Icon(  _obscureText ? Icons.visibility_off: Icons.visibility,color: _obscureText == false ?Colors.blue[100]: Colors.lightBlueAccent,): const Text(''),
        ),
        ),
    ));
  }
}