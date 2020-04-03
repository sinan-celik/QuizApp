// import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:rebuilder/rebuilder.dart';
// import 'package:quiz_app/login/CustomIcons.dart';
// import 'package:momentum/Screens/Profile.dart';
import 'package:quiz_app/login/SocialIcons.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quiz_app/login/login_api.dart';
import 'package:quiz_app/src/datamodels/app_data.dart';
import 'package:quiz_app/src/models/models.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:toast/toast.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

bool _signUpActive = false;
bool _signInActive = true;
// var facebookLogin = FacebookLogin();
TextEditingController _emailController = TextEditingController();
TextEditingController _passwordController = TextEditingController();
TextEditingController _newEmailController = TextEditingController();
TextEditingController _newPasswordController = TextEditingController();
TextEditingController _newNameController = TextEditingController();
TextEditingController _newPhoneController = TextEditingController();
// final FirebaseAuth _auth = FirebaseAuth.instance;

TextInputType textInputType = TextInputType.phone;

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: [
    'email',
    // 'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

GoogleSignInAccount _account;
AppModel _appModel;
BuildContext _buildContext;
final storage = FlutterSecureStorage();

// var email = 'tony@starkindustries.com';
// bool emailValid = RegExp(
//         r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
//     .hasMatch(email);


// class LoginPageWidget extends StatelessWidget {
//   LoginPageWidget({Key key}) : super(key: key);

//   Widget build(BuildContext context) {
//     return MaterialApp(
//         theme: _buildDarkTheme(),
//         home: Scaffold(
//           resizeToAvoidBottomPadding: true,
//           body:  Builder(
//               builder: (context) =>  Container(
//                     decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                             begin: Alignment.topCenter,
//                             end: Alignment.bottomCenter,
//                             colors: [
//                           Theme.of(context).primaryColor,
//                           Theme.of(context).primaryColorLight
//                         ])),
//                     child: Padding(
//                       padding: EdgeInsets.only(top: 40.0),
//                       //Sets the main padding all widgets has to adhere to.
//                       child: LogInPage(),
//                     ),
//                   )),
//         ));
//   }
// }

class _LogInPageState extends StateMVC<LogInPage> {
  _LogInPageState() : super(Controller());

  @override
  Widget build(BuildContext context) {
    final appModel = DataModelProvider.of<AppModel>(context);
    _appModel = appModel;
    _buildContext = context;

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: true);
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          AppBar(
            centerTitle: true,
            title: const Text(
              'Bağlan',
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => _appModel.tab.value = AppTab.main,
            ),
          ),
          // Container(
          //   child: Padding(
          //       padding: EdgeInsets.only(top: 2.0),
          //       child: Column(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: <Widget>[
          //           // Text(Controller.displayLogoTitle,
          //           //     style: CustomTextStyle.title(context)),
          //           // Text(
          //           //   Controller.displayLogoSubTitle,
          //           //   style: CustomTextStyle.subTitle(context),
          //           // ),
          //         ],
          //       )),
          //   width: ScreenUtil().setWidth(750),
          //   height: ScreenUtil().setHeight(190),
          // ),
          // SizedBox(
          //   height: ScreenUtil().setHeight(60),
          // ),
          Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: IntrinsicWidth(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    OutlineButton(
                      onPressed: () => setState(Controller.changeToSignIn),
                      borderSide: const BorderSide(
                        style: BorderStyle.none,
                      ),
                      child: Text(Controller.displaySignInMenuButton,
                          style: _signInActive
                              ? TextStyle(
                                  fontSize: 22,
                                  color: Theme.of(context).accentColor,
                                  fontWeight: FontWeight.bold)
                              : TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).accentColor,
                                  fontWeight: FontWeight.normal)),
                    ),
                    OutlineButton(
                      onPressed: () => setState(Controller.changeToSignUp),
                      borderSide: const BorderSide(
                        style: BorderStyle.none,
                      ),
                      child: Text(Controller.displaySignUpMenuButton,
                          style: _signUpActive
                              ? TextStyle(
                                  fontSize: 22,
                                  color: Theme.of(context).accentColor,
                                  fontWeight: FontWeight.bold)
                              : TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).accentColor,
                                  fontWeight: FontWeight.normal)),
                    )
                  ],
                ),
              ),
            ),
            width: ScreenUtil().setWidth(750),
            height: ScreenUtil().setHeight(170),
          ),
          SizedBox(
            height: ScreenUtil().setHeight(10),
          ),
          Container(
            child: Padding(
                padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                child: _signInActive ? _showSignIn(context) : _showSignUp()),
            width: ScreenUtil().setWidth(750),
            height: ScreenUtil().setHeight(778),
          ),
        ],
      ),
    );
  }

  Widget _showSignIn(context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: ScreenUtil().setHeight(30),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.only(),
              child: TextField(
                style: TextStyle(color: Theme.of(context).accentColor),
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: Controller.displayHintTextEmail,
                  hintStyle: CustomTextStyle.formField(context),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).accentColor, width: 1.0)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).accentColor, width: 1.0)),
                  prefixIcon: const Icon(
                    FontAwesomeIcons.envelope,
                    color: Colors.white,
                  ),
                ),
                obscureText: false,
                keyboardType: TextInputType.emailAddress,
              ),
            ),
          ),
          SizedBox(
            height: ScreenUtil().setHeight(1),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.only(),
              child: TextField(
                obscureText: true,
                style: TextStyle(color: Theme.of(context).accentColor),
                controller: _passwordController,
                decoration: InputDecoration(
                  //Add th Hint text here.
                  hintText: Controller.displayHintTextPassword,
                  hintStyle: CustomTextStyle.formField(context),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).accentColor, width: 1.0)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).accentColor, width: 1.0)),
                  prefixIcon: const Icon(
                    FontAwesomeIcons.unlockAlt,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: ScreenUtil().setHeight(40),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.only(),
              child: RaisedButton(
                  child: Row(
                    children: <Widget>[
                      const SocialIcon(iconData: FontAwesomeIcons.envelope),
                      Expanded(
                        child: Text(
                          Controller.displaySignInEmailButton,
                          textAlign: TextAlign.center,
                          style: CustomTextStyle.button(context),
                        ),
                      )
                    ],
                  ),
                  color: Colors.blueGrey,
                  onPressed: () => {
                        Scaffold.of(context).showSnackBar(SnackBar(
                          duration: const Duration(seconds: 10),
                          content: Row(
                            children: <Widget>[
                              const CircularProgressIndicator(),
                              const Text('  Giriş Yapılıyor...')
                            ],
                          ),
                        )),
                        Controller.tryToLogInUserViaEmail(
                            context, _emailController, _passwordController)
                      }
                  // onPressed: () => {},
                  ),
            ),
          ),
          SizedBox(
            height: ScreenUtil().setHeight(30),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.only(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  horizontalLine(),
                  Text(Controller.displaySeparatorText,
                      style: CustomTextStyle.body(context)),
                  horizontalLine()
                ],
              ),
            ),
          ),
          SizedBox(
            height: ScreenUtil().setHeight(30),
          ),
          Container(
            child: Padding(
                padding: const EdgeInsets.only(),
                child: RaisedButton(
                  child: Row(
                    children: <Widget>[
                      SocialIcon(iconData: FontAwesomeIcons.google),
                      Expanded(
                        child: Text(
                          Controller.displaySignInGoogleButton,
                          textAlign: TextAlign.center,
                          style: CustomTextStyle.button(context),
                        ),
                      )
                    ],
                  ),
                  color: const Color(0xFF3C5A99),
                  onPressed: () => {Controller.handleGoogleSignIn(context)},
                )),
          ),
          SizedBox(
            height: ScreenUtil().setHeight(30),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.only(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  horizontalLine(),
                  Text(Controller.displaySeparatorText,
                      style: CustomTextStyle.body(context)),
                  horizontalLine()
                ],
              ),
            ),
          ),
          SizedBox(
            height: ScreenUtil().setHeight(30),
          ),
          Container(
            child: Padding(
                padding: const EdgeInsets.only(),
                child: RaisedButton(
                  child: Row(
                    children: <Widget>[
                      SocialIcon(iconData: FontAwesomeIcons.facebook),
                      Expanded(
                        child: Text(
                          Controller.displaySignInFacebookButton,
                          textAlign: TextAlign.center,
                          style: CustomTextStyle.button(context),
                        ),
                      )
                    ],
                  ),
                  color: const Color(0xFF3C5A99),
                  onPressed: () => {},
                )),
          ),
        ],
      );

  Widget _showSignUp() => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            child: Padding(
              padding: const EdgeInsets.only(),
              child: TextField(
                obscureText: false,
                style: CustomTextStyle.formField(context),
                controller: _newNameController,
                decoration: InputDecoration(
                  //Add th Hint text here.
                  hintText: Controller.displayHintTextNewName,
                  hintStyle: CustomTextStyle.formField(context),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).accentColor, width: 1.0)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).accentColor, width: 1.0)),
                  prefixIcon: const Icon(
                    Icons.person_add,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.only(),
              child: TextField(
                inputFormatters: [
                  WhitelistingTextInputFormatter(RegExp('[0-9]')),
                ],
                obscureText: false,
                style: CustomTextStyle.formField(context),
                controller: _newPhoneController,
                decoration: InputDecoration(
                  //Add th Hint text here.
                  hintText: Controller.displayHintTextNewPhone,
                  hintStyle: CustomTextStyle.formField(context),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).accentColor, width: 1.0)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).accentColor, width: 1.0)),
                  prefixIcon: const Icon(
                    Icons.phone_android,
                    color: Colors.white,
                  ),
                ),
                keyboardType: TextInputType.phone,
              ),
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.only(),
              child: TextField(
                // inputFormatters: [WhitelistingTextInputFormatter(RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")),],
                obscureText: false,
                style: CustomTextStyle.formField(context),
                controller: _newEmailController,
                decoration: InputDecoration(
                  //Add th Hint text here.
                  hintText: Controller.displayHintTextNewEmail,
                  hintStyle: CustomTextStyle.formField(context),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).accentColor, width: 1.0)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).accentColor, width: 1.0)),
                  prefixIcon: const Icon(
                    Icons.email,
                    color: Colors.white,
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.only(),
              child: TextField(
                obscureText: true,
                style: CustomTextStyle.formField(context),
                controller: _newPasswordController,
                decoration: InputDecoration(
                  //Add the Hint text here.
                  hintText: Controller.displayHintTextNewPassword,
                  hintStyle: CustomTextStyle.formField(context),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).accentColor, width: 1.0)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).accentColor, width: 1.0)),
                  prefixIcon: const Icon(
                    Icons.lock,
                    color: Colors.white,
                  ),
                ),
                // keyboardType: TextInputType.visiblePassword,
              ),
            ),
          ),
          SizedBox(
            height: ScreenUtil().setHeight(30),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.only(),
              child: RaisedButton(
                child: Text(
                  Controller.displaySignUpMenuButton,
                  style: CustomTextStyle.button(context),
                ),
                color: Colors.blueGrey,
                onPressed: () => {
                  Scaffold.of(context).showSnackBar(SnackBar(
                    duration: Duration(seconds: 10),
                    content: Row(
                      children: <Widget>[
                        CircularProgressIndicator(),
                        Text("  Kayıt Gerçekleştiriliyor...")
                      ],
                    ),
                  )),
                  // Future.delayed(Duration(seconds: 3), () {
                  Controller.signUpWithEmailAndPassword(
                      _newEmailController,
                      _newPasswordController,
                      _newNameController,
                      _newPhoneController)
                  // .whenComplete(() => {
                  //       // // Navigator.of(context).pushNamed("/Home")
                  //       // Scaffold.of(context).removeCurrentSnackBar()
                  //     })
                  // }),
                },
              ),
            ),
          ),
        ],
      );

  Widget horizontalLine() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Container(
          width: ScreenUtil().setWidth(120),
          height: 1.0,
          color: Colors.white.withOpacity(0.6),
        ),
      );

  Widget emailErrorText() => Text(Controller.displayErrorEmailLogIn);
}

