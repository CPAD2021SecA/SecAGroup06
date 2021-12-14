import 'package:cpad_assignment/models/user.dart';
import 'package:cpad_assignment/services/firebase_service.dart';
import 'package:cpad_assignment/services/user_service.dart';
import 'package:cpad_assignment/ui/screens/home_screen/widgets/user_card.dart';
import 'package:cpad_assignment/ui/screens/login/login_screen.dart';
import 'package:cpad_assignment/ui/screens/members_screen/members_screen.dart';
import 'package:cpad_assignment/ui/screens/mom_screen/mom_screen.dart';
import 'package:cpad_assignment/ui/screens/polls_screen/polls_screen.dart';
import 'package:cpad_assignment/ui/styles.dart';
import 'package:cpad_assignment/ui/widgets/custom_outlined_button.dart';
import 'package:cpad_assignment/utility/app_data.dart';
import 'package:cpad_assignment/utility/size_config.dart';
import 'package:flutter/material.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:get/get.dart';
import 'package:cpad_assignment/ui/screens/concern_screen/concern_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future _fetchUser;

  @override
  void initState() {
    super.initState();
    _fetchUser = UserService.getUser();

    _fetchUser.then((user) {
      if (!user.isAdmin) if (user.isRejected)
        Get.off(() => RejectScreen());
      else if (!user.isVerified) Get.off(() => VerificationScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kBackgroundColor,
      child: FutureBuilder(
          future: _fetchUser,
          builder: (context, snapshot) {
            BotToast.showLoading();
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Container();
              default:
                if (snapshot.hasError) {
                  BotToast.closeAllLoading();
                  print("[Error]: ${snapshot.error}");
                  return Scaffold(body: Text(snapshot.error.toString()));
                } else {
                  BotToast.closeAllLoading();
                  AppUser appUser = AppData.getUser()!;
                  return HomeData(appUser: appUser);
                }
            }
          }),
    );
  }
}

class HomeData extends StatelessWidget {
  const HomeData({
    Key? key,
    required this.appUser,
  }) : super(key: key);

  final AppUser appUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        titleTextStyle: TextStyle(
            fontSize: kLargeText, fontWeight: kBold, color: Colors.white),
        title: Text("Hello ${appUser.name ?? ''}"),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              BotToast.showLoading();

              FirebaseService.signOut().then((_) {
                BotToast.closeAllLoading();

                Get.off(() => LoginScreen());
              });
            },
            icon: Icon(
              Icons.logout,
              color: Colors.white,
            ),
          )
        ],
      ),
      backgroundColor: kBackgroundColor,
      body: Padding(
        padding: EdgeInsets.symmetric(
            vertical: kVerticalPadding, horizontal: kHorizontalPadding),
        child: Column(
          children: [
            UserCard(appUser: appUser),
            SizedBox(height: SizeConfig.blockSizeHorizontal * 10),
            Container(
              width: double.infinity,
              child: CustomOutlineButton(
                text: 'Members',
                onPressed: () {
                  Get.to(() => MembersScreen());
                },
              ),
            ),
            SizedBox(height: SizeConfig.blockSizeHorizontal * 4),
            Container(
              width: double.infinity,
              child: CustomOutlineButton(
                text: 'MoMs',
                onPressed: () {
                  Get.to(() => MOMScreen());
                },
              ),
            ),
            SizedBox(height: SizeConfig.blockSizeHorizontal * 4),
            Container(
              width: double.infinity,
              child: CustomOutlineButton(
                text: 'Polls',
                onPressed: () {
                  Get.to(() => PollsScreen());
                },
              ),
            ),
            SizedBox(height: SizeConfig.blockSizeHorizontal * 4),
            Container(
              width: double.infinity,
              child: CustomOutlineButton(
                text: 'Concerns',
                onPressed: () {
                  Get.to(() => ConcernScreen());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
