import 'dart:async';

import 'package:dar_plus_app/configuration/app_colors.dart';
import 'package:dar_plus_app/utils/ui/app_back_button.dart';
import 'package:dar_plus_app/utils/ui/app_buttons.dart';
import 'package:dar_plus_app/utils/ui/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';

class SelectLocationScreen extends StatefulWidget {
  const SelectLocationScreen({
    super.key,
    this.initialLatitude,
    this.initialLongitude,
  });

  final double? initialLatitude;
  final double? initialLongitude;

  @override
  State<SelectLocationScreen> createState() => _SelectLocationScreenState();
}

class _SelectLocationScreenState extends State<SelectLocationScreen> {
  static const _defaultPosition = LatLng(31.9539, 35.9106); // Amman, Jordan

  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();
  late LatLng _selectedPosition;
  bool _mapReady = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialLatitude != null && widget.initialLongitude != null) {
      _selectedPosition =
          LatLng(widget.initialLatitude!, widget.initialLongitude!);
    } else {
      _selectedPosition = _defaultPosition;
      _resolveCurrentPosition();
    }
  }

  Future<void> _resolveCurrentPosition() async {
    final current = await _getCurrentPosition();
    if (current == null || !mounted) return;

    final latLng = LatLng(current.latitude, current.longitude);
    setState(() => _selectedPosition = latLng);

    if (_mapReady) {
      final controller = await _mapController.future;
      await controller.animateCamera(CameraUpdate.newLatLngZoom(latLng, 15));
    }
  }

  Future<Position?> _getCurrentPosition() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return null;

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return null;
      }
      if (permission == LocationPermission.deniedForever) return null;

      return Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
    } catch (_) {
      return null;
    }
  }

  void _onMapTap(LatLng position) {
    setState(() => _selectedPosition = position);
  }

  Future<void> _goToCurrentLocation() async {
    final position = await _getCurrentPosition();
    if (position == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not get current location.')),
        );
      }
      return;
    }

    final latLng = LatLng(position.latitude, position.longitude);
    setState(() => _selectedPosition = latLng);
    if (_mapReady) {
      final controller = await _mapController.future;
      await controller.animateCamera(CameraUpdate.newLatLngZoom(latLng, 16));
    }
  }

  void _confirmSelection() {
    Navigator.of(context).pop(_selectedPosition);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: _selectedPosition,
                        zoom: 15,
                      ),
                      onMapCreated: (controller) {
                        _mapController.complete(controller);
                        _mapReady = true;
                      },
                      onTap: _onMapTap,
                      mapType: MapType.normal,
                      myLocationEnabled: true,
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,
                      compassEnabled: true,
                      markers: {
                        Marker(
                          markerId: const MarkerId('selected'),
                          position: _selectedPosition,
                          draggable: true,
                          onDragEnd: (position) {
                            setState(() => _selectedPosition = position);
                          },
                        ),
                      },
                    ),
                  ),
                  Positioned(
                    right: 4.w,
                    bottom: 2.h,
                    child: FloatingActionButton(
                      heroTag: 'current_location',
                      backgroundColor: AppColors.whiteColor,
                      onPressed: _goToCurrentLocation,
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
                  Text(
                    'Lat: ${_selectedPosition.latitude.toStringAsFixed(6)}, '
                    'Lng: ${_selectedPosition.longitude.toStringAsFixed(6)}',
                      style: appTextStyle(
                        context,
                        fontSize: 10.sp,
                        color: AppColors.grayBrandColor,
                      ),
                    ),
                  SizedBox(height: 1.h),
                  AppButton(
                    onPressed: _confirmSelection,
                    backgroundColor: AppColors.goldBrandColor,
                    child: Text(
                      'Confirm Location',
                      style: appTextStyle(
                        context,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.whiteColor,
                      ),
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

  Widget _buildHeader() {
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
          const AppBackButton(),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              'Select Location',
              style: appTextStyle(
                context,
                fontSize: 16.sp,
                fontWeight: FontWeight.w900,
                color: Colors.black.withAlpha(240),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
