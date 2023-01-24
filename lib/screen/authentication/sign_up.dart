import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ncart_eats/constants/enum.dart';
import 'package:ncart_eats/generated/l10n.dart';
import 'package:ncart_eats/helpers/generic_widget.dart';
import 'package:ncart_eats/helpers/utilities.dart';
import 'package:ncart_eats/helpers/validator.dart';
import 'package:ncart_eats/model/user/user.dart';
import 'package:ncart_eats/resources/app_colors.dart';
import 'package:ncart_eats/resources/app_icons.dart';
import 'package:ncart_eats/resources/app_styles.dart';
import 'package:ncart_eats/riverpod/service_providers/user_service.dart';
import 'package:ncart_eats/riverpod/state_providers/state_provider.dart';
import 'package:ncart_eats/screen/authentication/Login.dart';
import 'package:ncart_eats/screen/authentication/otp_verification.dart';
import 'package:ncart_eats/screen/authentication/terms_conditions.dart';
import 'package:ncart_eats/widget/app_button.dart';
import 'package:ncart_eats/widget/app_checkbox.dart';
import 'package:ncart_eats/widget/app_phone_field.dart';

class SignUp extends ConsumerStatefulWidget {
  final String? phoneNumber;

  const SignUp({Key? key, this.phoneNumber}) : super(key: key);

  @override
  ConsumerState<SignUp> createState() => _SignUpState();
}

class _SignUpState extends ConsumerState<SignUp> {
  late TextEditingController firstNameFieldController;
  late TextEditingController lastNameFieldController;
  late TextEditingController phoneNumberFieldController;
  late bool termsAndConditionEnabled = true;

  @override
  void initState() {
    firstNameFieldController = TextEditingController();
    lastNameFieldController = TextEditingController();
    phoneNumberFieldController = TextEditingController();
    if (widget.phoneNumber != null) {
      phoneNumberFieldController.text = widget.phoneNumber!;
    }

    super.initState();
  }

  @override
  void dispose() {
    firstNameFieldController.dispose();
    lastNameFieldController.dispose();
    phoneNumberFieldController.dispose();

    super.dispose();
  }

  void _onSignUpButtonTapped() {
    String firstName = firstNameFieldController.text;
    if (firstName.isEmpty) {
      Utilities.showToastBar(S.of(context).firstNameError, context);
      return;
    }

    String lastName = lastNameFieldController.text;
    if (lastName.isEmpty) {
      Utilities.showToastBar(S.of(context).lastNameError, context);
      return;
    }

    String phoneNumber = phoneNumberFieldController.text;
    if (phoneNumber.isEmpty || !Validator.validatePhoneNumber(phoneNumber)) {
      Utilities.showToastBar(S.of(context).phoneError, context);
      return;
    }

    _addUserToDB(
        User(
            firstName: firstName,
            lastName: lastName,
            mobile: "+91$phoneNumber",
            hasAddressAdded: false,
            hasTermAndConditionAgreed: termsAndConditionEnabled), () {
      Utilities.navigateTo(context, OtpVerification(phoneNumber: phoneNumber));
    });
  }

  void _addUserToDB(User user, VoidCallback onSuccess) async {
    try {
      ref.read(loaderIndicatorProvider.notifier).show();
      await UserService.addUserToDB(user);
      ref.read(loaderIndicatorProvider.notifier).hide();
      onSuccess();
    } catch (e) {
      ref.read(loaderIndicatorProvider.notifier).hide();
      if (e == 409) {
        Utilities.showToastBar(S.of(context).alreadyRegisteredError, context);
      } else {
        Utilities.showToastBar(S.of(context).signUpError, context);
      }
    }
  }

  Widget _buildLogoImageWidget() => Padding(
      padding: const EdgeInsets.only(top: 60),
      child: Center(child: Image.asset(AppIcons.logo)));

  Widget _buildTitleTextWidget() => Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Text(S.of(context).signUp.toUpperCase(),
          style: GoogleFonts.roboto(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)));

  Widget _buildFirstNameFieldWidget() => TextField(
      controller: firstNameFieldController,
      cursorColor: AppColors.themeColor,
      decoration: AppStyles.fieldDecorationWithIcon(
          context,
          S.of(context).firstName,
          const Icon(Icons.account_circle,
              color: AppColors.transparentTextColor)));

  Widget _buildLastNameFieldWidget() => TextField(
      controller: lastNameFieldController,
      cursorColor: AppColors.themeColor,
      decoration: AppStyles.fieldDecorationWithIcon(
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
                    onTap: () => Utilities.navigateTo(
                        context, const TermsAndCondition()),
                    child: Text(S.of(context).termAndCondition,
                        style: GoogleFonts.roboto(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.lightBlue))))
          ]));

  Widget _buildBottomButtonWidget(bool enabled) => Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 50),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppButton(
                width: (MediaQuery.of(context).size.width - 40) / 2,
                label: S.of(context).signIn,
                type: ButtonType.secondary.toString(),
                onTapped: () => enabled
                    ? null
                    : Utilities.navigateWithReplacement(
                        context, const Login())),
            AppButton(
                width: (MediaQuery.of(context).size.width - 40) / 2,
                label: S.of(context).signUp,
                type: ButtonType.primary.toString(),
                onTapped: () => enabled ? null : _onSignUpButtonTapped())
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
    bool loaderEnabled = ref.watch(loaderIndicatorProvider);

    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(children: [
          SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                _buildLogoImageWidget(),
                _buildTitleTextWidget(),
                _buildUserInfoFieldWidget(),
                _buildTermsAndConditionWidget(),
                _buildBottomButtonWidget(loaderEnabled),
                _buildContinueAsGuestWidget(),
                const SizedBox(height: 30)
              ])),
          GenericWidget.buildCircularProgressIndicator(loaderEnabled)
        ]));
  }
}
