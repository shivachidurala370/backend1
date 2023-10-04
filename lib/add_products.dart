import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'models/products_model.dart';

class AddProducts extends StatefulWidget {
  const AddProducts({super.key});

  @override
  State<AddProducts> createState() => _AddProductsState();
}

class _AddProductsState extends State<AddProducts> {
  final TextEditingController _productnamecontroller = TextEditingController();
  final TextEditingController _descriptopncontroller = TextEditingController();

  //ProductsModel? products;
  void addProducts() async {
    String productName = _productnamecontroller.text.trim();
    String description = _descriptopncontroller.text.trim();

    final formdata = FormData.fromMap({
      "product_name": productName,
      "description": description,
      "image": await MultipartFile.fromFile(image!.path),
    });

    try {
      Response response = await Dio().post(
          "http://jayanthi10.pythonanywhere.com/api/v1/add_products/",
          data: formdata);
      print(response.data);

      if (response.statusCode == 200) {
        Navigator.pop(context);
      }

      print("===========>${response.statusMessage}");

      //products = productsModelFromJson(jsonEncode(response.data));
    } catch (e) {
      print(e);
      print("===========>error}");
    }
  }

  File? image;
  void pickImage(ImageSource source) async {
    try {
      final pickerFile = await ImagePicker().pickImage(source: source);
      setState(() {
        image = File(pickerFile!.path);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _productnamecontroller,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Enter Product name"),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: _descriptopncontroller,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: "Description"),
            ),
            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () => pickImage(ImageSource.gallery),
              child: Container(
                alignment: Alignment.center,
                height: 40,
                width: 140,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "Select a image",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            image != null
                ? SizedBox(
                    height: 120,
                    width: 120,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: Image.file(
                          image!,
                          fit: BoxFit.cover,
                        )),
                  )
                :
                // Container(
                //   decoration: BoxDecoration(
                //     shape: BoxShape.circle,
                //     color: Colors.red,
                //     image: DecorationImage(
                //       image: NetworkImage(''),
                //       fit: BoxFit.cover, // optional
                //     ),
                //   ),
                //   height: 120,
                //   width: 150,
                // ),
                SizedBox(
                    height: 20,
                  ),
            TextButton(
                onPressed: () {
                  addProducts();
                },
                child: Text("Add Product")),
          ],
        ),
      ),
    ));
  }
}
