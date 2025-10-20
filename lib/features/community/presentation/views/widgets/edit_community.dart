import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/utils/assets.dart';
import '../../../../../core/utils/functions/pick_image.dart';
import '../../../../../core/widgets/rounded_btn.dart';
import '../../views_model/community_provider.dart';

class EditCommunity extends ConsumerStatefulWidget {
  final String name;
  const EditCommunity({super.key, required this.name});

  @override
  ConsumerState<EditCommunity> createState() => _EditCommunityState();
}

class _EditCommunityState extends ConsumerState<EditCommunity> {
  File? banner;
  File? avatar;

  void selectImage(bool isBanner) async {
    final image = await pickImage(ref);
    if (image != null) {
      setState(() {
        if (isBanner) {
          banner = image;
        } else {
          avatar = image;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(communityNotifierProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Community')),
      body: ref
          .watch(communityProvider(widget.name))
          .when(
            data: (community) => Padding(
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
                                : community.banner.isEmpty || community.banner == Assets.banner
                                ? const Icon(Icons.camera_alt_outlined, size: 40)
                                : CachedNetworkImage(imageUrl: community.banner),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -30,
                        left: 30,
                        child: GestureDetector(
                          onTap: () => selectImage(false),
                          child: CircleAvatar(
                            backgroundImage: avatar != null
                                ? FileImage(avatar!)
                                : CachedNetworkImageProvider(community.avatar),
                            radius: 35,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  RoundedBtn(
                    label: isLoading ? '' : 'Save',
                    onPressed: isLoading
                        ? () {}
                        : () => ref
                              .watch(communityNotifierProvider.notifier)
                              .editCommunity(
                                community: community,
                                banner: banner,
                                avatar: avatar,
                                context: context,
                              ),
                    bgColor: AppColors.blueColor,
                    icon: isLoading ? const CircularProgressIndicator() : null,
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
