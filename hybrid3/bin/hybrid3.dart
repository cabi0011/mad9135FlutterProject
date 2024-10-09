import 'dart:convert';
import 'package:hybrid3/hybrid3.dart' as hybrid3; 

void main(List<String> arguments) {

  String json = '''
  [
    {"first":"Steve", "last":"Griffith", "email":"griffis@algonquincollege.com"},
    {"first":"Adesh", "last":"Shah", "email":"shaha@algonquincollege.com"},
    {"first":"Tony", "last":"Davidson", "email":"davidst@algonquincollege.com"},
    {"first":"Adam", "last":"Robillard", "email":"robilla@algonquincollege.com"}
  ]
  ''';

  List<dynamic> decodedJson = jsonDecode(json);
  List<Map<String, String>> people = decodedJson.map((item) {
    return (item as Map<String, dynamic>)
        .map((key, value) => MapEntry(key as String, value as String));
  }).toList();

  hybrid3.Students students =
      hybrid3.Students(people);

  students.sort('first');

  students
      .plus({"first": "John", "last": "Doe", "email": "john.doe@example.com"});


  students.remove("Doe");
  students.output();
}
