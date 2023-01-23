import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ncart_eats/constants/enum.dart';
import 'package:ncart_eats/generated/l10n.dart';
import 'package:ncart_eats/helpers/utilities.dart';
import 'package:ncart_eats/helpers/validator.dart';
import 'package:ncart_eats/resources/app_colors.dart';
import 'package:ncart_eats/screen/authentication/otp_verification.dart';
import 'package:ncart_eats/screen/authentication/sign_up.dart';
import 'package:ncart_eats/screen/authentication/terms_conditions.dart';
import 'package:ncart_eats/widget/app_button.dart';
import 'package:ncart_eats/widget/app_checkbox.dart';
import 'package:ncart_eats/widget/app_phone_field.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late bool termsAndConditionEnabled = true;
  late bool rememberMeEnabled = false;
  late TextEditingController phoneNumberFieldController;

  @override
  void initState() {
    phoneNumberFieldController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    phoneNumberFieldController.dispose();

    super.dispose();
  }

  void _onSignInButtonTapped() {
    String phoneNumber = phoneNumberFieldController.text;
    if (phoneNumber.isEmpty || !Validator.validatePhoneNumber(phoneNumber)) {
      Utilities.showToastBar(S.of(context).phoneError, context);
      return;
    }

    Utilities.navigateTo(context, OtpVerification(phoneNumber: phoneNumber));
  }

  Widget _buildLogoImageWidget() =>
      Center(child: Image.asset('assets/images/logo.png'));

  Widget _buildTitleTextWidget() => Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Text(S.of(context).signIn.toUpperCase(),
          style: GoogleFonts.roboto(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)));

  Widget _buildPhoneNumberFieldWidget() => Container(
      margin: const EdgeInsets.only(top: 50, left: 15, right: 15),
      padding: const EdgeInsets.only(left: 15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
                color: AppColors.shadowColor,
                offset: Offset(0.0, 0.5), //(x,y)
                blurRadius: 3.0)
          ]),
      child: AppPhoneField(fieldEditController: phoneNumberFieldController));

  Widget _buildRememberMeWidget() => Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
      child: AppCheckbox(
          checked: rememberMeEnabled,
          label: S.of(context).rememberMe,
          onChanged: (bool? checked) =>
              setState(() => rememberMeEnabled = checked!)));

  Widget _buildTermsAndConditionWidget() => Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 13),
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
                    onTap: () => Utilities.navigateTo(
                        context, const TermsAndCondition()),
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
            AppButton(
                width: (MediaQuery.of(context).size.width - 40) / 2,
                label: S.of(context).signUp,
                type: ButtonType.secondary.toString(),
                onTapped: () =>
                    Utilities.navigateWithReplacement(context, const SignUp())),
            AppButton(
                width: (MediaQuery.of(context).size.width - 40) / 2,
                label: S.of(context).signIn,
                type: ButtonType.primary.toString(),
                onTapped: _onSignInButtonTapped)
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
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              _buildLogoImageWidget(),
              _buildTitleTextWidget(),
              _buildPhoneNumberFieldWidget(),
              _buildRememberMeWidget(),
              _buildTermsAndConditionWidget(),
              _buildBottomButtonWidget(),
              _buildContinueAsGuestWidget(),
            ]));
  }
}
