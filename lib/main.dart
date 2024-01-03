import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //razorpay object
  Razorpay? _razorpay;
  TextEditingController amountController = TextEditingController();

  
  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
    Fluttertoast.showToast(msg: "Success : ${response.paymentId}" , timeInSecForIosWeb: 4);

  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    Fluttertoast.showToast(msg: "Error : ${response.code} - ${response.message}" , timeInSecForIosWeb: 4);

  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
    Fluttertoast.showToast(msg: "External Wallet : ${response.walletName}" , timeInSecForIosWeb: 4);

  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _razorpay = Razorpay();
  
    _razorpay?.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay?.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay?.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }


  void makePayment() async {
    var options = {
      'key' : 'rzp_test_BQfWCSPjfpPmye',
      'amount' : 200000, //rs 200
      'name' : 'Shreyansh',
      'description' : 'test payment',
      'prefill' : {'contact' : '9494XXXXXX', 'email' : 'test@gmail.com',},
    };

    try {
       _razorpay?.open(options);
    } catch (e) {
      print("Error in razorpay :  $e"); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Text(
                "Razorpay Integration",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: amountController,
                decoration: InputDecoration(
                    hintText: "Enter amount",
                    icon: Icon(Icons.monetization_on)),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            TextButton(onPressed: () {
              makePayment();
            }, child: Text("Start Payment"))
          ],
        ),
      ),
    );
  }

}
