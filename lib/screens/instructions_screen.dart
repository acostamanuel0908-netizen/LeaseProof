import 'package:flutter/material.dart';

class InstructionsScreen extends StatelessWidget {
  const InstructionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Instructions & Compliance')),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            '''
How to use LeaseProof app:

1. Add your properties and tenants.
2. Perform pre-move-in inspections with photos, signatures, and timestamps.
3. Perform move-out inspections similarly.
4. Store data offline safely.
5. Generate PDF reports and share with tenants.
6. Use GPS tagging optionally to verify inspection location.
7. Use the app regularly to stay compliant with California laws (AB 2801, security deposits, etc.)

For detailed legal advice, consult a professional.
''',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
