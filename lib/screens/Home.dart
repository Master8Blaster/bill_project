import 'package:bill_project/screens/add_product/AddProduct.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bill Project"),
        actions: [
          IconButton.filledTonal(
            onPressed: () {
              Get.to(AddProduct());
            },
            icon: const Icon(Icons.add_rounded),
          )
        ],
      ),
      body: SizedBox(
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
