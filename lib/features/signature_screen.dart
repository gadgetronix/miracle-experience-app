import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:signature/signature.dart';

class SignatureScreen extends StatelessWidget {
  SignatureScreen({super.key});

  final SignatureController _controller = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Signature Pad")),
      body: Column(
        children: [
          Signature(
            controller: _controller,
            height: 300,
            backgroundColor: Colors.grey[200]!,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () async {
                  final Uint8List? data = await _controller.toPngBytes();
                  if (data != null) {
                    // await sendSignatureToAPI(data);
                  }
                },
                child: const Text("Save & Send"),
              ),
              ElevatedButton(
                onPressed: () => _controller.clear(),
                child: const Text("Clear"),
              ),
            ],
          ),
        ],
      ),
    );
  }
  // Future<void> sendSignatureToAPI(Uint8List signatureBytes) async {
  //   var request = http.MultipartRequest(
  //     'POST',
  //     Uri.parse('https://your-api-endpoint.com/upload'),
  //   );

  //   // Add image file
  //   request.files.add(
  //     http.MultipartFile.fromBytes(
  //       'signature',
  //       signatureBytes,
  //       filename: 'signature.png',
  //       contentType: MediaType('image', 'png'),
  //     ),
  //   );

  //   // Add other fields if necessary
  //   request.fields['user_id'] = '123';

  //   var response = await request.send();

  //   if (response.statusCode == 200) {
  //     print('Signature uploaded successfully!');
  //   } else {
  //     print('Upload failed with status: ${response.statusCode}');
  //   }
  // }
}
