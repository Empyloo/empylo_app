import 'package:flutter/material.dart';

class StyledCampaignTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final Widget? accompanyingWidget;
  final bool isAccompanyingWidgetOnTop;
  final bool isAccompanyingWidgetCentered;

  const StyledCampaignTextField({
    Key? key,
    required this.controller,
    this.labelText = '',
    this.accompanyingWidget,
    this.isAccompanyingWidgetOnTop = true,
    this.isAccompanyingWidgetCentered = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isAccompanyingWidgetOnTop && accompanyingWidget != null)
            _buildAccompanyingWidget(),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: labelText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          if (!isAccompanyingWidgetOnTop && accompanyingWidget != null)
            _buildAccompanyingWidget(),
        ],
      ),
    );
  }

  Widget _buildAccompanyingWidget() {
    return isAccompanyingWidgetCentered
        ? Center(child: accompanyingWidget)
        : accompanyingWidget!;
  }
}
