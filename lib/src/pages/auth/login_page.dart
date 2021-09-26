import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:catmapp/src/globals.dart';
import 'package:catmapp/src/config.dart' show Routes;

Map<String, Future<bool> Function(dynamic)?> _trySignIn = {
  'email': (user) async => false,
  'google': (_) async => await Auth.instance.tryGoogle(),
  'twitter': (_) async => false,
  'facebook': (_) async => false,
};

class LoginPage extends StatelessWidget {
  final _user = User();
  final _formKey = GlobalKey<FormState>();

  LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              buildHeader(),
              const TextDivider(text: 'Insert your Account'),
              MyTextField(
                margin: const EdgeInsets.symmetric(vertical: 7, horizontal: 20),
                hintText: 'Email Address',
                prefixIcon: const Icon(
                  Icons.email_outlined,
                  size: 20,
                  color: Colors.black45,
                ),
                onClear: () => _user.email = '',
                onChanged: (email) => _user.email = email,
              ),
              MyTextField(
                hiddenText: true,
                hintText: 'Password',
                margin: const EdgeInsets.symmetric(vertical: 7, horizontal: 20),
                prefixIcon: const Icon(
                  Icons.lock_outline,
                  size: 20,
                  color: Colors.black45,
                ),
                onClear: () => _user.password = '',
                onChanged: (pwd) => _user.password = pwd,
              ),
              signInButton(),
              const TextDivider(),
              socialNetworks(),
            ],
          ),
        ),
      ),
    );
  }

  Widget signInButton() {
    return OutlinedButton.icon(
      icon: const Icon(Icons.send),
      label: const Text('Sign In'),
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();
          final isAuth = await _trySignIn['email']!.call(_user);

          if (isAuth) {
            await Get.toNamed(Routes.home);
          }
        }
      },
    );
  }

  Widget socialNetworks() {
    List<Widget> children = [];
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
            'Sign In with ${social.capitalize}',
            textAlign: TextAlign.center,
          ),
          style: const ButtonStyle(alignment: Alignment.centerLeft),
          onPressed: () async {
            final isAuth = await _trySignIn[social]!.call(null);
            if (isAuth) {
              await Get.toNamed(Routes.home);
            }
          },
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
                text: 'Sign In to ',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                    text: 'catMapp',
                    style: TextStyle(
                      fontSize: 20,
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
