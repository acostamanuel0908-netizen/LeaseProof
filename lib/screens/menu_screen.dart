import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  final String instructions = '''
How to Use LeaseProof App:

1. Add your properties on the Properties screen.
2. For each property, create a Move-In Inspection before tenant moves in.
3. Capture photos during inspection. Each photo includes a timestamp and location.
4. Both landlord and tenant sign the inspection in the Signatures screen.
5. After the tenant moves out, create a Move-Out Inspection to document any damages.
6. Export inspections as PDF and share with tenants.
7. Back up your inspection data with Google Drive integration.

California Compliance Notes:
- Always get tenant signatures on move-in and move-out inspections.
- Keep photos dated and geotagged.
- Share inspection reports with tenants within 21 days of move-out.
- Keep records for at least 3 years.

For full legal advice, consult a lawyer.
''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Instructions & Compliance')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: SingleChildScrollView(child: Text(instructions)),
      ),
    );
  }
}
