import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; // Import the necessary library
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:udharkhatabook/customer.dart';

class CustomerProvider extends ChangeNotifier {
  late Database _database;
  List<Customer> _customers = [];
  List<Customer> _filteredCustomers = [];

  List<Customer> get filteredCustomers => _filteredCustomers;

  CustomerProvider() {
    // Initialize the database
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    sqfliteFfiInit(); // Initialize sqflite_common_ffi
    databaseFactory = databaseFactoryFfi; // Set the databaseFactory to use sqflite_common_ffi

    _database = await openDatabase(
      join(await getDatabasesPath(), 'udharbook_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE customers(id INTEGER PRIMARY KEY, name TEXT, phoneNumber TEXT)',
        );
      },
      version: 1,
    );

    // Fetch initial data from the database
    _customers = await _getCustomersFromDatabase();
    filterCustomers('');
  }

  Future<List<Customer>> _getCustomersFromDatabase() async {
    final List<Map<String, dynamic>> maps = await _database.query('customers');
    return List.generate(maps.length, (index) {
      return Customer(
        id: maps[index]['id'],
        name: maps[index]['name'],
        phoneNumber: maps[index]['phoneNumber'],
      );
    });
  }

  void filterCustomers(String query) {
    _filteredCustomers = _customers
        .where((customer) => customer.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    notifyListeners();
  }

  Future<void> addCustomer(String name, String phoneNumber) async {
    final newCustomer = Customer(name: name, phoneNumber: phoneNumber);
    _customers.add(newCustomer);
    filterCustomers('');

    // Save to Sqflite
    await _database.insert(
      'customers',
      newCustomer.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  // Check if the same customer data is already saved
  bool isCustomerAlreadySaved(String name, String phoneNumber) {
    return _customers.any(
          (customer) => customer.name == name && customer.phoneNumber == phoneNumber,
    );
  }
}
