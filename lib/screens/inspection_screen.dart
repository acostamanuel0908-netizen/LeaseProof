import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';

import '../models/property.dart';
import '../models/inspection.dart';

class InspectionScreen extends StatefulWidget {
  @override
  _InspectionScreenState createState() => _InspectionScreenState();
}

class _InspectionScreenState extends State<InspectionScreen> {
  Property? _property;
  final ImagePicker _picker = ImagePicker();
  File? _photo;
  final TextEditingController _tenantController = TextEditingController();

  Location _location = Location();
  LocationData? _locationData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args is Property) _property = args;
  }

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) return;
    }

    PermissionStatus permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }
  }

  Future<void> _takePhoto() async {
    final XFile? img = await _picker.pickImage(source: ImageSource.camera, imageQuality: 70);
    if (img == null) return;

    _locationData = await _location.getLocation();

    setState(() => _photo = File(img.path));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Inspection')),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            if (_property != null) Text('Property: ${_property!.name}'),
            TextField(controller: _tenantController, decoration: InputDecoration(labelText: 'Tenant Name')),
            SizedBox(height: 12),
            ElevatedButton.icon(onPressed: _takePhoto, icon: Icon(Icons.camera_alt), label: Text('Take Photo')),
            if (_photo != null) Padding(padding: EdgeInsets.only(top: 8), child: Image.file(_photo!, height: 180)),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                if (_property == null) return;
                final now = DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());
                final inspection = Inspection(
                  propertyId: _property!.id ?? 0,
                  tenantName: _tenantController.text,
                  type: 'move_in',
                  createdAt: now,
                );

                Navigator.pushNamed(
                  context,
                  '/signatures',
                  arguments: {'inspection': inspection, 'photo': _photo},
                );
              },
              child: Text('Save & Capture Signatures'),
            ),
          ],
        ),
      ),
    );
  }
}
