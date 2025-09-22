import 'package:flutter/material.dart';
import 'package:housell/config/theme/app_colors.dart';
import 'package:housell/core/widgets/app_text.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late YandexMapController _mapController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                // Yandex Map
                YandexMap(
                  onMapCreated: (YandexMapController controller) async {
                    _mapController = controller;
                    await _mapController.moveCamera(
                      CameraUpdate.newCameraPosition(
                        const CameraPosition(
                          target: Point(latitude: 41.2995, longitude: 69.2401),
                          zoom: 12.0,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
