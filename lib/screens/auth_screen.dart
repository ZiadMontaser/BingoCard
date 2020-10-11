import 'package:bingo_card/providers/auth.dart';
import 'package:bingo_card/providers/avatars.dart';
import 'package:bingo_card/screens/avaters_screen.dart';
import 'package:bingo_card/widgets/my_avatar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

enum AuthScreenMode {
  GamerTag,
  EmailPass,
}

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth';

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with TickerProviderStateMixin {
  String emailRegExp =
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";
  String passwordRegExp =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';

  AuthScreenMode mode = AuthScreenMode.GamerTag;
  AnimationController _leftControl;
  Animation<Offset> leftSlideAnimation;

  AnimationController _rightControl;
  Animation<Offset> rightSlideAnimation;

  String avatarUrl;
  TextEditingController gamerTagController = TextEditingController();
  Map<String, String> input = {
    'email': '',
    'password': '',
  };

  GlobalKey<FormState> _form = GlobalKey<FormState>();

  @override
  void dispose() {
    _leftControl.dispose();
    _rightControl.dispose();
    gamerTagController.dispose();
    // _form.currentState.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _leftControl = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    leftSlideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(-2, 0),
    ).animate(CurvedAnimation(
      parent: _leftControl,
      curve: Curves.easeIn,
    ));

    _rightControl = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    rightSlideAnimation = Tween<Offset>(
      end: Offset.zero,
      begin: Offset(-2, 0),
    ).animate(CurvedAnimation(
      parent: _rightControl,
      curve: Curves.linear,
    ));
  }

  void onGamerTagPressed() async {
    if (avatarUrl == null) {
      avatarUrl = await Avatars.of(context, listen: false).getRandom();
      print(avatarUrl);
    }
    _rightControl.forward();
    _leftControl.forward();
    mode = AuthScreenMode.EmailPass;
  }

  void save(BuildContext context) async {
    if (!_form.currentState.validate()) return;

    _form.currentState.save();

    try {
      await Auth.of(context, listen: false).signUp(
        input['email'],
        input['password'],
        gamerTagController.text,
        avatarUrl,
      );
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (error) {
      print(error.toString());
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message
              .replaceFirst('com.google.firebase.FirebaseException:', '')),
        ),
      );
    }
  }

  Future<bool> onBackPressed() async {
    if (mode == AuthScreenMode.GamerTag)
      return true;
    else {
      _leftControl.reverse();
      _rightControl.reverse();
      mode = AuthScreenMode.GamerTag;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final query = MediaQuery.of(context);
    AppBar appBar = AppBar();
    double pageHight =
        query.size.height - appBar.preferredSize.height - query.padding.top - 0;
    return WillPopScope(
      onWillPop: onBackPressed,
      child: Scaffold(
        appBar: AppBar(),
        body: Container(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              height: pageHight,
              child: Stack(children: [
                buildEmailPassScreen(context),
                buildGamerTagScreen(context)
              ]),
            ),
          ),
        ),
      ),
    );
  }

  SlideTransition buildEmailPassScreen(BuildContext context) {
    return SlideTransition(
      position: rightSlideAnimation,
      textDirection: TextDirection.rtl,
      child: Form(
        key: _form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              children: [
                MyAvatar(
                  url: avatarUrl,
                  radius: 35,
                ),
                SizedBox(
                  width: 32,
                ),
                Text('Hi, ${gamerTagController.text}'),
              ],
            ),
            Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                  ),
                  onSaved: (newValue) {
                    input['email'] = newValue;
                  },
                  validator: (email) {
                    bool isValid = RegExp(emailRegExp).hasMatch(email);
                    if (isValid) return null;
                    return 'Please Enter a valid Email';
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Password',
                  ),
                  onSaved: (password) {
                    input['password'] = password;
                  },
                  validator: (password) {
                    if (password.isEmpty) {
                      return 'Please Enter a Password';
                    } else if (!RegExp(r'^(?=.*[A-Z])||(?=.*[a-z])')
                        .hasMatch(password)) {
                      return 'Password Should contain letters';
                    } else if (!RegExp(r'^(?=.*?[0-9])').hasMatch(password)) {
                      return 'Password Should contain numbers';
                    } else if (password.length < 8) {
                      return 'Password is too short';
                    }
                    return null;
                  },
                ),
              ],
            ),
            LayoutBuilder(
              builder: (context, constraints) => FlatButton(
                  onPressed: () => save(context),
                  child: Text('Lets Play'),
                  color: Theme.of(context).accentColor,
                  textColor: Colors.white),
            )
          ],
        ),
      ),
    );
  }

  SlideTransition buildGamerTagScreen(BuildContext context) {
    return SlideTransition(
      position: leftSlideAnimation,
      child: Container(
        color: Theme.of(context).canvasColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              children: [
                MyAvatar(
                  radius: 50,
                  icon: Icons.add,
                  url: avatarUrl,
                  onTap: () async {
                    final url = await Navigator.of(context)
                        .pushNamed(AvatersListScreen.routeName);
                    avatarUrl = url;
                  },
                ),
                SizedBox(width: 32),
                Expanded(
                  child: TextField(
                    controller: gamerTagController,
                    keyboardAppearance: Brightness.dark,
                    decoration: InputDecoration(
                      labelText: 'Gamer Tag',
                    ),
                    maxLength: 20,
                  ),
                ),
              ],
            ),
            FlatButton.icon(
              label: Text(
                'I Am done',
                style: TextStyle(
                  // fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              icon: Icon(
                Icons.arrow_back,
                size: 24,
              ),
              onPressed: onGamerTagPressed,
              textColor: Colors.white,
              padding: EdgeInsets.all(8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(const Radius.circular(15))),
              color: Theme.of(context).primaryColor,
            )
          ],
        ),
      ),
    );
  }
}
