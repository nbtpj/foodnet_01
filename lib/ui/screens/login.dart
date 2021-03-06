import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodnet_01/ui/components/custom_button.dart';
import 'package:foodnet_01/ui/components/custom_text_field.dart';
import 'package:foodnet_01/util/constants/animations.dart';
import 'package:foodnet_01/util/constants/colors.dart';
import 'package:foodnet_01/util/constants/strings.dart';
import 'package:foodnet_01/util/data.dart';
import 'package:foodnet_01/util/entities.dart';
import 'package:foodnet_01/util/enum.dart';
import 'package:foodnet_01/util/extensions.dart';
import 'package:foodnet_01/util/validations.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool loading = false;
  bool validate = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? email, password, name;
  FocusNode nameFN = FocusNode();
  FocusNode emailFN = FocusNode();
  FocusNode passFN = FocusNode();
  FormMode formMode = FormMode.LOGIN;

  login() async {
    FormState form = formKey.currentState!;
    form.save();
    if (!form.validate()) {
      validate = true;
      setState(() {});
      showInSnackBar('Please fix the errors in red before submitting.');
    } else {
      if (formMode == FormMode.LOGIN) {
        try {
          await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: email!, password: password!);
        } on FirebaseAuthException catch (e) {
          if (e.code == 'user-not-found') {
            showInSnackBar(noUserFoundString);
          } else if (e.code == 'wrong-password') {
            showInSnackBar(wrongPassString);
          }
        }
      } else if (formMode == FormMode.REGISTER) {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email!, password: password!)
            .then((result) {
          result.user!.updateDisplayName(name!);
          ProfileData newProfile = ProfileData(
              id: result.user!.uid,
              name: name!,
              userAsset:
                  "https://firebasestorage.googleapis.com/v0/b/mobile-foodnet.appspot.com/o/profile%2Favatar_default.jpeg?alt=media&token=56e50943-98e5-44d8-9590-235569b96fe3",
              wallAsset:
                  "https://firebasestorage.googleapis.com/v0/b/mobile-foodnet.appspot.com/o/profile%2Fwall_default.png?alt=media&token=64c186ba-bf3a-44db-a501-ccfdcc80fa2f");
          createNewProfile(newProfile);
        }).catchError((e) {
          if (e.code == 'weak-password') {
            showInSnackBar(weakPassString);
          } else if (e.code == 'email-already-in-use') {
            showInSnackBar(emailExistString);
          }
        });
      } else {
        await FirebaseAuth.instance
            .sendPasswordResetEmail(email: email!)
            .then((value) {
          showInSnackBar(resetPassString);
        }).catchError((e) {
          if (e.code == 'user-not-found') {
            showInSnackBar(noUserFoundString);
          }
        });
      }
    }
  }

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: Row(
        children: [
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                  child: buildFormContainer(context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildLottieContainer(BuildContext context) {
    final screenWidth = min(
        MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);
    return Expanded(
      child: SizedBox(
          width: screenWidth * 0.5,
          height: screenWidth * 0.5,
          child: Center(
              child: Image.asset(
            AppAnimations.appAnimation,
            fit: BoxFit.contain,
          ))),
    );
  }

  buildFormContainer(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        buildLottieContainer(context),
        const Text(
          appName,
          style: TextStyle(
            fontSize: 40.0,
            fontWeight: FontWeight.bold,
          ),
        ).fadeInList(0, false),
        const SizedBox(height: 60.0),
        Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: formKey,
          child: buildForm(),
        ),
        Visibility(
          visible: formMode == FormMode.LOGIN,
          child: Column(
            children: [
              const SizedBox(height: 10.0),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    formMode = FormMode.FORGOT_PASSWORD;
                    setState(() {});
                  },
                  child: Text(
                    forgotPassword,
                    style: TextStyle(
                      color: buttonColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ).fadeInList(3, false),
        const SizedBox(height: 20.0),
        buildButton(),
        const SizedBox(height: 10.0),
        Visibility(
          visible: formMode == FormMode.LOGIN,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(account),
              InkWell(
                onTap: () {
                  formMode = FormMode.REGISTER;
                  setState(() {});
                },
                child: Text(
                  registerString,
                  style: TextStyle(color: buttonColor),
                ),
              ),
            ],
          ),
        ).fadeInList(5, false),
        Visibility(
          visible: formMode != FormMode.LOGIN,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(haveAccount),
              InkWell(
                onTap: () {
                  formMode = FormMode.LOGIN;
                  setState(() {});
                },
                child: Text(
                  loginString,
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  buildForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Visibility(
          visible: formMode == FormMode.REGISTER,
          child: Column(
            children: [
              CustomTextField(
                enabled: !loading,
                hintText: name_string,
                textInputAction: TextInputAction.next,
                validateFunction: Validations.validateName,
                onSaved: (String? val) {
                  name = val;
                },
                focusNode: nameFN,
                nextFocusNode: emailFN,
              ),
              const SizedBox(height: 20.0),
            ],
          ),
        ),
        CustomTextField(
          enabled: !loading,
          hintText: "Email",
          textInputAction: TextInputAction.next,
          validateFunction: Validations.validateEmail,
          onSaved: (String? val) {
            email = val;
          },
          focusNode: emailFN,
          nextFocusNode: passFN,
        ).fadeInList(1, false),
        Visibility(
          visible: formMode != FormMode.FORGOT_PASSWORD,
          child: Column(
            children: [
              const SizedBox(height: 20.0),
              CustomTextField(
                enabled: !loading,
                hintText: passwordString,
                textInputAction: TextInputAction.done,
                validateFunction: Validations.validatePassword,
                submitAction: login,
                obscureText: true,
                onSaved: (String? val) {
                  password = val;
                },
                focusNode: passFN,
              ),
            ],
          ),
        ).fadeInList(2, false),
      ],
    );
  }

  buildButton() {
    return Visibility(
      visible: !loading,
      replacement: const Center(child: CircularProgressIndicator()),
      child: CustomButton(
        label: formMode,
        onPressed: login,
        color: buttonColor,
      ).fadeInList(4, false),
    );
  }
}
