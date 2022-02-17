import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'api/api_client.dart';
import 'api/api_response.dart';
import 'api/api_route.dart';
import 'api/interceptors/log_interceptor.dart';
import 'employee.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String response = '';
  APIClient? client;

  @override
  void initState() {
    super.initState();
    client = APIClient(BaseOptions(baseUrl: 'https://katafo.github.io/json'));
    final interceptors = [
      APILogInterceptor(),
    ];
    client?.instance.interceptors.addAll(interceptors);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('API Response'),
        ),
        body: Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Center(
            child: Column(
              children: <Widget>[
                TextButton(
                  child: Text('Fetch Employees'),
                  onPressed: () async {
                    try {
                      final result = await fetchEmployeeList();
                      setState(() {
                        response = '${result.length} employees';
                      });
                    } on Exception catch (err) {
                      setState(() {
                        response = err.toString();
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextButton(
                  child: Text('Fetch Employee Details'),
                  onPressed: () async {
                    try {
                      final emp = await fetchEmployeeDetails(1);
                      setState(() {
                        response = emp.toString();
                      });
                    } on Exception catch (err) {
                      setState(() {
                        response = err.toString();
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                Text(response),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<List<Employee>> fetchEmployeeList() async {
    final result = await client?.request(
        route: APIRoute(APIType.listEmployees),
        create: () => APIListResponse<Employee>(create: () => Employee()));

    final employees = result?.response?.data ?? [];
    return employees;
  }

  Future<Employee> fetchEmployeeDetails(int empID) async {
    final result = await client?.request(
        route: APIRoute(APIType.detailsEmployee, routeParams: '$empID'),
        create: () => APIResponse<Employee>(create: () => Employee()));

    final employee = result?.response?.data;

    if (employee != null) {
      return employee;
    }

    throw ErrorResponse(message: 'Employee not found');
  }
}
