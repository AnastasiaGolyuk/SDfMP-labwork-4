import 'package:flutter/material.dart';
import 'package:planner/consts/consts.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField(
      {Key? key,
      required this.label,
      required this.controller,
      required this.isPasswordField,
      required this.initialValue, required this.inputType,})
      : super(key: key);

  final String label;
  final TextEditingController controller;
  final bool isPasswordField;
  final String initialValue;
  final TextInputType inputType;

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _passwordVisible = false;

  @override
  void initState() {
    _passwordVisible = false;
    widget.controller.text=widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isPasswordField) {
      return TextFormField(
        controller: widget.controller,
        obscureText: !_passwordVisible,
        keyboardType: widget.inputType,
        style: TextStyle(color: Colors.black, fontSize: 15),
        decoration: InputDecoration(
          labelStyle: TextStyle(color: Consts.textColor, fontSize: 15),
          labelText: widget.label,
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                _passwordVisible = !_passwordVisible;
              });
            },
            icon: Icon(
              _passwordVisible ? Icons.visibility : Icons.visibility_off,
              color: Consts.btnColor,
            ),
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Consts.btnColor, width: 3),
          ),
        ),
      );
    } else {
      return TextFormField(
        controller: widget.controller,
        style: TextStyle(color: Colors.black, fontSize: 15),
        keyboardType: widget.inputType,
        decoration: InputDecoration(
          labelStyle: TextStyle(color: Consts.textColor, fontSize: 15),
          labelText: widget.label,
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Consts.btnColor, width: 3),
          ),
        ),
      );
    }
  }
}
