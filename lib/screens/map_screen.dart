import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as permission;

import '../constants/app_constants.dart';
import '../constants/app_theme.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_button.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  final Location _location = Location();
  final Set<Marker> _markers = {};
  
  CameraPosition _initialPosition = const CameraPosition(
    target: LatLng(37.7749, -122.4194), // Default to San Francisco
    zoom: 12,
  );
  
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  Future<void> _initializeMap() async {
    final status = await permission.Permission.location.request();
    if (status != permission.PermissionStatus.granted) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      final locationData = await _location.getLocation();
      _initialPosition = CameraPosition(
        target: LatLng(locationData.latitude!, locationData.longitude!),
        zoom: 14,
      );
      
      // Add mock sign language resources
      _addMockMarkers();
      
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error getting location: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _addMockMarkers() {
    // Mock data for sign language resources
    final resources = [
      {
        'name': 'Sign Language Center',
        'description': 'Classes and resources for sign language learners',
        'position': LatLng(
          _initialPosition.target.latitude + 0.01,
          _initialPosition.target.longitude + 0.01,
        ),
        'type': 'education',
      },
      {
        'name': 'Deaf Community Center',
        'description': 'Community center for deaf and hard of hearing individuals',
        'position': LatLng(
          _initialPosition.target.latitude - 0.01,
          _initialPosition.target.longitude - 0.01,
        ),
        'type': 'community',
      },
      {
        'name': 'Sign Language Interpreter Services',
        'description': 'Professional sign language interpretation services',
        'position': LatLng(
          _initialPosition.target.latitude + 0.02,
          _initialPosition.target.longitude - 0.02,
        ),
        'type': 'service',
      },
      {
        'name': 'Deaf-Friendly Cafe',
        'description': 'Cafe with staff trained in basic sign language',
        'position': LatLng(
          _initialPosition.target.latitude - 0.02,
          _initialPosition.target.longitude + 0.02,
        ),
        'type': 'business',
      },
    ];

    for (var i = 0; i < resources.length; i++) {
      final resource = resources[i];
      _markers.add(
        Marker(
          markerId: MarkerId('marker_$i'),
          position: resource['position'] as LatLng,
          infoWindow: InfoWindow(
            title: resource['name'] as String,
            snippet: resource['description'] as String,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            _getMarkerHue(resource['type'] as String),
          ),
        ),
      );
    }
  }

  double _getMarkerHue(String type) {
    switch (type) {
      case 'education':
        return BitmapDescriptor.hueBlue;
      case 'community':
        return BitmapDescriptor.hueViolet;
      case 'service':
        return BitmapDescriptor.hueGreen;
      case 'business':
        return BitmapDescriptor.hueOrange;
      default:
        return BitmapDescriptor.hueRed;
    }
  }

  Future<void> _goToCurrentLocation() async {
    try {
      final locationData = await _location.getLocation();
      final controller = await _controller.future;
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(locationData.latitude!, locationData.longitude!),
            zoom: 15,
          ),
        ),
      );
    } catch (e) {
      debugPrint('Error going to current location: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppStrings.errorNoLocation),
          backgroundColor: AppColors.errorColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(
        title: AppStrings.mapTitle,
      ),
      body: Stack(
        children: [
          _isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                )
              : GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: _initialPosition,
                  markers: _markers,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  compassEnabled: true,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                ),
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                AppStrings.mapInstructions,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: _goToCurrentLocation,
              backgroundColor: AppColors.primaryColor,
              child: const Icon(Icons.my_location),
            ),
          ),
        ],
      ),
    );
  }
} 