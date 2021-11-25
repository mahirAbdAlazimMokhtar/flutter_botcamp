import 'package:flutter/material.dart';

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  required Function validate,
  required String label,
  required IconData prefix,
  bool isClickable = true,
  Function? onSubmit,
  Function? onTap,
  Function? onChange,
}) =>
    Form(
      child: TextFormField(
        onTap: () {
          onTap!();
        },
        controller: controller,
        keyboardType: type,
        onFieldSubmitted: (s) {
          onSubmit ?? (s);
        },
        onChanged: (String value) {
          onChange!(value);
        },
        validator: (String? value) {
          return '';
        },
        enabled: isClickable,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(
            prefix,
          ),
          border: const OutlineInputBorder(),
        ),
      ),
    );
