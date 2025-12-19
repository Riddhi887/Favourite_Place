import 'package:flutter/material.dart';
import 'package:favourite_place/models/place.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    super.key,
    this.location = const PlaceLocation(
      latitude: 37.4722,
      longitude: -122.084,
      address: '',
    ),
    //if the dfault location is chosen
    this.isSelecting = true,
  });

  final PlaceLocation location;
  final bool isSelecting;

  @override
  State<StatefulWidget> createState() {
    return _MapScreenState();
  }
}

class _MapScreenState extends State<MapScreen> {

  LatLng? _pickedLocation;          //can use Location? _pickedLocation if using google maps

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(
          widget.isSelecting ? 'Pick Your Location.' : 'Your Location',
          style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        actions: [
          if (widget.isSelecting)
            IconButton(
              icon: const Icon(Icons.save_rounded), 
              onPressed: () {
                Navigator.of(context).pop(_pickedLocation);
              },
              ),
        ],
      ),
      body: 
     FlutterMap(
        options: MapOptions(
        initialCenter: LatLng(widget.location.latitude, widget.location.longitude),
        initialZoom: 16.0,
        onTap: widget.isSelecting ? (position, point) {
        setState(() {
          _pickedLocation = point;
        });
        } : null,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.favourite_place',
          ),
          MarkerLayer(
            markers: (_pickedLocation == null && widget.isSelecting == true )? [] : [
              Marker(
              point: _pickedLocation != null ? _pickedLocation! : 
              LatLng(
                widget.location.latitude, widget.location.longitude
                ),
              width: 50,
              height: 50,
              child: Icon(Icons.location_on, size: 50, color: Colors.red),
            ),
          ],
        ),
      ],
    ),
  );
}
}
