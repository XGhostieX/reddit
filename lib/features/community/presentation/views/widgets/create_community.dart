import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/utils/functions/display_message.dart';
import '../../../../../core/widgets/rounded_btn.dart';
import '../../views_model/community_provider.dart';

class CreateCommunity extends ConsumerStatefulWidget {
  const CreateCommunity({super.key});

  @override
  ConsumerState<CreateCommunity> createState() => _CreateCommunityState();
}

class _CreateCommunityState extends ConsumerState<CreateCommunity> {
  final communityNameController = TextEditingController();

  @override
  void dispose() {
    communityNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(communityNotifierProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Create a Community'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Community Name'),
            const SizedBox(height: 10),
            TextField(
              controller: communityNameController,
              maxLength: 21,
              decoration: InputDecoration(
                hintText: 'r/Community_name',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.blueColor),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            RoundedBtn(
              label: isLoading ? '' : 'Create Community',
              onPressed: isLoading
                  ? () {}
                  : () {
                      if (communityNameController.text.trim().isEmpty ||
                          communityNameController.text.trim() == '') {
                        return displayMessage('Please Enter a Valid Community Name', true);
                      }
                      ref
                          .read(communityNotifierProvider.notifier)
                          .createCommunity(communityNameController.text.trim(), context);
                    },
              bgColor: AppColors.blueColor,
              icon: isLoading ? const CircularProgressIndicator() : null,
            ),
          ],
        ),
      ),
    );
  }
}
