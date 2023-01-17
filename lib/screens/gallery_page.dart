import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class GalleryPage extends StatefulWidget {
  GalleryPage({super.key});

  List<File> imageList = [];

  @override
  _GalleryPageState createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  double get height => MediaQuery.of(context).size.height;
  File? image;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.fitness_center),
            const SizedBox(width: 5),
            Text(
              "FitTrack",
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.blue.shade900,
        centerTitle: false,
        actions: const [
          SizedBox(
            width: 40,
          )
        ],
      ),
      body: Center(
        child: image == null
            ? Text(
                'WORKING ON PROGRESS',
                style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white,
                    letterSpacing: 4),
              )
            : GridView.count(
                crossAxisCount: 3,
                children: widget.imageList
                    .map((widget) => Image.file(widget))
                    .toList(),
              ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FloatingActionButton(
              heroTag: "btn1",
              onPressed: () {
                onImageButtonPressed(ImageSource.camera);
              },
              backgroundColor: Colors.blue.shade900,
              elevation: 20,
              child: const Icon(Icons.photo_camera),
            ),
            FloatingActionButton(
              heroTag: "btn2",
              onPressed: () {
                onImageButtonPressed(ImageSource.gallery);
              },
              backgroundColor: Colors.blue.shade900,
              elevation: 20,
              child: const Icon(Icons.photo_library),
            ),
          ],
        ),
      ),
    );
  }

  void onImageButtonPressed(ImageSource source) async {
    try {
      await getImage(source);
    } catch (e) {
      print(e);
    }
  }

  Future getImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      image = File(pickedFile!.path);
      widget.imageList.add(image!);
    });
  }
}
