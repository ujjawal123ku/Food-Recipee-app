import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:food_recipe/RecipeModel.dart';
import 'package:food_recipe/Search.dart';
import 'package:food_recipe/details.dart';
import 'package:food_recipe/fetchdata.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isLoading = false;
  List<RecipeModel> reclist = [];

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchdata();
  }

  Future<void> fetchdata() async {
    setState(() {
      isLoading = true;
    });

    try {
      reclist = await DataFetcher.fetchData('ladoo');
    } catch (e) {
      print('Error fetching data: $e');
    }

    setState(() {
      isLoading = false;
    });

    print("recipe length ${reclist.length}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff213A50), Color(0xff071938)],
          ),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 10, right: 10),
                    child: GestureDetector(
                      onTap: () {
                        if ((searchController.text).replaceAll(" ", "") == "") {
                          print("Blank search");
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Search(searchController.text),
                            ),
                          );
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.search, color: Colors.black54),
                            SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: searchController,
                                decoration: InputDecoration(
                                  hintText: 'Search products',
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    "Find The Right Place!",
                    style: TextStyle(fontSize: 35, fontWeight: FontWeight.w300, color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Let's Cook Something New!",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: SingleChildScrollView(
                      child: isLoading
                          ? Center(child: CircularProgressIndicator())
                          : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(

                            child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: reclist.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {},
                                  child: Card(
                                    margin: EdgeInsets.only(left: 10,right: 10,top: 20),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    elevation: 1.0,
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          child: Image.network(
                                            reclist[index].appimgUrl,
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: 200,
                                          ),
                                        ),
                                        Positioned(
                                          left: 0,
                                          right: 0,
                                          bottom: 0,
                                          child: Container(
                                            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                            decoration: BoxDecoration(color: Colors.black26),
                                            child: Text(
                                              reclist[index].applabel,
                                              style: TextStyle(color: Colors.white, fontSize: 20),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
