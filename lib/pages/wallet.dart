import 'dart:convert';
import 'dart:ui';
import 'package:flutter_application_1/service/database.dart';
import 'package:flutter_application_1/service/shared_pref.dart';
import 'package:flutter_application_1/widget/app_constant.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_application_1/widget/widget_support.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  String? wallet, id;
  int? add;
  TextEditingController amountcontroller = new TextEditingController();
  getthesharedpref() async {
    wallet = await SharedPreferenceHelper().getUserWallet();
    id = await SharedPreferenceHelper().getUserId();
    setState(() {});
  }

  ontheload() async {
    await getthesharedpref();
    setState(() {});
  }

  @override
  void initState() {
    ontheload();
    // TODO: implement initState
    super.initState();
  }

  Map<String, dynamic>? paymentIntent;
  String selectedAmount = '0';

  // Function to handle amount selection
  void handleAmountSelection(String amount) {
    setState(() {
      selectedAmount = amount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: wallet == null
            ? CircularProgressIndicator()
            : Container(
                margin: EdgeInsets.only(top: 40.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Material(
                      elevation: 2.0,
                      child: Container(
                        padding: EdgeInsets.only(bottom: 10.0),
                        child: Center(
                          child: Text(
                            "Wallet",
                            style: AppWidget.HeadLineTextFeildStyle(),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(color: Color(0xfff2f2f2)),
                      child: Row(
                        children: [
                          Image.asset(
                            "images/wallet.png",
                            height: 60,
                            width: 60,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(
                            width: 40.0,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Saldo Anda",
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w400),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                "\$" + wallet!,
                                style: AppWidget.boldTextFeildStyle(),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 200),
                      child: Text(
                        "Tambah Saldo",
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.w500),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () => handleAmountSelection('100'),
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: selectedAmount == '100'
                                        ? Color(0xFF008080)
                                        : Color(0xffe9e2e2)),
                                borderRadius: BorderRadius.circular(5)),
                            child: Text(
                              "\$100",
                              style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w600,
                                  color: selectedAmount == '100'
                                      ? Color(0xFF008080)
                                      : Colors.black),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => handleAmountSelection('500'),
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: selectedAmount == '500'
                                        ? Color(0xFF008080)
                                        : Color(0xffe9e2e2)),
                                borderRadius: BorderRadius.circular(5)),
                            child: Text(
                              "\$500",
                              style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w600,
                                  color: selectedAmount == '500'
                                      ? Color(0xFF008080)
                                      : Colors.black),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => handleAmountSelection('1000'),
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: selectedAmount == '1000'
                                        ? Color(0xFF008080)
                                        : Color(0xffe9e2e2)),
                                borderRadius: BorderRadius.circular(5)),
                            child: Text(
                              "\$1000",
                              style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w600,
                                  color: selectedAmount == '1000'
                                      ? Color(0xFF008080)
                                      : Colors.black),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            openEdit();
                          },
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: selectedAmount == 'Lainnya'
                                        ? Color(0xFF008080)
                                        : Color(0xffe9e2e2)),
                                borderRadius: BorderRadius.circular(5)),
                            child: Text(
                              "Lainnya...",
                              style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w500,
                                  color: selectedAmount == '2000'
                                      ? Color(0xFF008080)
                                      : Colors.black),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (selectedAmount != '0') {
                          makePayment(selectedAmount);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Please select an amount first'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 20.0),
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Color(0xFF008080),
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Center(
                          child: Text(
                            "Bayar",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 17.0,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }

  Future<void> makePayment(String amount) async {
    try {
      paymentIntent = await createPaymentIntent(amount, 'USD');
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: paymentIntent!['client_secret'],
                  style: ThemeMode.dark,
                  merchantDisplayName: 'User'))
          .then((value) {});
      displayPaymentSheet(amount);
    } catch (e, s) {
      print('exception: $e$s');
    }
  }

  displayPaymentSheet(String amount) async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) async {
        add = int.parse(wallet!) + int.parse(amount);
        await SharedPreferenceHelper().saveUserWallet(add.toString());
        await DatabaseMethod().UpdateUserWallet(id!, add.toString());
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          ),
                          SizedBox(width: 10),
                          Text("Payment Successfully!")
                        ],
                      )
                    ],
                  ),
                ));
        await getthesharedpref();
        paymentIntent = null;
        selectedAmount = '0';
        setState(() {});
      }).onError((error, stackTrace) {
        print('Error is:---> $error $stackTrace');
      });
    } on StripeException catch (e) {
      print('Error is:---> $e');
      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
                content: Text("Cancelled"),
              ));
    } catch (e) {
      print(e);
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card',
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $secretKey',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      print('Payment Intent Body->>> ${response.body.toString()}');
      return jsonDecode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
  }

  calculateAmount(String amount) {
    final calculatedAmount = (int.parse(amount) * 100);
    return calculatedAmount.toString();
  }

  Future openEdit() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            content: SingleChildScrollView(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.cancel)),
                        SizedBox(
                          width: 50.0,
                        ),
                        Center(
                          child: Text("Tambah Saldo",
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Color(0xFF008080),
                                fontWeight: FontWeight.bold,
                              )),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text("Top up:"),
                    SizedBox(height: 10.0),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black38, width: 2.0),
                          borderRadius: BorderRadius.circular(10)),
                      child: TextField(
                        controller: amountcontroller,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Masukkan jumlah'),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          makePayment(amountcontroller.text);
                        },
                        child: Container(
                          width: 100,
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Color(0xFF008080),
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                              child: Text(
                            "Bayar",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17.0,
                            ),
                          )),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ));
}
