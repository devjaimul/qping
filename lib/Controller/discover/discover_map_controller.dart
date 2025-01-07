import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:qping/global_widgets/custom_text.dart';
import 'package:qping/global_widgets/custom_text_button.dart';
import 'package:qping/global_widgets/custom_text_field.dart';
import 'package:qping/utils/app_colors.dart';

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
      'name': 'Ahad Munshi',
      'image': 'https://imgs.search.brave.com/7pbjW4GuowwR959yWtROSCo5YtMblsLY3tBUcbe9Bdw/rs:fit:500:0:0:0/g:ce/aHR0cHM6Ly9pLnBp/bmltZy5jb20vb3Jp/Z2luYWxzLzNiLzcx/L2Q1LzNiNzFkNWZi/MTQ1NWY2MDNiM2Rl/MmNiY2M4MThhMWVk/LmpwZw',
      'location': LatLng(23.759287273526724, 90.42894329783785),
    },
    {
      'id': '2',
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
      await _addNearbyPeopleMarkers();
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

  Future<void> _addNearbyPeopleMarkers() async {
    for (var person in nearbyPeople) {
      final markerIcon = await _createCustomMarker(person['image']);
      markers.add(
        Marker(
          markerId: MarkerId(person['id']),
          position: person['location'],
          infoWindow: InfoWindow(
            title: person['name'],
            onTap: () => showPersonInfo(person),
          ),
          icon: markerIcon,
        ),
      );
    }
  }

  Future<BitmapDescriptor> _createCustomMarker(String imageUrl) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final double markerSize = 150.r;

    // Draw marker background (red circle)
    final Paint paint = Paint()..color = AppColors.primaryColor;
    canvas.drawCircle(
      Offset(markerSize / 2, markerSize / 2),
      markerSize / 2,
      paint,
    );

    // Download the user image
    final Uint8List imageBytes = await _downloadImage(imageUrl);
    final ui.Image userImage = await _loadImage(imageBytes);

    // Draw the user image clipped into a circular shape
    final double imageSize = 120.h;
    final Rect imageRect = Rect.fromLTWH(
      (markerSize - imageSize) / 2,
      (markerSize - imageSize) / 2,
      imageSize,
      imageSize,
    );

    final Path circlePath = Path()
      ..addOval(imageRect)
      ..close();
    canvas.clipPath(circlePath);
    canvas.drawImageRect(
      userImage,
      Rect.fromLTWH(0, 0, userImage.width.toDouble(), userImage.height.toDouble()),
      imageRect,
      Paint(),
    );

    // Finalize and convert to BitmapDescriptor
    final ui.Image markerImage = await pictureRecorder.endRecording().toImage(markerSize.toInt(), markerSize.toInt());
    final ByteData? byteData = await markerImage.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List bytes = byteData!.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(bytes);
  }


  Future<Uint8List> _downloadImage(String url) async {
    final http.Response response = await http.get(Uri.parse(url));
    return response.bodyBytes;
  }

  Future<ui.Image> _loadImage(Uint8List imageBytes) async {
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(imageBytes, (ui.Image img) {
      completer.complete(img);
    });
    return completer.future;
  }

  void showPersonInfo(Map<String, dynamic> person) {
    Get.dialog(
      AlertDialog(
        title: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Icon(Icons.close, size: 24.sp, color: Colors.black),
              ),
            ),
            CircleAvatar(
              radius: 50.r,
              backgroundImage: NetworkImage(person['image']),
            ),
          ],
        ),
        content: Column(
          spacing: 20.h,
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextOne(text: person['name']),
            CustomTextField(
              controller: TextEditingController(),
              hintText: "Type your message",
            ),
            CustomTextButton(
              text: "Send Message",
              onTap: () {
                Get.snackbar('Message', 'Message sent to ${person['name']}!');
              },
            ),
          ],
        ),
      ),
    );
  }
}
