import 'package:auth_demo/auth_pages/forgotPassword.dart';
import 'package:auth_demo/auth_pages/signIn.dart';
import 'package:auth_demo/auth_pages/signUp.dart';
import 'package:flutter/material.dart';

class Authentication extends StatefulWidget {
  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  final GlobalKey<ScaffoldState> _authScaffoldKey = GlobalKey<ScaffoldState>();
  PageController authPageController =
      PageController(keepPage: true, initialPage: 1);

  int page = 1;
  
  // No Internet Connection SnackBar
  SnackBar networkErrorSnackBar = SnackBar(
    content: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.wifi_off,
          size: 15,
          color: Colors.white,
        ),
        SizedBox(
          width: 4,
        ),
        Text("No internet connection. Try again!")
      ],
    ),
  );

  // Change Page Button Preffixs
  List<String> preffix = [
    "Don't want to reset password? ",
    "Need an account? ",
    "Have an account? ",
  ];

  // Change Page Button Suffixs
  List<String> suffix = [
    "Sign In",
    "SignUp",
    "Sign In",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _authScaffoldKey,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [

                      // Logo Template
                      Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(75),
                          color: Colors.grey,
                        ),
                        child: Center(
                          child: Text(
                            "Logo",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height / 2,

                    // PageView To Display Auth Pages
                    child: PageView(
                      controller: authPageController,
                      physics: NeverScrollableScrollPhysics(),
                      onPageChanged: (value) {
                        setState(() {
                          page = value;
                        });
                      },
                      children: [

                        // Forgot Password Page
                        ForgotPassword(
                          authPageController: authPageController,
                          authScaffoldKey: _authScaffoldKey,
                          networkErrorSnackBar: networkErrorSnackBar,
                        ),

                        // SignIn Page
                        SignIn(
                          authPageController: authPageController,
                          authScaffoldKey: _authScaffoldKey,
                          networkErrorSnackBar: networkErrorSnackBar,
                        ),

                        // SignUp Page
                        SignUp(
                          authScaffoldKey: _authScaffoldKey,
                          networkErrorSnackBar: networkErrorSnackBar,
                        ),
                      ],
                    ),
                  ),

                  // Change Page Button
                  GestureDetector(
                    onTap: () {
                      if (authPageController.page == 2) {
                        authPageController.previousPage(
                          duration: Duration(milliseconds: 700),
                          curve: Curves.easeInOutCirc,
                        );
                      } else {
                        authPageController.nextPage(
                          duration: Duration(milliseconds: 700),
                          curve: Curves.easeInOutCirc,
                        );
                      }
                    },
                    child: RichText(
                      text: TextSpan(
                        text: preffix[page],
                        style: Theme.of(context).textTheme.headline5,
                        children: <TextSpan>[
                          TextSpan(
                              text: suffix[page],
                              style: Theme.of(context).textTheme.headline4),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}










