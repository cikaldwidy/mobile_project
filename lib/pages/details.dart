import 'package:flutter/material.dart';
import 'package:flutter_application_1/widget/widget_support.dart';

class Details extends StatefulWidget {
  const Details({super.key});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  int a = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(Icons.arrow_back_ios_new_outlined, color: Colors.black),
              ),
              Image.asset(
                "images/salad2.png",
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2.0,
                fit: BoxFit.fill,
              ),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Mediterran",
                        style: AppWidget.semiBooldTextFeildStyle(),
                      ),
                      Text(
                        "Chickpea Salad",
                        style: AppWidget.boldTextFeildStyle(),
                      ),
                    ],
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      if (a > 1) {
                        setState(() {
                          a--;
                        });
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.remove,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20.0),
                  Text(
                    a.toString(),
                    style: AppWidget.boldTextFeildStyle(),
                  ),
                  const SizedBox(width: 20.0),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        a++;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              Text(
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laboru",
                maxLines: 3,
                style: AppWidget.LightTextFeildStyle(),
              ),
              const SizedBox(height: 30.0),
              Row(
                children: [
                  Text(
                    "Delivery Time",
                    style: AppWidget.semiBooldTextFeildStyle(),
                  ),
                  const SizedBox(width: 25.0),
                  const Icon(Icons.alarm, color: Colors.black54),
                  const SizedBox(width: 5.0),
                  Text(
                    "30 min",
                    style: AppWidget.semiBooldTextFeildStyle(),
                  ),
                ],
              ),
              const SizedBox(height: 30.0), // Spacer replaced with SizedBox
              Padding(
                padding: const EdgeInsets.only(bottom: 40.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Total Price",
                          style: AppWidget.semiBooldTextFeildStyle(),
                        ),
                        Text(
                          "\$${28 * a}",
                          style: AppWidget.boldTextFeildStyle(),
                        ),
                      ],
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 2,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text(
                            "Add to cart",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          const SizedBox(width: 30.0),
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.shopping_cart_outlined,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 10.0),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
