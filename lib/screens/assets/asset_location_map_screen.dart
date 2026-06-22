import 'dart:async';

import 'package:dar_plus_app/configuration/app_colors.dart';
import 'package:dar_plus_app/main.dart';
import 'package:dar_plus_app/utils/helpers/map_navigation.dart';
import 'package:dar_plus_app/utils/ui/app_buttons.dart';
import 'package:dar_plus_app/utils/ui/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';

class AssetLocationMapScreen extends StatefulWidget {
  final double latitude;
  final double longitude;
  final String title;
  final String? subtitle;

  const AssetLocationMapScreen({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.title,
    this.subtitle,
  });

  @override
  State<AssetLocationMapScreen> createState() => _AssetLocationMapScreenState();
}

class _AssetLocationMapScreenState extends State<AssetLocationMapScreen> {
  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();
  bool _mapReady = false;

  LatLng get _position => LatLng(widget.latitude, widget.longitude);

  Set<Marker> get _markers => {
        Marker(
          markerId: const MarkerId('asset'),
          position: _position,
          infoWindow: InfoWindow(
            title: widget.title,
            snippet: widget.subtitle,
          ),
        ),
      };

  Future<void> _recenterMap() async {
    if (!_mapReady) return;
    final controller = await _mapController.future;
    await controller.animateCamera(
      CameraUpdate.newLatLngZoom(_position, 16),
    );
  }

  Future<void> _openExternalMaps() async {
    final ok = await launchGoogleMaps(
      latitude: widget.latitude,
      longitude: widget.longitude,
    );
    if (!mounted || ok) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(tr.something_went_wrong)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: _position,
                        zoom: 16,
                      ),
                      onMapCreated: (controller) {
                        _mapController.complete(controller);
                        _mapReady = true;
                      },
                      markers: _markers,
                      mapType: MapType.normal,
                      myLocationEnabled: true,
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,
                      compassEnabled: true,
                    ),
                  ),
                  Positioned(
                    right: 4.w,
                    bottom: 2.h,
                    child: FloatingActionButton(
                      heroTag: 'recenter_asset_map',
                      backgroundColor: AppColors.whiteColor,
                      onPressed: _recenterMap,
                      child: const Icon(
                        Icons.my_location_rounded,
                        color: AppColors.goldBrandColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(5.w, 1.h, 5.w, 2.h),
              child: Column(
                children: [
                  if (widget.subtitle != null &&
                      widget.subtitle!.trim().isNotEmpty) ...[
                    Text(
                      widget.subtitle!,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: appTextStyle(
                        context,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black.withAlpha(140),
                      ),
                    ),
                    SizedBox(height: 1.h),
                  ],
                  Text(
                    'Lat: ${widget.latitude.toStringAsFixed(6)}, '
                    'Lng: ${widget.longitude.toStringAsFixed(6)}',
                    style: appTextStyle(
                      context,
                      fontSize: 9.5.sp,
                      color: AppColors.grayBrandColor,
                    ),
                  ),
                  SizedBox(height: 1.2.h),
                  AppButton(
                    onPressed: _openExternalMaps,
                    backgroundColor: AppColors.goldBrandColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.map_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          tr.open_in_google_maps,
                          style: appTextStyle(
                            context,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.whiteColor,
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
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.grayBrandColor.withAlpha(20),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18,
                color: AppColors.blackColor,
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tr.view_on_map,
                  style: appTextStyle(
                    context,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w900,
                    color: Colors.black.withAlpha(240),
                  ),
                ),
                Text(
                  widget.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: appTextStyle(
                    context,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black.withAlpha(120),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
