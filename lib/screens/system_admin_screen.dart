import 'package:flutter/material.dart';

class SystemAdminScreen extends StatefulWidget {
  const SystemAdminScreen({super.key});

  @override
  State<SystemAdminScreen> createState() => _SystemAdminScreenState();
}

class _SystemAdminScreenState extends State<SystemAdminScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 7,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.indigo, size: 17),
        title: const Text(
          'مدير النظام',
          style: TextStyle(color: Colors.indigo),
        ),
      ),
      body: const Row(
        children: [
          Expanded(
            flex: 1,
            child: SizedBox(
              width: 200,
              height: double.infinity,
            ),
          ),
          Expanded(
            flex: 2,
            child: SizedBox(
              child: Center(
                child: Text('مدير النظام'),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: SizedBox(
              width: 200,
              height: double.infinity,
            ),
          ),
        ],
      ),
    );
  }
}
