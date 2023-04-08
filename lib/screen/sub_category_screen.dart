import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mime_type/mime_type.dart';
import 'package:path/path.dart';

import '../firebase_service.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../widgets/categories_list_widget.dart';

class SubCategoryScreen extends StatefulWidget {

  static const String id = 'sub-category';
  const SubCategoryScreen({Key? key}) : super(key: key);

  @override
  State<SubCategoryScreen> createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends State<SubCategoryScreen> {
  final FirebaseService _service = FirebaseService();
  final TextEditingController _subCatName = TextEditingController();
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  dynamic image;
  String? fileName;
  final _formKey = GlobalKey<FormState>();
  QuerySnapshot? snapshot;
  Object? _selectedValue;
  bool _noCategorySelected = false;

  pickImage() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.image, allowMultiple: false);
    if (result != null) {
      setState(() {
        image = result.files.first.bytes;
        fileName = result.files.first.name;
      });
    } else {
      print('Cancelled file picking');
    }
  }

  @override
  void initState() {
    getMainCatList();
    super.initState();
  }

  getMainCatList() {
    return _service.mainCat.get().then((QuerySnapshot querySnapshot) {
      setState(() {
        snapshot = querySnapshot;
      });
    });
  }

  Widget _dropDownButton() {
    return DropdownButton(
      value: _selectedValue,
      hint: const Text('Select Main Category'),
      items: snapshot!.docs.map((e) {
        return DropdownMenuItem<String>(
          value: e['mainCategory'],
          child: Text(
            e['mainCategory'],
          ),
        );
      }).toList(),
      onChanged: (selectedCat) {
        setState(() {
          _selectedValue = selectedCat;
          _noCategorySelected=false;
        });
      },
    );
  }

  saveImageToDb() async {
    EasyLoading.show();
    var ref = storage.ref('subCategoryImage/$fileName');

    try {
      String? mimiType = mime(basename(fileName!));
      var metaData = firebase_storage.SettableMetadata(contentType: mimiType);
      firebase_storage.TaskSnapshot uploadSnapshot =
          await ref.putData(image, metaData);
      String downloadUrl = await ref.getDownloadURL().then((value) {
        if (value.isNotEmpty) {
          _service.saveCategory(
            data: {
              'subCatName': _subCatName.text,
              'mainCategory': _selectedValue,
              'image': value,
              'active': true,
            },
            docName: _subCatName.text,
            reference: _service.subCat,
          ).then((value) {
            clear();
            EasyLoading.dismiss();
          });
        }
        return value;
      });
    } on FirebaseException catch (e) {
      clear();
      EasyLoading.dismiss();
      print(e.toString());
    }
  }

  clear() {
    setState(() {
      _subCatName.clear();
      image = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(8),
            child: const Text(
              'Sub Category Screen',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 36,
              ),
            ),
          ),
          const Divider(color: Colors.grey),
          Row(
            children: [
              const SizedBox(width: 10),
              Column(
                children: [
                  Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.grey.shade800),
                    ),
                    child: Center(
                      child: image == null
                          ? const Text('Sub Category Image')
                          : Image.memory(image),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: pickImage,
                    child: const Text('Upload Image'),
                  )
                ],
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  snapshot == null ? const Text("Loading...") : _dropDownButton(),
                  const SizedBox(
                    height: 8,
                  ),
                  if (_noCategorySelected == true)
                    const Text(
                      'No Main Category Selected',
                      style: TextStyle(color: Colors.red),
                    ),
                  SizedBox(
                    width: 200,
                    child: TextFormField(
                      controller: _subCatName,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter Sub Category Name';
                        }
                      },
                      decoration: const InputDecoration(
                          label: Text('Enter Sub Category Name'),
                          contentPadding: EdgeInsets.zero),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: clear,
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.white),
                          side: MaterialStateProperty.all(
                            BorderSide(color: Theme.of(context).primaryColor),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      if(image!=null)
                      ElevatedButton(
                        onPressed: () {
                          if (_selectedValue == null) {
                            setState(() {
                              _noCategorySelected = true;
                            });
                            return;
                          }
                          if (_formKey.currentState!.validate()) {
                            saveImageToDb();
                          }
                        },
                        child: const Text(
                          '   Save   ',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
          const Divider(color: Colors.grey),
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(10),
            child: const Text(
              'Sub Category List',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
            ),
          ),
          const SizedBox(height: 5),
          CategoryListWidget(
            reference: _service.subCat,
          ),
        ],
      ),
    );
  }
}

// EasyLoading.show();
// _service.saveCategory(
// data: {
// 'category': _selectedValue,
// 'mainCategory': _subCatName.text,
// 'approved': true,
// },
// reference: _service.mainCat,
// docName: _subCatName.text,
// ).then((value) {
// clear();
// EasyLoading.dismiss();
// });
