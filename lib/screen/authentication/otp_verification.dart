import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ncart_eats/generated/l10n.dart';
import 'package:ncart_eats/resources/app_colors.dart';
import 'package:ncart_eats/riverpod/state_providers/state_provider.dart';
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

  @override
  void initState() {
    otpFieldController = OtpFieldController();
    _startTimer();

    super.initState();
  }

  @override
  void dispose() {
    otpTimer.cancel();

    super.dispose();
  }

  void _startTimer() {
    int startTime = 60;
    ref.read(timerIndicatorProvider.notifier).setTime(startTime);

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

  Widget _buildOtpFieldWidget() => Padding(
      padding: const EdgeInsets.only(top: 30),
      child: AppOtpField(
          controller: otpFieldController,
          onCompleted: (String? otp) =>
              setState(() => verificationCode = otp!)));

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

    return Padding(
        padding: const EdgeInsets.only(left: 10),
        child: time == 0
            ? InkWell(
                onTap: () => _startTimer(), child: _buildResendTextWidget(time))
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

  Widget _buildVerifyButtonWidget() => SizedBox(
      height: 45,
      width: MediaQuery.of(context).size.width - 40,
      child: TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
              backgroundColor: AppColors.themeColor,
              foregroundColor: Colors.white),
          child: Text(S.of(context).verify,
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white))));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBarWidget(),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildOTPDescriptionTextWidget(),
              _buildOtpFieldWidget(),
              _buildResendOtpWidget(),
              if (verificationCode.isNotEmpty && verificationCode.length == 4)
                _buildVerifyButtonWidget()
            ]));
  }
}
