import 'package:flutter/material.dart';
import 'package:signature/signature.dart';

class SignaturePad extends StatefulWidget {
  final Function(Uint8List) onSaved;
  const SignaturePad({required this.onSaved, Key? key}) : super(key: key);

  @override
  State<SignaturePad> createState() => _SignaturePadState();
}

class _SignaturePadState extends State<SignaturePad> {
  final SignatureController _controller = SignatureController(penStrokeWidth: 2);

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
        decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
        child: Signature(controller: _controller),
      ),
      Row(
        children: [
          ElevatedButton(
            onPressed: () => _controller.clear(),
            child: const Text('Clear'),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: () async {
              final data = await _controller.toPngBytes();
              if (data != null) widget.onSaved(data);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    ]);
  }
}
