import 'package:auto_hide_keyboard/auto_hide_keyboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme/app_theme.dart';

class CustomTextField extends ConsumerWidget {
  final TextEditingController controller;
  final int? maxLength;
  final int? maxLines;
  final String hint;
  const CustomTextField({
    super.key,
    required this.controller,
    this.maxLength,
    required this.hint,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.read(themeNotifierProvider);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: theme.drawerTheme.backgroundColor,
      ),
      child: AutoHideKeyboard(
        child: TextField(
          controller: controller,
          maxLength: maxLength,
          maxLines: maxLines,
          decoration: InputDecoration(hintText: hint, border: InputBorder.none),
        ),
      ),
    );
  }
}
