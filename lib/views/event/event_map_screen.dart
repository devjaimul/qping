import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:qping/global_widgets/custom_text.dart';
import 'package:qping/global_widgets/custom_text_button.dart';
import 'package:qping/services/api_constants.dart';
import 'package:qping/utils/app_colors.dart';

class EventMapScreen extends StatefulWidget {
  const EventMapScreen({super.key});

  @override
  State<EventMapScreen> createState() => _EventMapScreenState();
}

class _EventMapScreenState extends State<EventMapScreen> {
  late GoogleMapController _mapController;
  LatLng _currentLocation = const LatLng(23.758855691617622, 90.42896325285551); // Example current location (San Francisco)
  LatLng _targetLocation = const LatLng(23.759359333841253, 90.44312769232896); // Example target location (Near SF)

  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  Circle? _circle;

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> polyline = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int shift = 0, result = 0;
      int b;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int deltaLat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += deltaLat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int deltaLng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += deltaLng;

      polyline.add(LatLng(lat / 1e5, lng / 1e5));
    }
    return polyline;
  }

  final String _googleApiKey = ApiConstants.googleMapKey; // Replace with your API key

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
      _initializeMapElements();
      _getDirections();
    });
  }

  void _initializeMapElements() {
    // Add markers
    _markers = {
      Marker(
        markerId: const MarkerId("currentLocation"),
        position: _currentLocation,
        infoWindow: const InfoWindow(title: "You are here"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
      Marker(
        markerId: const MarkerId("targetLocation"),
        position: _targetLocation,
        infoWindow: const InfoWindow(title: "Find Dooley!"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    };

    // Add circle around target location
    _circle = Circle(
      circleId: const CircleId("targetCircle"),
      center: _targetLocation,
      radius: 500, // 500 meters
      fillColor: Colors.red.withOpacity(0.3),
      strokeColor: Colors.red,
      strokeWidth: 2,
    );
  }

  Future<void> _getDirections() async {
    final String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${_currentLocation.latitude},${_currentLocation.longitude}&destination=${_targetLocation.latitude},${_targetLocation.longitude}&key=$_googleApiKey";

    try {
      final http.Response response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data["status"] == "OK") {
          final overviewPolyline = data["routes"][0]["overview_polyline"]["points"];
          List<LatLng> polylineCoordinates = _decodePolyline(overviewPolyline);

          setState(() {
            _polylines = {
              Polyline(
                polylineId: const PolylineId("route"),
                points: polylineCoordinates,
                color: Colors.blue,
                width: 5,
              ),
            };
          });
        }
        else {
          debugPrint("Directions API Error: ${data["status"]}");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error: ${data["status"]}")),
          );
        }
      } else {
        debugPrint("HTTP Error: ${response.statusCode}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("HTTP Error: ${response.statusCode}")),
        );
      }
    } catch (e) {
      debugPrint("Exception: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to fetch directions. Try again.")),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomTextOne(text: "Hunt",color: AppColors.textColor,fontSize: 18.sp,),
      ),
      body: Stack(
        children: [
          // Google Map
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _currentLocation,
              zoom: 14.0,
            ),
            myLocationEnabled: true,
            markers: _markers,
            polylines: _polylines,
            circles: _circle != null ? {_circle!} : {},
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
          ),



          // Bottom button
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding:  EdgeInsets.all(16.r),
              child: CustomTextButton(text: "Stop Hunting", onTap: (){}),
            )
          ),
        ],
      ),
    );
  }

}
