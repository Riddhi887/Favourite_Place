//manages the places that are selectes or added by user using the riverpod package
import 'dart:convert';
import 'dart:io';
import 'package:favourite_place/models/place.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:path_provider/path_provider.dart' as sysPaths;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

Future<Database> _getDatabase() async {
  //sql (here dbPath points to directory where db can be created)
  final dbPath = await sql.getDatabasesPath();

  //open db for given path and join the path of dbPAth with any db name of choice
  final db = await sql.openDatabase(
    path.join(dbPath, 'places.db'),
    //onCreate will execute when db created for 1st time
    onCreate: (db, version) {
      //onCreate take a Future value so we need to return a query here so it gets executed as db gets created
      return db.execute(
        'CREATE TABLE user_places( id TEXT PRIMARY KEY , title TEXT, image TEXT, lat REAL , longi REAL, address TEXT )',
      );
    },
    version: 1,
  );
  return db;
}

class UserPlacesNotifier extends StateNotifier<List<Place>> {
  //constructor function UserPlacesNotifier() that points to the parent class using super and gives initial state here is empty list ... state managed by riverpod must not be added to the memory

  //storing data in database
  //loading the data from the db as the app starts
  Future <void> loadPlaces() async {
    final db = await _getDatabase();
    final data = await db.query('user_places');
    final places = data
        .map(
          (row) => Place(
            id: row['id'] as String,
            title: row['title'] as String,
            image: File(row['image'] as String),
            location: PlaceLocation(
              latitude: row['lat'] as double,
              longitude: row['longi'] as double,
              address: row['address'] as String,
            ),
          ),
        )
        .toList();

    state = places;
  }

  UserPlacesNotifier() : super(const []);

  /*
  //Storing data in json file or locally
  Future<void> loadPlaces() async {
    final appDir = await sysPaths.getApplicationDocumentsDirectory();
    final file = File(
      '${appDir.path}/places_data.json',
    ); //to store location data locally

    if (!await file.exists()) {
      return;
    }

    //convert json item back to place object by taking each item from list
    final jsonString = await file.readAsString();
    final List<dynamic> jsonData = json.decode(jsonString);

    final places = jsonData.map((item) {
      return Place(
        title: item['title'],
        image: File(item['imagePath']),
        location: PlaceLocation(
          latitude: item['latitude'],
          longitude: item['longitude'],
          address: item['address'],
        ),
      );
    }).toList();

  state = places;     */

  //method that allows us to add new place using the riverpod by creating a new object
  //NOTE: we cannot directly add old object to memory instead have to create new obj
  Future<void> addPlace(
    String title,
    File image,
    PlaceLocation location,
  ) async {
    //get the path of the place to store it locally on device
    final appDir = await sysPaths.getApplicationDocumentsDirectory();

    final filename = path.basename(image.path); //to store image locally

    //copy the image to particular path (as string) first seg from appDir and another from filename
    //copy method has Future
    final copiedImage = await image.copy('${appDir.path}/$filename');

    final newPlace = Place(
      title: title,
      image: copiedImage,
      location: location,
    );

    //get the db
    final db = await _getDatabase();

    //perform operations on db (inserting)
    db.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'lat': newPlace.location.latitude,
      'longi': newPlace.location.longitude,
      'address': newPlace.location.address,
    });

    state = [
      newPlace,
      ...state,
    ]; //initate a new list and add new place to it ... is used to seperate all elements in list

    /*
    //  SAVE TO JSON FILE
    final file = File('${appDir.path}/places_data.json');

    // Convert all places to JSON format
    final placesData = state.map((place) {
      return {
        'title': place.title,
        'imagePath': place.image.path, // Save the path not img
        'latitude': place.location.latitude,
        'longitude': place.location.longitude,
        'address': place.location.address,
      };
    }).toList();

    //Write JSON to file
    await file.writeAsString(json.encode(placesData));    */
  }
}

//StateNotifierProvider will take UserPlacesNotifier, List<Place> as parameter to watch it and display it tells dart userPlaces in places.dart is actually list of places of user
final userPlacesProvider =
    StateNotifierProvider<UserPlacesNotifier, List<Place>>(
      (ref) => UserPlacesNotifier(),
    );
