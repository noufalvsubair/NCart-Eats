import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ncart_eats/constants/enum.dart';
import 'package:ncart_eats/generated/l10n.dart';
import 'package:ncart_eats/helpers/generic_widget.dart';
import 'package:ncart_eats/helpers/shared_preference.dart';
import 'package:ncart_eats/helpers/utilities.dart';
import 'package:ncart_eats/model/current_user/current_user.dart';
import 'package:ncart_eats/resources/app_colors.dart';
import 'package:ncart_eats/riverpod/service_providers/user_service.dart';
import 'package:ncart_eats/riverpod/state_providers/state_provider.dart';
import 'package:ncart_eats/screen/landing/home.dart';
import 'package:ncart_eats/screen/location/set_location.dart';
import 'package:ncart_eats/widget/app_button.dart';
import 'package:ncart_eats/widget/app_otp_field.dart';

class OtpVerification extends ConsumerStatefulWidget {
  final String phoneNumber;

  const OtpVerification({Key? key, required this.phoneNumber})
      : super(key: key);

  @override
  ConsumerState<OtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends ConsumerState<OtpVerification> {
  late OtpFieldController otpFieldController;
  late String verificationCode = '';
  late Timer otpTimer;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  String? verificationId;
  int? resendToken;

  @override
  void initState() {
    otpFieldController = OtpFieldController();
    Future.delayed(Duration.zero, () => _sentVerificationCode());

    super.initState();
  }

  @override
  void dispose() {
    otpTimer.cancel();

    super.dispose();
  }

  void _sentVerificationCode() async {
    ref.read(loaderIndicatorProvider.notifier).show();
    await firebaseAuth.verifyPhoneNumber(
        phoneNumber: "+91${widget.phoneNumber}",
        forceResendingToken: resendToken,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) {
          _verifyVerificationCode(credential, (CurrentUser currentUser) {
            if (currentUser.hasAddressAdded!) {
              Utilities.navigateAndClearAll(context, const Home());
            } else {
              Utilities.navigateAndClearAll(context, const SetLocation());
            }
          }, () {
            Utilities.showToastBar(S.of(context).otpVerificationError, context);
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          ref.read(loaderIndicatorProvider.notifier).hide();
          if (e.code == 'invalid-phone-number') {
            Utilities.showToastBar(S.of(context).phoneError, context);
          }
        },
        codeSent: (String verificationId, int? resendToken) {
          ref.read(loaderIndicatorProvider.notifier).hide();
          _startTimer();
          setState(() {
            this.verificationId = verificationId;
            this.resendToken = resendToken;
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          ref.read(loaderIndicatorProvider.notifier).hide();
          setState(() => this.verificationId = verificationId);
        });
  }

  void _startTimer() {
    int startTime = 60;
    const seconds = Duration(seconds: 1);
    otpTimer = Timer.periodic(seconds, (Timer timer) {
      if (startTime == 0) {
        setState(() => otpTimer.cancel());
      } else {
        startTime--;
      }
      ref.read(timerIndicatorProvider.notifier).setTime(startTime);
    });
  }

  void _onVerifyOTPButtonTapped() {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId!, smsCode: verificationCode);
    _verifyVerificationCode(credential, (CurrentUser currentUser) {
      if (currentUser.hasAddressAdded!) {
        Utilities.navigateAndClearAll(context, const Home());
      } else {
        Utilities.navigateAndClearAll(context, const SetLocation());
      }
    }, () {
      Utilities.showToastBar(S.of(context).otpVerificationError, context);
    });
  }

  void _verifyVerificationCode(PhoneAuthCredential credential,
      ValueChanged<CurrentUser> onSuccess, VoidCallback onFailed) async {
    try {
      ref.read(loaderIndicatorProvider.notifier).show();
      UserCredential userCredential =
          await firebaseAuth.signInWithCredential(credential);
      if (userCredential.user != null) {
        CurrentUser currentUser = await UserService.fetchUserByMobileNumber(
            userCredential.user!.phoneNumber);
        await SharedPreferenceHelper.shared.setUser(currentUser);
        ref.read(loaderIndicatorProvider.notifier).hide();
        onSuccess(currentUser);
      } else {
        ref.read(loaderIndicatorProvider.notifier).hide();
        onFailed();
      }
    } catch (e) {
      ref.read(loaderIndicatorProvider.notifier).hide();
      Utilities.showToastBar(e.toString(), context);
    }
  }

  PreferredSize _buildAppBarWidget() => PreferredSize(
      preferredSize: const Size.fromHeight(50),
      child: AppBar(
          elevation: 0.0,
          iconTheme: const IconThemeData(color: AppColors.normalTextColor),
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(S.of(context).otpVerification,
              style: GoogleFonts.roboto(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColors.normalTextColor))));

  Widget _buildOTPDescriptionTextWidget() => Center(
          child: RichText(
              text: TextSpan(
                  text: S.of(context).otpVerificationDescription,
                  style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: AppColors.transparentTextColor),
                  children: [
            TextSpan(
                text: '+91${widget.phoneNumber}',
                style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    color: AppColors.normalTextColor))
          ])));

  Widget _buildOtpFieldWidget() => Flexible(
      child: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: AppOtpField(
              controller: otpFieldController,
              onCompleted: (String? otp) =>
                  setState(() => verificationCode = otp!))));

  Widget _buildResendTextWidget(int time) =>
      Text(time == 0 ? S.of(context).resend : '${S.of(context).resend}($time)',
          style: GoogleFonts.roboto(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: time == 0
                  ? AppColors.normalTextColor
                  : AppColors.transparentTextColor));

  Widget _buildResendButtonWidget() {
    int time = ref.watch(timerIndicatorProvider);
    bool loaderEnabled = ref.watch(loaderIndicatorProvider);

    return Padding(
        padding: const EdgeInsets.only(left: 10),
        child: time == 0
            ? InkWell(
                onTap: () => loaderEnabled ? null : _sentVerificationCode(),
                child: _buildResendTextWidget(time))
            : Container(child: _buildResendTextWidget(time)));
  }

  Widget _buildResendOtpWidget() => Padding(
      padding: const EdgeInsets.only(top: 50, bottom: 30),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(S.of(context).resendOtpDescription,
                style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: AppColors.transparentTextColor)),
            _buildResendButtonWidget()
          ]));

  Widget _buildVerifyButtonWidget(bool enabled) => AppButton(
      label: S.of(context).verify,
      type: ButtonType.primary.toString(),
      onTapped: () => enabled ? null : _onVerifyOTPButtonTapped());

  @override
  Widget build(BuildContext context) {
    bool loaderEnabled = ref.watch(loaderIndicatorProvider);

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBarWidget(),
        body: Stack(children: [
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildOTPDescriptionTextWidget(),
                _buildOtpFieldWidget(),
                _buildResendOtpWidget(),
                if (verificationCode.isNotEmpty && verificationCode.length == 6)
                  _buildVerifyButtonWidget(loaderEnabled)
              ]),
          GenericWidget.buildCircularProgressIndicator(loaderEnabled)
        ]));
  }
}
