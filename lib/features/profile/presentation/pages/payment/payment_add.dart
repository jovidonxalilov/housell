import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:housell/config/theme/app_colors.dart';
import 'package:housell/core/extensions/widget_extension.dart';
import 'package:housell/core/widgets/app_text.dart';
import 'package:housell/core/widgets/w__container.dart';
import 'package:housell/core/widgets/w_custom_app_bar.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/widgets/app_image.dart';

class TopUpPage extends StatefulWidget {
  const TopUpPage({super.key});

  @override
  State<TopUpPage> createState() => _TopUpPageState();
}

class _TopUpPageState extends State<TopUpPage> {
  int selectedAmount = 0;
  String selectedPaymentMethod = 'Payme';
  final TextEditingController amountController = TextEditingController();

  final List<int> quickAmounts = [5000, 10000, 50000, 100000, 200000, 500000];

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundP,
      appBar: WCustomAppBar(
        title: AppText(
          text: "Top Up",
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Account Balance Card
              _buildBalanceCard(),
              const SizedBox(height: 24),

              // Top-up Amount Input
              _buildAmountInput(),
              const SizedBox(height: 24),

              // Quick Select
              _buildQuickSelect(),
              const SizedBox(height: 24),

              // Payment Method
              _buildPaymentMethod(),
              const SizedBox(height: 32),

              // Top Up Button
              _buildTopUpButton(),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBalanceCard() {
    return ContainerW(
      width: double.infinity,
      radius: 16,
      // boxShadow: [
      //   BoxShadow(
      //     color: Color(0xFF141414).withOpacity(0.08), // #141414 at 8%
      //     offset: Offset(0, 1), // X: 0, Y: 0
      //     blurRadius: 8, // Blur: 8
      //     spreadRadius: 0, // Spread: 0
      //   ),
      //   BoxShadow(
      //     color: Color(0xFF141414).withOpacity(0.04), // #141414 at 4%
      //     offset: Offset(0, 1), // X: 0, Y: 0
      //     blurRadius: 1, // Blur: 1
      //     spreadRadius: 0, // Spread: 0
      //   ),
      // ],
      // color: Color(0xffF2F0FF),
      color: AppColors.base.withOpacity(0.2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4,
                children: [
                  AppText(
                    text: 'Account Balance',
                    fontWeight: 500,
                    fontSize: 16,
                    color: AppColors.purpleA,
                  ),
                  AppText(
                    text: '700,000',
                    fontWeight: 700,
                    fontSize: 24,
                    color: AppColors.purpleA,
                  ),
                  AppText(
                    text: 'so’m available',
                    fontWeight: 400,
                    fontSize: 16,
                    color: AppColors.purpleA,
                  ),
                ],
              ),
              ContainerW(
                // decoration: BoxDecoration(
                color: AppColors.base.withOpacity(0.15),
                radius: 24,
                // ),
                child: AppImage(path: AppAssets.wallet).paddingAll(12),
              ),
            ],
          ),
        ],
      ).paddingAll(20),
    );
  }

  Widget _buildAmountInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Top-up Amount',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    hintText: selectedAmount > 0
                        ? selectedAmount.toString()
                        : '0',
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      selectedAmount = int.tryParse(value) ?? 0;
                    });
                  },
                ),
              ),
              Text(
                "so'm",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickSelect() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Select',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.2,
          ),
          itemCount: quickAmounts.length,
          itemBuilder: (context, index) {
            final amount = quickAmounts[index];
            final isSelected = selectedAmount == amount;

            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedAmount = amount;
                  amountController.text = amount.toString();
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF8B7FFF) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF8B7FFF)
                        : Colors.grey.shade200,
                    width: 1.5,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _formatAmount(amount),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "so'm",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: isSelected
                            ? Colors.white70
                            : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildPaymentMethod() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Payment Method',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        _buildPaymentOption(
          'Payme',
          'assets/payme.png', // Sizning asset papkangizda bo'lishi kerak
          Colors.blue.shade400,
        ),
        const SizedBox(height: 12),
        _buildPaymentOption(
          'Click',
          'assets/click.png', // Sizning asset papkangizda bo'lishi kerak
          Colors.blue.shade600,
        ),
      ],
    );
  }

  Widget _buildPaymentOption(String name, String iconPath, Color color) {
    final isSelected = selectedPaymentMethod == name;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPaymentMethod = name;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF8B7FFF) : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Icon(
                  name == 'Payme' ? Icons.payment : Icons.credit_card,
                  color: color,
                  size: 24,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const Spacer(),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Color(0xFF8B7FFF),
                size: 24,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopUpButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: selectedAmount > 0
            ? () {
                // Top up funksiyasi
                _showSuccessDialog();
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF8B7FFF),
          disabledBackgroundColor: Colors.grey.shade300,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Top Up Balance',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.explore_outlined, 'Explore', false),
          _buildNavItem(Icons.map_outlined, 'Map', false),
          _buildNavItem(Icons.add_circle_outline, '', false, isCenter: true),
          _buildNavItem(Icons.message_outlined, 'Message', false),
          _buildNavItem(Icons.person_outline, 'Profile', false),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    IconData icon,
    String label,
    bool isActive, {
    bool isCenter = false,
  }) {
    if (isCenter) {
      return Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF8B7FFF), Color(0xFFB4A9FF)],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: isActive ? const Color(0xFF8B7FFF) : Colors.grey,
          size: 26,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isActive ? const Color(0xFF8B7FFF) : Colors.grey,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }

  String _formatAmount(int amount) {
    if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(0)},000';
    }
    return amount.toString();
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Color(0xFF8B7FFF), size: 64),
            const SizedBox(height: 16),
            const Text(
              'Top Up Successful!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '$selectedAmount so\'m added to your balance',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B7FFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Done',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
