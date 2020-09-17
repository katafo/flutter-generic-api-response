import 'api/decodable.dart';

class Employee implements Decodable<Employee> {

  int id;
  String name;
  int salary;
  int age;
  String profileImage;

  @override
  Employee decode(dynamic data) {
    id = data['id'];
    name = data['employee_name'] ?? '';
    salary = data['employee_salary'] ?? 0;
    age = data['employee_age'] ?? 0;
    profileImage = data['profile_image'] ?? '';
    return this;
  }

}