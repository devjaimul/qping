// DiscoverMapController.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qping/global_widgets/custom_text.dart';

class DiscoverMapController extends GetxController {
  final Completer<GoogleMapController> mapController = Completer();
  final RxSet<Marker> markers = <Marker>{}.obs;
  final Rx<LatLng?> selectedLocation = Rx<LatLng?>(null);
  final RxString searchAddress = ''.obs;
  Position? currentPosition;

  static const CameraPosition initialPosition = CameraPosition(
    target: LatLng(-6.2088, 106.8456),
    zoom: 14.0,
  );

  final List<Map<String, dynamic>> nearbyPeople = [
    {
      'id': '1',
      'name': 'John Doe',
      'image': 'https://via.placeholder.com/150',
      'location': LatLng(-6.2078, 106.8450),
    },
    {
      'id': '2',
      'name': 'Jane Smith',
      'image': 'https://via.placeholder.com/150',
      'location': LatLng(-6.2090, 106.8460),
    },
    {
      'id': '3',
      'name': 'Chris Johnson',
      'image': 'https://via.placeholder.com/150',
      'location': LatLng(-6.2100, 106.8440),
    },
  ];

  @override
  void onInit() {
    super.onInit();
    checkLocationPermission();
  }

  Future<void> checkLocationPermission() async {
    if (await Permission.location.request().isGranted) {
      await _getCurrentLocation();
      _addNearbyPeopleMarkers();
    } else {
      Get.snackbar(
        'Permission Denied',
        'Location permission is required to use this feature.',
      );
    }
  }

  Future<void> _getCurrentLocation() async {
    currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    markers.add(
      Marker(
        markerId: const MarkerId('currentLocation'),
        position: LatLng(currentPosition!.latitude, currentPosition!.longitude),
        infoWindow: const InfoWindow(title: 'You are here'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      ),
    );

    final GoogleMapController controller = await mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(currentPosition!.latitude, currentPosition!.longitude),
      zoom: 14.0,
    )));
  }

  void _addNearbyPeopleMarkers() {
    for (var person in nearbyPeople) {
      markers.add(
        Marker(
          markerId: MarkerId(person['id']),
          position: person['location'],
          infoWindow: InfoWindow(
            title: person['name'],
            onTap: () => showPersonInfo(person),
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    }
  }

  void showPersonInfo(Map<String, dynamic> person) {
    Get.dialog(
      AlertDialog(
        title: Text(person['name']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.network(person['image'], height: 100, width: 100),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Logic for sending a message
                Get.snackbar('Message', 'Message sent to ${person['name']}!');
              },
              child: Text('Send Message'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}
