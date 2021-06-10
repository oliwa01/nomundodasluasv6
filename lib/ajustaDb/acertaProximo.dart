import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AcertaProximo extends StatefulWidget {
  const AcertaProximo({Key? key}) : super(key: key);

  @override
  _AcertaProximoState createState() => _AcertaProximoState();
}

class _AcertaProximoState extends State<AcertaProximo> {
  Future leProximo() async {
    CollectionReference luas =
        FirebaseFirestore.instance.collection('DiarioLuas');
    //
    luas
        .where('ProximoDb', isNotEqualTo: ['I', 'D'])
        .get()
        .then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((docu) {
            print(docu.id);
            luas.doc(docu.id).set({'ProximoDb': 'D'});
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          child: Column(
            children: [
              Expanded(
                  child: TextButton(
                onPressed: () {
                  leProximo();
                },
                child: Text("NOSQL"),
              )),
              Expanded(
                  child: Container(
                color: Colors.green,
              ))
            ],
          ),
        ),
      ),
    );
  }
}
