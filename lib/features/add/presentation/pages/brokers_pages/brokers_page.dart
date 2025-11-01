import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:housell/config/router/routes.dart';
import 'package:housell/config/theme/app_colors.dart';
import 'package:housell/core/constants/app_status.dart';
import 'package:housell/core/extensions/widget_extension.dart';
import 'package:housell/core/widgets/app_image.dart';
import 'package:housell/core/widgets/app_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:housell/core/widgets/w_custom_app_bar.dart';
import 'package:housell/features/add/data/model/maker_model.dart';
import 'package:housell/features/add/presentation/bloc/add_bloc.dart';
import 'package:housell/features/add/presentation/bloc/add_event.dart';
import 'package:housell/features/add/presentation/bloc/add_state.dart';
import 'package:housell/features/profile/data/model/profile_model.dart';
import '../../../../../core/dp/dp_injection.dart';
import '../../../../../core/widgets/w__container.dart';
import '../../../domain/usecase/add_usecase.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BrokersPage extends StatefulWidget {
  const BrokersPage({super.key});

  @override
  State<BrokersPage> createState() => _BrokersPageState();
}

class _BrokersPageState extends State<BrokersPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddHouseBloc(
        getIt<AddHouseUsecase>(),
        getIt<AddPhotosUrlUsecase>(),
        getIt<GetMaklersUsecase>(),
          getIt<GetMaklerUsecase>(),
      )..add(AddGetMaklersEvent()),
      child: Scaffold(
        backgroundColor: AppColors.backgroundP,
        appBar: _buildAppBar(),
        body: BlocBuilder<AddHouseBloc, AddHouseState>(
          builder: (context, state) => _buildBody(
            context,
            state,
          ).paddingOnly(left: 24, right: 24, top: 24),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return WCustomAppBar(
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: AppColors.black),
        onPressed: () => Navigator.pop(context),
      ),
      title: AppText(
        text: "Choose a Broker",
        fontSize: 18,
        fontWeight: 500,
        color: AppColors.black,
      ),
      centerTitle: true,
      actions: [
        AppText(
          text: Routes.add,
          color: AppColors.black,
          onTap: () {
            context.push(Routes.searchBroker);
          },
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context, AddHouseState state) {
    if (state.mainStatus == MainStatus.loading) {
      return _buildLoadingState();
    }

    if (state.mainStatus == MainStatus.failure) {
      return _buildErrorState(context, state.errorMessage);
    }

    if (state.mainStatus == MainStatus.succes) {
      final maklerModel = state.maklerModel;
      if (maklerModel == null || maklerModel.data.isEmpty) {
        return _buildEmptyState();
      }
      return _buildBrokerList(maklerModel);
    }

    return const SizedBox.shrink();
  }

  Widget _buildLoadingState() {
    return Center(
      child: CircularProgressIndicator(
        // color: AppColors.primary,
        strokeWidth: 3,
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String errorMessage) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64.w, color: AppColors.lightIcon),
            SizedBox(height: 16.h),
            AppText(
              text: "Failed to load brokers",
              fontSize: 16,
              fontWeight: 500,
              color: AppColors.textLight,
              textAlign: TextAlign.center,
            ),
            if (errorMessage.isNotEmpty) ...[
              SizedBox(height: 8.h),
              AppText(
                text: errorMessage,
                fontSize: 14,
                fontWeight: 400,
                color: AppColors.lightIcon,
                textAlign: TextAlign.center,
                maxLines: 3,
              ),
            ],
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: () {
                context.read<AddHouseBloc>().add(AddGetMaklersEvent());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: AppText(
                text: "Try Again",
                fontSize: 14,
                fontWeight: 600,
                color: AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_off, size: 64.w, color: AppColors.lightIcon),
          SizedBox(height: 16.h),
          AppText(
            text: "No brokers available",
            fontSize: 16,
            fontWeight: 500,
            color: AppColors.textLight,
          ),
          SizedBox(height: 8.h),
          AppText(
            text: "Please check back later",
            fontSize: 14,
            fontWeight: 400,
            color: AppColors.lightIcon,
          ),
        ],
      ),
    );
  }

  Widget _buildBrokerList(MaklerModel maklerModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16.h),
        AppText(
          text: "Choose a broker",
          fontSize: 24,
          fontWeight: 700,
          color: AppColors.lightIcon,
        ),
        SizedBox(height: 24.h),
        Expanded(
          child: ContainerW(
            color: AppColors.white,
            width: double.infinity,
            boxShadow: [
              BoxShadow(
                color: Color(0xFF141414).withOpacity(0.04),
                offset: Offset(0, -2),
                blurRadius: 8,
                spreadRadius: 0,
              ),
              BoxShadow(
                color: Color(0xFF141414).withOpacity(0.02),
                offset: Offset(0, -1),
                blurRadius: 1,
                spreadRadius: 0,
              ),
            ],
            child: ListView.builder(
              // padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: maklerModel.data.length,
              // separatorBuilder: (context, index) => SizedBox(height: 12.h),
              itemBuilder: (context, index) {
                return BrokerCard(
                  broker: maklerModel.data[index],
                  onTap: () {
                    context.push("/broker/${maklerModel.data[index].id}");
                  },
                );
              },
            ).paddingOnly(top: 16, bottom: 16),
          ),
        ),
      ],
    );
  }

  // void _openSearchPage(MaklerModel maklerModel) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => BrokerSearchPage(maklerModel: maklerModel),
  //     ),
  //   );
  // }
}

