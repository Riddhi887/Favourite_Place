import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Place {
  Place({required this.title}) : id = uuid.v4();      //generating id from uuid dynamically
  final String id;
  final String title;
}
