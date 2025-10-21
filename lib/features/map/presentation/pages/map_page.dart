import 'package:flutter/material.dart';
import 'package:housell/core/constants/app_assets.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';

// Property Model
class Property {
  final String id;
  final String title;
  final double price;
  final String location;
  final Point coordinates;
  final String imageUrl;
  final int bedrooms;
  final int bathrooms;
  final int area;

  Property({
    required this.id,
    required this.title,
    required this.price,
    required this.location,
    required this.coordinates,
    required this.imageUrl,
    required this.bedrooms,
    required this.bathrooms,
    required this.area,
  });
}

// Map Page
class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  YandexMapController? mapController;
  final TextEditingController searchController = TextEditingController();
  Property? selectedProperty;
  bool isClusterMode = false;
  double currentZoom = 14.0;
  List<PlacemarkMapObject> placemarks = [];
  Point? currentLocation;
  bool isLoadingLocation = true;

  // Sample properties data
  final List<Property> properties = [
    Property(
      id: '1',
      title: 'Modern Downtown Apartment',
      price: 1800,
      location: 'Tashkent, Yunusobod Rayon',
      coordinates: const Point(latitude: 41.311151, longitude: 69.279737),
      imageUrl: 'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688',
      bedrooms: 3,
      bathrooms: 2,
      area: 105,
    ),
    Property(
      id: '2',
      title: 'Luxury Villa',
      price: 2500,
      location: 'Tashkent, Chilonzor',
      coordinates: const Point(latitude: 41.315151, longitude: 69.275737),
      imageUrl: 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750',
      bedrooms: 4,
      bathrooms: 3,
      area: 150,
    ),
    Property(
      id: '3',
      title: 'Cozy Studio',
      price: 800,
      location: 'Tashkent, Mirzo Ulugbek',
      coordinates: const Point(latitude: 41.318151, longitude: 69.282737),
      imageUrl: 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267',
      bedrooms: 1,
      bathrooms: 1,
      area: 45,
    ),
    Property(
      id: '4',
      title: 'Family House',
      price: 1500,
      location: 'Tashkent, Yunusobod',
      coordinates: const Point(latitude: 41.308151, longitude: 69.277737),
      imageUrl: 'https://images.unsplash.com/photo-1568605114967-8130f3a36994',
      bedrooms: 3,
      bathrooms: 2,
      area: 120,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  Future<void> _initializeMap() async {
    await _getCurrentLocation();
    // await _createMarkers();
  }

  // Icon'ni Bitmap'ga aylantirish
  Future<BitmapDescriptor> _createCustomIcon({
    required IconData iconData,
    required Color color,
    required double size,
    String? label,
    Color? labelColor,
  }) async {
    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    final paint = Paint()..color = color;

    // Circle background
    canvas.drawCircle(
      Offset(size / 2, size / 2),
      size / 2,
      paint,
    );

    // Icon
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );
    textPainter.text = TextSpan(
      text: String.fromCharCode(iconData.codePoint),
      style: TextStyle(
        fontSize: size * 0.6,
        fontFamily: iconData.fontFamily,
        color: Colors.white,
      ),
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        (size - textPainter.width) / 2,
        (size - textPainter.height) / 2,
      ),
    );

    // Label
    if (label != null) {
      final labelPainter = TextPainter(
        textDirection: TextDirection.ltr,
      );
      labelPainter.text = TextSpan(
        text: label,
        style: TextStyle(
          fontSize: size * 0.25,
          color: labelColor ?? Colors.white,
          fontWeight: FontWeight.bold,
          backgroundColor: Colors.black87,
        ),
      );
      labelPainter.layout();
      labelPainter.paint(
        canvas,
        Offset(
          (size - labelPainter.width) / 2,
          size + 5,
        ),
      );
    }

    final picture = pictureRecorder.endRecording();
    final img = await picture.toImage(
      size.toInt(),
      label != null ? (size + 25).toInt() : size.toInt(),
    );
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    final uint8List = byteData!.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(uint8List);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    try {
      // Check permission
      final permission = await _checkLocationPermission();

      if (!permission) {
        setState(() {
          isLoadingLocation = false;
          // Default location - Tashkent center
          currentLocation = const Point(latitude: 41.311151, longitude: 69.279737);
        });
        return;
      }

      // Get current position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        currentLocation = Point(
          latitude: position.latitude,
          longitude: position.longitude,
        );
        isLoadingLocation = false;
      });

      // Move camera to current location
      if (mapController != null) {
        await mapController!.moveCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: currentLocation!,
              zoom: 14,
            ),
          ),
          animation: const MapAnimation(
            type: MapAnimationType.smooth,
            duration: 1.0,
          ),
        );
      }

      // Add current location marker
      _addCurrentLocationMarker();
    } catch (e) {
      print('Location error: $e');
      setState(() {
        isLoadingLocation = false;
        currentLocation = const Point(latitude: 41.311151, longitude: 69.279737);
      });
    }
  }

  Future<bool> _checkLocationPermission() async {
    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showLocationServiceDialog();
      return false;
    }

    // Check permission
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showPermissionDeniedDialog();
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showPermissionDeniedForeverDialog();
      return false;
    }

    return true;
  }

  void _showLocationServiceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Location Services Disabled'),
        content: const Text('Please enable location services to use this feature.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Geolocator.openLocationSettings();
            },
            child: const Text('Settings'),
          ),
        ],
      ),
    );
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permission Denied'),
        content: const Text('Location permission is required to show your current location.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showPermissionDeniedForeverDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permission Denied'),
        content: const Text(
          'Location permission is permanently denied. Please enable it in app settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: const Text('Settings'),
          ),
        ],
      ),
    );
  }

  Future<void> _addCurrentLocationMarker() async {
    if (currentLocation == null) return;

    final locationIcon = await _createCustomIcon(
      iconData: Icons.my_location,
      color: Colors.blue,
      size: 40,
    );

    setState(() {
      placemarks.add(
        PlacemarkMapObject(
          mapId: const MapObjectId('current_location'),
          point: currentLocation!,
          icon: PlacemarkIcon.single(
            PlacemarkIconStyle(
              image: locationIcon,
              scale: 1.0,
            ),
          ),
          opacity: 1.0,
        ),
      );
    });
  }

  void _onMapCreated(YandexMapController controller) {
    mapController = controller;

    if (currentLocation != null) {
      controller.moveCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: currentLocation!,
            zoom: 14,
          ),
        ),
      );
    }
  }

  void _createMarkers() {
    placemarks = properties.map((property) {
      return PlacemarkMapObject(
        mapId: MapObjectId('property_${property.id}'),
        point: property.coordinates,
        icon: PlacemarkIcon.single(
          PlacemarkIconStyle(
            image: BitmapDescriptor.fromAssetImage(AppAssets.apartment),
            scale: 0.5,
          ),
        ),
        text: PlacemarkText(
          text: '\${property.price.toInt()}',
          style: const PlacemarkTextStyle(
            color: Colors.blue,
            size: 12,
            placement: TextStylePlacement.bottom,
          ),
        ),
        onTap: (PlacemarkMapObject self, Point point) {
          setState(() {
            selectedProperty = property;
          });
        },
      );
    }).toList();

    // Add current location marker if available
    if (currentLocation != null) {
      _addCurrentLocationMarker();
    }
  }

  void _createClusterMarkers() {
    final clusters = <String, List<Property>>{};

    for (var property in properties) {
      final key = '${property.coordinates.latitude.toStringAsFixed(2)}_'
          '${property.coordinates.longitude.toStringAsFixed(2)}';
      clusters.putIfAbsent(key, () => []).add(property);
    }

    placemarks = [];

    clusters.forEach((key, propertyList) {
      if (propertyList.length > 1) {
        final center = propertyList.first.coordinates;
        placemarks.add(
          PlacemarkMapObject(
            mapId: MapObjectId('cluster_$key'),
            point: center,
            icon: PlacemarkIcon.single(
              PlacemarkIconStyle(
                image: BitmapDescriptor.fromAssetImage("assetName"),
                scale: 0.7,
              ),
            ),
            text: PlacemarkText(
              text: '${propertyList.length}',
              style: const PlacemarkTextStyle(
                color: Colors.white,
                size: 14,
                placement: TextStylePlacement.center,
              ),
            ),
            onTap: (PlacemarkMapObject self, Point point) {
              mapController?.moveCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(target: center, zoom: 16),
                ),
                animation: const MapAnimation(
                  type: MapAnimationType.smooth,
                  duration: 0.5,
                ),
              );
            },
          ),
        );
      } else {
        final property = propertyList.first;
        placemarks.add(
          PlacemarkMapObject(
            mapId: MapObjectId('property_${property.id}'),
            point: property.coordinates,
            icon: PlacemarkIcon.single(
              PlacemarkIconStyle(
                image: BitmapDescriptor.fromAssetImage("assetName"),
                scale: 0.5,
              ),
            ),
            text: PlacemarkText(
              text: '\${property.price.toInt()}',
              style: const PlacemarkTextStyle(
                color: Colors.blue,
                size: 12,
                placement: TextStylePlacement.bottom,
              ),
            ),
            onTap: (PlacemarkMapObject self, Point point) {
              setState(() {
                selectedProperty = property;
              });
            },
          ),
        );
      }
    });

    // Add current location marker
    if (currentLocation != null) {
      _addCurrentLocationMarker();
    }
  }

  void _onCameraPositionChanged(
      CameraPosition position,
      CameraUpdateReason reason,
      bool finished,
      ) {
    if (finished) {
      final newZoom = position.zoom;
      final shouldCluster = newZoom < 12.0;

      if (shouldCluster != isClusterMode) {
        setState(() {
          currentZoom = newZoom;
          isClusterMode = shouldCluster;
        });

        if (isClusterMode) {
          _createClusterMarkers();
        } else {
          _createMarkers();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Yandex Map
          if (!isLoadingLocation)
            YandexMap(
              onMapCreated: _onMapCreated,
              onCameraPositionChanged: _onCameraPositionChanged,
              mapObjects: placemarks,
              nightModeEnabled: false,
              rotateGesturesEnabled: true,
              scrollGesturesEnabled: true,
              tiltGesturesEnabled: true,
              zoomGesturesEnabled: true,
              mapType: MapType.vector,
            )
          else
            const Center(
              child: CircularProgressIndicator(),
            ),

          // Search Bar
          Positioned(
            top: 50,
            left: 16,
            right: 70,
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search Properties',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                onSubmitted: (value) {
                  // Search implementation
                },
              ),
            ),
          ),

          // Filter Button
          Positioned(
            top: 50,
            right: 16,
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.tune, color: Colors.black87),
                onPressed: () {
                  // Show filter dialog
                },
              ),
            ),
          ),

          // Current Location Button
          Positioned(
            bottom: selectedProperty != null ? 180 : 30,
            right: 16,
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: _getCurrentLocation,
              child: const Icon(Icons.my_location, color: Colors.blue),
            ),
          ),

          // Property Card
          if (selectedProperty != null)
            Positioned(
              bottom: 20,
              left: 16,
              right: 16,
              child: _buildPropertyCard(selectedProperty!),
            ),
        ],
      ),
    );
  }

  Widget _buildPropertyCard(Property property) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Property Image
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              bottomLeft: Radius.circular(16),
            ),
            child: Image.network(
              property.imageUrl,
              width: 120,
              height: 140,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 120,
                  height: 140,
                  color: Colors.grey[300],
                  child: const Icon(Icons.home, size: 40, color: Colors.grey),
                );
              },
            ),
          ),

          // Property Details
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        property.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$${property.price}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF5B51FF),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        property.location,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      _buildPropertyFeature(Icons.bed, '${property.bedrooms}'),
                      const SizedBox(width: 12),
                      _buildPropertyFeature(
                        Icons.bathtub,
                        '${property.bathrooms}',
                      ),
                      const SizedBox(width: 12),
                      _buildPropertyFeature(
                        Icons.square_foot,
                        '${property.area}',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Favorite Button
          Padding(
            padding: const EdgeInsets.all(8),
            child: IconButton(
              icon: const Icon(Icons.favorite_border),
              color: Colors.grey[600],
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyFeature(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}