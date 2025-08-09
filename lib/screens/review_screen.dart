import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../models/inspection.dart';

class ReviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map?;

    final File? photo = args?['photo'];
    final Inspection? inspection = args?['inspection'];
    final Uint8List? landlordSig = args?['landlordSig'];
    final Uint8List? tenantSig = args?['tenantSig'];

    return Scaffold(
      appBar: AppBar(title: Text('Review Inspection')),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (photo != null) Image.file(photo, height: 180),
              SizedBox(height: 12),
              if (landlordSig != null) ...[
                Text('Landlord Signature'),
                Image.memory(landlordSig, height: 100),
              ],
              SizedBox(height: 12),
              if (tenantSig != null) ...[
                Text('Tenant Signature'),
                Image.memory(tenantSig, height: 100),
              ],
              SizedBox(height: 12),
              ElevatedButton(
                onPressed: () async {
                  final doc = pw.Document();

                  final photoBytes = photo != null ? await photo.readAsBytes() : null;

                  doc.addPage(pw.Page(
                    build: (context) => pw.Column(children: [
                      pw.Text('LeaseProof Inspection Report', style: pw.TextStyle(fontSize: 24)),
                      if (photoBytes != null) pw.Image(pw.MemoryImage(photoBytes), width: 300),
                      pw.SizedBox(height: 20),
                      if (landlordSig != null)
                        pw.Column(children: [
                          pw.Text('Landlord Signature'),
                          pw.Image(pw.MemoryImage(landlordSig), width: 200),
                        ]),
                      pw.SizedBox(height: 20),
                      if (tenantSig != null)
                        pw.Column(children: [
                          pw.Text('Tenant Signature'),
                          pw.Image(pw.MemoryImage(tenantSig), width: 200),
                        ]),
                    ]),
                  ));

                  await Printing.layoutPdf(onLayout: (format) async => doc.save());
                },
                child: Text('Export PDF'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
