import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController _mapController;
  late Marker _marker = Marker(markerId: MarkerId('dummy'));
  late Polyline _polyline = Polyline(polylineId: PolylineId('dummy'));

  late Position _currentLocation;
  List<LatLng> _polylineCoordinates = [];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    Timer.periodic(Duration(seconds: 10), (timer) {
      _getCurrentLocation();
    });
  }

  void _updateLocation(Position position) {
    setState(() {
      _currentLocation = position;
      _updateMarker();
      _updatePolyline();
    });
  }

  void _updateMarker() {
    _marker = Marker(
      markerId: MarkerId('currentLocation'),
      position: LatLng(_currentLocation.latitude, _currentLocation.longitude),
      infoWindow: InfoWindow(
        title: 'My current location',
        snippet:
        'Lat: ${_currentLocation.latitude}, Lng: ${_currentLocation.longitude}',
      ),
    );
  }

  void _updatePolyline() {
    _polylineCoordinates.add(
      LatLng(_currentLocation.latitude, _currentLocation.longitude),
    );

    _polyline = Polyline(
      polylineId: PolylineId('polyline'),
      color: Colors.blue,
      points: _polylineCoordinates,
    );
  }

  Future<void> _getCurrentLocation() async {
    try {
      _currentLocation = await Geolocator.getCurrentPosition();
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map screen'),
        centerTitle: true,
      ),
      body: GoogleMap(
        onMapCreated: (controller) {
          _mapController = controller;
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(23.722492033350452, 90.38713362067938),
          zoom: 17,
        ),
        markers: _marker != null ? Set.of([_marker]) : Set<Marker>(),
        polylines: _polyline != null ? Set.of([_polyline]) : Set<Polyline>(),
      ),
    );
  }
}

//
