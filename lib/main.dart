// ignore_for_file: deprecated_member_use

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:hover_ussd/hover_ussd.dart';
import 'package:nitusue_payment/error.dart';
import 'package:nitusue_payment/fail.dart';
import 'package:nitusue_payment/success.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:sms/sms.dart';

late SmsReceiver receiver;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  HoverUssd.initialize();
  receiver = SmsReceiver();
  runApp(const MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //loader
  bool loading = false;

  void listen() {
    receiver.onSmsReceived.listen((SmsMessage msg) => myfuction(msg));
  }

  void myfuction(SmsMessage msg) {
    var string = msg.body;
    bool fail = string.contains('Transaction');
    bool success = string.contains('Umetuma');

    log("faile $fail fail");
    log("my#: " + msg.body);
    if (fail) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const FailScreen()),
      );
    }else if(success){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SuccessScreen()),
      );
    }else{
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ErrorScreen()),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    listen();
  }

  @override
  Widget build(BuildContext context) {
    final HoverUssd _hoverUssd = HoverUssd();
    return MaterialApp(
      home: loading
          ? const Center(child: CircularProgressIndicator())
          : Scaffold(
              appBar: AppBar(
                title: const Text('Plugin example app'),
              ),
              body: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        FlatButton(
                          onPressed: () {
                            _hoverUssd.sendUssd(
                              actionId: "aff94e8b",
                              extras: {
                                "phone": "0655621253",
                                "amount": "100",
                              },
                            );
                          },
                          child: const Text("Start Trasaction"),
                        ),
                        StreamBuilder(
                          stream: _hoverUssd.getUssdTransactionState,
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            log("data# $snapshot");
                            if (snapshot.data == TransactionState.succesfull) {
                              return const Text("succesfull");
                            } else if (snapshot.data ==
                                TransactionState.actionDowaloadFailed) {
                              return const Text("action download failed");
                            } else if (snapshot.data ==
                                TransactionState.failed) {
                              log("data2# $snapshot");
                              return const Text("failed :");
                            }

                            return const Text("no transaction");
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
