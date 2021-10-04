
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hms_gms_availability/flutter_hms_gms_availability.dart';

class HmsGmsAvailablity extends StatefulWidget {
  const HmsGmsAvailablity({Key? key}) : super(key: key);

  @override
  _HmsGmsAvailablityState createState() => _HmsGmsAvailablityState();
}



class _HmsGmsAvailablityState extends State<HmsGmsAvailablity> {

  bool isHMS = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FlutterHmsGmsAvailability.isGmsAvailable.then((value) => {
      if(!value){
        isHMS = true
      }
    });
    print(isHMS);
  }

  ColorFilter greyscale = ColorFilter.matrix(<double>[
    0.2126, 0.7152, 0.0722, 0, 0,
    0.2126, 0.7152, 0.0722, 0, 0,
    0.2126, 0.7152, 0.0722, 0, 0,
    0,      0,      0,      1, 0,
  ]);

  ColorFilter identity = ColorFilter.matrix(<double>[
    1, 0, 0, 0, 0,
    0, 1, 0, 0, 0,
    0, 0, 1, 0, 0,
    0, 0, 0, 1, 0,
  ]);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32.0),
      child: Column(
        children: [
          Text("This Device is",style: TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.bold
          ),),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ColorFiltered(
                colorFilter: isHMS?identity:greyscale,
                child: Image(
                  width: 100.0,
                  height: 100.0,
                  image: AssetImage("assets/images/hms.jpg"),
                ),
              ),
              ColorFiltered(
                colorFilter: isHMS?greyscale:identity,
                child: Image(
                  width: 100.0,
                  height: 100.0,
                  image: AssetImage('assets/images/gms.jpg'),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
