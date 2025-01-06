// DiscoverMapScreen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:qping/Controller/discover/discover_map_controller.dart';
import 'package:qping/global_widgets/custom_text_field.dart';
import 'package:qping/utils/app_icons.dart';

class DisCoverMapScreen extends StatefulWidget {
  const DisCoverMapScreen({super.key});

  @override
  State<DisCoverMapScreen> createState() => _DisCoverMapScreenState();
}

class _DisCoverMapScreenState extends State<DisCoverMapScreen> {
  final DiscoverMapController mapController = Get.put(DiscoverMapController());

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
                    child: Obx(() {
                      return CustomTextField(
                        controller: TextEditingController(
                          text: mapController.searchAddress.value,
                        ),
                        hintText: 'Search Location or Keyword',
                        onChanged: (value) {},
                        prefixIcon: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: SizedBox(
                            height: 20.h,
                            width: 20.w,
                            child: Image.asset(AppIcons.search),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  Obx(() {
                    return GoogleMap(
                      mapType: MapType.normal,
                      initialCameraPosition: DiscoverMapController.initialPosition,
                      myLocationEnabled: true,
                      markers: mapController.markers.value,
                      onMapCreated: (GoogleMapController controller) {
                        mapController.mapController.complete(controller);
                      },
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
