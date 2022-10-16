import 'package:flutter/material.dart';
import 'package:task_manager/src/presentation/features/utils/validator.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget({
    Key? key,
    required this.controller,
    required this.title,
  }) : super(key: key);

  final TextEditingController controller;
  final bool title;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: errorText,
      minLines: 1,
      maxLines: title ? null : 5,
      maxLength: title ? null : 300,
      decoration: InputDecoration(labelText: title ? 'Title' : "Description"),
    );
  }
}
