import 'package:flutter/material.dart';
import 'package:flutter_application_api_data/card/employee_card.dart';
import 'package:flutter_application_api_data/model_class/employee_model.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({
    super.key,
    required this.datas,
  });
  final Data datas;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final username = TextEditingController();
  final password = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Dashboard Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 4.0, left: 10, right: 10),
        child: Column(
          children: [
            Card(
              shadowColor: Colors.yellow,
              color: Colors.teal,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                height: 40,
                width: 120,
                child: const Center(
                  child: Text(
                    'DASHBOARD',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                
                        color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 40,
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
