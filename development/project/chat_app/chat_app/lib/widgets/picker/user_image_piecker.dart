import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';

class UserUmagePickerState extends StatefulWidget {
  UserUmagePickerState(this.imagePickerFn);
  final void Function(File pickImage) imagePickerFn;
  @override
  State<UserUmagePickerState> createState() => UserUmagePickerStateState();
}

class UserUmagePickerStateState extends State<UserUmagePickerState> {
  File? _pickedUmage;
  void _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.camera,imageQuality: 50,maxWidth: 150);
    // requires import 'dart:io';
    File pickedImageFile = File(pickedImage!.path);
    setState(() {
      _pickedUmage = pickedImageFile;
    });
    widget.imagePickerFn(_pickedUmage!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          backgroundImage:
              _pickedUmage != null ? FileImage(_pickedUmage!) : null,
        ),
        TextButton.icon(
          onPressed: () {
            _pickImage();
          },
          icon: Icon(
            Icons.image,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          label: Text('Add Image'),
        ),
      ],
    );
  }
}
