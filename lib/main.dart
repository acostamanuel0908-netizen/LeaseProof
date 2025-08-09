import 'package:flutter/material.dart';

import 'screens/properties_screen.dart';
import 'screens/inspection_screen.dart';
import 'screens/signature_screen.dart';
import 'screens/review_screen.dart';
import 'screens/menu_screen.dart';
import 'models/inspection.dart';
import 'dart:io';
import 'dart:typed_data';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(LeaseProofApp());
}

class LeaseProofApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LeaseProof',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => PropertiesScreen(),
        '/inspection': (context) => InspectionScreen(),
        '/review': (context) => ReviewScreen(),
        '/menu': (context) => MenuScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/signatures') {
          final args = settings.arguments as Map;
          final Inspection inspection = args['inspection'];
          final File? photo = args['photo'];

          return MaterialPageRoute(
            builder: (context) => SignatureScreen(
              onSignaturesCaptured:
                  (Uint8List landlordSig, Uint8List tenantSig) {
                Navigator.pushReplacementNamed(
                  context,
                  '/review',
                  arguments: {
                    'inspection': inspection,
                    'photo': photo,
                    'landlordSig': landlordSig,
                    'tenantSig': tenantSig,
                  },
                );
              },
            ),
            settings: settings,
          );
        }
        return null;
      },
    );
  }
}
