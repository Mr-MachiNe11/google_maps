import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapsScreen extends StatefulWidget {
  const GoogleMapsScreen({super.key});

  @override
  State<GoogleMapsScreen> createState() => _GoogleMapsScreenState();
}

class _GoogleMapsScreenState extends State<GoogleMapsScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  final _googleApiKey = "AIzaSyDEp8ksfnISJtutBcNoHRaIGdf9rMllfoM";

  static const initialPoint = LatLng(37.4219, -122.0854);
  static const finalPoint = LatLng(37.4116, -122.0713);

  List<LatLng> polylineCoordinates = [];
  Position? position;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getPolyPoints();
    _fetchPosition();
    _listenCurrentLocation();
  }

  Future<void> _getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        _googleApiKey,
        PointLatLng(initialPoint.latitude, initialPoint.longitude),
        PointLatLng(finalPoint.latitude, finalPoint.longitude));

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) =>
          polylineCoordinates.add(LatLng(point.latitude, point.longitude)));
      setState(() {});
    }
  }

  Future<void> _fetchPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    Position currentPosition = await Geolocator.getCurrentPosition();
    setState(() {
      position = currentPosition;
    });
  }

  Future<void> _listenCurrentLocation() async {
    GoogleMapController googleMapController = await _controller.future;

    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.best,
          distanceFilter: 1,
          timeLimit: Duration(seconds: 1)),
    ).listen(
          (p) {
        setState(() {
          position = p;
          polylineCoordinates.add(LatLng(p.latitude, p.longitude));
        });

        googleMapController.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(
                target: LatLng(p.latitude, p.longitude), zoom: 14.5)));
        _updateMarkerPosition(p, googleMapController);
      },
    );
  }

  void _updateMarkerPosition(Position newPosition, GoogleMapController controller) {
    setState(() {
      position = newPosition;
    });

    controller.moveCamera(CameraUpdate.newLatLng(LatLng(newPosition.latitude, newPosition.longitude)));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purpleAccent,
        centerTitle: true,
        title: const Text(
          'Google Maps Screen',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: position == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                  target: LatLng(position!.latitude, position!.longitude),
                  zoom: 14.5),
              zoomControlsEnabled: true,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              polylines: {
                Polyline(
                    polylineId: const PolylineId('route'),
                    points: polylineCoordinates,
                    color: Colors.lightBlue,
                    width: 6),
              },
              markers: {
                Marker(
                    markerId: const MarkerId('currentPosition'),
                    position: LatLng(position!.latitude, position!.longitude),
                    infoWindow: InfoWindow(
                      title: 'My current location',
                      snippet:
                          'Lat: ${position!.latitude}, Lng: ${position!.longitude}',
                    ),
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueMagenta)),
                const Marker(
                  markerId: MarkerId('source'),
                  position: initialPoint,
                ),
                const Marker(
                  markerId: MarkerId('destination'),
                  position: finalPoint,
                ),
              },
              onMapCreated: (mapController) {
                _controller.complete(mapController);
              },
            ),
    );
  }
}
