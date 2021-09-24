import 'package:catmapp/src/widgets/containers.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../widgets/text_field.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: [
          buildHeader(),
          const TextDivider(text: 'Insert your Account'),
          const MyTextField(
            margin: EdgeInsets.symmetric(vertical: 7, horizontal: 13),
            hintText: 'Email Address',
            prefixIcon: Icon(
              Icons.email_outlined,
              size: 20,
              color: Colors.black45,
            ),
          ),
          const MyTextField(
            hiddenText: true,
            hintText: 'Password',
            margin: EdgeInsets.symmetric(vertical: 7, horizontal: 13),
            prefixIcon: Icon(
              Icons.lock_outline,
              size: 20,
              color: Colors.black45,
            ),
          ),
          // social networks
          socialNetworks(),
        ],
      ),
    );
  }

  Widget socialNetworks() {
    List<Widget> children = [const TextDivider()];
    children.addAll(['google', 'facebook', 'twitter'].map((social) {
      double? socialWidth = social == 'facebook' ? 15 : 20;
      return SizedBox(
        width: Get.width * .7,
        child: OutlinedButton.icon(
          icon: SizedBox(
            child: Image.asset(
              'assets/icons/$social.png',
              fit: BoxFit.fill,
              width: 20,
            ),
            width: socialWidth,
          ),
          label: Text(
            'Sign in with ${social.capitalize}',
            textAlign: TextAlign.center,
          ),
          style: const ButtonStyle(alignment: Alignment.centerLeft),
          onPressed: () {},
        ),
      );
    }));

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children,
    );
  }

  Widget buildHeader() {
    return Container(
      height: Get.size.height / 3,
      alignment: Alignment.center,
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: Image.asset('assets/kitty.png', fit: BoxFit.cover),
            width: Get.width * .25,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(5),
            child: Text.rich(
              TextSpan(
                text: 'Login to ',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                    text: 'catMapp',
                    style: TextStyle(
                      fontSize: 23,
                      color: Color(0xffEB008B),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