class LogInPage extends StatefulWidget {
  const LogInPage({Key key}) : super(key: key);

  @protected
  @override
  State<StatefulWidget> createState() => _LogInPageState();
}

class Controller extends ControllerMVC {
  /// Singleton Factory
  factory Controller() {
    // if (_this == null) _this = Controller._();
    _this ??= Controller._();
    return _this;
  }

  Controller._();
  static Controller _this;

  /// Allow for easy access to 'the Controller' throughout the application.
  static Controller get con => _this;

  /// The Controller doesn't know any values or methods. It simply handles the communication between the view and the model.

  // static String get displayLogoTitle => Model._logoTitle;

  // static String get displayLogoSubTitle => Model._logoSubTitle;

  static String get displaySignUpMenuButton => Model._signUpMenuButton;

  static String get displaySignInMenuButton => Model._signInMenuButton;

  static String get displayHintTextEmail => Model._hintTextEmail;

  static String get displayHintTextPassword => Model._hintTextPassword;

  static String get displayHintTextNewEmail => Model._hintTextNewEmail;

  static String get displayHintTextNewPassword => Model._hintTextNewPassword;
  static String get displayHintTextNewName => Model._hintTextNewName;
  static String get displayHintTextNewPhone => Model._hintTextNewPhone;

  static String get displaySignUpButtonTest => Model._signUpButtonText;

