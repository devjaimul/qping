import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qping/Controller/discover/discover_controller.dart';
import 'package:qping/global_widgets/custom_text.dart';
import 'package:qping/global_widgets/custom_text_button.dart';
import 'package:qping/services/api_constants.dart';
import 'package:qping/utils/app_colors.dart';
import 'package:qping/utils/app_images.dart';
import 'package:shimmer/shimmer.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final DiscoverScreenController controller = Get.put(DiscoverScreenController());
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Pagination trigger when scrolling near bottom
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 50) {
        if (!controller.isLoading.value) {
          controller.fetchGroupList();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async{
            await controller.fetchGroupList();
          },
          child: Obx(
                () {
              if (controller.isLoading.value && controller.groupList.isEmpty) {
                return ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding:  EdgeInsets.symmetric(horizontal: 16.w),
                      child: Card(
                        color: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.all(10.r),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  width: double.infinity,
                                  height: 20.h,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 5.h),
                              Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  width: 150.w,
                                  height: 20.h,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 10.h),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }

              if (controller.groupList.isEmpty) {
                // No data
                return Center(child: CustomTextOne(text: "No groups found", fontSize: 16.sp));
              }

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Title Row
                    Row(
                      children: [
                        // Example emoji or icon
                        Text(
                          "✨",
                          style: TextStyle(fontSize: 20.sp),
                        ),
                        SizedBox(width: 8.w),
                        CustomTextOne(
                          text: "Discover Groups",
                          fontSize: 18.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),

                    /// Groups List
                    Expanded(
                      child: ListView.separated(
                        controller: _scrollController,
                        itemCount: controller.groupList.length,
                        separatorBuilder: (_, __) => SizedBox(height: 12.h),
                        itemBuilder: (context, index) {
                          final group = controller.groupList[index];
                          final avatar = group['avatar'] ?? '';
                          final name = group['name'] ?? '';
                          final totalMember = group['totalMember'] ?? '0';
                          final description = group['description'] ?? '';
                          final groupId = group['_id'] ?? '';

                          return _buildGroupItem(
                            image: avatar,
                            name: name,
                            members: "$totalMember Members",
                            description: description,
                            onJoinTap: () => controller.joinGroup(groupId),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildGroupItem({
    required String image,
    required String name,
    required String members,
    required String description,
    required VoidCallback onJoinTap,
  }) {
    return Container(
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5.r,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /// Group Image
          CircleAvatar(
            radius: 30.r,
            backgroundImage: image.isNotEmpty
                ? NetworkImage("${ApiConstants.imageBaseUrl}/$image")
                : null,
            child: image.isEmpty
                ? CustomTextOne(
              text: name.isNotEmpty ? name[0].toString().toUpperCase() : "?",
              fontSize: 14.sp,
            )
                : null,
          ),
          SizedBox(width: 10.w),

          /// Group Info
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Group Name
                CustomTextOne(
                  text: name,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  maxLine: 1,
                  textOverflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                // Members Count
                CustomTextOne(
                  text: members,
                  fontSize: 12.sp,
                  color: Colors.grey,
                  maxLine: 1,
                ),
                SizedBox(height: 4.h),
                // Description
                CustomTextOne(
                  text: description,
                  fontSize: 12.sp,
                  color: Colors.grey,
                  textAlign: TextAlign.start,
                  maxLine: 2,
                  textOverflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          /// Join Button
          Expanded(
            child: CustomTextButton(
              onTap: onJoinTap, // <--- Calls joinGroup in the controller
              text: "Join",
              fontSize: 14.sp,
              padding: 0,
              color: Colors.transparent,
              textColor: AppColors.primaryColor,
              borderColor: AppColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
