import 'package:flutter/material.dart';
import 'inspection_list_screen.dart';
import 'instructions_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('LeaseProof Home')),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(child: Text('Menu')),
            ListTile(
              title: const Text('Instructions'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const InstructionsScreen()));
              },
            ),
            ListTile(
              title: const Text('Inspections'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const InspectionListScreen()));
              },
            ),
          ],
        ),
      ),
      body: const Center(child: Text('Welcome to LeaseProof!')),
    );
  }
}
