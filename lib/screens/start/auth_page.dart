import 'package:extended_image/extended_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tomato_record/constants/shared_pref_keys.dart';
import 'package:tomato_record/states/user_notifier.dart';
import '../../constants/common_size.dart';
import '../../utils/logger.dart';

class AuthPage extends StatefulWidget {
  AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

const duration = Duration(milliseconds: 300);

class _AuthPageState extends State<AuthPage> {
  final inputBorder = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey),
  );

  final TextEditingController _phoneNumberController =
      TextEditingController(text: '010');

  final TextEditingController _codeController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  VerificationStatus _verificationStatus = VerificationStatus.none;

  String? _verficationId;

  int? _forceResendingToken;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        Size size = MediaQuery.of(context).size;

        return IgnorePointer(
          ignoring: _verificationStatus == VerificationStatus.verifying,
          child: Form(
            key: _formKey,
            child: Scaffold(
              appBar: AppBar(
                title: Text('전화번호 로그인'),
              ),
              body: Padding(
                padding: const EdgeInsets.all(common_padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        ExtendedImage.asset(
                          'assets/imgs/padlock.png',
                          width: size.width * 0.15,
                        ),
                        SizedBox(
                          width: common_s_padding,
                        ),
                        Text(
                          '''토마토 마켓은 휴대폰 번호로 가입해요.
          번호는 안전하게 보관되며
          어디에도 공개되지 않아요.''',
                        ),
                      ],
                    ),
                    SizedBox(
                      height: common_padding,
                    ),
                    TextFormField(
                      controller: _phoneNumberController,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [MaskedInputFormatter("000 0000 0000")],
                      decoration: InputDecoration(
                          focusedBorder: inputBorder, border: inputBorder),
                      validator: (phoneNumber) {
                        if (phoneNumber != null && phoneNumber.length == 13) {
                          return null;
                        } else {
                          return '전화번호 제대로 입력해주세요';
                        }
                      },
                    ),
                    SizedBox(
                      height: common_s_padding,
                    ),
                    TextButton(
                      onPressed: () async {
                        if (_verificationStatus ==
                            VerificationStatus.codesending) {
                          return;
                        }
                        _getAddress();
                        if (_formKey.currentState != null) {
                          bool passed = _formKey.currentState!.validate();
                          if (passed) {
                            String phoneNumber = _phoneNumberController.text;
                            phoneNumber = phoneNumber.replaceAll(' ', '');
                            phoneNumber = phoneNumber.replaceFirst('0', '');

                            FirebaseAuth auth = FirebaseAuth.instance;

                            setState(() {
                              _verificationStatus =
                                  VerificationStatus.codesending;
                            });

                            await auth.verifyPhoneNumber(
                              phoneNumber: '+82$phoneNumber',
                              forceResendingToken: _forceResendingToken,
                              verificationCompleted:
                                  (PhoneAuthCredential credential) async {
                                await auth.signInWithCredential(credential);
                              },
                              codeAutoRetrievalTimeout:
                                  (String verificationId) {},
                              codeSent: (String verificationId,
                                  int? forceResendingToken) async {
                                _verficationId = verificationId;
                                _forceResendingToken = forceResendingToken;
                                setState(() {
                                  _verificationStatus =
                                      VerificationStatus.codesent;
                                });
                              },
                              verificationFailed:
                                  (FirebaseAuthException error) {
                                logger.e(error.message);
                                setState(() {
                                  _verificationStatus = VerificationStatus.none;
                                });
                              },
                            );
                          }
                        }
                      },
                      child: (_verificationStatus ==
                              VerificationStatus.codesending)
                          ? SizedBox(
                              width: 26,
                              height: 26,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : Text('인증문자 발송'),
                    ),
                    SizedBox(
                      height: common_padding,
                    ),
                    AnimatedOpacity(
                      duration: duration,
                      opacity: _verificationStatus == VerificationStatus.none
                          ? 0
                          : 1,
                      curve: Curves.easeInOut,
                      child: AnimatedContainer(
                        duration: duration,
                        curve: Curves.easeInOut,
                        height: getVerificationHeight(_verificationStatus),
                        child: TextFormField(
                          controller: _codeController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [MaskedInputFormatter("000000")],
                          decoration: InputDecoration(
                              focusedBorder: inputBorder, border: inputBorder),
                          // validator: (verificationNumber) {
                          //   if (verificationNumber != null &&
                          //       verificationNumber.length == 6) {
                          //     return null;
                          //   } else {
                          //     return '인증번호를 확인해주세요.';
                          //   }
                          // },
                        ),
                      ),
                    ),
                    AnimatedContainer(
                      height: getVerificationBtnHeight(_verificationStatus),
                      duration: duration,
                      curve: Curves.easeInOut,
                      child: TextButton(
                        onPressed: () {
                          attemptVerify();
                        },
                        child: (_verificationStatus ==
                                VerificationStatus.verifying)
                            ? CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text('인증하기'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  double getVerificationHeight(VerificationStatus status) {
    switch (status) {
      case VerificationStatus.none:
        return 0;
      case VerificationStatus.codesending:
      case VerificationStatus.codesent:
      case VerificationStatus.verifying:
      case VerificationStatus.verificationDone:
        return 60 + common_s_padding;
    }
  }

  double getVerificationBtnHeight(VerificationStatus status) {
    switch (status) {
      case VerificationStatus.none:
        return 0;
      case VerificationStatus.codesending:
      case VerificationStatus.codesent:
      case VerificationStatus.verifying:
      case VerificationStatus.verificationDone:
        return 48;
    }
  }

  void attemptVerify() async {
    setState(() {
      _verificationStatus = VerificationStatus.verifying;
    });

    try {
      // Create a PhoneAuthCredential with the code
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: _verficationId!, smsCode: _codeController.text);

      // Sign the user in (or link) with the credential
      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      logger.e('verification failed!!');
      SnackBar snackBar = SnackBar(content: Text('인증번호가 올바르지 않습니다.'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    setState(() {
      _verificationStatus = VerificationStatus.verificationDone;
    });
  }

  _getAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String address = prefs.getString(SHARED_ADDRESS) ?? "";
    double lat = prefs.getDouble(SHARED_LAT) ?? 0;
    double lon = prefs.getDouble(SHARED_LON) ?? 0;
  }
}

enum VerificationStatus {
  none,
  codesending,
  codesent,
  verifying,
  verificationDone,
}
