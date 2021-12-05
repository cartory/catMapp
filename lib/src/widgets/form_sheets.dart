import 'dart:io';
import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../globals.dart';

class PlaceFormSheet extends StatefulWidget {
  final Place? place;
  final String? title;

  const PlaceFormSheet({Key? key, this.place, this.title}) : super(key: key);

  @override
  _PlaceFormSheetState createState() => _PlaceFormSheetState();
}

class _PlaceFormSheetState extends State<PlaceFormSheet> {
  File? imgFile;

  late final Place place;

  final _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    place = widget.place ?? Place();
  }

  Future<void> pickImage() async {
    final src = await selectImageSource();
    if (src == null) return;
    try {
      final xfile = await _picker.pickImage(source: src);
      if (xfile == null) return;
      setState(() => imgFile = File(xfile.path));
    } catch (e) {
      log(e.toString());
    }
  }

  Widget buildImage({double? size = 150}) {
    // UPDATING PLACE
    if (place.id != null && imgFile == null && place.photoUrl != null) {
      return CachedNetworkImage(
        height: size,
        imageUrl: place.photoUrl!,
        imageBuilder: (_, imageProvider) {
          return Container(
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
              image: DecorationImage(fit: BoxFit.contain, image: imageProvider),
            ),
          );
        },
      );
    }

    // DEFAULT IMAGE
    if (imgFile == null && (place.id == null || place.photoUrl == null)) {
      return Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(100),
        ),
        child: CircleAvatar(
          minRadius: size,
          backgroundColor: Colors.grey.shade200,
          child: const Icon(
            Icons.photo_camera_back_rounded,
            size: 30,
            color: Colors.grey,
          ),
        ),
      );
    }

    // SHOWING DATASOURCE FROM IMAGEPICKER
    return CircleAvatar(
      minRadius: size! * .5,
      backgroundColor: Colors.grey.shade200,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: Image.file(
          imgFile!,
          width: size,
          height: size,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ClipRect(
        child: Banner(
          location: BannerLocation.topEnd,
          message: place.id == null ? 'New' : 'Edit',
          color: place.id == null ? Get.theme.colorScheme.primaryVariant : Colors.green.shade600,
          child: ListView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            children: [
              // IMAGE PROVIDER
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: InkWell(
                  onTap: pickImage,
                  child: buildImage(),
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              // PLACE NAME
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: TextFormField(
                  initialValue: place.code,
                  onChanged: (code) => place.code = code,
                  validator: (code) => code!.isEmpty ? 'Code Required' : null,
                  decoration: InputDecoration(
                    filled: true,
                    labelText: 'Code',
                    contentPadding: const EdgeInsets.all(15),
                    floatingLabelStyle: Get.theme.inputDecorationTheme.floatingLabelStyle,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: TextFormField(
                  initialValue: place.name,
                  onChanged: (name) => place.name = name,
                  validator: (name) => name!.isEmpty ? 'Name Required' : null,
                  decoration: InputDecoration(
                    filled: true,
                    labelText: 'Name',
                    contentPadding: const EdgeInsets.all(15),
                    floatingLabelStyle: Get.theme.inputDecorationTheme.floatingLabelStyle,
                  ),
                ),
              ),
              // PLACE NAME
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: TextFormField(
                  minLines: 3,
                  maxLines: 3,
                  initialValue: place.description,
                  onChanged: (description) => place.description = description,
                  decoration: InputDecoration(
                    filled: true,
                    labelText: 'Description',
                    contentPadding: const EdgeInsets.all(15),
                    floatingLabelStyle: Get.theme.inputDecorationTheme.floatingLabelStyle,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: OutlinedButton(
                        child: Row(
                          children: const [
                            Icon(Icons.clear_rounded, color: Colors.red),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text('Cancel'),
                            ),
                          ],
                        ),
                        onPressed: () => Get.back(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: OutlinedButton(
                        child: Row(
                          children: const [
                            Icon(Icons.check_outlined, color: Colors.green),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text('Save'),
                            ),
                          ],
                        ),
                        onPressed: () async {
                          if (!_formKey.currentState!.validate()) return;
                          _formKey.currentState!.save();
                          await PlaceApi.addPlace(place, imgFile);
                          Get.back();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
