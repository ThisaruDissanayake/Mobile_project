import 'package:appecommerce/const/AppColors.dart';
import 'package:appecommerce/widgets/fetchProducts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Cart extends StatefulWidget {
  List<Map<String, dynamic>>? cartItems;

  Cart({this.cartItems, Key? key}) : super(key: key);

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  Future<void> addToOrder() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;

    if (currentUser == null) {
      // Handle the case where the user is not authenticated
      print("Error: User not authenticated");
      return;
    }

    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection("Orders");

    // Check if cartItems is not null before proceeding
    if (widget.cartItems == null || widget.cartItems!.isEmpty) {
      // Handle the case where there are no items in the cart
      print("Error: Cart is empty");
      return;
    }

    // Loop through the cart items and add them to the Orders collection
    for (var item in widget.cartItems!) {
      try {
        await _collectionRef
            .doc(currentUser.email)
            .collection("orderItems")
            .add({
              "name": item["name"],
              "price": item["price"],
              "url": item["url"],
            });
        print("Added item to order");
      } catch (error) {
        print("Failed to add item: $error");
        // Handle the error as needed
      }
    }
  }

  Future<List<Object?>> fetchCartItems() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;

    if (currentUser == null) {
      // Handle the case where the user is not authenticated
      print("Error: User not authenticated");
      return [];
    }

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("users-cart-items")
          .doc(currentUser.email)
          .collection("items")
          .get();

      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (error) {
      print("Error fetching cart items: $error");
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    // Fetch cart items when the widget is initialized
    fetchCartItems().then((items) {
      setState(() {
        widget.cartItems = items.cast<Map<String, dynamic>>();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: fetchData("users-cart-items"),
            ),
            SizedBox(
              width: 1.sw,
              height: 56.h,
              child: ElevatedButton(
                onPressed: () => addToOrder(),
                child: Text(
                  "Add to Order",
                  style: TextStyle(color: Colors.white, fontSize: 18.sp),
                ),
                style: ElevatedButton.styleFrom(
                  primary: AppColors.deep_orange,
                  elevation: 3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
