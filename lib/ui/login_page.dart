import 'package:flutter/material.dart';
import 'package:restaurant_app/common/color_schemes.g.dart';
import 'package:restaurant_app/ui/restaurant_list_page.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/login_page';

  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() => _LoginPage();
}

class _LoginPage extends State<StatefulWidget> {
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        title: const Text('Login Page'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(left: 16, right: 16),
            padding: const EdgeInsets.all(16),
            width: 500,
            height: 350,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: lightColorScheme.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: SingleChildScrollView(
              child: _buildColumn(context),
            ),
          ),
        ),
      ),
    );
  }

  Column _buildColumn(BuildContext context) {
    const Widget sizedBoxHeightSmall = SizedBox(height: 10);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildText(
          text: 'Selamat datang di Restaurant App!',
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        sizedBoxHeightSmall,
        _buildText(
          text: 'Silahkan masuk menggunakan email yang terdaftar!',
          fontSize: 16,
        ),
        sizedBoxHeightSmall,
        _buildTextField(
          labelText: 'Email',
          textEditingController: _controllerEmail,
          hintText: 'npc@dicoding.com',
        ),
        sizedBoxHeightSmall,
        _buildTextField(
          labelText: 'Password',
          textEditingController: _controllerPassword,
          obscureText: true,
        ),
        sizedBoxHeightSmall,
        Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(
                context,
                RestaurantListPage.routeName,
              );
            },
            child: const Text(
              'Submit',
            ),
          ),
        ),
      ],
    );
  }

  Text _buildText({
    required String text,
    required double fontSize,
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: lightColorScheme.onPrimary,
      ),
    );
  }

  TextField _buildTextField(
      {bool obscureText = false,
      required String labelText,
      String hintText = '',
      required TextEditingController textEditingController}) {
    return TextField(
      controller: textEditingController,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: lightColorScheme.onPrimaryContainer),
        border: const UnderlineInputBorder(),
        filled: true,
        fillColor: lightColorScheme.primaryContainer,
        hintText: hintText,
      ),
    );
  }

  @override
  void dispose() {
    _controllerEmail.dispose();
    _controllerPassword.dispose();
    super.dispose();
  }
}
