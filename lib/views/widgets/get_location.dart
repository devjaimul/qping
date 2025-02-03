import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qping/global_widgets/custom_text.dart';
import 'package:qping/global_widgets/custom_text_field.dart';


class GetLocation extends StatefulWidget {
  const GetLocation({super.key});

  @override
  State<GetLocation> createState() => _GetLocationState();
}

class _GetLocationState extends State<GetLocation> {
  final Completer<GoogleMapController> _controller = Completer();
  Position? _currentPosition;
  final Set<Marker> _markers = {};
  LatLng? _selectedLocation;
  final TextEditingController _locationController = TextEditingController();

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(51.5074, -0.1278),
    zoom: 14.0,
  );

  // Constants for text and error messages
  static const String pleaseSelectLocation =
      'Please select a location on the map';
  static const String failedToRetrieveAddress = 'Failed to retrieve address';

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    // Check if location services are enabled
    if (!await Geolocator.isLocationServiceEnabled()) {
      _showLocationServicesDialog();
      return;
    }

    // Request location permission using Geolocator
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
       Get.snackbar("!!!", 'Location permission is denied.');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
    Get.snackbar("!!!", "Location permission is permanently denied. Please enable it in settings.");
      openAppSettings(); // Redirect user to app settings
      return;
    }

    // If permission is granted, get current location
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _currentPosition = position;
      _markers.add(
        Marker(
          markerId: const MarkerId('currentLocation'),
          position: LatLng(position.latitude, position.longitude),
          infoWindow: const InfoWindow(title: 'You are here'),
        ),
      );
    });

    _goToCurrentLocation();
  }



  Future<void> _goToCurrentLocation() async {
    final GoogleMapController controller = await _controller.future;
    if (_currentPosition != null) {
      CameraPosition cameraPosition = CameraPosition(
        target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        zoom: 14.0,
      );
      controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    }
  }

  Future<String?> _getAddressFromLatLng(LatLng latLng) async {
    List<Placemark> placemarks =
    await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
    if (placemarks.isNotEmpty) {
      Placemark place = placemarks[0];
      return '${place.locality}, ${place.country}'; // Customize as per your requirement
    }
    return null;
  }

  void _onMapTapped(LatLng location) async {
    String? address = await _getAddressFromLatLng(location);

    setState(() {
      _selectedLocation = location;
      _markers.add(
        Marker(
          markerId: const MarkerId('selectedLocation'),
          position: location,
          infoWindow: const InfoWindow(title: 'Selected Location'),
        ),
      );
      if (address != null) {
        _locationController.text = address; // Update the text field with the address
      }
    });
  }

  @override
  void dispose() {
    _locationController.dispose(); // Dispose the controller when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: CustomTextOne(
            text: "Location",
            fontSize: 18.sp,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: () async {
                if (_selectedLocation != null) {
                  String? address =
                  await _getAddressFromLatLng(_selectedLocation!);
                  if (address != null) {
                    Map<String, dynamic> locationData = {
                      'address': address,
                      'latitude': _selectedLocation!.latitude,
                      'longitude': _selectedLocation!.longitude,
                    };
                    Get.back(
                        result:
                        locationData); // Return the address and location data back to the previous screen
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text(failedToRetrieveAddress)),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text(pleaseSelectLocation)),
                  );
                }
              },
            ),
          ],
          bottom: PreferredSize(
              preferredSize: Size.fromHeight(60.h),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
                child: CustomTextField(
                  controller: _locationController,
                  hintText: 'Search Location',
                  suffixIcon: IconButton(
                      onPressed: () {
                        _searchLocation();
                      },
                      icon: const Icon(Icons.search)),
                ),
              ))),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _initialPosition,
            myLocationEnabled: true,
            markers: _markers,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            onTap: _onMapTapped,
          ),
        ],
      ),
    );
  }

  Future<void> _searchLocation() async {
    if (_locationController.text.isNotEmpty) {
      try {
        List<Location> locations =
        await locationFromAddress(_locationController.text);
        if (locations.isNotEmpty) {
          LatLng searchedLocation =
          LatLng(locations[0].latitude, locations[0].longitude);

          final GoogleMapController controller = await _controller.future;
          controller.animateCamera(CameraUpdate.newLatLng(searchedLocation));

          setState(() {
            _markers.clear();
            _markers.add(Marker(
              markerId: const MarkerId('searchedLocation'),
              position: searchedLocation,
              infoWindow: InfoWindow(title: _locationController.text),
            ));
            _selectedLocation = searchedLocation;
          });
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location not found')),
        );
      }
    }
  }

  void _showLocationServicesDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Location Services Disabled'),
          content: const Text('Please enable location services to continue.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                await Geolocator.openLocationSettings(); // Open location settings
              },
              child: const Text('Turn On'),
            ),
          ],
        );
      },
    );
  }

}
