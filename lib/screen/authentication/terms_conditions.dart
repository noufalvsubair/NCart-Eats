import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ncart_eats/generated/l10n.dart';
import 'package:ncart_eats/resources/app_colors.dart';

class TermsAndCondition extends StatefulWidget {
  const TermsAndCondition({Key? key}) : super(key: key);

  @override
  State<TermsAndCondition> createState() => _TermsAndConditionState();
}

class _TermsAndConditionState extends State<TermsAndCondition> {
  PreferredSize _buildAppBarWidget() => PreferredSize(
      preferredSize: const Size.fromHeight(50),
      child: AppBar(
          elevation: 0.0,
          iconTheme: IconThemeData(color: AppColors.backgroundOverlayDarkColor),
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(S.of(context).termAndCondition,
              style: GoogleFonts.raleway(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textHighestEmphasisColor))));

  Widget _buildTermsAndConditionItemWidget(String title, String description) =>
      Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title.isNotEmpty)
              Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
                  child: Text(title,
                      style: GoogleFonts.raleway(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: AppColors.textHighestEmphasisColor))),
            Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
                child: Text(description,
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.normal,
                        fontSize: 13,
                        color: AppColors.textHighEmphasisColor))),
          ]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBarWidget(),
        body: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              _buildTermsAndConditionItemWidget(
                  '', S.of(context).termsAndConditionInfo),
              _buildTermsAndConditionItemWidget(S.of(context).information,
                  S.of(context).termsAndConditionInfoDescription),
              _buildTermsAndConditionItemWidget(
                  S.of(context).purpose, S.of(context).purposeDescription),
              _buildTermsAndConditionItemWidget(
                  S.of(context).serviceAvailability,
                  S.of(context).serviceAvailabilityDescription),
              _buildTermsAndConditionItemWidget(
                  S.of(context).orders, S.of(context).ordersDescription),
              _buildTermsAndConditionItemWidget(
                  S.of(context).meals, S.of(context).mealsDescription),
              _buildTermsAndConditionItemWidget(
                  S.of(context).availabilityAndDelivery,
                  S.of(context).availabilityAndDeliveryDescription),
              _buildTermsAndConditionItemWidget(S.of(context).cancellation,
                  S.of(context).cancellationDescription),
              _buildTermsAndConditionItemWidget(S.of(context).priceAndPayment,
                  S.of(context).priceAndPaymentDescription),
              _buildTermsAndConditionItemWidget(S.of(context).ourLiability,
                  S.of(context).ourLiabilityDescription),
              _buildTermsAndConditionItemWidget(
                  S.of(context).eventOutsideOurControl,
                  S.of(context).eventOutsideOurControlDescription),
              _buildTermsAndConditionItemWidget(S.of(context).entireAgreement,
                  S.of(context).entireAgreementDescription),
              _buildTermsAndConditionItemWidget(
                  S.of(context).lawAndJurisdiction,
                  S.of(context).lawAndJurisdictionDescription)
            ])));
  }
}
