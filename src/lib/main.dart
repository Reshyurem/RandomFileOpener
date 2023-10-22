import 'package:open_file_plus/open_file_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io' as io;

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RFO',
      theme: ThemeData(
          primarySwatch: Colors.purple, scaffoldBackgroundColor: Colors.white),
      home: const MyHomePage(title: 'Flutter Random File Opener'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String randomDirectory = "";
  String fileName = "";
  List files = [];
  defaultLocations? _selectedLocation;

  void chooseDirectory() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

    setState(() {
      randomDirectory = selectedDirectory!;
      files = io.Directory(selectedDirectory).listSync();
      fileName = randomDirectory;
    });
  }

  void openRandomFile() {
    setState(() {
      fileName = files.length.toString();
    });
    if (files.isNotEmpty) {
      int randomIndex = DateTime.now().millisecondsSinceEpoch % files.length;
      io.File file = files[randomIndex];
      OpenFile.open(file.path);
      setState(() {
        fileName = file.path;
      });
    }
    else {
      String path = "/mnt/media_rw/F251-6C3E/${_selectedLocation!.path}";
      files = io.Directory(path).listSync();
      int randomIndex = DateTime.now().millisecondsSinceEpoch % files.length;
      io.File file = files[randomIndex];
      OpenFile.open(file.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pathController = TextEditingController();

    final List<DropdownMenuEntry<defaultLocations>> pathEntries =
        <DropdownMenuEntry<defaultLocations>>[];
    for (final defaultLocations color in defaultLocations.values) {
      pathEntries.add(
        DropdownMenuEntry<defaultLocations>(value: color, label: color.path),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            DropdownMenu<defaultLocations>(
              initialSelection: defaultLocations.real,
              controller: pathController,
              label: const Text("Default Location"),
              dropdownMenuEntries: pathEntries,
              onSelected: (defaultLocations? value) {
                setState(() {
                  if(value != null) {
                    _selectedLocation = value;
                  }
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
                onPressed: chooseDirectory,
                icon: const Icon(Icons.folder_open, size: 48),
                label: const Text("Choose Directory",
                    style: TextStyle(fontSize: 14)),
                style: ElevatedButton.styleFrom(
                  maximumSize: const Size(150, 100),
                )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openRandomFile,
        tooltip: 'Choose Random File',
        child: const Icon(Icons.remove_red_eye),
      ),
    );
  }
}

enum defaultLocations {
  real('Real', 'Real'),
  img('Imaginary', 'Temp');

  const defaultLocations(this.name, this.path);
  final String name;
  final String path;
}
