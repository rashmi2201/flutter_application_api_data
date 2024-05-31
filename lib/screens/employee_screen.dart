import 'package:flutter/material.dart';
import 'package:flutter_application_api_data/card/employee_card.dart';
import 'package:flutter_application_api_data/model_class/employee_model.dart';

class EmployeeScreen extends StatefulWidget {
  const EmployeeScreen({super.key, required this.datas});
  final Data datas;
  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          textAlign: TextAlign.center,
          'Employee Details',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 4.0, left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Card.outlined(
              color: Colors.blue,
              shadowColor: Colors.pink,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                height: 50,
                width: 170,
                child: const Center(
                  child: Text(
                    'Employee Screen',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Colors.black),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            EmployeeCard(
              avatarUrl:
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRIZKq-Rka-yG0Qrkl2t6zdn77cDHyDa7at6Q&s',
              employeeName: widget.datas.userid ?? '',
              designation: widget.datas.deg ?? '',
              employeeID: widget.datas.eid ?? '',
              type: widget.datas.type ?? '',
              dateofJoining: widget.datas.doj ?? '',
              salary: widget.datas.salary ?? '',
            ),
          ],
        ),
      ),
    );
  }
}
