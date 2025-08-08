import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signature/signature.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

void main() {
  runApp(LeaseProofApp());
}

class LeaseProofApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LeaseProof',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: InspectionScreen(),
    );
  }
}

class InspectionItem {
  String name;
  bool? good; // true=good, false=damaged, null=unset
  File? photo;

  InspectionItem(this.name);
}

class InspectionScreen extends StatefulWidget {
  @override
  _InspectionScreenState createState() => _InspectionScreenState();
}

class _InspectionScreenState extends State<InspectionScreen> {
  List<InspectionItem> items = [
    InspectionItem('Walls'),
    InspectionItem('Floors'),
    InspectionItem('Windows'),
    InspectionItem('Doors'),
  ];

  final picker = ImagePicker();

  final SignatureController landlordSignatureController = SignatureController(
    penStrokeWidth: 2,
    penColor: Colors.blue,
    exportBackgroundColor: Colors.white,
  );

  final SignatureController tenantSignatureController = SignatureController(
    penStrokeWidth: 2,
    penColor: Colors.green,
    exportBackgroundColor: Colors.white,
  );

  Future<void> pickImage(int index) async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        items[index].photo = File(pickedFile.path);
      });
    }
  }

  Future<void> generatePdf() async {
    final pdf = pw.Document();
    final dateStr = DateFormat.yMMMMd().format(DateTime.now());

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Header(level: 0, child: pw.Text('LeaseProof Inspection Report')),
          pw.Paragraph(text: 'Date: $dateStr'),
          pw.ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return pw.Column(children: [
                pw.Text('${item.name}: ${item.good == true ? 'Good' : item.good == false ? 'Damaged' : 'Not set'}'),
                if (item.photo != null)
                  pw.Padding(
                    padding: const pw.EdgeInsets.only(top: 8),
                    child: pw.Image(pw.MemoryImage(item.photo!.readAsBytesSync()), width: 200),
                  ),
                pw.SizedBox(height: 10),
              ]);
            },
          ),
          pw.Header(level: 1, text: 'Signatures'),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
            children: [
              pw.Column(children: [
                pw.Text('Landlord'),
                pw.Container(
                  height: 100,
                  width: 200,
                  decoration: pw.BoxDecoration(border: pw.Border.all()),
                  child: pw.Image(pw.MemoryImage(await landlordSignatureController.toPngBytes() ?? Uint8List(0))),
                ),
              ]),
              pw.Column(children: [
                pw.Text('Tenant'),
                pw.Container(
                  height: 100,
                  width: 200,
                  decoration: pw.BoxDecoration(border: pw.Border.all()),
                  child: pw.Image(pw.MemoryImage(await tenantSignatureController.toPngBytes() ?? Uint8List(0))),
                ),
              ]),
            ],
          ),
        ],
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/inspection_report.pdf');
    await file.writeAsBytes(await pdf.save());

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('PDF Report generated!')),
    );
  }

  @override
  void dispose() {
    landlordSignatureController.dispose();
    tenantSignatureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LeaseProof Inspection'),
      ),
      body: ListView.builder(
        itemCount: items.length + 3,
        itemBuilder: (context, index) {
          if (index < items.length) {
            final item = items[index];
            return Card(
              margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: ListTile(
                title: Text(item.name),
                subtitle: Text(item.good == null
                    ? 'Status not set'
                    : item.good == true
                        ? 'Good'
                        : 'Damaged'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.check_circle, color: item.good == true ? Colors.green : null),
                      onPressed: () {
                        setState(() {
                          item.good = true;
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.cancel, color: item.good == false ? Colors.red : null),
                      onPressed: () {
                        setState(() {
                          item.good = false;
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.camera_alt),
                      onPressed: () => pickImage(index),
                    ),
                  ],
                ),
              ),
            );
          } else if (index == items.length) {
            return Padding(
              padding: EdgeInsets.all(12),
              child: Text('Landlord Signature:', style: TextStyle(fontWeight: FontWeight.bold)),
            );
          } else if (index == items.length + 1) {
            return Signature(
              controller: landlordSignatureController,
              height: 150,
              backgroundColor: Colors.grey[200]!,
            );
          } else if (index == items.length + 2) {
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(12),
                  child: Text('Tenant Signature:', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Signature(
                  controller: tenantSignatureController,
                  height: 150,
                  backgroundColor: Colors.grey[200]!,
                ),
                SizedBox(height: 20),
                ElevatedButton.icon(
                  icon: Icon(Icons.picture_as_pdf),
                  label: Text('Generate PDF Report'),
                  onPressed: generatePdf,
                ),
              ],
            );
          }
          return Container();
        },
      ),
    );
  }
}
