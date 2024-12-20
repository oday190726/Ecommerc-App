/*import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class AdminUploadPage extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final brandUploadName;
  const AdminUploadPage({Key? key, this.brandUploadName}) : super(key: key);

  @override
  State<AdminUploadPage> createState() => _AdminUploadPageState();
}

class _AdminUploadPageState extends State<AdminUploadPage> {
  File? file;
  final box = GetStorage();
  var dropDownCategory = "Category";
  var dropDownOffer = "Offer";
  var dropDownType = "Type";
  var dropDownColor = "Color";
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    brandController.text = widget.brandUploadName;
    super.initState();
  }

  @override
  void dispose() {
    widget.brandUploadName;
    super.dispose();
  }

  final brandController = TextEditingController();
  final titleController = TextEditingController();
  final descController = TextEditingController();
  final categoryController = TextEditingController();
  final priceController = TextEditingController();
  final discountController = TextEditingController();

  clearTextInput() {
    titleController.clear();
    descController.clear();
    categoryController.clear();
    priceController.clear();
    discountController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "Add Products",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w400, color: Colors.black),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18.0),
            child: GestureDetector(
              onTap: clearTextInput,
              child: const Icon(
                Icons.clear,
              ),
            ),
          )
        ],
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .where('email', isEqualTo: user!.email)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Text(
                        'Loading...',
                      );
                    } else {
                      List<QueryDocumentSnapshot<Object?>> firestoreItems =
                          snapshot.data!.docs;
                      return Column(
                        children: [
                          firestoreItems[0]['adminrole'] == 'superAdmin'
                              ? TextFormField(
                                  controller: brandController,
                                  autofocus: true,
                                  textInputAction: TextInputAction.next,
                                  textCapitalization: TextCapitalization.words,
                                  decoration: const InputDecoration(
                                      labelText: "Store Name"),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) =>
                                      (value != null && value.isEmpty)
                                          ? 'Store Name Must Not be Empty'
                                          : null,
                                )
                              : TextFormField(
                                  controller: brandController,
                                  readOnly: true,
                                  decoration: const InputDecoration(
                                      labelText: "Store Name"),
                                ),
                          TextFormField(
                            controller: titleController,
                            textInputAction: TextInputAction.next,
                            textCapitalization: TextCapitalization.words,
                            decoration: const InputDecoration(
                                labelText: "Product Name"),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) =>
                                (value != null && value.isEmpty)
                                    ? 'Product Name Must Not be Empty'
                                    : null,
                          ),
                          TextFormField(
                            controller: descController,
                            textInputAction: TextInputAction.next,
                            decoration:
                                const InputDecoration(labelText: "Description"),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) =>
                                (value != null && value.isEmpty)
                                    ? 'Description Must Not be Empty'
                                    : null,
                          ),
                          TextFormField(
                            controller: priceController,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            decoration:
                                const InputDecoration(labelText: "Price"),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) =>
                                (value != null && value.isEmpty)
                                    ? 'Price Must Not be Empty'
                                    : null,
                          ),
                          TextFormField(
                            controller: discountController,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.go,
                            decoration:
                                const InputDecoration(labelText: "Discount"),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              DropdownButton<String>(
                                value: dropDownCategory,
                                icon: const Icon(Icons.arrow_downward),
                                elevation: 16,
                                style:
                                    const TextStyle(color: Colors.deepPurple),
                                underline: Container(
                                  height: 2,
                                  color: Colors.deepPurpleAccent,
                                ),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    dropDownCategory = newValue!;
                                  });
                                },
                                items: <String>[
                                  "Category",
                                  'Men',
                                  'Women',
                                  'Kids',
                                  'Men,Women',
                                  'Men,Kids',
                                  'Women,Kids'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                              DropdownButton<String>(
                                value: dropDownOffer,
                                icon: const Icon(Icons.arrow_downward),
                                elevation: 16,
                                style:
                                    const TextStyle(color: Colors.deepPurple),
                                underline: Container(
                                  height: 2,
                                  color: Colors.deepPurpleAccent,
                                ),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    dropDownOffer = newValue!;
                                  });
                                },
                                items: <String>[
                                  "Offer",
                                  'Yes',
                                  'No'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              DropdownButton<String>(
                                value: dropDownType,
                                icon: const Icon(Icons.arrow_downward),
                                elevation: 16,
                                style: const TextStyle(
                                  color: Colors.deepPurpleAccent,
                                ),
                                underline: Container(
                                  height: 2,
                                  color: Colors.deepPurpleAccent,
                                ),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    dropDownType = newValue!;
                                  });
                                },
                                items: <String>[
                                  "Type",
                                  'Sports',
                                  'Classic',
                                  'Casual'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                              DropdownButton<String>(
                                value: dropDownColor,
                                icon: const Icon(Icons.arrow_downward),
                                elevation: 16,
                                style:
                                    const TextStyle(color: Colors.deepPurple),
                                underline: Container(
                                  height: 2,
                                  color: Colors.deepPurpleAccent,
                                ),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    dropDownColor = newValue!;
                                  });
                                },
                                items: <String>[
                                  "Color",
                                  "No Specific",
                                  "Red",
                                  "Black",
                                  "Blue",
                                  "White",
                                  "Yellow"
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    pickImage(ImageSource.camera);
                                  },
                                  child: const Text("Camera")),
                              const SizedBox(
                                width: 40,
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    pickImage(ImageSource.gallery);
                                  },
                                  child: const Text("Gallery"))
                            ],
                          )
                        ],
                      );
                    }
                  }),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    upload(context);
                  },
                  child: const Text("Upload"))
            ],
          ),
        ),
      )),
    );
  }

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      setState(() {
        file = File(image.path);
        box.write("a", file);
      });
    } on PlatformException catch (e) {
      // ignore: avoid_print
      print("Failed to upload image: $e");
    }
  }

  Future upload(context) async {
  final isValid = formKey.currentState!.validate();
  if (!isValid) return;

  // Validate all dropdowns
  if (dropDownCategory == "Category") {
    return Get.snackbar('Category Required', "Please insert the category",
        duration: const Duration(milliseconds: 2000),
        backgroundColor: const Color.fromRGBO(255, 255, 255, 0.494));
  }

  if (dropDownOffer == "Offer") {
    return Get.snackbar('Offer Required', "Please insert offer",
        duration: const Duration(milliseconds: 2000),
        backgroundColor: const Color.fromRGBO(255, 255, 255, 0.494));
  }

  if (dropDownColor == "Color") {
    return Get.snackbar('Colour Required', "Please insert the colour",
        duration: const Duration(milliseconds: 2000),
        backgroundColor: const Color.fromRGBO(255, 255, 255, 0.494));
  }

  if (dropDownType == "Type") {
    return Get.snackbar('Type Required', "Please insert the type",
        duration: const Duration(milliseconds: 2000),
        backgroundColor: const Color.fromRGBO(255, 255, 255, 0.494));
  }

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const Center(
      child: CircularProgressIndicator(),
    )
  );

  try {
    // Generate document ID
    var docid = FirebaseFirestore.instance.collection('products').doc().id;
    DocumentReference documentReferencer = FirebaseFirestore.instance
        .collection('products')
        .doc(docid);

    // Use placeholder image URL
    Map<String, dynamic> data = <String, dynamic>{
      'brand_store': brandController.text,
      'productName': titleController.text,
      'description': descController.text,
      'price': priceController.text,
      'discount': discountController.text,
      'image': "https://placehold.co/400x400?text=ProductImage", // Placeholder image
      'productID': docid.trim(),
      'category': dropDownCategory.trim(),
      'offer': dropDownOffer.trim(),
      'type': dropDownType.trim(),
      'color': dropDownColor.trim(),
    };

    await documentReferencer
        .set(data)
        .then(((value) => Get.back()))
        .then(((value) => Get.back()))
        .then((value) => Get.snackbar(
            'Success', 
            'Uploaded Successfully',
            duration: const Duration(milliseconds: 2000),
            backgroundColor: const Color.fromARGB(126, 255, 255, 255)
        ));

  } on FirebaseException catch (e) {
    print(e);
    Get.snackbar('Error', e.message.toString(),
        duration: const Duration(milliseconds: 2000),
        backgroundColor: const Color.fromRGBO(255, 255, 255, 0.494));
  }
}
}
*/


