import 'package:favourite_place/models/place.dart';
import 'package:favourite_place/screens/place_details.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PlacesList extends StatelessWidget {
  const PlacesList({super.key, required this.places});

  final List<Place> places; //from place.dart of Models folder

  @override
  Widget build(BuildContext context) {
    if (places.isEmpty) {
      return Center(
        child: Text(
          'No Places Added Yet.',
          style: GoogleFonts.aBeeZee(
            textStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      );
    }
   
    //if the places are present in the list
    return ListView.builder(
      itemCount: places.length,
     
      itemBuilder: (ctx, index) => ListTile(
        leading: CircleAvatar(
          radius: 28,
          backgroundImage: FileImage(places[index].image),    //using Image.file we gwt widget but with FileImage we get provider (necessary here)
        ),
        title: Text(
          places[index].title,
          style: GoogleFonts.aBeeZee(
            // choose any Google font
            fontSize: 19,
            fontWeight: FontWeight.w600,
            color: const Color.fromARGB(255, 255, 255, 255),
          ),
        ),

        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) =>PlaceDetailsScreen(
                place: places[index]
                ),
                ),
                );
        },
      ),
    );
  }
}
