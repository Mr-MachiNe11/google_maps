import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static const initialPoint = LatLng(23.807134426120705, 90.35868379092524);
  static const finalPoint = LatLng(23.804582263714366, 90.37516328319539);

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
      body: GoogleMap(
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        mapType: MapType.normal,
          initialCameraPosition:
              CameraPosition(target: initialPoint, zoom: 15),zoomControlsEnabled: true,),
    );
  }
}
