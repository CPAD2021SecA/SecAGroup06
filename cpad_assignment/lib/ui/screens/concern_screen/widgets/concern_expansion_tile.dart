import 'package:cpad_assignment/models/concern.dart';
import 'package:cpad_assignment/provider/concern_provider.dart';
import 'package:cpad_assignment/services/concern_service.dart';
import 'package:cpad_assignment/ui/styles.dart';
import 'package:cpad_assignment/ui/widgets/custom_dialog.dart';
import 'package:cpad_assignment/ui/widgets/custom_expansion_tile.dart';
import 'package:cpad_assignment/ui/widgets/solid_rounded_button.dart';
import 'package:cpad_assignment/utility/app_data.dart';
import 'package:cpad_assignment/utility/size_config.dart';
import 'package:cpad_assignment/utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'package:firebase_auth/firebase_auth.dart' as firebaseAuth;

class ConcernExpansionTile extends StatefulWidget {
  final Concern concern;

  const ConcernExpansionTile({required this.concern});

  @override
  _ConcernExpansionTileState createState() => _ConcernExpansionTileState();
}

class _ConcernExpansionTileState extends State<ConcernExpansionTile> {
  late String userId;

  @override
  void initState() {
    super.initState();
    setState(() {
      userId = firebaseAuth.FirebaseAuth.instance.currentUser!.uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomExpansionTile(
      titlePadding: EdgeInsets.symmetric(vertical: 10),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.title, size: 18, color: kPrimaryColor),
              SizedBox(width: SizeConfig.blockSizeHorizontal),
              Text(
                widget.concern.title ?? '-',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          SizedBox(height: SizeConfig.blockSizeHorizontal),
          Row(
            children: [
              Icon(Icons.date_range, size: 18, color: kPrimaryColor),
              SizedBox(width: SizeConfig.blockSizeHorizontal),
              Text(
                Utility.getTimeStamp(
                    unformattedDate: widget.concern.date!, showTime: false),
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            widget.concern.content ?? '-',
            style: TextStyle(fontSize: 14),
          ),
        ),
        SizedBox(height: SizeConfig.blockSizeHorizontal),
        Divider(
          color: Colors.grey.shade300,
        ),
        SizedBox(height: SizeConfig.blockSizeHorizontal),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.grey.shade300,
                  )),
              child: Row(
                children: [
                  Icon(
                    widget.concern.isResolved!
                        ? Icons.check
                        : Icons.hourglass_top,
                    size: 20,
                    color: widget.concern.isResolved!
                        ? Colors.lightGreen
                        : kPrimaryColor,
                  ),
                  SizedBox(width: 5),
                  Text(
                    widget.concern.isResolved! ? 'Resolved' : 'Pending',
                    style: TextStyle(
                        color: widget.concern.isResolved!
                            ? Colors.lightGreen
                            : kPrimaryColor,
                        fontSize: kNormalText),
                  ),
                ],
              ),
            ),
            if (AppData.isAdmin() && !widget.concern.isResolved!)
              TextButton(
                onPressed: () {
                  showCustomDialog(
                    context: context,
                    title: 'Concern',
                    description: 'Are you sure you want to resolve?',
                    rightButtonText: 'Resolve',
                    onRightButton: () {
                      Provider.of<ConcernProvider>(context, listen: false)
                          .markResolved(
                              concern: widget.concern, isResolved: true);
                      Get.back();
                      ConcernService.setResolved(
                              id: widget.concern.id!, isResolved: true)
                          .then((_) {
                        Utility.showToast('Concern Resolved');
                      }).catchError((e) {
                        Get.back();
                        print(e);
                        Provider.of<ConcernProvider>(context, listen: false)
                            .markResolved(
                                concern: widget.concern, isResolved: false);
                        Utility.showSnackBar(
                            isError: true,
                            message:
                                'Something went wrong while deleting. Please try again.');
                      });
                    },
                  );
                },
                child: Text(
                  "Resolve",
                  style: TextStyle(color: kPrimaryColor, fontSize: kMediumText),
                ),
              )
            else if (!AppData.isAdmin())
              GestureDetector(
                onTap: () {
                  showCustomDialog(
                    context: context,
                    title: 'Concern',
                    description: 'Are you sure you want to delete?',
                    rightButtonText: 'Delete',
                    onRightButton: () {
                      Provider.of<ConcernProvider>(context, listen: false)
                          .deleteConcern(widget.concern);
                      Get.back();
                      ConcernService.deleteConcernById(id: widget.concern.id!)
                          .then((_) {
                        Utility.showToast('Concern deleted');
                      }).catchError((e) {
                        Get.back();
                        print(e);
                        Provider.of<ConcernProvider>(context, listen: false)
                            .addConcern(widget.concern);
                        Utility.showSnackBar(
                            isError: true,
                            message:
                                'Something went wrong while deleting. Please try again.');
                      });
                    },
                  );
                },
                child: Icon(Icons.delete_outline, color: Colors.red),
              ),
          ],
        ),
        SizedBox(height: 10)
      ],
    );
  }
}
