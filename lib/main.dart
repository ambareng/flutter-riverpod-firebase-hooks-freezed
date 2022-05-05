import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    const ProviderScope(
      child: MyApp()
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FloatingActionButton(
                onPressed: () {
                  FirebaseFirestore.instance
                    .collection('test')
                    .add({
                      'timestamp': Timestamp.fromDate(DateTime.now())
                    });
                },
                child: const Icon(Icons.cloud_queue_sharp),
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance.collection('test').snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return const SizedBox.shrink();
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (context, index) {
                      final docData = snapshot.data!.docs[index];
                      final dateTime = (docData['timestamp'] as Timestamp).toDate();
                      return ListTile(
                        title: Text(dateTime.toString()),
                      );
                    }
                  );
                }
              )
            ],
          )
        ),
      ),
    );
  }
}
