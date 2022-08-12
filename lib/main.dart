import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(const InitializeApp());
}

class InitializeApp extends StatelessWidget {
  const InitializeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const ErrorFirebase();
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return MyApp();
          }
          return const Loading();
        });
  }
}

class MyApp extends StatelessWidget {
  final databaseReference = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(),
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.amber,
          title: const Text('Flutter with FireBAse'),
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [FormSection(), Expanded(child: ListSection())],
          ),
        ),
      ),
    );
  }

  void addDataTofireBase() {
    try {
      databaseReference
          .collection('Items')
          .add({'text': 'Faire des exercices de respiratin'}).then(
              (value) => print(value.id));
    } catch (error) {
      print('ceci est une erreur dela collection ${error.toString()}');
    }
  }
}

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Loading Page'),
        ),
        body: Column(
          children: [
            Container(
              height: 20,
              color: Colors.white,
              child: const Text('En Cours De chargement!'),
            ),
          ],
        ),
      ),
    );
  }
}

class ErrorFirebase extends StatelessWidget {
  const ErrorFirebase({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Error Page'),
        ),
        body: Column(
          children: [
            Container(
              height: 20,
              color: Colors.white,
              child: const Text('Erreur De chargement!'),
            ),
          ],
        ),
      ),
    );
  }
}

class ListSection extends StatelessWidget {
  final databaseReference = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: databaseReference.collection('Items').snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<QuerySnapshot?> snapshot) {
          return ListView(
            children: snapshot.data!.docs.map((document) {
              return ListTile(title: Text(document['text']));
            }).toList(),
          );
        });
  }
}

class FormSection extends StatelessWidget {
  final databaseReference = FirebaseFirestore.instance;
  final myControler = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: myControler,
            ),
          ),
        ),
        Container(
          width: 45,
          height: 45,
          color: Colors.orange,
          child: IconButton(
              onPressed: () {
                addItem();
              },
              icon: Icon(Icons.add)),
        ),
      ],
    );
  }

  void addItem() {
    try {
      databaseReference
          .collection('Items')
          .add({'text': myControler.text}).then((value) {
        print(value.id);
        myControler.clear();
      });
    } catch (error) {
      print('ceci est une erreur dela collection ${error.toString()}');
    }
  }
}
