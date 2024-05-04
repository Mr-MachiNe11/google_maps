import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Position? position;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _onScreenStart();
    _listenCurrentLocation();
  }

  Future<void> _onScreenStart() async {

    bool isEnabled = await Geolocator.isLocationServiceEnabled();
    print(isEnabled);

    print(await Geolocator.getLastKnownPosition());

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      position = await Geolocator.getCurrentPosition();
      print(position);
    } else {
      LocationPermission requestStatus = await Geolocator.requestPermission();
      if (requestStatus == LocationPermission.whileInUse ||
          requestStatus == LocationPermission.always) {
        _onScreenStart();
      } else {
        print('Request Denied!');
      }
    }
  }

  void _listenCurrentLocation() {
    Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.best,
          distanceFilter: 1,
          //timeLimit: Duration(seconds: 3)
        )).listen(
          (p) {
        print(p);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        centerTitle: true,
        title: const Text(
          'G Map',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Text(
            'Current Location: ${position?.latitude},${position?.longitude}'),
      ),
    );
  }
}

//



