import 'package:favourite_place/screens/map.dart';
import 'package:flutter/material.dart';
import 'package:favourite_place/models/place.dart';
import 'package:google_fonts/google_fonts.dart';

class PlaceDetailsScreen extends StatelessWidget {
  const PlaceDetailsScreen({super.key, required this.place});
  final Place place;

  // Map preview URL - Using OpenStreetMap
  String get locationImage {
    final lat = place.location.latitude;
    final long = place.location.longitude;

    return 'https://maps.locationiq.com/v3/staticmap?key=pk.ee1daea3c5ba57bc6f05f62f1daee708&center=$lat,$long&zoom=16&size=600x300&format=png&markers=icon:large-red-cutout|$lat,$long';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(
          place.title,
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      body: Center(
        child: Stack(
          children: [
            Image.file(
              place.image,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),

            Positioned(
              bottom: 1,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => MapScreen(
                          location: place.location, 
                          isSelecting: false,
                          ),
                          ),
                      );
                    },
                    child: CircleAvatar(
                      radius: 77,
                      backgroundImage: NetworkImage(locationImage),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          const Color.fromARGB(143, 20, 52, 107),
                          const Color.fromARGB(114, 85, 12, 36),
                        ],
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                      ),
                    ),
                    child: Text(
                      place.location.address,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        // choose any Google font
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color.fromARGB(255, 207, 207, 207),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
