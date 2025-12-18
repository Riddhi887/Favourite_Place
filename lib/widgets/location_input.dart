import 'package:favourite_place/models/place.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationInput extends StatefulWidget {
  const LocationInput({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LocationInputState();
  }
}

class _LocationInputState extends State<LocationInput> {
  PlaceLocation? _pickedLocation;
  var _isGettingLocation = false;

  // Map preview URL - Using OpenStreetMap
  String get locationImage {
    if (_pickedLocation == null) {
      return '';
    }
    final lat = _pickedLocation!.latitude;
    final long = _pickedLocation!.longitude;

    // Using LocationIQ Static Maps you can use google geocoding and state map api too
    // Sign up at locationiq.com for a free API key
    // put access token after key = 
    return 'https://maps.locationiq.com/v3/staticmap?key=pk.ee1daea3c5ba57bc6f05f62f1daee708&center=$lat,$long&zoom=16&size=600x300&format=png&markers=icon:large-red-cutout|$lat,$long';
  }

  //get current location
  void _getcurrentLocation() async {
    Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    setState(() {
      _isGettingLocation = true;
    });

    locationData = await location.getLocation();

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

    print('Fetched coordinates: lat=$lat, long=$longi');

    // Using OpenStreetMap Nominatim for reverse geocoding (FREE!)
    String address =
        'Lat: ${lat.toStringAsFixed(4)}, Long: ${longi.toStringAsFixed(4)}';

    try {
      // Nominatim requires a User-Agent header
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$longi&zoom=18&addressdetails=1',
      );

      print('Nominatim URL: $url');

      final response = await http.get(
        url,
        headers: {
          'User-Agent': 'FavouritePlaceApp/1.0', // Required by Nominatim
        },
      );

      print('Nominatim status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final resData = json.decode(response.body);

        if (resData['display_name'] != null) {
          address = resData['display_name'];
          print('Address fetched: $address');
        } else {
          print('No address found in response');
        }
      } else {
        print('Nominatim request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Could not fetch address from Nominatim: $e');
    }

    // Set location and show preview
    setState(() {
      _pickedLocation = PlaceLocation(
        latitude: lat,
        longitude: longi,
        address: address,
      );
      _isGettingLocation = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    //if no location chosen show this
    Widget _previewContent = Text(
      'No Location Chosen.',
      style: GoogleFonts.aBeeZee(color: Colors.white, fontSize: 15),
    );

    //if we have picked location - show map preview
    if (_pickedLocation != null) {
      _previewContent = Image.network(
        locationImage,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          print('Error loading map image: $error');
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
            //button to get currrent location
            TextButton.icon(
              icon: Icon(Icons.location_on_sharp),
              label: Text(
                'Get Current Location.',
                style: GoogleFonts.aBeeZee(color: Colors.white, fontSize: 15),
              ),
              onPressed: _getcurrentLocation,
            ),

            //button to get location on map
            TextButton.icon(
              icon: Icon(Icons.map),
              label: Text(
                'Select on Map',
                style: GoogleFonts.aBeeZee(color: Colors.white, fontSize: 15),
              ),
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }
}
