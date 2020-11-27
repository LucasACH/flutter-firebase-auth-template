import 'package:auth_demo/authService.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  SignIn({
    Key key,
    @required this.authPageController,
    @required this.authScaffoldKey,
    @required this.networkErrorSnackBar,
  }) : super(key: key);

  final PageController authPageController;
  final GlobalKey<ScaffoldState> authScaffoldKey;
  final SnackBar networkErrorSnackBar;

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController emailTextField = TextEditingController();
  final TextEditingController passwordTextField = TextEditingController();
  final GlobalKey<FormState> _signInFormKey = GlobalKey<FormState>();

  // Run Action When Loading
  bool loading = false;

  // Map For Displaying Erorr Messages
  Map<String, String> errorMessage = {
    "email": "",
    "password": "",
    "network": "",
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Form(
        key: _signInFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 3,
            ),
            TextFormField(
              controller: emailTextField,
              autocorrect: false,
              enableSuggestions: false,
              keyboardType: TextInputType.emailAddress,
              cursorColor: Theme.of(context).accentColor,
              obscureText: false,
              style: Theme.of(context).textTheme.headline5,
              decoration: InputDecoration(labelText: "Email"),
              validator: (email) {
                if (email.isEmpty) {
                  return "Please enter an email adress";
                } else if (email.contains("@") == false) {
                  return "Invalid email adress";
                } else if (errorMessage["email"].isNotEmpty) {
                  return errorMessage["email"];
                }
                return null;
              },
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: passwordTextField,
              autocorrect: false,
              enableSuggestions: false,
              keyboardType: TextInputType.visiblePassword,
              cursorColor: Theme.of(context).accentColor,
              obscureText: true,
              style: Theme.of(context).textTheme.headline5,
              decoration: InputDecoration(labelText: "Password"),
              validator: (password) {
                if (password.isEmpty) {
                  return "Please enter a password";
                } else if (errorMessage["password"].isNotEmpty) {
                  return errorMessage["password"];
                }
                return null;
              },
            ),
            SizedBox(
              height: 10,
            ),

            // Forgot Password Button
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                GestureDetector(
                  onTap: () => widget.authPageController.previousPage(
                    duration: Duration(milliseconds: 700),
                    curve: Curves.easeInOutCirc,
                  ),
                  child: Text(
                    "Forgot Password?",
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),

            // Sign In Button
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: loading
                    ? Container(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).scaffoldBackgroundColor),
                        ),
                      )
                    : Text("Sign In"),
                onPressed: () async {
                  setState(() {
                    errorMessage["email"] = "";
                    errorMessage["netwrok"] = "";
                    errorMessage["password"] = "";
                  });

                  // 1. Check Form Validation
                  // 2. Set State "loading" = true
                  // 3. Call "signIn" Future inside AuthService()
                  // 4. Catch NetworkError - Show SnackBar
                  // 5. Set State "errorMessage" = value
                  // 6. Check Form Validation Again
                  // 7. If Valid => Home

                  if (_signInFormKey.currentState.validate()) {
                    setState(() {
                      loading = true;
                    });
                    await AuthService()
                        .signIn(emailTextField.text, passwordTextField.text)
                        .then((value) {
                      if (value["network"].isNotEmpty) {
                        widget.authScaffoldKey.currentState
                            .showSnackBar(widget.networkErrorSnackBar);
                        setState(() {
                          loading = false;
                        });
                      }
                      setState(() {
                        errorMessage = value;
                        loading = false;
                      });
                    });
                    _signInFormKey.currentState.validate();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
