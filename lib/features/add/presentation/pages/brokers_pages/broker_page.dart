import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housell/config/theme/app_colors.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:housell/core/constants/app_status.dart';
import 'package:housell/features/add/presentation/bloc/add_bloc.dart';
import 'package:housell/features/add/presentation/bloc/add_event.dart';
import 'package:housell/features/add/presentation/bloc/add_state.dart';

import '../../../../../core/dp/dp_injection.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../data/model/maker_model.dart';
import '../../../domain/usecase/add_usecase.dart';

class BrokerPage extends StatefulWidget {
  final String id;

  const BrokerPage({super.key, required this.id});

  @override
  State<BrokerPage> createState() => _BrokerPageState();
}

class _BrokerPageState extends State<BrokerPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddHouseBloc(
        getIt<AddHouseUsecase>(),
        getIt<AddPhotosUrlUsecase>(),
        getIt<GetMaklersUsecase>(),
        getIt<GetMaklerUsecase>(),
      )..add(AddGetMaklerEvent(id: widget.id)),
      child: Scaffold(
        backgroundColor: AppColors.backgroundP,
        body: BlocBuilder<AddHouseBloc, AddHouseState>(
          builder: (context, state) {
            final broker = state.makler;
            if (state.mainStatus == MainStatus.loading) {
              return Center(child: CircularProgressIndicator());
            }
            if (state.mainStatus == MainStatus.failure) {
              return Center(child: AppText(text: "Malumot kelmadi"));
            }
            if (state.mainStatus == MainStatus.succes) {
              return CustomScrollView(
                slivers: [
                  _buildAppBar(context),
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        _buildHeader(broker!),
                        SizedBox(height: 24.h),
                        _buildActionButtons(),
                        SizedBox(height: 32.h),
                        _buildStatsSection(),
                        SizedBox(height: 32.h),
                        _buildAboutSection(broker),
                        SizedBox(height: 24.h),
                        _buildSpecialtiesSection(),
                        SizedBox(height: 24.h),
                        _buildLanguagesSection(),
                        SizedBox(height: 24.h),
                        _buildSocialLinks(),
                        SizedBox(height: 24.h),
                        _buildVIPPropertiesSection(),
                        SizedBox(height: 32.h),
                      ],
                    ),
                  ),
                ],
              );
            }
            return SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      backgroundColor: AppColors.backgroundP,
      elevation: 0,
      pinned: false,
      leading: Padding(
        padding: EdgeInsets.all(8.w),
        child: CircleAvatar(
          backgroundColor: AppColors.white,
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: AppColors.black, size: 20.sp),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.all(8.w),
          child: CircleAvatar(
            backgroundColor: AppColors.white,
            child: IconButton(
              icon: Icon(Icons.share, color: AppColors.black, size: 20.sp),
              onPressed: () => _onSharePressed(context),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(Maklers broker) {
    return Column(
      children: [
        // Profile Image
        Container(
          width: 120.w,
          height: 120.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: NetworkImage(broker.image ?? ''),
              fit: BoxFit.cover,
            ),
            border: Border.all(color: AppColors.white, width: 4),
          ),
        ),
        SizedBox(height: 16.h),

        // Name
        AppText(
          text: '${broker.name} ${broker.surname}',
          fontSize: 24,
          fontWeight: 700,
          color: AppColors.black,
        ),
        SizedBox(height: 8.h),

        // Rating
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...List.generate(5, (index) {
              return Icon(
                Icons.star,
                size: 16.sp,
                color: index < 4 ? AppColors.red : AppColors.lightIcon,
              );
            }),
            SizedBox(width: 8.w),
            AppText(
              text: '4.6',
              fontSize: 14,
              fontWeight: 600,
              color: AppColors.black,
            ),
            SizedBox(width: 4.w),
            AppText(
              text: '58 reviews',
              fontSize: 14,
              fontWeight: 400,
              color: AppColors.textLight,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          // See All Listings Button
          SizedBox(
            width: double.infinity,
            height: 48.h,
            child: ElevatedButton(
              onPressed: _onSeeAllListings,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: AppText(
                text: 'See All Listings',
                fontSize: 16,
                fontWeight: 600,
                color: AppColors.white,
              ),
            ),
          ),
          SizedBox(height: 12.h),

          // Add as Agent Button
          SizedBox(
            width: double.infinity,
            height: 48.h,
            child: OutlinedButton(
              onPressed: _onAddAsAgent,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.primary, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: AppText(
                text: 'Add as your agent',
                fontSize: 16,
                fontWeight: 600,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem(
            icon: Icons.home_outlined,
            value: '3',
            label: 'Properties',
            color: AppColors.primary,
          ),
          _buildStatItem(
            icon: Icons.check_circle_outline,
            value: '1',
            label: 'Sold',
            color: AppColors.primary,
          ),
          _buildStatItem(
            icon: Icons.calendar_today_outlined,
            value: '2025',
            label: 'Member Since',
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24.sp),
          ),
          SizedBox(height: 8.h),
          AppText(
            text: value,
            fontSize: 18,
            fontWeight: 700,
            color: AppColors.black,
          ),
          SizedBox(height: 4.h),
          AppText(
            text: label,
            fontSize: 12,
            fontWeight: 400,
            color: AppColors.textLight,
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection(Maklers broker) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              text: 'Get to know ${broker.name}',
              fontSize: 18,
              fontWeight: 700,
              color: AppColors.black,
            ),
            SizedBox(height: 4.h),
            AppText(
              text: 'Managing Broker/Partner, e-PRO',
              fontSize: 14,
              fontWeight: 600,
              color: AppColors.primary,
            ),
            SizedBox(height: 12.h),
            AppText(
              text:
                  'With over 12 years of experience in the real estate industry, ${broker.name} is a trusted name in helping clients find their dream homes or secure lucrative investment properties. Based in vibrant Tashkent, he specializes in residential sales, luxury estates, and rental management, boasting a proven track record of closing deals with a 98% client satisfaction rate...',
              fontSize: 14,
              fontWeight: 400,
              color: AppColors.textLight,
              height: 1.5,
            ),
            SizedBox(height: 12.h),
            GestureDetector(
              onTap: _onShowMore,
              child: AppText(
                text: 'Show more',
                fontSize: 14,
                fontWeight: 600,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecialtiesSection() {
    final specialties = [
      'Property Management',
      'First Time Homebuyers',
      'Luxury Homes',
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              text: 'Specialties',
              fontSize: 18,
              fontWeight: 700,
              color: AppColors.black,
            ),
            SizedBox(height: 12.h),
            ...specialties.map(
              (specialty) => Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Row(
                  children: [
                    Container(
                      width: 6.w,
                      height: 6.w,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    AppText(
                      text: specialty,
                      fontSize: 14,
                      fontWeight: 400,
                      color: AppColors.textLight,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguagesSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              text: 'Speaks',
              fontSize: 18,
              fontWeight: 700,
              color: AppColors.black,
            ),
            SizedBox(height: 8.h),
            AppText(
              text: 'English, Russian, Uzbek',
              fontSize: 14,
              fontWeight: 400,
              color: AppColors.textLight,
            ),
            SizedBox(height: 12.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: AppText(
                text: '20 Years of experience',
                fontSize: 12,
                fontWeight: 600,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialLinks() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildSocialButton(
            icon: Icons.language,
            onPressed: _onWebsitePressed,
          ),
          SizedBox(width: 16.w),
          _buildSocialButton(
            icon: Icons.camera_alt,
            onPressed: _onInstagramPressed,
          ),
          SizedBox(width: 16.w),
          _buildSocialButton(
            icon: Icons.telegram,
            onPressed: _onTelegramPressed,
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 48.w,
      height: 48.w,
      decoration: BoxDecoration(
        color: AppColors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: AppColors.primary, size: 20.sp),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildVIPPropertiesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: AppText(
            text: 'VIP Properties',
            fontSize: 20,
            fontWeight: 700,
            color: AppColors.black,
          ),
        ),
        SizedBox(height: 16.h),
        // Properties list here
        Container(
          height: 200.h,
          color: AppColors.black,
          child: Center(
            child: AppText(
              text: 'Properties will be displayed here',
              fontSize: 14,
              fontWeight: 400,
              color: AppColors.textLight,
            ),
          ),
        ),
      ],
    );
  }

  // Action Methods
  void _onSharePressed(BuildContext context) {
    // Share logic
  }

  void _onSeeAllListings() {
    // Navigate to all listings
  }

  void _onAddAsAgent() {
    // Add as agent logic
  }

  void _onShowMore() {
    // Show full description
  }

  void _onWebsitePressed() {
    // Open website
  }

  void _onInstagramPressed() {
    // Open Instagram
  }

  void _onTelegramPressed() {
    // Open Telegram
  }
}
