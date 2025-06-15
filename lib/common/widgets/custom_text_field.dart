import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String label;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final String? hint;
  final TextInputType? keyboardType;
  final FocusNode? focusNode;
  final bool isPassword;
  final bool readOnly;
  final MaskTextInputFormatter? formatter;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final void Function()? onTap;
  final bool enabled;
  final String? initialValue;

  const CustomTextField({
    super.key,
    this.controller,
    required this.label,
    this.prefixIcon,
    this.focusNode,
    this.keyboardType,
    this.hint,
    this.formatter,
    this.suffixIcon,
    this.isPassword = false,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.readOnly = false,
    this.onTap,
    this.enabled = true,
    this.initialValue,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final RxBool hidePassword = true.obs;

  @override
  Widget build(BuildContext context) {
    if (widget.isPassword) {
      return passwordTextField(context);
    } else {
      return textField(context);
    }
  }

  Widget passwordTextField(BuildContext context) {
    return Obx(() => TextFormField(
      controller: widget.controller,
      obscureText: widget.isPassword ? hidePassword.value : false,
      validator: widget.validator,
      enabled: widget.enabled,
      keyboardType: widget.keyboardType,
      focusNode: widget.focusNode,
      onChanged: widget.onChanged,
      readOnly: widget.readOnly,
      onFieldSubmitted: widget.onSubmitted,
      onTap: widget.onTap,
      style: TextStyle(fontSize: 18),
      initialValue: widget.initialValue,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        prefixIcon: Icon(widget.prefixIcon),
        suffixIcon: widget.isPassword
            ? IconButton(
          onPressed: () => hidePassword.value = !hidePassword.value,
          icon: Icon(hidePassword.value ? Iconsax.eye_slash : Iconsax.eye),
        )
            : (widget.suffixIcon != null ? Icon(widget.suffixIcon) : null),
      ),
    ));
  }

  Widget textField(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      enabled: widget.enabled,
      focusNode: widget.focusNode,
      keyboardType: widget.keyboardType,
      readOnly: widget.readOnly,
      onChanged: widget.onChanged,
      style: TextStyle(fontSize: 18),
      onTap: widget.onTap,
      onFieldSubmitted: widget.onSubmitted,
      inputFormatters: widget.formatter != null ? [widget.formatter!] : [],
      initialValue: widget.initialValue,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        prefixIcon: Icon(widget.prefixIcon),
      ),
    );
  }
}
