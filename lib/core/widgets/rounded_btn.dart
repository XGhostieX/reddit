import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class RoundedBtn extends StatelessWidget {
  final String label;
  final Widget? icon;
  final VoidCallback onPressed;
  const RoundedBtn({
    super.key,
    required this.label,
    this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        label: Text(label, style: const TextStyle(fontSize: 18)),
        icon: icon,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.greyColor,
          minimumSize: const Size(double.infinity, 50),
        ),
      ),
    );
  }
}
