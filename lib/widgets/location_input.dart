import 'package:favourite_place/models/place.dart';
import 'package:favourite_place/screens/map.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationInput extends StatefulWidget {
  const LocationInput({super.key, required this.onSelectLocation});

  final void Function(PlaceLocation location) onSelectLocation;

  @override
  State<StatefulWidget> createState() {
    return _LocationInputState();
  }
}

class _LocationInputState extends State<LocationInput> {
  PlaceLocation? _pickedLocation;
  var _isGettingLocation = false;

  String get locationImage {
    if (_pickedLocation == null) {
      return '';
    }

    final lat = _pickedLocation!.latitude;
    final long = _pickedLocation!.longitude;

    return 'https://maps.locationiq.com/v3/staticmap?key=pk.ee1daea3c5ba57bc6f05f62f1daee708&center=$lat,$long&zoom=16&size=600x300&format=png&markers=icon:large-red-cutout|$lat,$long';
  }

  Future<void> _savePlace(double latitude, double longitude) async {
    final url = Uri.parse(
      'https://nominatim.openstreetmap.org/reverse?format=json&lat=$latitude&lon=$longitude&zoom=18&addressdetails=1',
    );

    final response = await http.get(
      url,
      headers: {'User-Agent': 'FavouritePlaceApp/1.0'},
    );

    String address =
        'Lat: ${latitude.toStringAsFixed(4)}, Long: ${longitude.toStringAsFixed(4)}';

    if (response.statusCode == 200) {
      final resData = json.decode(response.body);
      if (resData['display_name'] != null) {
        address = resData['display_name'];
      }
    }

    setState(() {
      _pickedLocation = PlaceLocation(
        latitude: latitude,
        longitude: longitude,
        address: address,
      );
      _isGettingLocation = false;
    });

    widget.onSelectLocation(_pickedLocation!);
  }

  void _getcurrentLocation() async {
    Location location = Location();

    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return;
    }

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    setState(() {
      _isGettingLocation = true;
    });

    LocationData locationData = await location.getLocation();
    final lat = locationData.latitude;
    final longi = locationData.longitude;

    if (lat == null || longi == null) {
      setState(() {
        _isGettingLocation = false;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not get your location coordinates.'),
        ),
      );
      return;
    }

    await _savePlace(lat, longi);
  }

  void _selectOnMap() async {
    final pickedLocation = await Navigator.of(
      context,
    ).push<LatLng>(MaterialPageRoute(builder: (context) => MapScreen()));

    if (pickedLocation == null) {
      return;
    }

    setState(() {
      _isGettingLocation = true;
    });

    await _savePlace(pickedLocation.latitude, pickedLocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    Widget _previewContent = Text(
      'No Location Chosen.',
      style: GoogleFonts.aBeeZee(color: Colors.white, fontSize: 15),
    );

    if (_pickedLocation != null) {
      _previewContent = Image.network(
        locationImage,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return Center(
            child: Text(
              'Could not load map preview',
              style: GoogleFonts.aBeeZee(color: Colors.white),
            ),
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(child: CircularProgressIndicator());
        },
      );
    }

    if (_isGettingLocation) {
      _previewContent = const CircularProgressIndicator();
    }

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Theme.of(context).colorScheme.primary.withValues(),
            ),
          ),
          alignment: Alignment.center,
          height: 180,
          width: double.infinity,
          child: _previewContent,
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              icon: Icon(Icons.location_on_sharp),
              label: Text(
                'Get Current Location.',
                style: GoogleFonts.aBeeZee(color: Colors.white, fontSize: 15),
              ),
              onPressed: _getcurrentLocation,
            ),
            TextButton.icon(
              icon: Icon(Icons.map),
              label: Text(
                'Select on Map',
                style: GoogleFonts.aBeeZee(color: Colors.white, fontSize: 15),
              ),
              onPressed: _selectOnMap,
            ),
          ],
        ),
      ],
    );
  }
}
