import 'package:cpad_assignment/models/concern.dart';
import 'package:cpad_assignment/models/mom.dart';
import 'package:cpad_assignment/models/user.dart';
import 'package:cpad_assignment/provider/concern_provider.dart';
import 'package:cpad_assignment/provider/mom_provider.dart';
import 'package:cpad_assignment/services/concern_service.dart';
import 'package:cpad_assignment/services/firebase_service.dart';
import 'package:cpad_assignment/services/mom_service.dart';
import 'package:cpad_assignment/ui/styles.dart';
import 'package:cpad_assignment/ui/widgets/rounded_text_field.dart';
import 'package:cpad_assignment/utility/app_data.dart';
import 'package:cpad_assignment/utility/size_config.dart';
import 'package:cpad_assignment/utility/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

showConcernBottomSheet() {
  Get.bottomSheet(
    ConcernBottomSheet(),
    isScrollControlled: true,
  );
}

class ConcernBottomSheet extends StatefulWidget {
  @override
  _ConcernBottomSheetState createState() => _ConcernBottomSheetState();
}

class _ConcernBottomSheetState extends State<ConcernBottomSheet> {
  late DateTime _pickedDate;
  TextEditingController _dateController = TextEditingController();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _concernController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null)
      setState(() {
        _pickedDate = picked;
        _dateController.text = DateFormat('dd/MM/yyyy').format(_pickedDate);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.blockSizeHorizontal * 2.6),
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: kHorizontalPadding,
                vertical: SizeConfig.blockSizeHorizontal * 7),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30))),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RoundedTextField(
                    hintText: 'Title',
                    controller: _titleController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: SizeConfig.blockSizeHorizontal * 5),
                  InkWell(
                    onTap: () {
                      _selectDate(); // Call Function that has showDatePicker()
                    },
                    child: IgnorePointer(
                      child: RoundedTextField(
                        hintText: 'Date',
                        controller: _dateController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: SizeConfig.blockSizeHorizontal * 5),
                  RoundedTextField(
                    controller: _concernController,
                    hintText: 'Concern',
                    maxLines: 2,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: SizeConfig.blockSizeHorizontal * 5),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton.icon(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.resolveWith((states) =>
                            EdgeInsets.symmetric(vertical: 8, horizontal: 14)),
                        backgroundColor: MaterialStateProperty.resolveWith(
                            (states) => kButtonColor),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _startLoading();
                          AppUser? _user = AppData.getUser();
                          Concern _newConcern = Concern(
                              userID:
                                  _user?.id ?? FirebaseService.currentUserId,
                              title: _titleController.text,
                              content: _concernController.text,
                              date: _pickedDate.toIso8601String(),
                              isResolved: false);
                          ConcernService.saveConcern(
                            concern: _newConcern,
                          ).then((concern) {
                            Provider.of<ConcernProvider>(context, listen: false)
                                .addConcern(concern);
                            _stopLoading();
                            Get.back();
                          }).catchError((e) {
                            _stopLoading();

                            Get.back();
                            Utility.showSnackBar(
                                isError: true,
                                message:
                                    'Something went wrong while saving the MOM. Please try again.');
                          });
                        }
                      },
                      icon: Icon(
                        Icons.save_outlined,
                        color: Colors.white,
                        size: 26,
                      ),
                      label: Text(
                        'Save',
                        style: TextStyle(
                            letterSpacing: 0.5,
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (_isLoading)
          Container(
            alignment: Alignment.center,
            color: Colors.black.withOpacity(0.5),
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          )
      ],
    );
  }

  void _startLoading() {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    } else {
      _isLoading = true;
    }
  }

  void _stopLoading() {
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    } else {
      _isLoading = false;
    }
  }
}
