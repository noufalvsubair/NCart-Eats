import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ncart_eats/components/app_checkbox.dart';
import 'package:ncart_eats/components/app_phone_field.dart';
import 'package:ncart_eats/generated/l10n.dart';
import 'package:ncart_eats/resources/app_colors.dart';
import 'package:ncart_eats/screen/authentication/Login.dart';
import 'package:ncart_eats/screen/authentication/terms_conditions.dart';
import 'package:ncart_eats/utils/decoration_utils.dart';
import 'package:ncart_eats/utils/utils.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late TextEditingController firstNameFieldController;
  late TextEditingController lastNameFieldController;
  late TextEditingController phoneNumberFieldController;
  late bool termsAndConditionEnabled = true;

  @override
  void initState() {
    firstNameFieldController = TextEditingController();
    lastNameFieldController = TextEditingController();
    phoneNumberFieldController = TextEditingController();

    super.initState();
  }

  Widget _buildLogoImageWidget() => Padding(
      padding: const EdgeInsets.only(top: 60),
      child: Center(child: Image.asset('assets/images/logo.png')));

  Widget _buildTitleTextWidget() => Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Text(S.of(context).signUp.toUpperCase(),
          style: GoogleFonts.roboto(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)));

  Widget _buildFirstNameFieldWidget() => TextField(
      controller: firstNameFieldController,
      cursorColor: AppColors.themeColor,
      decoration: DecorationUtils.fieldDecorationWithIcon(
          context,
          S.of(context).firstName,
          const Icon(Icons.account_circle,
              color: AppColors.transparentTextColor)));

  Widget _buildLastNameFieldWidget() => TextField(
      controller: lastNameFieldController,
      cursorColor: AppColors.themeColor,
      decoration: DecorationUtils.fieldDecorationWithIcon(
          context,
          S.of(context).lastName,
          const Icon(Icons.account_circle,
              color: AppColors.transparentTextColor)));

  Widget _buildUserInfoFieldWidget() => Container(
      margin: const EdgeInsets.only(top: 50, left: 15, right: 15),
      padding: const EdgeInsets.only(left: 15, right: 15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
                color: AppColors.shadowColor,
                offset: Offset(0.0, 0.5), //(x,y)
                blurRadius: 3.0)
          ]),
      child: Column(children: [
        _buildFirstNameFieldWidget(),
        const Divider(height: 0.3, color: AppColors.transparentTextColor),
        _buildLastNameFieldWidget(),
        const Divider(height: 0.3, color: AppColors.transparentTextColor),
        AppPhoneField(fieldEditController: phoneNumberFieldController)
      ]));

  Widget _buildTermsAndConditionWidget() => Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 25),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppCheckbox(
                checked: termsAndConditionEnabled,
                label: S.of(context).termsAndConditionDescription,
                onChanged: (bool? checked) =>
                    setState(() => termsAndConditionEnabled = checked!)),
            Padding(
                padding: const EdgeInsets.only(left: 5),
                child: InkWell(
                    onTap: () =>
                        Utils.navigateTo(context, const TermsAndCondition()),
                    child: Text(S.of(context).termAndCondition,
                        style: GoogleFonts.roboto(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.lightBlue))))
          ]));

  Widget _buildBottomButtonWidget() => Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 50),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
                height: 45,
                width: (MediaQuery.of(context).size.width - 40) / 2,
                child: TextButton(
                    onPressed: () =>
                        Utils.navigateWithReplacement(context, const Login()),
                    style: TextButton.styleFrom(
                        foregroundColor: AppColors.themeColor),
                    child: Text(S.of(context).signIn,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.themeColor)))),
            SizedBox(
                height: 45,
                width: (MediaQuery.of(context).size.width - 40) / 2,
                child: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                        backgroundColor: AppColors.themeColor,
                        foregroundColor: Colors.white),
                    child: Text(S.of(context).signUp,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white))))
          ]));

  Widget _buildContinueAsGuestWidget() => Center(
      child: InkWell(
          onTap: () {},
          child: RichText(
              text: TextSpan(
                  text: S.of(context).continueAs,
                  style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: AppColors.transparentTextColor),
                  children: [
                TextSpan(
                    text: S.of(context).guest,
                    style: GoogleFonts.roboto(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: AppColors.normalTextColor))
              ]))));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
              _buildLogoImageWidget(),
              _buildTitleTextWidget(),
              _buildUserInfoFieldWidget(),
              _buildTermsAndConditionWidget(),
              _buildBottomButtonWidget(),
              _buildContinueAsGuestWidget(),
              const SizedBox(height: 30)
            ])));
  }
}
