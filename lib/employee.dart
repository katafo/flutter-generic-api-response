import 'api/decodable.dart';

class Employee implements Decodable<Employee> {
  int? id;
  String? name;
  String? email;
  String? phone;
  Address? address;

  @override
  Employee decode(dynamic data) {
    id = data['id'];
    name = data['employee_name'] ?? '';
    email = data['email'] ?? '';
    phone = data['phone'] ?? '';
    if (data['address'] != null) {
      address = Address.fromJson(data['address']);
    }
    return this;
  }

  @override
  String toString() {
    return '''ID: $id\nName: $name\nEmail: $email\nPhone: $phone\nAddress: ${address?.street ?? ''}''';
  }
}

class Address {
  String? street;
  String? suite;
  String? city;

  Address.fromJson(Map<String, dynamic> json) {
    street = json['street'] ?? '';
    suite = json['suite'] ?? '';
    city = json['city'] ?? '';
  }
}
