// DiscoverMapScreen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:qping/Controller/discover/discover_map_controller.dart';
import 'package:qping/global_widgets/custom_text_field.dart';
import 'package:qping/utils/app_colors.dart';

class DisCoverMapScreen extends StatefulWidget {
  const DisCoverMapScreen({super.key});

  @override
  State<DisCoverMapScreen> createState() => _DisCoverMapScreenState();
}

class _DisCoverMapScreenState extends State<DisCoverMapScreen> {
  final DiscoverMapController mapController = Get.put(DiscoverMapController());
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    mapController.checkLocationPermission();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(375, 812));

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, size: 24.sp),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                  Expanded(
                    child: CustomTextField(controller: _searchController,hintText: 'Search Location or Keyword',
                    suffixIcon:  IconButton(
                      icon: Icon(Icons.search,color: AppColors.primaryColor,),
                      onPressed: () {
                        mapController.searchLocation(
                          _searchController.text.trim(),
                        );
                      },
                    ),
                    )
                  ),
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                return GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition:
                  DiscoverMapController.initialPosition,
                  myLocationEnabled: true,
                  markers: mapController.markers.value,
                  onMapCreated: (GoogleMapController controller) {
                    mapController.mapController.complete(controller);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