import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class AdminUploadPage extends StatefulWidget {
  final String brandUploadName;
  const AdminUploadPage({Key? key, required this.brandUploadName}) : super(key: key);

  @override
  State<AdminUploadPage> createState() => _AdminUploadPageState();
}

class _AdminUploadPageState extends State<AdminUploadPage> {
  File? file;

  // Dropdown variables
  String dropDownCategory = "Category";
  String dropDownOffer = "Offer";
  String dropDownType = "Type";
  String dropDownColor = "Color";

  final formKey = GlobalKey<FormState>();
  final brandController = TextEditingController();
  final titleController = TextEditingController();
  final descController = TextEditingController();
  final priceController = TextEditingController();
  final discountController = TextEditingController();
  final imageUrlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    brandController.text = widget.brandUploadName;
  }

  @override
  void dispose() {
    brandController.dispose();
    titleController.dispose();
    descController.dispose();
    priceController.dispose();
    discountController.dispose();
    imageUrlController.dispose();
    super.dispose();
  }

  void clearTextInput() {
    titleController.clear();
    descController.clear();
    priceController.clear();
    discountController.clear();
    imageUrlController.clear();
    setState(() {
      file = null;
      dropDownCategory = "Category";
      dropDownOffer = "Offer";
      dropDownType = "Type";
      dropDownColor = "Color";
    });
  }

  Future pickImage(ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile == null) return;
      setState(() {
        file = File(pickedFile.path);
        imageUrlController.clear(); // Clear URL when file is picked
      });
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image: $e');
    }
  }

  Future upload(BuildContext context) async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    // Validate dropdowns
    if (dropDownCategory == "Category" || dropDownOffer == "Offer" ||
        dropDownType == "Type" || dropDownColor == "Color") {
      Get.snackbar('Validation Error', 'Please complete all dropdown selections.');
      return;
    }

    // Check if either file or URL is provided
    if (file == null && imageUrlController.text.isEmpty) {
      Get.snackbar('Image Required', 'Please select an image or provide an image URL');
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      String docId = FirebaseFirestore.instance.collection('products').doc().id;
      String imageSource = file != null ? file!.path : imageUrlController.text;

      Map<String, dynamic> data = {
        'brand_store': brandController.text.trim(),
        'productName': titleController.text.trim(),
        'description': descController.text.trim(),
        'price': priceController.text.trim(),
        'discount': discountController.text.trim(),
        'productID': docId,
        'category': dropDownCategory,
        'offer': dropDownOffer,
        'type': dropDownType,
        'color': dropDownColor,
        'image': imageSource,
      };

      await FirebaseFirestore.instance.collection('products').doc(docId).set(data);

      Get.back(); // Close loading dialog
      Get.back(); // Return to previous screen
      Get.snackbar('Success', 'Product uploaded successfully');
    } catch (e) {
      Get.back(); // Close loading dialog
      Get.snackbar('Error', 'Failed to upload product: $e');
    }
  }

  Widget buildImagePreview() {
    if (file != null) {
      return Image.file(file!, height: 150, width: 150, fit: BoxFit.cover);
    } else if (imageUrlController.text.isNotEmpty) {
      return Image.network(
        imageUrlController.text,
        height: 150,
        width: 150,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Text('Invalid Image URL', style: TextStyle(color: Colors.red));
        },
      );
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Products', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: clearTextInput,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: brandController,
                    decoration: const InputDecoration(labelText: 'Store Name'),
                    validator: (value) => value?.isEmpty ?? true ? 'Store Name is required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: 'Product Name'),
                    validator: (value) => value?.isEmpty ?? true ? 'Product Name is required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: descController,
                    decoration: const InputDecoration(labelText: 'Description'),
                    validator: (value) => value?.isEmpty ?? true ? 'Description is required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: priceController,
                    decoration: const InputDecoration(labelText: 'Price'),
                    keyboardType: TextInputType.number,
                    validator: (value) => value?.isEmpty ?? true ? 'Price is required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: discountController,
                    decoration: const InputDecoration(labelText: 'Discount'),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),

                  // Image URL field
                  TextFormField(
                    controller: imageUrlController,
                    decoration: const InputDecoration(
                      labelText: 'Image URL',
                      hintText: 'Enter image URL or use camera/gallery below',
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        setState(() {
                          file = null; // Clear file when URL is entered
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),

                  // Image preview
                  buildImagePreview(),
                  const SizedBox(height: 16),

                  // Image picker buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => pickImage(ImageSource.camera),
                        icon: const Icon(Icons.camera_alt),
                        label: const Text('Camera'),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => pickImage(ImageSource.gallery),
                        icon: const Icon(Icons.photo_library),
                        label: const Text('Gallery'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Dropdowns
                  DropdownButtonFormField<String>(
                    value: dropDownCategory,
                    decoration: const InputDecoration(labelText: 'Category'),
                    items: ['Category', 'Men', 'Women', 'Kids', 'Men,Women', 'Men,Kids', 'Women,Kids']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) => setState(() => dropDownCategory = value!),
                  ),
                  const SizedBox(height: 16),
                  
                  DropdownButtonFormField<String>(
                    value: dropDownOffer,
                    decoration: const InputDecoration(labelText: 'Offer'),
                    items: ['Offer', 'Yes', 'No']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) => setState(() => dropDownOffer = value!),
                  ),
                  const SizedBox(height: 16),

                  DropdownButtonFormField<String>(
                    value: dropDownType,
                    decoration: const InputDecoration(labelText: 'Type'),
                    items: ['Type', 'Sports', 'Classic', 'Casual']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) => setState(() => dropDownType = value!),
                  ),
                  const SizedBox(height: 16),

                  DropdownButtonFormField<String>(
                    value: dropDownColor,
                    decoration: const InputDecoration(labelText: 'Color'),
                    items: ['Color', 'No Specific', 'Red', 'Black', 'Blue', 'White', 'Yellow']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) => setState(() => dropDownColor = value!),
                  ),
                  const SizedBox(height: 24),

                  // Upload button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => upload(context),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Upload Product', style: TextStyle(fontSize: 16)),
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
}