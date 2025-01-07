// DiscoverMapController.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qping/global_widgets/custom_text.dart';
import 'package:qping/global_widgets/custom_text_button.dart';
import 'package:qping/global_widgets/custom_text_field.dart';

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
    {
      'id': '4',
      'name': 'Ahad Munshi',
      'image': 'https://imgs.search.brave.com/7pbjW4GuowwR959yWtROSCo5YtMblsLY3tBUcbe9Bdw/rs:fit:500:0:0:0/g:ce/aHR0cHM6Ly9pLnBp/bmltZy5jb20vb3Jp/Z2luYWxzLzNiLzcx/L2Q1LzNiNzFkNWZi/MTQ1NWY2MDNiM2Rl/MmNiY2M4MThhMWVk/LmpwZw',
      'location': LatLng(23.759287273526724, 90.42894329783785),
    },
    {
      'id': '5',
      'name': 'Ashique',
      'image': "https://imgs.search.brave.com/1JofeKOgrP4Ez9lHmxBPZqekvGWtxx2pVTuTkvpI07Y/rs:fit:500:0:0:0/g:ce/aHR0cHM6Ly9pLnBp/bmltZy5jb20vb3Jp/Z2luYWxzL2I0LzZl/LzUxL2I0NmU1MTg4/OTRjMTkzNmQzMzFj/MjY0OTRiYzRlMjc4/LS1pdGFjaGktYWth/dHN1a2ktc2FzdWtl/LXVjaGloYS5qcGc",
      'location': LatLng(23.75872184162463, 90.42932194380249),
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
        title:  Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () {Get.back();},
                child: Icon(Icons.close, size: 24.sp, color: Colors.black),
              ),
            ),
            CircleAvatar(radius: 50.r, backgroundImage: NetworkImage(person['image']),),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 20.h,
          children: [
            CustomTextOne(text: person['name']),
            CustomTextField(controller: TextEditingController(),hintText: "type your message",),
          CustomTextButton(text: "Send Message", onTap: (){
            Get.snackbar('Message', 'Message sent to ${person['name']}!');
          }),

          ],
        ),
      ),
    );
  }
}