  static String get displaySignInEmailButton =>
      Model._signInWithEmailButtonText;

  static String get displaySignInGoogleButton =>
      Model._signInWithGoogleButtonText;

  static String get displaySignInFacebookButton =>
      Model._signInWithFacebookButtonText;

  static String get displaySeparatorText =>
      Model._alternativeLogInSeparatorText;

  static String get displayErrorEmailLogIn => Model._emailLogInFailed;

  static void changeToSignUp() => Model._changeToSignUp();

  static void changeToSignIn() => Model._changeToSignIn();

  static Future<bool> signInWithFacebook(context) =>
      Model._signInWithFacebook(context);

  static Future<bool> handleGoogleSignIn(context) =>
      Model._handleGoogleSignIn(context);

  static Future<bool> signInWithEmail(context, email, password) =>
      Model._signInWithEmail(context, email, password);

  static Future<bool> signUpWithEmailAndPassword(
      email, password, name, phone) async {
    Model._signUpWithEmailAndPassword(email, password, name, phone);
  }

  // static Future navigateToProfile(context) => Model._navigateToProfile(context);

  // static Future tryToLogInUserViaFacebook(context) async {
  //   if (await signInWithFacebook(context) == true) {
  //     navigateToProfile(context);
  //   }
  // }

  static Future tryToLogInUserViaEmail(context, email, password) async {
    if (await signInWithEmail(context, email, password) == true) {
      // navigateToProfile(context);
    }
  }

