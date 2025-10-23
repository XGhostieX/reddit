import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme/app_theme.dart';

class DottedContainer extends ConsumerWidget {
  final VoidCallback onTap;
  final Widget child;
  const DottedContainer(this.onTap, this.child, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: onTap,
      child: DottedBorder(
        options: RoundedRectDottedBorderOptions(
          radius: const Radius.circular(10),
          dashPattern: [10, 4],
          strokeCap: StrokeCap.round,
          color: ref.watch(themeNotifierProvider).textTheme.bodyLarge!.color!,
        ),
        child: Container(
          width: double.infinity,
          height: 150,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          child: child,
        ),
      ),
    );
  }
}
