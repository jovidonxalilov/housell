import 'package:flutter/material.dart';

class SavePropertiesPage extends StatefulWidget {
  const SavePropertiesPage({Key? key}) : super(key: key);

  @override
  State<SavePropertiesPage> createState() => _SavePropertiesPageState();
}

class _SavePropertiesPageState extends State<SavePropertiesPage> {
  int selectedTabIndex = 0;

  final List<String> tabs = ['All (3)', 'Buy (1)', 'Rent (2)'];

  // Sample properties data
  final List<Property> allProperties = [
    Property(
      id: '1',
      title: 'Modern Downtown Apartment',
      location: 'Tashkent Yakkasaroy Rayon',
      price: 1800,
      bedrooms: 2,
      area: 105,
      imageUrl: 'assets/images/property1.jpg',
      isVip: true,
      isLiked: true,
      type: PropertyType.rent,
    ),
    Property(
      id: '2',
      title: 'Modern Downtown Apartment in',
      location: 'Tashkent Yunusobod Rayon',
      price: 180000,
      bedrooms: 3,
      area: 150,
      imageUrl: 'assets/images/property2.jpg',
      isVip: false,
      isLiked: true,
      type: PropertyType.buy,
    ),
    Property(
      id: '3',
      title: 'Luxury Villa with Garden',
      location: 'Tashkent Mirzo Ulugbek',
      price: 2500,
      bedrooms: 4,
      area: 200,
      imageUrl: 'assets/images/property3.jpg',
      isVip: true,
      isLiked: true,
      type: PropertyType.rent,
    ),
  ];

  List<Property> get filteredProperties {
    if (selectedTabIndex == 0) {
      return allProperties;
    } else if (selectedTabIndex == 1) {
      return allProperties.where((p) => p.type == PropertyType.buy).toList();
    } else {
      return allProperties.where((p) => p.type == PropertyType.rent).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black87, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Saved Properties',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 16),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(0xFF6C5CE7).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '3',
              style: TextStyle(
                color: Color(0xFF6C5CE7),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Tab Bar
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: List.generate(
                  tabs.length,
                      (index) => _buildTabItem(tabs[index], index),
                ),
              ),
            ),
          ),
          // All Properties Header
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'All Properties',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // Toggle view mode
                  },
                  icon: Icon(
                    Icons.view_agenda_outlined,
                    color: Colors.grey[600],
                    size: 22,
                  ),
                ),
              ],
            ),
          ),
          // Properties List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
              itemCount: filteredProperties.length,
              itemBuilder: (context, index) {
                return SavedPropertyCard(
                  property: filteredProperties[index],
                  onLikeToggle: () {
                    setState(() {
                      filteredProperties[index].isLiked =
                      !filteredProperties[index].isLiked;
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem(String title, int index) {
    bool isSelected = selectedTabIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTabIndex = index;
        });
      },
      child: Container(
        margin: EdgeInsets.only(right: 12),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFF6C5CE7) : Colors.grey[100],
          borderRadius: BorderRadius.circular(25),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[700],
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class SavedPropertyCard extends StatelessWidget {
  final Property property;
  final VoidCallback onLikeToggle;

  const SavedPropertyCard({
    Key? key,
    required this.property,
    required this.onLikeToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with badges
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                child: Container(
                  height: 180,
                  width: double.infinity,
                  color: Colors.grey[300],
                  child: Image.asset(
                    property.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: Center(
                          child: Icon(
                            Icons.image_not_supported,
                            size: 50,
                            color: Colors.grey[400],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              // VIP Badge
              if (property.isVip)
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Color(0xFF6C5CE7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'VIP',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              // Heart Icon
              Positioned(
                top: 12,
                right: 12,
                child: GestureDetector(
                  onTap: onLikeToggle,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      property.isLiked ? Icons.favorite : Icons.favorite_border,
                      color: property.isLiked ? Colors.red : Colors.grey[600],
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Content
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  property.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8),
                // Price
                Text(
                  property.type == PropertyType.rent
                      ? '\$ ${property.price.toStringAsFixed(0)} /month'
                      : '\$ ${property.price.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8),
                // Location
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: Colors.grey[500],
                    ),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        property.location,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                // Details Row
                Row(
                  children: [
                    // Bedrooms
                    _buildDetailItem(
                      Icons.bed_outlined,
                      '${property.bedrooms}',
                    ),
                    SizedBox(width: 20),
                    // Area
                    _buildDetailItem(
                      Icons.square_foot_outlined,
                      '${property.area} m²',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: Colors.grey[500],
        ),
        SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }
}

// Property Model
enum PropertyType { buy, rent }

class Property {
  final String id;
  final String title;
  final String location;
  final double price;
  final int bedrooms;
  final int area;
  final String imageUrl;
  final bool isVip;
  bool isLiked;
  final PropertyType type;

  Property({
    required this.id,
    required this.title,
    required this.location,
    required this.price,
    required this.bedrooms,
    required this.area,
    required this.imageUrl,
    this.isVip = false,
    this.isLiked = false,
    required this.type,
  });
}