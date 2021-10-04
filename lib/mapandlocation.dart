import 'dart:collection';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:huawei_location/location/fused_location_provider_client.dart';
import 'package:huawei_location/location/location.dart' as HuaweiLocationModel;
import 'package:huawei_map/constants/param.dart';

import 'package:huawei_map/map.dart';

class HuaweiMapDemo extends StatefulWidget {
  @override
  _HuaweiMapDemoState createState() => _HuaweiMapDemoState();
}

class _HuaweiMapDemoState extends State<HuaweiMapDemo> {
  static const double _zoom = 10;

  late FusedLocationProviderClient fusedLocation;
  late HuaweiMapController mapController;
  Set<Marker> markerlist = Set();

  MapType _currentMapType = MapType.normal;
  bool _trafficEnabled = false;

  bool _isLocSourceActive = false;
  String lastLocation = "";
  CameraPosition cam =
      CameraPosition(target: LatLng(20.012959, 35.997438), zoom: _zoom);
  // CameraPosition(target: LatLng(41.012959, 28.997438), zoom: _zoom);

  late CameraPosition cameraPosition;
  LatLng _latLng = LatLng(24.677719, 46.699703);

  _getLastLocation() async {
    var location = await fusedLocation.getLastLocation();
    _latLng = LatLng(location.latitude!, location.longitude!);

    CameraUpdate cameraUpdate = CameraUpdate.newLatLngZoom(_latLng, 15);
    mapController.animateCamera(cameraUpdate);
    setState(() {
      markerlist.add(Marker(
        markerId: MarkerId("MyLocation"),
        position: _latLng,
        icon: BitmapDescriptor.fromAsset("assets/images/marker.png"),
      )
      );
    });
    print("_getLastLocation ${_latLng.lat} ${_latLng.lng}");
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    fusedLocation = FusedLocationProviderClient();
  }

  Future<void> _onMapCreated(HuaweiMapController controller) async {
    mapController = controller;
    await Future.delayed(Duration(seconds: 3))
        .then((value) => {_getLastLocation()});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        HuaweiMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(target: _latLng, zoom: _zoom),
          mapType: MapType.normal,
          markers: markerlist,
        )
      ],
    ));
  }
}
