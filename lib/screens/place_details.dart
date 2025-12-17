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
          child: Text(
            place.title, style: GoogleFonts.aBeeZee(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: const Color.fromARGB(255, 255, 255, 255),),
     ),
     ),
    );
  }
}
