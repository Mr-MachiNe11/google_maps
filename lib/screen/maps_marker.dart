import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsMarkers extends StatefulWidget {
  const MapsMarkers({super.key});

  @override
  State<MapsMarkers> createState() => _MapsMarkersState();
}

class _MapsMarkersState extends State<MapsMarkers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        centerTitle: true,
        title: const Text(
          'Maps Markers',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: GoogleMap(
        zoomControlsEnabled: true,
        initialCameraPosition: const CameraPosition(
            target: LatLng(23.72227133373129, 90.38725179699476),
            zoom: 17,
            tilt: 90,
            bearing: 90),
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        onTap: (LatLng latLng) {
          print('Tapped on map: $latLng');
        },
        onLongPress: (LatLng latLng) {
          print('On long press: $latLng');
        },
        //liteModeEnabled: true,
        markers: {
          Marker(
            markerId: MarkerId('my-new-institute'),
            position: LatLng(23.723311272003098, 90.38795035332441),
            infoWindow: InfoWindow(title: 'My New Institute'),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueViolet),
            draggable: true,
          ),
          Marker(
            markerId: MarkerId('my-new-club'),
            position: LatLng(23.722383681056304, 90.38782831281424),
            infoWindow: InfoWindow(title: 'My New Restaurant'),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueAzure),
            draggable: true,
          ),
          Marker(
            markerId: MarkerId('my-new-restaurant'),
            position: LatLng(23.722492033350452, 90.38713362067938),
            infoWindow: InfoWindow(title: 'My New club'),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueMagenta),
            draggable: true,
          ),
        },
        circles: {
          Circle(
              circleId: CircleId('restaurant-circle'),
              center: LatLng(23.722492033350452, 90.38713362067938),
              radius: 50,
              strokeColor: Colors.orange,
              strokeWidth: 3,
              fillColor: Colors.orange.withOpacity(0.15)),
          Circle(
              circleId: CircleId('club-circle'),
              center: LatLng(23.722383681056304, 90.38782831281424),
              radius: 50,
              strokeColor: Colors.purple,
              strokeWidth: 3,
              fillColor: Colors.purple.withOpacity(0.15)),
        },
        polygons: {
          Polygon(
              polygonId: PolygonId('poly'),
              fillColor: Colors.orange.withOpacity(0.5),
              strokeColor: Colors.purple,
              strokeWidth: 3,
              points: [
                LatLng(23.72558264480928, 90.38406701736301),
                LatLng(23.723264616374276, 90.38931341822739),
                LatLng(23.721184541872795, 90.38733836535792),
                LatLng(23.722144875974152, 90.38449617080835),
                LatLng(23.7253370929241, 90.38636298829059),
              ])
        },
      ),
    );
  }
}
