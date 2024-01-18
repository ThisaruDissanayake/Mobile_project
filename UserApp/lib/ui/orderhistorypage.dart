import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OrderHistoryPage extends StatefulWidget {
  @override
  _OrderHistoryPageState createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  late User? _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;
  }

  Future<List<Map<String, dynamic>>> _fetchOrderHistory() async {
    List<Map<String, dynamic>> orderHistory = [];

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("costomer_oders")
          .doc(_currentUser!.email)
          .collection("Finalcoutmeroders")
          .get();

      orderHistory = querySnapshot.docs.map((doc) {
        Map<String, dynamic> orderData = doc.data() as Map<String, dynamic>;

        // Assuming 'cartItems' is a field within each document
        List<Map<String, dynamic>> cartItems = (orderData['cartItems'] as List<dynamic>)
            .map((item) => item as Map<String, dynamic>)
            .toList();

        orderData['cartItems'] = cartItems;

        return orderData;
      }).toList();
    } catch (error) {
      print("Error fetching order history: $error");
    }

    return orderHistory;
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order History"),
      ),
      body:  Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/back.png"),
          fit: BoxFit.cover,
        ),
      ),
      
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchOrderHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            List<Map<String, dynamic>> orderHistory = snapshot.data ?? [];

            if (orderHistory.isEmpty) {
              return Center(child: Text("No order history available."));
            }

            return ListView.builder(
              itemCount: orderHistory.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> orderData = orderHistory[index];

                // Retrieve cartItems from orderData
                List<Map<String, dynamic>> cartItems = (orderData['cartItems'] as List<dynamic>)
                    .map((item) => item as Map<String, dynamic>)
                    .toList();

                // Customize the order history item UI according to your needs
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Text("Order ${index + 1}"),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Customer Name: ${orderData['customername']}"),
                              Text("Receiver's Phone: ${orderData['receiversphone']}"),
                              Text("Order Date: ${orderData['orderdate']}"),
                              Text("Delivery Method: ${orderData['delivermethod']}"),
                              Text("Address: ${orderData['address']}"),
                              // Add more details as needed
                            ],
                          ),
                          
                      
                    
                        ),
                        // Display cartItems details
                        for (var item in cartItems)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                title: Text("Item: ${item['name']}"),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Price: ${item['price']}"),
                                    // Display the image from the URL
                                    Image.network(
                                      item['url'],
                                      height: 100, // Adjust the height as needed
                                    ),
                                    // Add more details as needed
                                  ],
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      ),
    );
  }
}