  static Future tryToSignUpWithEmail(email, password) async {
    if (await tryToSignUpWithEmail(email, password) == true) {
      //TODO Display success message or go to Login screen
    } else {
      //TODO Display error message and stay put.
    }
  }
}

class Model {
  // static String _logoTitle = "MOMENTUM";
  // static String _logoSubTitle = "GROWTH * HAPPENS * TODAY";
  static const String _signInMenuButton = 'Giriş Yap';
  static const String _signUpMenuButton = 'Kaydol';

  static const String _hintTextEmail = 'e-posta';
  static const String _hintTextPassword = 'şifre';

  static const String _hintTextNewEmail = 'E-posta adresiniz';
  static const String _hintTextNewPassword = 'Şifreniz';
  static const String _hintTextNewName = 'Adınız';
  static const String _hintTextNewPhone = 'Telefonunuz';
  static const String _signUpButtonText = 'Kaydol';

  static const String _signInWithEmailButtonText = 'E-posta ile giriş yap';
  static const String _signInWithGoogleButtonText = 'Google ile giriş yap';
  static const String _signInWithFacebookButtonText = 'Facebook ile giriş yap';
  static const String _alternativeLogInSeparatorText = 'ya da';

  static const String _emailLogInFailed =
      'Email or Password was incorrect. Please try again';

  static void _changeToSignUp() {
    _signUpActive = true;
    _signInActive = false;
  }

  static void _changeToSignIn() {
    _signUpActive = false;
    _signInActive = true;
  }

  static Future<bool> _signInWithFacebook(context) async {
    // final FacebookLoginResult result =
    // await facebookLogin.logInWithReadPermissions(['email']);

    // final AuthCredential credential = FacebookAuthProvider.getCredential(
    //   accessToken: result.accessToken.token,
    // );
    // final FirebaseUser user =
    //     (await _auth.signInWithCredential(credential)).user;
    // assert(user.email != null);
    // assert(user.displayName != null);
    // assert(!user.isAnonymous);
    // assert(await user.getIdToken() != null);

    // final FirebaseUser currentUser = await _auth.currentUser();
    // assert(user.uid == currentUser.uid);
    // if (user != null) {
    //   print('Successfully signed in with Facebook. ' + user.uid);
    //   return true;
    // } else {
    //   print('Failed to sign in with Facebook. ');
    //   return false;
    // }
  }

