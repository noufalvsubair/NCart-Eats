import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ncart_eats/generated/l10n.dart';
import 'package:ncart_eats/resources/app_colors.dart';
import 'package:ncart_eats/widget/app_otp_field.dart';

class OtpVerification extends StatefulWidget {
  final String phoneNumber;

  const OtpVerification({Key? key, required this.phoneNumber})
      : super(key: key);

  @override
  State<OtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  late OtpFieldController otpFieldController;
  late String verificationCode = '';

  @override
  void initState() {
    otpFieldController = OtpFieldController();

    super.initState();
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
            Padding(
                padding: const EdgeInsets.only(left: 10),
                child: InkWell(
                    onTap: () {},
                    child: Text(S.of(context).resend,
                        style: GoogleFonts.roboto(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: AppColors.normalTextColor))))
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
