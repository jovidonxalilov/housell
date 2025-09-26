import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:housell/config/theme/app_colors.dart';
import 'package:housell/core/constants/app_assets.dart';
import 'package:housell/core/widgets/app_image.dart';
import 'package:housell/core/widgets/app_text.dart';
import 'package:housell/core/widgets/w__container.dart';
import 'package:housell/core/widgets/w_custom_app_bar.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          /// Rasmlar vertical scroll
          ListView.builder(
            padding: EdgeInsets.only(
              bottom: screenHeight * 0.3, // bottom sheet past holatda ustini yopmasligi uchun
            ),
            itemCount: 5,
            itemBuilder: (context, index) {
              return Image.network(
                "https://picsum.photos/500/300?random=$index",
                fit: BoxFit.cover,
              );
            },
          ),

          /// AppBar (rasm ustida ko‘rinadi)
          Positioned(
            top: -20, // Status bar ostidan joy
            left: 0,
            right: 0,
            child: WCustomAppBar(
              backgroundColor: Colors.transparent,
              leading: ContainerW(
                width: 40,
                height: 40,
                color: AppColors.white,
                child: Center(
                  child: AppImage(path: AppAssets.chevronLeft),
                ),
              ),
              showLeadingAutomatically: false,
              actions: [
                ContainerW(
                  width: 40,
                  height: 40,
                  color: AppColors.white,
                  child: Center(
                    child: AppImage(path: AppAssets.share02),
                  ),
                ),
                SizedBox(width: 12.h,),
                ContainerW(
                  width: 40,
                  height: 40,
                  color: AppColors.white,
                  child: Center(
                    child: AppImage(path: AppAssets.hearth),
                  ),
                ),
              ],
            )
          ),

          /// Bottom sheet
          DraggableScrollableSheet(
            initialChildSize: 0.3, // Pastki balandlik
            minChildSize: 0.3,
            maxChildSize: (screenHeight - 88) / screenHeight, // tepadan 80px joy qoldiradi
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: CustomScrollView(
                  controller: scrollController,
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            SizedBox(height: 12),
                            Center(
                              child: Icon(Icons.drag_handle, color: Colors.grey),
                            ),
                            SizedBox(height: 16),
                            Text(
                              "Sarlavha",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Bu yerda mahsulot yoki uy haqida batafsil ma'lumot yoziladi. "
                                  "Scroll qilinsa yuqoriga chiqadi, pastda turganda esa kam joy egallaydi.",
                            ),
                            SizedBox(height: 600), // demo kontent
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}


