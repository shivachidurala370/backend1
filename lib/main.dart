import 'dart:convert';

import 'package:backend1/add_products.dart';
import 'package:backend1/delete_products.dart';
import 'package:backend1/update_products.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'models/category_model.dart';
import 'models/products_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  CategoryModel? category;

  void getCategoryData() async {
    try {
      Response response = await Dio()
          .get("http://jayanthi10.pythonanywhere.com/api/v1/list_category/");
      //print(response.data);

      category = categoryModelFromJson(jsonEncode(response.data));
    } catch (e) {
      print(e);
    }
  }

  ProductsModel? products;

  void getProductsData() async {
    try {
      Response response = await Dio()
          .get("http://jayanthi10.pythonanywhere.com/api/v1/list_products/");
      //print(response.data);

      products = productsModelFromJson(jsonEncode(response.data));
    } catch (e) {
      print(e);
    }
  }

  final TextEditingController _usernamecontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();

  void login() async {
    String username = _usernamecontroller.text.trim();
    String password = _passwordcontroller.text.trim();

    final formdata = FormData.fromMap({
      "username": username,
      "password": password,
    });

    try {
      Response response = await Dio().post(
          "http://jayanthi10.pythonanywhere.com/api/v1/login/",
          data: formdata);
      print(response.data);

      //products = productsModelFromJson(jsonEncode(response.data));
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getCategoryData();
    getProductsData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _usernamecontroller,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: "Enter Username"),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                obscureText: true,
                controller: _passwordcontroller,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: "Enter Password"),
              ),
              TextButton(
                  onPressed: () {
                    login();
                  },
                  child: Text("Login")),
              TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AddProducts()));
                  },
                  child: Text("Add Product")),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UpdateProduct()));
                  },
                  child: Text("Update Product")),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DeleteProduct()));
                  },
                  child: Text("Delete Product"))

              // category == null
              //     ? CircularProgressIndicator()
              //     : Text("${category!.name}"),
              // SizedBox(
              //   height: 40,
              // ),
              // products == null
              //     ? const CircularProgressIndicator()
              //     : SizedBox(
              //         height: 300,
              //         child: ListView.builder(
              //             itemCount: products!.data!.length,
              //             itemBuilder: (context, index) {
              //               return Text("${products!.data![index].productName}");
              //             }),
              //       )
            ],
          ),
        ),
      ),
    );
  }
}
