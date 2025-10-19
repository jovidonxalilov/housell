import 'package:flutter/material.dart';
import 'package:housell/config/theme/app_colors.dart';
import 'package:housell/core/extensions/widget_extension.dart';
import 'package:housell/core/widgets/w_text_form.dart';

class LocationFilterPage extends StatefulWidget {
  const LocationFilterPage({Key? key}) : super(key: key);

  @override
  State<LocationFilterPage> createState() => _LocationFilterPageState();
}

class _LocationFilterPageState extends State<LocationFilterPage> {
  // ValueNotifiers for state management
  final ValueNotifier<List<String>> _selectedLocationsNotifier = ValueNotifier([]);
  final ValueNotifier<List<String>> _searchResultsNotifier = ValueNotifier([]);
  final ValueNotifier<bool> _isSearchingNotifier = ValueNotifier(false);

  final TextEditingController _searchController = TextEditingController();

  // Popular locations - production da API dan kelishi kerak
  final List<String> _popularLocations = [
    'Mirzo-Ulugbek',
    'Chilonzar',
    'Shaykhontohur',
    'Mirobod',
    'Sergeli',
    'Bektemir',
    'Olmazor',
    'Yakkasaray',
  ];

  // Search suggestions - production da API dan kelishi kerak
  final Map<String, String> _locationSuggestions = {
    'Shahriston': 'Tashkent, Uzbekistan',
    'Shahriston metro': 'Tashkent, Uzbekistan',
    'Elnur korhasi': 'Bagriston, Tashkent, Uzbekistan',
  };

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _selectedLocationsNotifier.dispose();
    _searchResultsNotifier.dispose();
    _isSearchingNotifier.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();

    if (query.isEmpty) {
      _isSearchingNotifier.value = false;
      _searchResultsNotifier.value = [];
    } else {
      _isSearchingNotifier.value = true;
      _searchResultsNotifier.value = _locationSuggestions.keys
          .where((location) =>
          location.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  void _toggleLocation(String location) {
    final currentSelected = List<String>.from(_selectedLocationsNotifier.value);

    if (currentSelected.contains(location)) {
      currentSelected.remove(location);
    } else {
      currentSelected.add(location);
    }

    _selectedLocationsNotifier.value = currentSelected;
  }

  void _clearAll() {
    _selectedLocationsNotifier.value = [];
    _searchController.clear();
  }

  void _reset() {
    _selectedLocationsNotifier.value = [];
    _searchController.clear();
  }

  void _done() {
    Navigator.pop(context, _selectedLocationsNotifier.value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundP,
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchBar(),
            _buildSelectedChips(),
            Expanded(child: _buildContent()),
            _buildBottomButtons(),
          ],
        ).paddingOnly(top: 24, left: 24, right: 24),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: ValueListenableBuilder<TextEditingValue>(
            valueListenable: _searchController,
            builder: (context, value, child) {
              return WTextField(
                controller: _searchController,
                fillColor: AppColors.white,
                borderNoFocusColor: AppColors.lightSky,
                // decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 15,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey[400],
                  size: 20,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                suffixIconWidget: value.text.isNotEmpty
                    ? GestureDetector(
                  onTap: _searchController.clear,
                  child: Icon(
                    Icons.close,
                    color: Colors.grey[400],
                    size: 20,
                  ),
                )
                    : null,
                // border: InputBorder.none,
                // contentPadding: const EdgeInsets.symmetric(
                //   horizontal: 12,
                //   vertical: 10,
                // ),
                // ),
              );
            },
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedChips() {
    return ValueListenableBuilder<bool>(
      valueListenable: _isSearchingNotifier,
      builder: (context, isSearching, child) {
        if (isSearching) return const SizedBox.shrink();

        return ValueListenableBuilder<List<String>>(
          valueListenable: _selectedLocationsNotifier,
          builder: (context, selectedLocations, child) {
            if (selectedLocations.isEmpty) return const SizedBox.shrink();

            return Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ...selectedLocations.map(
                        (location) => _buildFilterChip(location),
                  ),
                  GestureDetector(
                    onTap: _clearAll,
                    child: Text(
                      'Clear',
                      style: TextStyle(
                        color: Colors.blue[600],
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildContent() {
    return ValueListenableBuilder<bool>(
      valueListenable: _isSearchingNotifier,
      builder: (context, isSearching, child) {
        return isSearching
            ? _buildSearchResults()
            : _buildPopularLocations();
      },
    );
  }

  Widget _buildBottomButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: ValueListenableBuilder<List<String>>(
        valueListenable: _selectedLocationsNotifier,
        builder: (context, selectedLocations, child) {
          final hasSelection = selectedLocations.isNotEmpty;

          return Row(
            children: [
              Expanded(
                child: _buildButton(
                  label: 'Reset',
                  onTap: _reset,
                  isPrimary: false,
                  isEnabled: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildButton(
                  label: 'Done',
                  onTap: hasSelection ? _done : null,
                  isPrimary: true,
                  isEnabled: hasSelection,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildButton({
    required String label,
    required VoidCallback? onTap,
    required bool isPrimary,
    required bool isEnabled,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: isPrimary
              ? (isEnabled ? const Color(0xFF5B4FFF) : Colors.grey[300])
              : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: isPrimary ? null : Border.all(color: Colors.grey[300]!),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isPrimary
                  ? (isEnabled ? Colors.white : Colors.grey[400])
                  : Colors.grey[700],
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFEEEBFF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF5B4FFF),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: () => _toggleLocation(label),
            child: const Icon(
              Icons.close,
              size: 16,
              color: Color(0xFF5B4FFF),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPopularLocations() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.trending_up, size: 20),
              SizedBox(width: 8),
              Text(
                'Popular Locations',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ValueListenableBuilder<List<String>>(
            valueListenable: _selectedLocationsNotifier,
            builder: (context, selectedLocations, child) {
              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _popularLocations.map((location) {
                  final isSelected = selectedLocations.contains(location);

                  return _buildLocationChip(
                    location: location,
                    isSelected: isSelected,
                    onTap: () => _toggleLocation(location),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLocationChip({
    required String location,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF5B4FFF) : Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          location,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[700],
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    return ValueListenableBuilder<List<String>>(
      valueListenable: _searchResultsNotifier,
      builder: (context, searchResults, child) {
        if (searchResults.isEmpty) {
          return Center(
            child: Text(
              'No results found',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: searchResults.length,
          itemBuilder: (context, index) {
            final location = searchResults[index];
            final subtitle = _locationSuggestions[location] ?? '';

            return _buildSearchResultItem(
              location: location,
              subtitle: subtitle,
              onTap: () => _toggleLocation(location),
            );
          },
        );
      },
    );
  }

  Widget _buildSearchResultItem({
    required String location,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey[200]!,
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.location_on,
                color: Colors.grey[600],
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    location,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}