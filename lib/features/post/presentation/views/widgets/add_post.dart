import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/models/community_model.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/utils/functions/display_message.dart';
import '../../../../../core/utils/functions/pick_image.dart';
import '../../../../../core/widgets/custom_text_field.dart';
import '../../../../../core/widgets/dotted_container.dart';
import '../../../../../core/widgets/rounded_btn.dart';
import '../../../../community/presentation/views_model/community_provider.dart';
import '../../views_model/post_provider.dart';

class AddPost extends ConsumerStatefulWidget {
  const AddPost({super.key});

  @override
  ConsumerState<AddPost> createState() => _AddPostState();
}

class _AddPostState extends ConsumerState<AddPost> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController linkController = TextEditingController();
  File? image;
  CommunityModel? selectedCommunity;

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    linkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(postNotifierProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Post'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(controller: titleController, hint: 'Title', maxLength: 30),
            const SizedBox(height: 10),
            DottedContainer(
              () async {
                final pickedImage = await pickImage(ref);
                if (pickedImage != null) {
                  setState(() {
                    image = pickedImage;
                  });
                }
              },
              image != null ? Image.file(image!) : const Icon(Icons.camera_alt_outlined, size: 40),
            ),
            const SizedBox(height: 10),
            CustomTextField(controller: descriptionController, hint: 'Description', maxLines: 5),
            const SizedBox(height: 10),
            CustomTextField(controller: linkController, hint: 'Link'),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text('Select Community', style: TextStyle(fontSize: 20)),
                ref
                    .watch(userCommunitiesProvider)
                    .when(
                      data: (communities) {
                        if (communities.isEmpty) {
                          return const Text('Please Join a Community Before Posting');
                        }
                        selectedCommunity = communities[0];
                        return DropdownButton(
                          underline: const SizedBox(),
                          value: selectedCommunity ?? communities[0],
                          items: communities
                              .map(
                                (community) => DropdownMenuItem(
                                  value: community,
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundImage: CachedNetworkImageProvider(
                                          community.avatar,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(community.name),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedCommunity = value;
                            });
                          },
                        );
                      },
                      error: (error, stackTrace) => const Center(
                        child: Text('Something Wrong Happend, Please Try Again Later'),
                      ),
                      loading: () => const Center(child: CircularProgressIndicator()),
                    ),
              ],
            ),
            RoundedBtn(
              label: isLoading ? '' : 'Post',
              onPressed: isLoading
                  ? () {}
                  : () {
                      if (titleController.text.isEmpty) {
                        displayMessage('Please Enter a Post Title', true);
                      } else if (selectedCommunity == null) {
                        displayMessage('Please Select a Community', true);
                      } else if (descriptionController.text.isEmpty &&
                          linkController.text.isEmpty &&
                          image == null) {
                        displayMessage('Please Enter a Description, Link or Image', true);
                      } else {
                        ref
                            .read(postNotifierProvider.notifier)
                            .addPost(
                              context: context,
                              title: titleController.text.trim(),
                              community: selectedCommunity!,
                              description: descriptionController.text.isEmpty
                                  ? null
                                  : descriptionController.text.trim(),
                              link: linkController.text.isEmpty ? null : linkController.text.trim(),
                              image: image,
                            );
                      }
                    },
              icon: isLoading ? const CircularProgressIndicator() : null,
              bgColor: AppColors.blueColor,
            ),
          ],
        ),
      ),
    );
  }
}
