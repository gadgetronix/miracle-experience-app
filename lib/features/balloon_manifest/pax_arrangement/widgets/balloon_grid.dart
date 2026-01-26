import 'package:flutter/material.dart';
import 'package:miracle_experience_mobile_app/features/network_helper/cubit/pax_arangement_cubit.dart';
import 'package:miracle_experience_mobile_app/features/network_helper/models/helper_models/balloon_basket_model.dart';

import '../../../../core/basic_features.dart';
import 'compartment_card.dart';

class BalloonGrid extends StatelessWidget {
  final double gridHeight;

  const BalloonGrid({super.key, required this.gridHeight});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xfff8f9fa),
        border: Border.all(width: 0.5, color: Colors.grey),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(0xfff8f9fa),
              border: Border(top: BorderSide(width: 0.001, color: Colors.grey)),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            alignment: Alignment.center,
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Text('TOP', style: fontStyleRegular14),
          ),
          Divider(height: 0),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: gridHeight,
            ),
            itemCount: CompartmentType.values.length,
            itemBuilder: (context, index) {
              return CompartmentCard(type: CompartmentType.values[index]);
            },
          ),
          Divider(height: 0),
          BlocBuilder<PaxArrangementCubit, BalloonBasketModel>(
            builder: (context, state) {
              return Container(
                decoration: BoxDecoration(
                  color: Color(0xfff8f9fa),
                  border: Border(
                    bottom: BorderSide(width: 0.001, color: Colors.grey),
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                alignment: Alignment.center,
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${state.getLeftWeight().toStringAsFixed(0)} KG',
                      style: fontStyleRegular14,
                    ),
                    Text('BOTTOM', style: fontStyleRegular14),
                    Text(
                      '${state.getRightWeight().toStringAsFixed(0)} KG',
                      style: fontStyleRegular14,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
