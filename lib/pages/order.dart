import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/service/database.dart';
import 'package:flutter_application_1/service/shared_pref.dart';
import '../widget/widget_support.dart';

class Order extends StatefulWidget {
  const Order({super.key});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  String? id, wallet;
  int total = 0, amount2 = 0;
  Timer? _timer; // Timer untuk pembaruan otomatis

  // Fungsi untuk memulai timer
  void startTimer() {
    // Batalkan timer yang ada jika masih berjalan
    _timer?.cancel();

    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      amount2 = total;
      if (mounted) {
        setState(() {
          // Reset total sebelum perhitungan ulang
          ontheload(); // Muat ulang data
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Batalkan timer saat widget dihapus
    super.dispose();
  }

  // Ambil data dari SharedPreferences
  getthesharedpref() async {
    wallet = await SharedPreferenceHelper().getUserWallet();
    id = await SharedPreferenceHelper().getUserId();
    setState(() {});
  }

  // Fungsi untuk memuat ulang data dari food cart
  ontheload() async {
    await getthesharedpref();
    foodStream = await DatabaseMethod().getFoodCart(id!);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    ontheload();
    startTimer(); // Mulai timer saat widget dimuat
  }

  Stream? foodStream;

  // Fungsi untuk menghitung total setelah data dimuat
  int calculateTotal(QuerySnapshot snapshot) {
    int totalPrice = 0;
    snapshot.docs.forEach((doc) {
      totalPrice += int.parse(doc['Total']); // Menambahkan total harga
    });
    return totalPrice;
  }

  // Widget untuk menampilkan daftar makanan dari stream
  Widget foodCart() {
    return StreamBuilder(
      stream: foodStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (snapshot.hasData) {
          // Menghitung total hanya setelah data tersedia
          total = calculateTotal(snapshot.data);

          return ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: snapshot.data.docs.length,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              DocumentSnapshot ds = snapshot.data.docs[index];
              return Container(
                margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 15.0),
                child: Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Container(
                          height: 70.0,
                          width: 30,
                          decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(child: Text(ds["Quantity"])),
                        ),
                        SizedBox(width: 20.0),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(60),
                          child: Image.asset("images/salad2.png",
                              height: 80, width: 80, fit: BoxFit.cover),
                        ),
                        SizedBox(width: 20.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(ds["Name"],
                                style: AppWidget.boldTextFeildStyle()),
                            Text("\$" + ds["Total"],
                                style: AppWidget.boldTextFeildStyle()),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return Center(child: Text("No data available"));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Material(
              elevation: 2.0,
              child: Container(
                padding: EdgeInsets.only(bottom: 10.0),
                child: Center(
                  child: Text("Food Cart",
                      style: AppWidget.HeadLineTextFeildStyle()),
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              height: MediaQuery.of(context).size.height / 2,
              child: foodCart(),
            ),
            Spacer(),
            Divider(),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Total Price", style: AppWidget.boldTextFeildStyle()),
                  Text("\$" + total.toString(),
                      style: TextStyle(
                          fontSize: 21.0, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            SizedBox(height: 10.0),
            GestureDetector(
              onTap: () async {
                try {
                  int amount = int.parse(wallet!) - amount2;
                  await DatabaseMethod()
                      .UpdateUserWallet(id!, amount.toString());
                  await SharedPreferenceHelper()
                      .saveUserWallet(amount.toString());

                  // Tampilkan pesan sukses
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.white),
                          SizedBox(width: 10),
                          Text(
                            'Checkout berhasil! Lihat Saldo',
                            style: TextStyle(
                                fontSize: 15.0,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 3),
                      behavior: SnackBarBehavior.floating,
                      margin: EdgeInsets.all(15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                } catch (e) {
                  // Tampilkan pesan error jika terjadi kesalahan
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          Icon(Icons.error, color: Colors.white),
                          SizedBox(width: 10),
                          Text(
                            'Checkout Gagal!',
                            style: TextStyle(
                                fontSize: 17.0,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 3),
                      behavior: SnackBarBehavior.floating,
                      margin: EdgeInsets.all(15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10)),
                margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
                child: Center(
                    child: Text(
                  "Checkout",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
