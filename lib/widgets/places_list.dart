import 'package:favourite_place/models/place.dart';
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
        title: Text(
          places[index].title,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
            color: Theme.of(context).colorScheme.onSurface
      ),
      ),
      ),
      );
  }
}
