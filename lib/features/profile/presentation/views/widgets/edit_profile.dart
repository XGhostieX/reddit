import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/utils/assets.dart';
import '../../../../../core/utils/functions/pick_image.dart';
import '../../../../../core/widgets/rounded_btn.dart';
import '../../../../auth/presentation/views_model/auth_provider.dart';
import '../../views_model/profile_provider.dart';

class EditProfile extends ConsumerStatefulWidget {
  final String uid;
  const EditProfile({super.key, required this.uid});

  @override
  ConsumerState<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends ConsumerState<EditProfile> {
  File? banner;
  File? profile;
  late TextEditingController nameController;

  @override
  void initState() {
    nameController = TextEditingController(text: ref.read(userProvider)!.name);
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void selectImage(bool isBanner) async {
    final image = await pickImage(ref);
    if (image != null) {
      setState(() {
        if (isBanner) {
          banner = image;
        } else {
          profile = image;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(profileNotifierProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: ref
          .watch(getUserProvider(widget.uid))
          .when(
            data: (user) => Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      InkWell(
                        onTap: () => selectImage(true),
                        child: DottedBorder(
                          options: const RoundedRectDottedBorderOptions(
                            radius: Radius.circular(10),
                            dashPattern: [10, 4],
                            strokeCap: StrokeCap.round,
                            color: AppColors.whiteColor,
                          ),
                          child: Container(
                            width: double.infinity,
                            height: 150,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                            child: banner != null
                                ? Image.file(banner!)
                                : user.banner.isEmpty || user.banner == Assets.banner
                                ? const Icon(Icons.camera_alt_outlined, size: 40)
                                : CachedNetworkImage(imageUrl: user.banner),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -30,
                        left: 30,
                        child: GestureDetector(
                          onTap: () => selectImage(false),
                          child: CircleAvatar(
                            backgroundImage: profile != null
                                ? FileImage(profile!)
                                : CachedNetworkImageProvider(user.profile),
                            radius: 35,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: 'Name',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.blueColor),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),
                  RoundedBtn(
                    label: isLoading ? '' : 'Save',
                    onPressed: isLoading
                        ? () {}
                        : () => ref
                              .watch(profileNotifierProvider.notifier)
                              .editProfile(
                                banner: banner,
                                profile: profile,
                                name: nameController.text.trim(),
                                context: context,
                              ),
                    icon: isLoading ? const CircularProgressIndicator() : null,
                    bgColor: AppColors.blueColor,
                  ),
                ],
              ),
            ),
            error: (error, stackTrace) =>
                const Center(child: Text('Something Wrong Happend, Please Try Again Later')),
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
    );
  }
}
