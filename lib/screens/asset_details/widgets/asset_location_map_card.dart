import 'package:dar_plus_app/configuration/app_colors.dart';
import 'package:dar_plus_app/features/assets/data/models/asset_item.dart';
import 'package:dar_plus_app/main.dart';
import 'package:dar_plus_app/screens/assets/asset_location_map_screen.dart';
import 'package:dar_plus_app/utils/ui/app_text_styles.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';

class AssetLocationMapCard extends StatelessWidget {
  final AssetItem asset;

  const AssetLocationMapCard({super.key, required this.asset});

  LatLng get _position => LatLng(asset.latitude!, asset.longitude!);

  void _openFullMap(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AssetLocationMapScreen(
          latitude: asset.latitude!,
          longitude: asset.longitude!,
          title: asset.name,
          subtitle: asset.location,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tr.location_section,
          style: appTextStyle(
            context,
            fontSize: 13.sp,
            fontWeight: FontWeight.w900,
            color: Colors.black.withAlpha(240),
          ),
        ),
        SizedBox(height: 1.h),
        GestureDetector(
          onTap: () => _openFullMap(context),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.goldBrandColor.withAlpha(60)),
              boxShadow: [
                BoxShadow(
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                  color: Colors.black.withAlpha(10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SizedBox(
                height: 22.h,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    AbsorbPointer(
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: _position,
                          zoom: 15,
                        ),
                        markers: {
                          Marker(
                            markerId: const MarkerId('asset_preview'),
                            position: _position,
                          ),
                        },
                        mapType: MapType.normal,
                        myLocationEnabled: false,
                        myLocationButtonEnabled: false,
                        zoomControlsEnabled: false,
                        compassEnabled: false,
                        rotateGesturesEnabled: false,
                        scrollGesturesEnabled: false,
                        tiltGesturesEnabled: false,
                        zoomGesturesEnabled: false,
                        liteModeEnabled:
                            defaultTargetPlatform == TargetPlatform.android,
                      ),
                    ),
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withAlpha(40),
                              Colors.black.withAlpha(120),
                            ],
                            stops: const [0.45, 0.75, 1],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 4.w,
                      right: 4.w,
                      bottom: 1.4.h,
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  asset.location,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: appTextStyle(
                                    context,
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 0.3.h),
                                Text(
                                  tr.tap_to_view_map,
                                  style: appTextStyle(
                                    context,
                                    fontSize: 9.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white.withAlpha(210),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 3.5.w,
                              vertical: 0.9.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.goldBrandColor,
                              borderRadius: BorderRadius.circular(999),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      AppColors.goldBrandColor.withAlpha(80),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.fullscreen_rounded,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                SizedBox(width: 1.5.w),
                                Text(
                                  tr.view_on_map,
                                  style: appTextStyle(
                                    context,
                                    fontSize: 9.sp,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
