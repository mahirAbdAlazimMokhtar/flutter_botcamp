import 'package:flutter/material.dart';

Widget textFormField({
  required TextEditingController controller,
  required TextInputType inputType,
  required Function validate,
  required String label,
  required IconData prefixIconData,
  Function? onSubmit,
  Function? onPressed,
  Function? onChange,
}) {
  return TextFormField(
    onChanged: (value) {
      onChange!(value);
    },
    controller: controller,
    keyboardType: inputType,
    decoration: InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
      prefixIcon: Icon(prefixIconData),
    ),
    onTap: () {
      onPressed!();
    },
    validator: (value) {
      validate(value!);
    },
  );
}
