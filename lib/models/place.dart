import 'package:uuid/uuid.dart';
import 'dart:io';
import 'package:favourite_place/widgets/location_input.dart';

const uuid = Uuid();

class PlaceLocation {
  const PlaceLocation({
    required this.latitude,
    required this.longitude,
    required this.address,
  });
  final double latitude;
  final double longitude;
  final String address;
}

class Place {
  Place({required this.title, required this.image, required this.location})
    : id = uuid.v4(); //generating id from uuid dynamically
  final String id;
  final String title;
  final File image;
  final PlaceLocation location;
}
