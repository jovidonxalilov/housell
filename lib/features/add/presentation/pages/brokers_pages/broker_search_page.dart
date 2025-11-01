import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:housell/features/add/presentation/bloc/add_bloc.dart';
import 'package:housell/features/add/presentation/bloc/add_event.dart';

import '../../../../../config/theme/app_colors.dart';
import '../../../../../core/constants/app_status.dart';
import '../../../../../core/dp/dp_injection.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../data/model/maker_model.dart';
import '../../../domain/usecase/add_usecase.dart';
import '../../bloc/add_state.dart';
import 'brokers_page.dart';

class BrokerSearchPage extends StatefulWidget {
  const BrokerSearchPage({super.key});

  @override
  State<BrokerSearchPage> createState() => _BrokerSearchPageState();
}

class _BrokerSearchPageState extends State<BrokerSearchPage> {
  final ValueNotifier<String> _searchQueryNotifier = ValueNotifier<String>('');
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _searchQueryNotifier.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _searchQueryNotifier.value = _searchController.text.trim();
  }

  List<Maklers> _filterBrokers(List<Maklers> brokers, String query) {
    if (query.isEmpty) return brokers;

    final lowerQuery = query.toLowerCase();
    return brokers.where((broker) {
      final name = broker.name.toLowerCase();
      final surname = broker.surname.toLowerCase();
      final email = (broker.email ?? '').toLowerCase();
      final phone = broker.phone.toLowerCase();

      return name.contains(lowerQuery) ||
          surname.contains(lowerQuery) ||
          email.contains(lowerQuery) ||
          phone.contains(lowerQuery);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddHouseBloc(getIt<AddHouseUsecase>(),
        getIt<AddPhotosUrlUsecase>(),
        getIt<GetMaklersUsecase>(),getIt<GetMaklerUsecase>())
        ..add(AddGetMaklersEvent()),
      child: Scaffold(
        backgroundColor: AppColors.backgroundP,
        appBar: _buildSearchAppBar(),
        body: BlocBuilder<AddHouseBloc, AddHouseState>(
          builder: (context, state) => _buildBody(state),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildSearchAppBar() {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: AppColors.black),
        onPressed: () => Navigator.pop(context),
      ),
      title: TextField(
        controller: _searchController,
        focusNode: _focusNode,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.black,
        ),
        decoration: InputDecoration(
          hintText: "Search brokers...",
          hintStyle: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.textLight,
          ),
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
      ),
      actions: [
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: _searchController,
          builder: (context, value, child) {
            if (value.text.isEmpty) return SizedBox(width: 48.w);

            return IconButton(
              icon: Icon(Icons.clear, color: AppColors.black, size: 20.sp),
              onPressed: () {
                _searchController.clear();
                _focusNode.requestFocus();
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildBody(AddHouseState state) {
    if (state.mainStatus == MainStatus.loading) {
      return _buildLoadingState();
    }

    if (state.mainStatus == MainStatus.failure) {
      return _buildErrorState();
    }

    if (state.mainStatus == MainStatus.succes) {
      final maklerModel = state.maklerModel;
      if (maklerModel == null || maklerModel.data.isEmpty) {
        return _buildEmptyState();
      }
      return _buildSearchResults(maklerModel.data);
    }

    return const SizedBox.shrink();
  }

  Widget _buildLoadingState() {
    return Center(
      child: CircularProgressIndicator(
        color: AppColors.primary,
        strokeWidth: 3,
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
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
          ),
          SizedBox(height: 8.h),
          AppText(
            text: "Please try again",
            fontSize: 14,
            fontWeight: 400,
            color: AppColors.lightIcon,
          ),
        ],
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
        ],
      ),
    );
  }

  Widget _buildSearchResults(List<Maklers> allBrokers) {
    return ValueListenableBuilder<String>(
      valueListenable: _searchQueryNotifier,
      builder: (context, searchQuery, child) {
        if (searchQuery.isEmpty) {
          return _buildEmptySearchState();
        }

        final filteredBrokers = _filterBrokers(allBrokers, searchQuery);

        if (filteredBrokers.isEmpty) {
          return _buildNoResultsState();
        }

        return ListView.separated(
          padding: EdgeInsets.all(16.w),
          itemCount: filteredBrokers.length,
          separatorBuilder: (context, index) => SizedBox(height: 12.h),
          itemBuilder: (context, index) {
            return BrokerCard(
              broker: filteredBrokers[index],
              onTap: () => _onBrokerSelected(filteredBrokers[index]),
              highlightText: searchQuery,
            );
          },
        );
      },
    );
  }

  Widget _buildEmptySearchState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search, size: 64.w, color: AppColors.lightIcon),
          SizedBox(height: 16.h),
          AppText(
            text: "Search for a broker",
            fontSize: 16,
            fontWeight: 500,
            color: AppColors.textLight,
          ),
          SizedBox(height: 8.h),
          AppText(
            text: "Enter a name to start searching",
            fontSize: 14,
            fontWeight: 400,
            color: AppColors.lightIcon,
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64.w, color: AppColors.lightIcon),
          SizedBox(height: 16.h),
          AppText(
            text: "No brokers found",
            fontSize: 16,
            fontWeight: 500,
            color: AppColors.textLight,
          ),
          SizedBox(height: 8.h),
          AppText(
            text: "Try a different search term",
            fontSize: 14,
            fontWeight: 400,
            color: AppColors.lightIcon,
          ),
        ],
      ),
    );
  }

  void _onBrokerSelected(Maklers broker) {
    Navigator.pop(context);
    Navigator.pop(context, broker);
  }
}