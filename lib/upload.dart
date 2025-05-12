import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;
import 'query.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  String? selectedFileName;
  String uploadDirectory = 'C:/Users/JEFRINA A P/PdfChat/PdfChat/data';
  bool isUploaded = false;

  Future<void> _uploadAndChooseFile() async {
    try {
      // Open the file picker to select a document
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: false,
      );

      if (result != null) {
        String fileName = result.files.single.name;
        setState(() {
          selectedFileName = fileName; // Capture the file name
        });

        // Ensure the target directory exists
        Directory targetDir = Directory(uploadDirectory);
        if (!targetDir.existsSync()) {
          print('Target directory does not exist, creating...');
          targetDir.createSync(recursive: true);
        }
        print('Target directory path: ${targetDir.path}');

        // Get the selected file and ensure that the target path is correct
        File selectedFile = File(result.files.single.path!);
        String targetPath = p.join(targetDir.path, fileName);

        print('Selected file path: ${result.files.single.path}');
        print('Target path: $targetPath');

        // Copy the file to the target directory
        await selectedFile.copy(targetPath);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('File uploaded to $targetPath')),
        );
        print('File uploaded successfully to $targetPath');

        // Set upload success flag
        setState(() {
          isUploaded = true;
        });
      } else {
        print('No file selected.');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No file selected.')),
        );
      }
    } catch (e) {
      print('Error during upload: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading file: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade800,
      appBar: AppBar(
        title: const Text('Upload Documents'),
        backgroundColor: const Color.fromARGB(255, 184, 188, 190),
        elevation: 5,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.upload_file,
                size: 100,
                color: Colors.white,
              ),
              const SizedBox(height: 20),
              const Text(
                'Upload your document',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
              const SizedBox(height: 10),
              const Text(
                'Accepted format: PDF',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _uploadAndChooseFile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 219, 225, 233),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  textStyle: const TextStyle(fontSize: 16),
                ),
                child: const Text(
                  'Upload and Choose File',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(height: 20),
              if (selectedFileName != null)
                Column(
                  children: [
                    const Text(
                      'Uploaded File:',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      selectedFileName!,
                      style: const TextStyle(
                          fontSize: 14, color: Colors.blueAccent),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              const SizedBox(height: 20),
              if (isUploaded)
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => QueryPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 219, 225, 233),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                  child: const Text(
                    'Go to Next Page',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
