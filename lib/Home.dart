import 'package:firebase/widgets/AuthWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:huawei_location/location/fused_location_provider_client.dart';

import 'package:huawei_map/map.dart';
import 'mapandlocation.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late FirebaseAuth auth;
  late Future<FirebaseApp> _initialization;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _initialization = Firebase.initializeApp();
      auth = FirebaseAuth.instance;
      fusedLocation = FusedLocationProviderClient();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.loose,
      children: [
        MapWidget(),
        UserCard("firas", "easdlk@flfl;jds.com", "234.2.341.24,234,.234,1.24"),
      ],
    );
  }


  Widget UserCard(String name, String email, String location) {
    return Container(
      height: 100.0,
      margin: EdgeInsets.only(top: 50.0, right: 16.0, left: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(25)),
        color: Colors.white,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image(
            image: AssetImage(
              'assets/images/marker.png',
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(name),
              Text(email),
              Text(location),
              TextButton(
                onPressed: () => {
                  auth.signOut(),
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => AuthWidget()))
                },
                child: Text("Logout",style: TextStyle(
                  color: Colors.red,
                ),),
              )
            ],
          ),

        ],
      ),
    );
  }
  Widget MapWidget(){
    return HuaweiMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(target: _latLng, zoom: _zoom),
      mapType: MapType.normal,
      markers: markerlist,
    );
  }
  static const double _zoom = 10;

  late FusedLocationProviderClient fusedLocation;
  late HuaweiMapController mapController;
  Set<Marker> markerlist = Set();
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

  Future<void> _onMapCreated(HuaweiMapController controller) async {
    mapController = controller;
    await Future.delayed(Duration(seconds: 3))
        .then((value) => {_getLastLocation()});
  }
}
