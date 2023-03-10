import 'package:book_buddy_5_admin/firebase_service.dart';
import 'package:book_buddy_5_admin/widgets/categories_list_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class CategoryScreen extends StatefulWidget {
  static const String id = 'category';
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final FirebaseService _service = FirebaseService();
  final TextEditingController _catName = TextEditingController();
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  dynamic image;
  String? fileName;
  final _formKey = GlobalKey<FormState>();

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

  saveImageToDb() async {
    EasyLoading.show();
    var ref = storage.ref('categoryImage/$fileName)');

    try {
      await ref.putData(image);
      String downloadUrl = await ref.getDownloadURL().then((value) {
        if (value.isNotEmpty) {
          _service.saveCategory(
            data: {
              'catName': _catName.text,
              'image': value,
              'active': true,
            },
            docName: _catName.text,
            reference: _service.categories,
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
      _catName.clear();
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
            padding: const EdgeInsets.all(10),
            child: const Text(
              'Category Screen',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 26,
              ),
            ),
          ),
          const Divider(
            color: Colors.grey,
          ),
          Row(
            children: [
              const SizedBox(width: 20),
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
                          ? const Text('Category Image')
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
              const SizedBox(
                width: 20,
              ),
              SizedBox(
                width: 200,
                child: TextFormField(
                  controller: _catName,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter Category Name';
                    }
                  },
                  decoration: const InputDecoration(
                      label: Text('Enter Category Name'),
                      contentPadding: EdgeInsets.zero),
                ),
              ),
              const SizedBox(width: 10),
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
              image == null
                  ? Container()
                  : ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          saveImageToDb();
                        }
                      },
                      child: const Text(
                        'Save',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
            ],
          ),
          const Divider(
            color: Colors.grey,
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(10),
            child: const Text(
              'Category List',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
            ),
          ),
          const SizedBox(height: 10),
          CategoryListWidget(
            reference: _service.categories,
          )
        ],
      ),
    );
  }
}
