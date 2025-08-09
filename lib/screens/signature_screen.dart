import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../widgets/signature_pad.dart';

class SignatureScreen extends StatefulWidget {
  final Function(Uint8List landlordSig, Uint8List tenantSig) onSignaturesCaptured;

  SignatureScreen({required this.onSignaturesCaptured});

  @override
  _SignatureScreenState createState() => _SignatureScreenState();
}

class _SignatureScreenState extends State<SignatureScreen> {
  Uint8List? landlordSignature;
  Uint8List? tenantSignature;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Capture Signatures')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text('Landlord Signature'),
            SignaturePad(
              onSaved: (data) {
                setState(() {
                  landlordSignature = data;
                });
              },
            ),
            SizedBox(height: 20),
            Text('Tenant Signature'),
            SignaturePad(
              onSaved: (data) {
                setState(() {
                  tenantSignature = data;
                });
              },
            ),
            Spacer(),
            ElevatedButton(
              onPressed: (landlordSignature != null && tenantSignature != null)
                  ? () {
                      widget.onSignaturesCaptured(landlordSignature!, tenantSignature!);
                    }
                  : null,
              child: Text('Confirm & Save'),
            ),
          ],
        ),
      ),
    );
  }
}
