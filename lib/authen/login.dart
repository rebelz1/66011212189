import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:teste_mulator/authen/register.dart';
import 'package:teste_mulator/config/config.dart';
import 'package:teste_mulator/model/req/post_login_req.dart';
import 'package:teste_mulator/model/res/post_login_res.dart';
import 'package:teste_mulator/pages/trip.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => LloginPageState();
}

class LloginPageState extends State<LoginPage> {
  String url = '';

  TextEditingController phoneNoCtl = TextEditingController();
  TextEditingController passwordCtl = TextEditingController();

  @override
  void initState() {
    super.initState();
    Configuration.getConfig().then((config) {
      url = config['apiEndpoint'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login Page"),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset('assets/images/logo.png'),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [Text("หมายเลขโทรศัพท์")],
                ),
              ),
              TextField(
                keyboardType: TextInputType.phone,
                controller: phoneNoCtl,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderSide: BorderSide(width: 1)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [Text("รหัสผ่าน")],
                ),
              ),
              TextField(
                keyboardType: TextInputType.visiblePassword,
                controller: passwordCtl,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderSide: BorderSide(width: 1)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Registerpage(),
                          ),
                        );
                      },
                      child: Text("ลงทะเบียนใหม่"),
                    ),
                    FilledButton(onPressed: login, child: Text("เข้าสู่ระบบ")),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  login() async {
    CustomerLoginPostRequest req = CustomerLoginPostRequest(
      phone: phoneNoCtl.text,
      password: passwordCtl.text,
    );
    var res = await http.post(
      Uri.parse('$url/customers/login'),
      headers: {"Content-Type": "application/json; charset=utf-8"},
      body: customerLoginPostRequestToJson(req),
    );
    CustomerLoginPostResponse customerLoginPostResponse =
        customerLoginPostResponseFromJson(res.body);
    log(customerLoginPostResponse.customer.fullname);
    log(customerLoginPostResponse.customer.email);
    log(customerLoginPostResponse.customer.idx.toString());
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TripsPages(cid: customerLoginPostResponse.customer.idx)),
    );
  }
}
