import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ncart_eats/generated/l10n.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Widget _buildLogoImageWidget() =>
      Center(child: Image.asset('assets/images/logo.png'));

  Widget _buildTitleTextWidget() => Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Text(S.of(context).signIn.toUpperCase(),
          style: GoogleFonts.roboto(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [_buildLogoImageWidget(), _buildTitleTextWidget()]));
  }
}
