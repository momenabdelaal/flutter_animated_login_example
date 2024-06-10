import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

import 'Animated_login.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Artboard? riveArtBoard;
  late RiveAnimationController controllerIdle;
  late RiveAnimationController controllerHandsUp;
  late RiveAnimationController controllerHandsDown;
  late RiveAnimationController controllerSuccess;
  late RiveAnimationController controllerFail;
  late RiveAnimationController controllerLookDownRight;
  late RiveAnimationController controllerLookDownLeft;
  late RiveAnimationController controllerLookIdle;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String testEmail = "bibomomen@gmail.com";
  String testPassword = "123456";
  final passwordFocusNode = FocusNode();
  bool isLockLeft = false;
  bool isLockRight = false;

  void removeAllController() {
    riveArtBoard?.artboard.removeController(controllerIdle);
    riveArtBoard?.artboard.removeController(controllerHandsUp);
    riveArtBoard?.artboard.removeController(controllerHandsDown);
    riveArtBoard?.artboard.removeController(controllerSuccess);
    riveArtBoard?.artboard.removeController(controllerFail);
    riveArtBoard?.artboard.removeController(controllerLookDownRight);
    riveArtBoard?.artboard.removeController(controllerLookDownLeft);
    riveArtBoard?.artboard.removeController(controllerLookIdle);
    isLockLeft = false;
    isLockRight = false;
  }

  void addControllerIdle() {
    removeAllController();
    riveArtBoard?.addController(controllerIdle);
  }

  void addControllerHandsDown() {
    removeAllController();
    riveArtBoard?.addController(controllerHandsDown);
  }

  void addControllerHandsUp() {
    removeAllController();
    riveArtBoard?.addController(controllerHandsUp);
  }

  void addControllerSuccess() {
    removeAllController();
    riveArtBoard?.addController(controllerSuccess);
  }

  void addControllerFail() {
    removeAllController();
    riveArtBoard?.addController(controllerFail);
  }

  void addControllerLookDownRight() {
    removeAllController();
    isLockRight = true;
    riveArtBoard?.addController(controllerLookDownRight);
  }

  void addControllerLookDownLeft() {
    removeAllController();
    isLockLeft = true;
    riveArtBoard?.addController(controllerLookDownLeft);
  }

  void addControllerLookIdle() {
    removeAllController();
    riveArtBoard?.addController(controllerLookIdle);
  }

  void checkForPasswordFocusNodeToChangeAnimationState() {
    passwordFocusNode.addListener(() {
      if (passwordFocusNode.hasFocus) {
        addControllerHandsUp();
      } else if (!passwordFocusNode.hasFocus) {
        addControllerHandsDown();
      }
    });
  }

  void validateEmailAndPassword() {
    if (formKey.currentState!.validate()) {
      addControllerSuccess();
    } else {
      addControllerFail();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controllerIdle = SimpleAnimation(AnimationEnum.idle.name);
    controllerHandsUp = SimpleAnimation(AnimationEnum.Hands_up.name);
    controllerHandsDown = SimpleAnimation(AnimationEnum.hands_down.name);
    controllerSuccess = SimpleAnimation(AnimationEnum.success.name);
    controllerFail = SimpleAnimation(AnimationEnum.fail.name);
    controllerLookDownRight =
        SimpleAnimation(AnimationEnum.Look_down_right.name);
    controllerLookDownLeft = SimpleAnimation(AnimationEnum.Look_down_left.name);
    controllerLookIdle = SimpleAnimation(AnimationEnum.look_idle.name);
    rootBundle.load('assets/animated_login_screen.riv').then((data) {
      final file = RiveFile.import(data);
      final artBoard = file.mainArtboard;
      artBoard.addController(controllerIdle);
      setState(() {
        riveArtBoard = artBoard;
      });
    });
    checkForPasswordFocusNodeToChangeAnimationState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Animated Login"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width / 20),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 20),
              child: Column(children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 3,
                  child: riveArtBoard == null
                      ? const SizedBox.shrink()
                      : Rive(artboard: riveArtBoard!),
                ),
                Form(
                    key: formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              )),
                          validator: (value) =>
                              value != testEmail ? "Wrong Email" : null,
                          onChanged: (value) {
                            if (value.isNotEmpty &&
                                value.length < 16 &&
                                !isLockLeft) {
                              addControllerLookDownLeft();
                            } else if (value.isNotEmpty &&
                                value.length > 16 &&
                                !isLockRight) {
                              addControllerLookDownRight();
                            }
                          },
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 25,
                        ),
                        TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(
                              labelText: "Password",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              )),
                          focusNode: passwordFocusNode,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 18,
                        ),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(),
                          child: TextButton(
                            style: TextButton.styleFrom(
                                shape: const StadiumBorder(),
                                backgroundColor: Colors.blue,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14)),
                            onPressed: () {},
                            child: const Text(
                              'Login',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    ))
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
