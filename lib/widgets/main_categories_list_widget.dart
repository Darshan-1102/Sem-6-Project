import 'package:book_buddy_5_admin/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MainCategoryListWidget extends StatefulWidget {
  const MainCategoryListWidget({Key? key}) : super(key: key);

  @override
  State<MainCategoryListWidget> createState() => _MainCategoryListWidgetState();
}

class _MainCategoryListWidgetState extends State<MainCategoryListWidget> {
  final FirebaseService _service = FirebaseService();
  QuerySnapshot? snapshot;

  @override
  void initState() {
    getCatList();
    super.initState();
  }

  getCatList() {
    return _service.categories.get().then((QuerySnapshot querySnapshot) {
      setState(() {
        snapshot = querySnapshot;
      });
    });
  }

  Widget categoryWidget(data) {
    return Card(
      color: Colors.grey.shade400,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(child: Text(data['mainCategory'])),
      ),
    );
  }

  Object? _selectedValue;
  bool _noCategorySelected = false;

  Widget _dropDownButton() {
    return DropdownButton(
      value: _selectedValue,
      hint: const Text('Select Category'),
      items: snapshot!.docs.map((e) {
        return DropdownMenuItem<String>(
          value: e['catName'],
          child: Text(
            e['catName'],
          ),
        );
      }).toList(),
      onChanged: (selectedCat) {
        setState(() {
          _selectedValue = selectedCat;
          _noCategorySelected = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        snapshot == null
            ? const Text("Loading...")
            : Row(
                children: [
                  _dropDownButton(),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedValue = null;
                      });
                    },
                    child: const Text("Show All"),
                  )
                ],
              ),
        const SizedBox(
          height: 10,
        ),
        StreamBuilder<QuerySnapshot>(
          stream: _service.mainCat
              .where('category', isEqualTo: _selectedValue)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text("Something Went wrong");
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LinearProgressIndicator();
            }
            if (snapshot.data!.size == 0) {
              return const Text('No Main Categories added');
            }
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                crossAxisSpacing: 3,
                mainAxisSpacing: 3,
                childAspectRatio: 3,
              ),
              itemCount: snapshot.data!.size,
              itemBuilder: (context, index) {
                var data = snapshot.data!.docs[index];
                return categoryWidget(data);
              },
            );
          },
        ),
      ],
    );
  }
}

// ListView(
// shrinkWrap: true,
// children: snapshot.data!.docs.map((DocumentSnapshot document){
// Map<String, dynamic> data= document.data()! as Map<String, dynamic>;
// return ListTile(
// title: Text(data['catName']),
//
// );
// }).toList(),
// );
