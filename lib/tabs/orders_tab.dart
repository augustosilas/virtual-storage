import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:virtual_store/models/user_model.dart';
import 'package:virtual_store/screens/login_screen.dart';
import 'package:virtual_store/tiles/order_tile.dart';

class OrdersTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (UserModel.of(context).isLoggedIn()) {
      String uid = UserModel.of(context).firebaseUser.user.uid;

      return FutureBuilder<QuerySnapshot>(
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView(
              children: snapshot.data.docs.map((doc) => OrderTile(doc.id)).toList()
                .reversed.toList(),
            );
          }
        },
        future: FirebaseFirestore.instance
            .collection("users")
            .doc(uid)
            .collection("orders")
            .get(),
      );
    } else {
      return Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.view_list,
              size: 80.0,
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(height: 16.0),
            Text(
              "Faça o login para acompanhar",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.0),
            RaisedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: Text(
                "Entrar",
                style: TextStyle(fontSize: 18.0),
              ),
              textColor: Colors.white,
              color: Theme.of(context).primaryColor,
            )
          ],
        ),
      );
    }

    return Container();
  }
}
