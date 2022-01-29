import 'package:flutter/material.dart';
import 'package:bianca/colors.dart';

class LTextField extends StatelessWidget {
  String title, hint;
  bool obscureText;
  TextEditingController? controller;

  LTextField({
    this.title = '',
    this.hint = '',
    this.obscureText = false,
    this.controller
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      if(title.isNotEmpty)
        Text(
          title,
          style: const TextStyle(
            color: AppColors.primary,
            fontSize: 12,
            fontWeight: FontWeight.w600
          ),
        ),
        if(title.isNotEmpty)
        const SizedBox(height: 6),
        TextField(
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 2
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: AppColors.primary.withOpacity(0.5),
                width: 2
              ),
            ),
            hintText: hint,
            hintStyle: TextStyle(
              color: AppColors.primary.withOpacity(0.5)
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 8
            )
          ),
          cursorColor: AppColors.accent,
          style: const TextStyle(
            color: AppColors.primary,
            fontSize: 14,
            fontWeight: FontWeight.w500
          ),
          obscureText: obscureText,
          controller: controller,
        )
      ],
    );
  }

}