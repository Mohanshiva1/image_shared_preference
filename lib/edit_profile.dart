import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_shared_preference/profile_widget.dart';
import 'package:image_shared_preference/user.dart';
import 'package:image_shared_preference/user_preference.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import 'button.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late User user;

  @override
  void initState() {
    super.initState();
    user = UserPreferences.getUser();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 32),
        physics: BouncingScrollPhysics(),
        children: [
          ProfileWidget(
            imagePath: user.imagePath,
            isEdit: true,
            onClicked: () async {
              final image = await ImagePicker()
                  .getImage(source: ImageSource.gallery);

              if (image == null) return;

              final directory = await getApplicationDocumentsDirectory();
              final name = basename(image.path);
              final imageFile = File('${directory.path}/$name');
              final newImage =
              await File(image.path).copy(imageFile.path);

              setState(() => user = user.copy(imagePath: newImage.path));
            },
          ),

          ButtonWidget(
            text: 'Save',
            onClicked: () {
              UserPreferences.setUser(user);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}