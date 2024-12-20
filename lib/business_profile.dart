import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class BusinessProfile extends StatefulWidget {
  const BusinessProfile({Key? key}) : super(key: key);

  @override
  State<BusinessProfile> createState() => _BusinessProfileState();
}

class _BusinessProfileState extends State<BusinessProfile> {
  File? file;
  final formKey = GlobalKey<FormState>();
  User? user = FirebaseAuth.instance.currentUser;
  String datetime = DateTime.now().toString();

  final storeNameController = TextEditingController();
  final contactController = TextEditingController();
  final locationController = TextEditingController();
  final websiteController = TextEditingController();
  final imageUrlController = TextEditingController();

  void clearTextInput() {
    storeNameController.clear();
    contactController.clear();
    locationController.clear();
    websiteController.clear();
    imageUrlController.clear();
    setState(() {
      file = null;
    });
  }

  Widget buildImagePreview() {
    if (file != null) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 20),
        height: 150,
        width: 150,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.file(file!, fit: BoxFit.cover),
        ),
      );
    } else if (imageUrlController.text.isNotEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 20),
        height: 150,
        width: 150,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            imageUrlController.text,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const Center(child: Text('Invalid Image URL', 
                style: TextStyle(color: Colors.red)));
            },
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18.0),
            child: GestureDetector(
              onTap: clearTextInput,
              child: const Icon(Icons.clear),
            ),
          )
        ],
        title: const Text(
          "Business Profile",
          style: TextStyle(
            fontSize: 20, 
            fontWeight: FontWeight.w400, 
            color: Colors.black
          ),
        ),
        elevation: 2.0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  // Image preview
                  buildImagePreview(),

                  TextFormField(
                    controller: storeNameController,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      labelText: "Store Name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(2),
                        borderSide: const BorderSide(color: Colors.grey)
                      ),
                    ),
                    validator: (value) => (value != null && value.isEmpty)
                      ? 'Must Not be Empty'
                      : null,
                  ),
                  const SizedBox(height: 15),

                  TextFormField(
                    controller: contactController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Contact",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(2),
                        borderSide: const BorderSide(color: Colors.grey)
                      ),
                    ),
                    validator: (value) => (value != null && value.isEmpty)
                      ? 'Contact Must Not be Empty'
                      : null,
                  ),
                  const SizedBox(height: 15),

                  TextFormField(
                    controller: locationController,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      labelText: "Location",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(2),
                        borderSide: const BorderSide(color: Colors.grey)
                      ),
                    ),
                    validator: (value) => (value != null && value.isEmpty)
                      ? 'Location Must Not be Empty'
                      : null,
                  ),
                  const SizedBox(height: 15),

                  TextFormField(
                    controller: websiteController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: "Website (Optional)",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(2),
                        borderSide: const BorderSide(color: Colors.grey)
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Image URL field
                  TextFormField(
                    controller: imageUrlController,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      labelText: "Logo URL",
                      hintText: "Enter image URL or use gallery below",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(2),
                        borderSide: const BorderSide(color: Colors.grey)
                      ),
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        setState(() {
                          file = null; // Clear file when URL is entered
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 25),

                  ElevatedButton(
                    onPressed: () => pickImageforlogo(ImageSource.gallery),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2),
                      ),
                      fixedSize: const Size(285, 50),
                      backgroundColor: const Color.fromARGB(255, 253, 253, 253),
                      foregroundColor: const Color.fromARGB(255, 53, 53, 53)
                    ),
                    child: Text(
                      file == null ? "Upload Logo" : "Change Logo",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 30),

                  ElevatedButton(
                    onPressed: () => upload(context),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2),
                      ),
                      fixedSize: const Size(285, 50),
                      backgroundColor: const Color.fromARGB(255, 181, 210, 255),
                      foregroundColor: const Color.fromARGB(255, 53, 53, 53)
                    ),
                    child: const Text(
                      "Create Profile",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future pickImageforlogo(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      setState(() {
        file = File(image.path);
        imageUrlController.clear(); // Clear URL when file is picked
      });
    } on PlatformException catch (e) {
      print("Failed to upload image: $e");
    }
  }

  Future upload(context) async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    if (file == null && imageUrlController.text.isEmpty) {
      Get.snackbar(
        'Image Required', 
        'Please select a logo image or provide an image URL',
        duration: const Duration(milliseconds: 2000),
        backgroundColor: const Color.fromRGBO(255, 255, 255, 0.494)
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      )
    );

    try {
      String logoUrl = file != null ? file!.path : imageUrlController.text;

      DocumentReference documentReferencer = FirebaseFirestore.instance
          .collection('business profile requests')
          .doc(storeNameController.text);
          
      Map<String, dynamic> data = {
        'store/brandName': storeNameController.text,
        'contact': contactController.text,
        'location': locationController.text,
        'website': websiteController.text,
        'storeLogo': logoUrl,
        'timestamp': datetime,
        'email': user?.email,
      };

      await documentReferencer.set(data);
      Get.back();
      Get.back();
      Get.snackbar(
        'Success', 
        'Mail will be sent after your Business Profile is ready',
        duration: const Duration(milliseconds: 4000),
        backgroundColor: const Color.fromARGB(126, 255, 255, 255)
      );
    } on FirebaseException catch (e) {
      Navigator.pop(context);
      Get.snackbar(
        'Error', 
        e.message.toString(),
        duration: const Duration(milliseconds: 2000),
        backgroundColor: const Color.fromRGBO(255, 255, 255, 0.494)
      );
    }
  }
}