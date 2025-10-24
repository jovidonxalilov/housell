import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:housell/core/constants/app_status.dart';
import 'package:housell/core/widgets/app_image.dart';
import 'package:housell/core/widgets/w_custom_app_bar.dart';
import 'package:housell/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:housell/features/profile/presentation/bloc/profile_state.dart';

import '../../../../../config/theme/app_colors.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/dp/dp_injection.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../domain/usecase/profile_usecase.dart';

// ==================== MODEL ====================

class SocialLink {
  final String id;
  final String url;
  final String title;
  final IconData icon;

  SocialLink({
    required this.id,
    required this.url,
    required this.title,
    required this.icon,
  });
}

class SocialLinksPage extends StatefulWidget {
  // final List<SocialLink> socialLinks;
  // final VoidCallback onAddLink;
  // final Function(SocialLink) onLinkTap;

  const SocialLinksPage({
    Key? key,
    // required this.socialLinks,
    // required this.onAddLink,
    // required this.onLinkTap,
  }) : super(key: key);

  @override
  State<SocialLinksPage> createState() => _SocialLinksPageState();
}

class _SocialLinksPageState extends State<SocialLinksPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc(
          getIt<ProfileGetUsecase>(),
          getIt<ProfilePatchUsecase>(),
          getIt<ProfilePhotoUrlUsecase>(),
          getIt<ProfileNewPhoneOtpUsecase>(),
          getIt<ProfileNewPhoneVerifyOtpUsecase>(),
          getIt<ProfileNewPasswordUsecase>(),
          getIt<ProfileGetMyHousesUsecase>()
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F7),
        appBar: WCustomAppBar(
          backgroundColor: AppColors.backgroundP,
          title: AppText(
            text: "Change Number",
            fontSize: 18,
            fontWeight: 400,
            color: AppColors.lightIcon,
          ),
          leading: AppImage(
            path: AppAssets.arrowChevronLeft,
            onTap: () => context.pop(),
            size: 24,
          ),
          showLeadingAutomatically: true,
        ),
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state.mainStatus == MainStatus.loading) {
              return Center(child: CircularProgressIndicator());
            }
            if (state.mainStatus == MainStatus.succes) {
              final profile = state.profileModel;
              return Column(
                children: [
                  // Add Social Links Button
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {},
                          child: Row(
                            children: [
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF5B51FF,
                                  ).withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.add,
                                  size: 18,
                                  color: Color(0xFF5B51FF),
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Add Social Links',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Padding(
                          padding: EdgeInsets.only(left: 40),
                          child: Text(
                            'Everyone can see and access your shared Social Links',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF8E8E93),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Social Links List
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      itemCount: 0,
                      separatorBuilder: (context, index) =>
                          const Divider(height: 1, indent: 60),
                      itemBuilder: (context, index) {
                        final link = profile!.links![index];
                        return Container(
                          color: Colors.white,
                          child: ListTile(
                            // onTap: () => widget.onLinkTap(link),
                            leading: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: const Color(0xFF5B51FF).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.search,
                                size: 20,
                                color: const Color(0xFF5B51FF),
                              ),
                            ),
                            title: Text(
                              profile.links.toString(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                            subtitle: Text(
                              profile.links.toString(),
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF8E8E93),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Color(0xFF8E8E93),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }
            if (state.miniStatus == MainStatus.failure) {
              return Center(child: AppText(text: "Malumot kelmad"));
            }
            return Center(child: AppText(text: "Malumot topilmadi"));
          },
        ),
      ),
    );
  }
}

// ==================== PAGE 2: ADD/EDIT LINK ====================

class AddSocialLinkPage extends StatefulWidget {
  final SocialLink? existingLink;
  final Function(String url, String title) onSave;

  const AddSocialLinkPage({Key? key, this.existingLink, required this.onSave})
    : super(key: key);

  @override
  State<AddSocialLinkPage> createState() => _AddSocialLinkPageState();
}

class _AddSocialLinkPageState extends State<AddSocialLinkPage> {
  late TextEditingController urlController;
  late TextEditingController titleController;
  bool hasChanges = false;
  bool showTitleChip = false;

  @override
  void initState() {
    super.initState();
    urlController = TextEditingController(text: widget.existingLink?.url ?? '');
    titleController = TextEditingController(
      text: widget.existingLink?.title ?? '',
    );
    showTitleChip = titleController.text.isNotEmpty;

    urlController.addListener(_onTextChanged);
    titleController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    setState(() {
      hasChanges =
          urlController.text.isNotEmpty || titleController.text.isNotEmpty;
      showTitleChip = titleController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    urlController.dispose();
    titleController.dispose();
    super.dispose();
  }

  void _handleBack() {
    if (hasChanges) {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text(
            'Discard Changes?',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
          ),
          content: const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              'If you go back now, you will lose your changes.',
              style: TextStyle(fontSize: 13, color: Color(0xFF8E8E93)),
            ),
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              isDefaultAction: true,
              child: const Text(
                'Discard Changes',
                style: TextStyle(
                  color: Color(0xFF5B51FF),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Keep Editing',
                style: TextStyle(color: Color(0xFF5B51FF)),
              ),
            ),
          ],
        ),
      );
    } else {
      Navigator.pop(context);
    }
  }

  void _handleDone() {
    if (urlController.text.isNotEmpty && titleController.text.isNotEmpty) {
      widget.onSave(urlController.text, titleController.text);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          color: Colors.black,
          onPressed: _handleBack,
        ),
        title: const Text(
          'Add link',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: hasChanges ? _handleDone : null,
            child: Text(
              'Done',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: hasChanges ? const Color(0xFF5B51FF) : Colors.grey,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // URL Field
            const Text(
              'URL',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xFF8E8E93),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: urlController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter URL',
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: Color(0xFFD1D1D6),
                        ),
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                  Icon(Icons.content_copy, size: 18, color: Colors.grey[400]),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Title Field
            const Text(
              'Title',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xFF8E8E93),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: showTitleChip
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFE5E5EA)),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            titleController.text,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(width: 6),
                          GestureDetector(
                            onTap: () {
                              titleController.clear();
                            },
                            child: const Icon(
                              Icons.close,
                              size: 16,
                              color: Color(0xFF8E8E93),
                            ),
                          ),
                        ],
                      ),
                    )
                  : TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter title',
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: Color(0xFFD1D1D6),
                        ),
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== PAGE 3: LINK DETAIL ====================

class SocialLinkDetailPage extends StatelessWidget {
  final SocialLink link;
  final VoidCallback onRemove;

  const SocialLinkDetailPage({
    Key? key,
    required this.link,
    required this.onRemove,
  }) : super(key: key);

  void _showRemoveDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text(
          'Remove link from your Profile?',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              onRemove();
            },
            isDestructiveAction: true,
            child: const Text(
              'Remove',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          color: Colors.black,
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Add link',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Done',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Color(0xFF5B51FF),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // URL Display
            const Text(
              'URL',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xFF8E8E93),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                link.url,
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),

            const SizedBox(height: 16),

            // Title Display with Chip
            const Text(
              'Title',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xFF8E8E93),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFE5E5EA)),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  link.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Remove Link Button
            Center(
              child: TextButton(
                onPressed: () => _showRemoveDialog(context),
                child: const Text(
                  'Remove Link',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
