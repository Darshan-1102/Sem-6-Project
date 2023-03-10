import 'package:book_buddy_5_admin/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryListWidget extends StatelessWidget {
  const CategoryListWidget({Key? key}) : super(key: key);

  Widget categoryWidget(data) {
    return Card(
      color: Colors.grey.shade400,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 80,
                width: 100,
                child: Image.network(data['image'],fit: BoxFit.fitWidth,)),
            Text(data['catName'])
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    FirebaseService service = FirebaseService();
    return StreamBuilder<QuerySnapshot>(
      stream: service.categories.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
