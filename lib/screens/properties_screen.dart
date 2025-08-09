import 'package:flutter/material.dart';
import '../services/db_service.dart';
import '../models/property.dart';

class PropertiesScreen extends StatefulWidget {
  @override
  _PropertiesScreenState createState() => _PropertiesScreenState();
}

class _PropertiesScreenState extends State<PropertiesScreen> {
  final DBService _db = DBService();
  List<Property> _props = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() async {
    final p = await _db.getProperties();
    setState(() => _props = p);
  }

  void _addSample() async {
    final p = Property(name: 'Sample Unit', address: '123 Main St');
    await _db.insertProperty(p);
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Properties'),
        actions: [
          IconButton(
            icon: Icon(Icons.menu_book),
            onPressed: () => Navigator.pushNamed(context, '/menu'),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _props.length,
        itemBuilder: (_, i) {
          final prop = _props[i];
          return ListTile(
            title: Text(prop.name),
            subtitle: Text(prop.address),
            onTap: () {
              Navigator.pushNamed(context, '/inspection', arguments: prop);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addSample,
        child: Icon(Icons.add),
      ),
    );
  }
}
