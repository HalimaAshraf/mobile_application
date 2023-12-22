import 'package:udharkhatabook/model/transaction.dart';

class Customer {
  final int? id;
  final String name;
  final String phoneNumber;

  Customer( {this.id, required this.name, required this.phoneNumber});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
    };
  }
}