// Search Page

// Reusable Broker Card Widget
class BrokerCard extends StatelessWidget {
  final Maklers broker;
  final VoidCallback onTap;
  final String? highlightText;

  const BrokerCard({
    super.key,
    required this.broker,
    required this.onTap,
    this.highlightText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Row(
            children: [
              _buildAvatar(),
              SizedBox(width: 12.w),
              Expanded(child: _buildInfo()),
              Icon(Icons.chevron_right, color: AppColors.lightIcon, size: 20.sp),
            ],
          ),
        ).paddingOnly(left: 16, right: 16),
        Divider().paddingOnly(top: 12, bottom: 12)
      ],
    );
  }

  Widget _buildAvatar() {
    final hasImage = broker.image != null && broker.image!.isNotEmpty;
    return ClipOval(
      child: Container(
        width: 48.w,
        height: 48.w,
        decoration: BoxDecoration(
          color: AppColors.grey200,
          shape: BoxShape.circle,
        ),
        child: hasImage
            ? Image.network(
                broker.image!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildAvatarPlaceholder();
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: SizedBox(
                      width: 20.w,
                      height: 20.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primary,
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  );
                },
              )
            : _buildAvatarPlaceholder(),
      ),
    );
  }

  Widget _buildAvatarPlaceholder() {
    return Icon(Icons.person, size: 24.sp, color: AppColors.lightIcon);
  }

  Widget _buildInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildName(),
        SizedBox(height: 4.h),
        _buildExperience(),
      ],
    );
  }

  Widget _buildName() {
    final fullName = _getFullName();

    if (highlightText == null || highlightText!.isEmpty) {
      return AppText(
        text: fullName,
        fontSize: 16,
        fontWeight: 600,
        color: AppColors.black,
        maxLines: 1,
      );
    }

    return _buildHighlightedText(fullName);
  }

  String _getFullName() {
    return '${broker.name} ${broker.surname}'.trim();
  }

  Widget _buildHighlightedText(String fullName) {
    final lowerName = fullName.toLowerCase();
    final lowerHighlight = highlightText!.toLowerCase();
    final startIndex = lowerName.indexOf(lowerHighlight);

    if (startIndex == -1) {
      return AppText(
        text: fullName,
        fontSize: 16,
        fontWeight: 600,
        color: AppColors.black,
        maxLines: 1,
      );
    }

    final endIndex = startIndex + highlightText!.length;

    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.black,
          height: 1.2,
        ),
        children: [
          TextSpan(text: fullName.substring(0, startIndex)),
          TextSpan(
            text: fullName.substring(startIndex, endIndex),
            style: TextStyle(
              backgroundColor: AppColors.primary.withOpacity(0.2),
              color: AppColors.primary,
            ),
          ),
          TextSpan(text: fullName.substring(endIndex)),
        ],
      ),
    );
  }

  Widget _buildExperience() {
    return Row(
      children: [
        Icon(Icons.work_outline, size: 14.sp, color: AppColors.lightIcon),
        SizedBox(width: 4.w),
        AppText(
          text: '${broker.yearsOfExperience} years experience',
          fontSize: 14,
          fontWeight: 400,
          color: AppColors.textLight,
        ),
      ],
    );
  }
}
