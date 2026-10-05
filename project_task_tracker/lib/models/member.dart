// Definition of the Member params
class Member {
  final String id;
  final String name;
  final String role;

  // Carrying out instantiation
  Member({required this.id, required this.name, required this.role});

  // Converting raw Member instance to a Map for saving and sending
  Map<String, dynamic> toMap() => {'id': id, 'name': name, 'role': role}; // Storing those params in a map(dictionary)

  // Converting the Map back to a Dart usable object
  factory Member.fromMap(Map<String, dynamic> map) => Member(
        id: map['id'],
        name: map['name'],
        role: map['role'],
      );
}

