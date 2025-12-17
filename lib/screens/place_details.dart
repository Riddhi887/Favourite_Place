import 'package:flutter/material.dart';
import 'package:favourite_place/models/place.dart';
import 'package:google_fonts/google_fonts.dart';

class PlaceDetailsScreen extends StatelessWidget {
  const PlaceDetailsScreen({super.key, required this.place});
  final Place place;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(
          place.title,
          style: GoogleFonts.poppins(
           
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
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
            ],
          ),
     ),
    );
  }
}
