import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class CustomInputField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final TextEditingController controller;
  final bool isPassword;
  final TextInputType keyboardType;
  final IconData icon;
  final List<FormFieldValidator<String>> validators;

  const CustomInputField({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.controller,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    required this.icon,
    required this.validators,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            labelText,
            style: const TextStyle(fontSize: 15, color: Colors.black87),
          ),
          const SizedBox(
            height: 5,
          ),
          FormBuilderTextField(
            key: Key(labelText),
            name: labelText,
            validator: FormBuilderValidators.compose(validators),
            obscureText: isPassword,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              // labelText: labelText,
              hintText: hintText,
              focusColor: Colors.green,

              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.lightGreen,
                  width: 1.0, // Set the color of the enabled border
                ),
                borderRadius: BorderRadius.circular(5.0),
              ),
              prefixIcon: Icon(icon),

              // Custom border when input is focused
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.green,
                  width: 1.4, // Set the color of the focused border
                ),
                borderRadius: BorderRadius.circular(5.0),
              ),

              // Custom error border when validation fails
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.red, // Red border on validation error
                  width: 1.4,
                ),
                borderRadius: BorderRadius.circular(5.0),
              ),

              // Custom border when field is focused and validation fails
              focusedErrorBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color:
                      Colors.red, // Red border on validation error and focused
                  width: 1.4,
                ),
                borderRadius: BorderRadius.circular(5.0),
              ),

              // Custom error style
              errorStyle: const TextStyle(color: Colors.redAccent),
              filled: false,
            ),
          ),
        ]);
  }
}
