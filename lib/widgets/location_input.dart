import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:location/location.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LocationInputState();
  }
}

class _LocationInputState extends State<LocationInput> {
  //loading spinner
  Location? _pickedLocation;
  var _isGettingLocation = false;

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
  
    locationData = await location.getLocation();        //seek for location till then wait

    //after getting location stop seeking
    setState(() {
      _isGettingLocation = false;
    });
    //get locationData on terminal for values
    print(locationData.latitude);
    print(locationData.longitude);
  }

  @override
  Widget build(BuildContext context) {

    //if no location chosen show this
    Widget _previewContent = Text(
            'No Location Chosen.',
            style: GoogleFonts.aBeeZee(color: Colors.white, fontSize: 15),
          );

    if(_isGettingLocation)
    {
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

          child: _previewContent
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