  static Future<bool> _signInWithEmail(context, TextEditingController email,
      TextEditingController password) async {
    try {
      final loginApi = LoginApi();
      var result1 = loginApi
          .loginUserWithEmail(
        email: email.text.trim().toLowerCase(),
        pass: password.text,
      )
          .then((result2) {
        if (result2.statusCode == 200) {
          final jsonResult = jsonDecode(result2.body);
          storage.write(key: 'token', value: jsonResult['token']);
          storage.write(key: 'email', value: email.text.trim().toLowerCase());
          storage.write(key: 'loginType', value: 'email');

          Toast.show('Giriş yapıldı...', context,
              duration: 4,
              gravity: Toast.TOP,
              backgroundColor: Colors.green,
              backgroundRadius: 5);
        } else {
          Toast.show('${jsonDecode(result2.body)}', context,
              duration: 7,
              gravity: Toast.TOP,
              backgroundColor: Colors.red,
              backgroundRadius: 5);
        }
        Scaffold.of(context).removeCurrentSnackBar();
        print(result2.body);
      });

      return true;
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  static Future<bool> _signUpWithEmailAndPassword(
      TextEditingController email,
      TextEditingController password,
      TextEditingController name,
      TextEditingController phone) async {
    try {
      final loginApi = LoginApi();
      var result1 = loginApi
          .registerUserWithEmail(
              email: email.text.trim().toLowerCase(),
              pass: password.text,
              name: name.text,
              phone: phone.text)
          .then((result2) {
        if (result2.statusCode == 200) {
          Toast.show(
              'Kaydınız başarıyla gerçekleşti. \r\nŞimdi giriş yapabilirsiniz',
              _buildContext,
              duration: 4,
              gravity: Toast.TOP,
              backgroundColor: Colors.green,
              backgroundRadius: 5);
        } else {
          Toast.show('${jsonDecode(result2.body)}', _buildContext,
              duration: 7,
              gravity: Toast.TOP,
              backgroundColor: Colors.red,
              backgroundRadius: 5);
        }
        Scaffold.of(_buildContext).removeCurrentSnackBar();
        print(result2.statusCode);
      });

      return true;
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  static Future<bool> _handleGoogleSignIn(BuildContext context) async {
    try {
      _account = await _googleSignIn.signIn();
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text(_account.email)));

      _appModel.tab.value = AppTab.main;
      //  _account.
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  // static Future _navigateToProfile(context) async {
  //   await Navigator.push(
  //       context, MaterialPageRoute(builder: (context) => Profile()));
  // }
}

// ThemeData _buildDarkTheme() {
//   final baseTheme = ThemeData(
//     fontFamily: "Open Sans",
//   );
//   return baseTheme.copyWith(
//     brightness: Brightness.dark,
//     primaryColor: Color(0xFF143642),
//     primaryColorLight: Color(0xFF26667d),
//     primaryColorDark: Color(0xFF08161b),
//     primaryColorBrightness: Brightness.dark,
//     accentColor: Colors.white,
//   );
// }

class CustomTextStyle {
  static TextStyle formField(BuildContext context) =>
      Theme.of(context).textTheme.title.copyWith(
          fontSize: 18.0, fontWeight: FontWeight.normal, color: Colors.white);

  static TextStyle title(BuildContext context) => Theme.of(context)
      .textTheme
      .title
      .copyWith(fontSize: 34, fontWeight: FontWeight.bold, color: Colors.white);

  static TextStyle subTitle(BuildContext context) =>
      Theme.of(context).textTheme.title.copyWith(
          fontSize: 14, fontWeight: FontWeight.normal, color: Colors.white);

  static TextStyle button(BuildContext context) =>
      Theme.of(context).textTheme.title.copyWith(
          fontSize: 20, fontWeight: FontWeight.normal, color: Colors.white);

  static TextStyle body(BuildContext context) =>
      Theme.of(context).textTheme.title.copyWith(
          fontSize: 14, fontWeight: FontWeight.normal, color: Colors.white);
}
