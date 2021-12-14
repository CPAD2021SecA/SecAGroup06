import 'package:cpad_assignment/provider/concern_provider.dart';
import 'package:cpad_assignment/services/concern_service.dart';
import 'package:cpad_assignment/ui/screens/concern_screen/widgets/concern_bottom_sheet.dart';
import 'package:cpad_assignment/ui/screens/concern_screen/widgets/concern_expansion_tile.dart';
import 'package:cpad_assignment/ui/styles.dart';
import 'package:cpad_assignment/ui/widgets/error_widget.dart';
import 'package:cpad_assignment/utility/app_data.dart';
import 'package:cpad_assignment/utility/size_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ConcernScreen extends StatefulWidget {
  @override
  _ConcernScreenState createState() => _ConcernScreenState();
}

class _ConcernScreenState extends State<ConcernScreen> {
  late Future fetchConcerns;

  Future<void> _fetchConcernsData() async {
    setState(() {
      fetchConcerns = AppData.isAdmin()
          ? ConcernService.fetchConcerns()
          : ConcernService.fetchConcernsByUser();
      fetchConcerns.then((concerns) {
        print('concerns - $concerns');
        Provider.of<ConcernProvider>(context, listen: false)
            .updateConcernList(concerns?.concernList ?? []);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchConcernsData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: !AppData.isAdmin()
          ? FloatingActionButton(
              heroTag: 'concernFAB',
              onPressed: () => showConcernBottomSheet(),
              backgroundColor: kButtonColor,
              child: Icon(Icons.add, size: 32),
            )
          : null,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        titleTextStyle: TextStyle(fontSize: kLargeText, fontWeight: kBold),
        title: Text("Concerns"),
      ),
      body: FutureBuilder(
        future: fetchConcerns,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    children: List.generate(
                      10,
                      (index) => Shimmer.fromColors(
                        baseColor: kButtonColor,
                        highlightColor: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Card(
                            margin: EdgeInsets.zero,
                            child: Container(
                              width: double.infinity,
                              height: SizeConfig.screenHeight * 0.12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
              break;

            default:
              if (snapshot.hasError) {
                return Container(
                  height: SizeConfig.screenHeight * 0.8,
                  child: Center(
                      child: CustomErrorWidget(onRefresh: _fetchConcernsData)),
                );
              } else {
                if (Provider.of<ConcernProvider>(context).concernsCount > 0)
                  return RefreshIndicator(
                    onRefresh: _fetchConcernsData,
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: kHorizontalPadding,
                            right: kHorizontalPadding,
                            bottom: SizeConfig.blockSizeHorizontal * 18,
                            left: kHorizontalPadding),
                        child: Column(
                          children: Provider.of<ConcernProvider>(context)
                              .concernList
                              .map(
                            (concern) {
                              return Padding(
                                padding: EdgeInsets.only(bottom: 10),
                                child: ConcernExpansionTile(concern: concern),
                              );
                            },
                          ).toList(),
                        ),
                      ),
                    ),
                  );
                else
                  return RefreshIndicator(
                    onRefresh: _fetchConcernsData,
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Container(
                        height: SizeConfig.screenHeight * 0.8,
                        child: Center(
                          child: Text(
                            'No Concerns raised',
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey.shade400,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  );
              }
          }
        },
      ),
    );
  }
}
