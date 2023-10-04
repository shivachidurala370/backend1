//import 'dart:html';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UpdateProduct extends StatefulWidget {
  const UpdateProduct({super.key});

  @override
  State<UpdateProduct> createState() => _UpdateproductState();
}

class _UpdateproductState extends State<UpdateProduct> {
  final TextEditingController _productidcontroller = TextEditingController();
  final TextEditingController _productnamecontroller = TextEditingController();
  final TextEditingController _descriptioncontroller = TextEditingController();

  void updateProduct() async {
    String productid = _productidcontroller.text.trim();
    String productname = _productnamecontroller.text.trim();
    String description = _descriptioncontroller.text.trim();

    final formdata = FormData.fromMap({
      "product_id": productid,
      "product_name": productname,
      "description": description,
      "image": await MultipartFile.fromFile(image!.path)
    });

    try {
      Response response = await Dio().patch(
          "http://jayanthi10.pythonanywhere.com/api/v1/update_product/",
          data: formdata);
      print(response.data);

      if (response.statusCode == 200) {
        Navigator.pop(context);
      }
    } catch (e) {
      print("============>Error");
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
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              TextField(
                controller: _productidcontroller,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: "Product id"),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: _productnamecontroller,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: "Product name"),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: _descriptioncontroller,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: "description"),
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
                  : SizedBox(
                      height: 20,
                    ),
              TextButton(
                  onPressed: () {
                    updateProduct();
                  },
                  child: Text("Update Product"))
            ],
          ),
        ),
      ),
    );
  }
}
