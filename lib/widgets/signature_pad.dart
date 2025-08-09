import 'package:flutter/material.dart';
import 'package:signature/signature.dart';

class SignaturePad extends StatefulWidget {
  final Function(Uint8List) onSaved;
  SignaturePad({required this.onSaved});

  @override
  _SignaturePadState createState() => _SignaturePadState();
}

class _SignaturePadState extends State<SignaturePad> {
  SignatureController _controller = SignatureController(penStrokeWidth: 2);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        height: 150,
        decoration: BoxDecoration(border: Border.all()),
        child: Signature(controller: _controller),
      ),
      Row(
        children: [
          ElevatedButton(
            onPressed: () => _controller.clear(),
            child: Text('Clear'),
          ),
          SizedBox(width: 12),
          ElevatedButton(
            onPressed: () async {
              final data = await _controller.toPngBytes();
              if (data != null) widget.onSaved(data);
            },
            child: Text('Save'),
          )
        ],
      )
    ]);
  }
}
