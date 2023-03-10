import 'package:book_buddy_5_admin/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryListWidget extends StatefulWidget {
  final CollectionReference? reference;
  const CategoryListWidget({this.reference, Key? key}) : super(key: key);

  @override
  State<CategoryListWidget> createState() => _CategoryListWidgetState();
}

class _CategoryListWidgetState extends State<CategoryListWidget> {
  FirebaseService service = FirebaseService();
  QuerySnapshot? snapshot;
  Object? _selectedValue;

  @override
  void initState() {
    getMainCatList();
    super.initState();
  }

  getMainCatList() {
    return service.mainCat.get().then((QuerySnapshot querySnapshot) {
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
        });
      },
    );
  }

  Widget categoryWidget(data) {
    return Card(
      color: Colors.grey.shade400,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
                height: 60,
                width: 150,
                child: Image.network(
                  data['image'],
                  fit: BoxFit.fitWidth,
                )),
            Text(
              widget.reference == service.categories
                  ? data['catName']
                  : data['subCatName'],
              style: const TextStyle(
                  //wordSpacing: 0.5,
                  letterSpacing: 0.5),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
            if(widget.reference ==service.subCat && snapshot !=null)
            Row(
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
          const SizedBox(height: 10),
          StreamBuilder<QuerySnapshot>(
            stream: widget.reference!
                .where('mainCategory', isEqualTo: _selectedValue)
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
                return const Text('No categories added');
              }
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 6, crossAxisSpacing: 3, mainAxisSpacing: 3),
                itemCount: snapshot.data!.size,
                itemBuilder: (context, index) {
                  var data = snapshot.data!.docs[index];
                  return categoryWidget(data);
                },
              );
            },
          ),
        ],
      ),
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
