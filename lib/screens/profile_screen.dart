import 'dart:convert';
import 'dart:io';
import 'dart:io' as Io;

import 'package:cool_alert/cool_alert.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:homerental/auth/intro_screen.dart';
import 'package:homerental/core/my_pref.dart';
import 'package:homerental/core/size_config.dart';
import 'package:homerental/core/xcontroller.dart';
import 'package:homerental/models/user_model.dart';
import 'package:homerental/pages/feedback_page.dart';
import 'package:homerental/pages/webview_page.dart';
import 'package:homerental/theme.dart';
import 'package:homerental/widgets/action_menu.dart';
import 'package:homerental/widgets/crop_editor_helper.dart';
import 'package:homerental/widgets/icon_back.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../models/name_id_model.dart';

class ProfileScreen extends StatelessWidget {
  final XController x = XController.to;
  final MyPref myPref = MyPref.to;

  ProfileScreen({Key? key}) : super(key: key) {
    updateUser.value = x.thisUser.value;
  }

  final updateUser = UserModel().obs;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: mainBackgroundcolor,
        title: topIcon(),
        elevation: 0.1,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        width: Get.width,
        height: Get.height,
        padding: const EdgeInsets.only(top: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: getProportionateScreenHeight(25)),
              // Container(
              //   alignment: Alignment.center,
              //   child: Obx(
              //     () => profileIcon(updateUser.value),
              //   ),
              // ),
              spaceHeight15,
              Obx(() => displayUserProfile(updateUser.value),),
              SizedBox(height: getProportionateScreenHeight(30)),
              listActions(),
              SizedBox(height: getProportionateScreenHeight(30)),
              InkWell(
                onTap: () =>
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            WebViewPage(
                              title: 'Manal Softech Private Limited',
                              url: 'https://www.manalsoftech.com',
                            ),
                      ),
                    ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/manal.png',
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                    spaceWidth5,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('Developed By'),
                        Text.rich(TextSpan(children: [
                          TextSpan(
                              text: 'Manal '.toUpperCase(),
                              style:
                              const TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(
                              text: 'sof'.toUpperCase(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red)),
                          TextSpan(
                              text: 'tech'.toUpperCase(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              )),
                        ])),
                      ],
                    )
                  ],
                ),
              ),
              // Container(
              //   alignment: Alignment.center,
              //   child: const Text(
              //     "Ver ${MyTheme.appVersion}",
              //     textAlign: TextAlign.center,
              //     style: textSmall,
              //   ),
              // ),
              SizedBox(height: getProportionateScreenHeight(55)),
              SizedBox(height: getProportionateScreenHeight(155)),
            ],
          ),
        ),
      ),
    );
  }

  Widget displayUserProfile(final UserModel thisUser) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.center,
          child: Text(
            "${thisUser.fullname}",
            style: const TextStyle(
                fontWeight: FontWeight.w800, fontSize: 20, letterSpacing: 0.5),
          ),
        ),
        Container(
          alignment: Alignment.center,
          child:
          Text("${thisUser.email}", style: const TextStyle(fontSize: 12)),
        ),
      ],
    );
  }

  final List<dynamic> actions = [
    {"title": "change_fullname".tr, "icon": const Icon(Feather.user)},
    {"title": "change_password".tr, "icon": const Icon(Feather.key)},
    {"title": "Add Property", "icon": const Icon(Feather.plus_circle)},
    {"title": "help_center".tr, "icon": const Icon(Feather.alert_circle)},
    {"title": "Privacy Policy", "icon": const Icon(Feather.paperclip)},
    {"title": "Delete Account", "icon": const Icon(CupertinoIcons.delete)},
    {"title": "Log Out", "icon": const Icon(Feather.log_out)},
  ];

  Widget listActions() {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: actions.map((e) {
        final int index = actions.indexOf(e);
        return ActionMenu(
            text: e['title'],
            icon: e['icon'],
            press: () {
              clickAction(index);
            });
      }).toList(),
    );
  }

  clickAction(final int index) {
    if (index >= actions.length - 1) {
      //LogOut Action
      CoolAlert.show(
          context: Get.context!,
          backgroundColor: Get.theme.canvasColor,
          type: CoolAlertType.confirm,
          text: 'Do you want to logout',
          confirmBtnText: 'Yes',
          cancelBtnText: 'No',
          confirmBtnColor: Colors.green,
          onConfirmBtnTap: () async {
            Get.back();
            x.setIndexBar(0);
            EasyLoading.show(status: 'Loading...');
            await Future.delayed(const Duration(milliseconds: 2200));
            x.doLogout();
            Future.delayed(const Duration(milliseconds: 1000), () {
              EasyLoading.dismiss();
              Get.offAll(IntroScreen());
            });
          });
    } else if (index == 0) {
      //Change Name
      showDialogOptionChangeFullname(XController.to, updateUser.value);
    } else if (index == 1) {
      //Change Password
      showDialogOptionChangePassword(XController.to, updateUser.value);
    } else if (index == 2) {
      showDialogOptionAddProperty(XController.to);
    } else if (index == 3) {
      // Help Center
      launchUrlString('tel:+91${1234567890}');
    } else if (index == 4) {
      //Privacy Policy
      Get.to(WebViewPage(
        title: 'Second Home',
        url: 'https://roomrent.developerzone.in/privacy-policy',
      ),);
    } else if (index == 5) {
      terminateAccount(XController.to);
    } else if (index == 5) {}
  }

  Widget profileIcon(final UserModel thisUser) {
    return Container(
      height: getProportionateScreenHeight(115),
      width: getProportionateScreenWidth(115),
      alignment: AlignmentDirectional.center,
      padding: const EdgeInsets.all(0),
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: ExtendedNetworkImageProvider(
                  "${thisUser.image}",
                  cache: true,
                ),
              ),
            ),
          ),
          Positioned(
            right: -10,
            bottom: -5,
            child: SizedBox(
              height: 44,
              width: 44,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor:
                  Get.theme.colorScheme.background.withOpacity(.9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    //side: BorderSide(color: Colors.white),
                  ),
                ),
                onPressed: () {
                  debugPrint("onclick add photo");
                  showDialogOptionImage();
                },
                child: Icon(
                  Icons.add_a_photo,
                  color: Get.theme.canvasColor,
                  size: 22,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget topIcon() {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 0),
            child: IconBack(callback: () {
              x.setIndexBar(0);
            }),
          ),
          Container(
            padding: const EdgeInsets.only(top: 0),
            child: Text(
              "profile".tr,
              style: const TextStyle(
                fontSize: 18,
                color: colorTrans2,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Get.to(FeedbackPage(), transition: Transition.fade);
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: colorGrey2,
                    style: BorderStyle.solid,
                    width: 0.8,
                  ),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Icon(
                  FontAwesome.edit,
                  size: 16,
                  color: Get.theme.colorScheme.secondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // option change photo
  final picker = ImagePicker();
  final pathImage = ''.obs;

  pickImageSource(int tipe) {
    Future<XFile?> file;
    file = picker.pickImage(
        source: tipe == 1 ? ImageSource.gallery : ImageSource.camera);
    file.then((XFile? pickFile) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (pickFile != null) {
          //startUpload();
          pathImage.value = pickFile.path;
          _cropImage(x, File(pathImage.value));
        }
      });
    });
  }

  final GlobalKey<ExtendedImageEditorState> editorKey =
  GlobalKey<ExtendedImageEditorState>();

  Future _cropImage(final XController x, final File imageFile) async {
    Get.dialog(
      Container(
        padding: const EdgeInsets.all(5),
        width: Get.width,
        height: Get.height / 1.2,
        child: Stack(
          children: [
            ExtendedImage.file(
              imageFile,
              fit: BoxFit.contain,
              mode: ExtendedImageMode.editor,
              extendedImageEditorKey: editorKey,
              cacheRawData: true,
              initEditorConfigHandler: (state) {
                return EditorConfig(
                  maxScale: 8.0,
                  cropRectPadding: const EdgeInsets.all(20.0),
                  hitTestSize: 20.0,
                  cropAspectRatio:
                  CropAspectRatios.original, // update your ratio here
                );
              },
            ),
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                onPressed: () {
                  Get.back();
                  cropAction(x);
                },
                icon: Icon(
                  Feather.check_circle,
                  color: Get.theme.primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  cropAction(final XController x) async {
    final Uint8List fileData = Uint8List.fromList(kIsWeb
        ? (await cropImageDataWithDartLibrary(state: editorKey.currentState!))!
        : (await cropImageDataWithNativeLibrary(
        state: editorKey.currentState!))!);

    final String title = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final String? fileFath =
    await ImageGallerySaver.saveImage(fileData, name: title);

    File tmpFile = File(fileFath!);
    String base64Image = base64Encode(tmpFile.readAsBytesSync());
    String fileName = tmpFile.path.split('/').last;
    Future.microtask(() {
      upload(fileName, base64Image);
    });
  }

  upload(String fileName, String base64Image) async {
    EasyLoading.show(status: "Loading...");

    String? idUser = updateUser.value.id;

    if (idUser == null && idUser == '') {
      return;
    }

    var dataPush = jsonEncode({
      "filename": fileName,
      "id": idUser,
      "image": base64Image,
      "lat": x.latitude,
      "loc": x.location,
    });

    debugPrint(dataPush);
    var path = "upload/upload_image_user";
    //debugPrint(link);

    x.provider.pushResponse(path, dataPush)!.then((result) {
      //debugPrint(result.body);
      dynamic dataresult = jsonDecode(result.bodyString!);
      //debugPrint(_result);

      //EasyLoading.dismiss();
      if (dataresult['code'] == '200') {
        EasyLoading.showSuccess("Process success...");
        String fileUploaded = "${dataresult['result']['file']}";
        debugPrint(fileUploaded);

        x.getUserById();
        Future.delayed(const Duration(seconds: 2), () {
          updateUser.value = x.thisUser.value;
        });
        Future.delayed(const Duration(seconds: 4), () {
          Future.microtask(() {
            x.asyncHome();
          });
          Get.back();
        });
      } else {
        EasyLoading.showError("Process failed...");
      }
    }).catchError((error) {
      debugPrint(error);
      EasyLoading.dismiss();
    });
  }

  showDialogOptionImage() {
    return showCupertinoModalBottomSheet(
      barrierColor: Get.theme.disabledColor.withOpacity(.4),
      context: Get.context!,
      builder: (context) =>
          Container(
            width: Get.width,
            height: Get.height / 2.5,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(15.0),
                topLeft: Radius.circular(15.0),
              ),
              gradient: LinearGradient(
                colors: [
                  mainBackgroundcolor,
                  mainBackgroundcolor2,
                  Colors.white,
                  Colors.white,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomRight,
              ),
            ),
            child: Container(
              width: Get.width,
              height: Get.height,
              padding: const EdgeInsets.only(top: 15),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Container(
                      width: Get.width,
                      height: Get.height,
                      padding:
                      const EdgeInsets.symmetric(vertical: 30, horizontal: 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: Get.width,
                            margin: const EdgeInsets.only(top: 0),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Container(
                              padding: const EdgeInsets.only(
                                  top: 0, bottom: 10),
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(MyTheme.conerRadius),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    "Pick One",
                                    style:
                                    Get.theme.textTheme.headlineSmall!.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          spaceHeight20,
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  Get.back();
                                  pickImageSource(0);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  margin: const EdgeInsets.only(
                                      left: 0, right: 0, bottom: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      Text(
                                        "Camera",
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              spaceWidth10,
                              InkWell(
                                onTap: () {
                                  Get.back();
                                  pickImageSource(1);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  margin: const EdgeInsets.only(
                                      left: 0, right: 0, bottom: 10),
                                  decoration: BoxDecoration(
                                    color: Get.theme.colorScheme.secondary,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      Text(
                                        "Gallery",
                                        style: textBold.copyWith(
                                          color: Get.theme.canvasColor,
                                          fontSize: 14,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          spaceHeight20,
                          spaceHeight20,
                          spaceHeight50,
                          spaceHeight50,
                          spaceHeight50,
                          spaceHeight50,
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      margin: const EdgeInsets.only(top: 0),
                      padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                      child: InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: const Icon(Feather.chevron_down, size: 30)),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  updateLanguageSetting(final XController x, final String lang) async {
    x.myPref.pLang.val = lang;
    await Future.delayed(const Duration(milliseconds: 300), () async {
      Locale locale =
      lang == 'en' ? const Locale('en', 'US') : const Locale('id', 'ID');
      Get.updateLocale(locale);
    });
  }

  terminateAccount(final XController x) {
    return showCupertinoModalBottomSheet(
      barrierColor: Get.theme.disabledColor.withOpacity(.4),
      context: Get.context!,
      builder: (context) =>
          Container(
            width: Get.width,
            height: Get.height / 2,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(15.0),
                topLeft: Radius.circular(15.0),
              ),
              gradient: LinearGradient(
                colors: [
                  mainBackgroundcolor,
                  mainBackgroundcolor2,
                  Colors.white,
                  Colors.white,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomRight,
              ),
            ),
            child: Container(
              width: Get.width,
              height: Get.height,
              padding: const EdgeInsets.only(top: 15),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Container(
                      width: Get.width,
                      height: Get.height,
                      padding:
                      const EdgeInsets.symmetric(vertical: 30, horizontal: 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: Get.width,
                            margin: const EdgeInsets.only(top: 0),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Container(
                              padding: const EdgeInsets.only(
                                  top: 0, bottom: 10),
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(MyTheme.conerRadius),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    "Terminate Account".tr,
                                    style: Get.theme.textTheme.headlineSmall!.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          spaceHeight10,
                          Container(
                            width: Get.width,
                            padding: EdgeInsets.all(10),
                            alignment: Alignment.center,
                            child: Text("Are You Sure You want to terminate your account, this action will delete all your you have provided.",
                              style: Get.theme.textTheme.bodyLarge!.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          spaceHeight10,
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  Get.back();
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  margin: const EdgeInsets.only(
                                      left: 0, right: 0, bottom: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      Text(
                                        "close".tr,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              spaceWidth20,
                              InkWell(
                                onTap: () async {
                                  Get.back();
                                  x.terminateAccount();
                                  EasyLoading.show(status: 'Loading...');
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  margin: const EdgeInsets.only(
                                      left: 0, right: 0, bottom: 10),
                                  decoration: BoxDecoration(
                                    color: Get.theme.colorScheme.secondary,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Terminate",
                                        style: textBold.copyWith(
                                          color: Get.theme.canvasColor,
                                          fontSize: 14,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          spaceHeight20,
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      margin: const EdgeInsets.only(top: 0),
                      padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                      child: InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: const Icon(Feather.chevron_down, size: 30)),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  //change fullName
  final TextEditingController _fullname = TextEditingController();
  showDialogOptionChangeFullname(final XController x, final UserModel thisUser) {
    _fullname.text = '${thisUser.fullname}';

    return showCupertinoModalBottomSheet(
      barrierColor: Get.theme.disabledColor.withOpacity(.4),
      context: Get.context!,
      builder: (context) =>
          Container(
            width: Get.width,
            height: Get.height / 2,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(15.0),
                topLeft: Radius.circular(15.0),
              ),
              gradient: LinearGradient(
                colors: [
                  mainBackgroundcolor,
                  mainBackgroundcolor2,
                  Colors.white,
                  Colors.white,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomRight,
              ),
            ),
            child: Container(
              width: Get.width,
              height: Get.height,
              padding: const EdgeInsets.only(top: 15),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Container(
                      width: Get.width,
                      height: Get.height,
                      padding:
                      const EdgeInsets.symmetric(vertical: 30, horizontal: 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: Get.width,
                            margin: const EdgeInsets.only(top: 0),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Container(
                              padding: const EdgeInsets.only(
                                  top: 0, bottom: 10),
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(MyTheme.conerRadius),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    "change_fullname".tr,
                                    style:
                                    Get.theme.textTheme.headlineSmall!.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          spaceHeight20,
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 0),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(22),
                              gradient: LinearGradient(
                                colors: [
                                  Get.theme.canvasColor,
                                  Get.theme.canvasColor.withOpacity(.98)
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Get.theme.colorScheme.background,
                                  blurRadius: 1.0,
                                  offset: const Offset(1, 2),
                                )
                              ],
                            ),
                            child: SizedBox(
                              width: Get.width,
                              child: TextField(
                                controller: _fullname,
                                keyboardType: TextInputType.multiline,
                                style: const TextStyle(fontSize: 15),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Fullname",
                                ),
                              ),
                            ),
                          ),
                          spaceHeight20,
                          spaceHeight10,
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  Get.back();
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  margin: const EdgeInsets.only(
                                      left: 0, right: 0, bottom: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      Text(
                                        "close".tr,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              spaceWidth10,
                              InkWell(
                                onTap: () async {
                                  String fn = _fullname.text.trim();
                                  if (fn.isEmpty) {
                                    MyTheme.showToast('Fullname invalid!');
                                    return;
                                  }
                                  Get.back();
                                  EasyLoading.show(status: 'Loading...');
                                  x.updateUserById(
                                      'update_about_fullname', 'About Me', fn);
                                  await Future.delayed(
                                      const Duration(milliseconds: 1800), () {
                                    x.getUserById();
                                    Future.delayed(
                                        const Duration(seconds: 2), () {
                                      updateUser.value = x.thisUser.value;
                                    });
                                  });

                                  Future.delayed(
                                      const Duration(milliseconds: 800),
                                          () {
                                        EasyLoading.showSuccess(
                                            'Update successful...');
                                        x.asyncHome();
                                      });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  margin: const EdgeInsets.only(
                                      left: 0, right: 0, bottom: 10),
                                  decoration: BoxDecoration(
                                    color: Get.theme.colorScheme.secondary,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      Text(
                                        "Submit",
                                        style: textBold.copyWith(
                                          color: Get.theme.canvasColor,
                                          fontSize: 14,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          spaceHeight20,
                          spaceHeight20,
                          spaceHeight50,
                          spaceHeight50,
                          spaceHeight50,
                          spaceHeight50,
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      margin: const EdgeInsets.only(top: 0),
                      padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                      child: InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: const Icon(Feather.chevron_down, size: 30)),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  //Add New Property
  final TextEditingController title = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController price = TextEditingController();
  final TextEditingController beds = TextEditingController();
  final TextEditingController baths = TextEditingController();
  final TextEditingController sqft = TextEditingController();

  var stateList = <NameIdModel>[
    NameIdModel(id: 1, name: 'Apartment'),
    NameIdModel(id: 7, name: 'Resort'),
    NameIdModel(id: 3, name: 'House'),
    NameIdModel(id: 4, name: 'Flat'),
    NameIdModel(id: 5, name: 'Premium'),
    NameIdModel(id: 2, name: 'Stay Home'),
  ].obs;

  var categoryId = '1'.obs;
  var image1 = ''.obs;
  var image1Base64 = ''.obs;
  var image2 = ''.obs;
  var image2Base64 = ''.obs;
  var image3 = ''.obs;
  var image3Base64 = ''.obs;
  var image4 = ''.obs;
  var image4Base64 = ''.obs;
  var image5 = ''.obs;
  var image5Base64 = ''.obs;
  var image6 = ''.obs;
  var image6Base64 = ''.obs;

  //Image1
  void getImage1(ImageSource imageSource) async {
    final pickedFile = await ImagePicker().pickImage(source: imageSource);
    if (pickedFile != null) {
      image1.value = pickedFile.path;
      final bytes = await Io.File(image1.value).readAsBytes();
      image1Base64.value = base64Encode(bytes); //Base64 Image
    } else {
      Get.snackbar(
        'Error',
        'No Image Selected',
        margin: const EdgeInsets.all(20),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.primaryColor,
        colorText: Colors.white,
      );
    }
  }
  //Image2
  void getImage2(ImageSource imageSource) async {
    final pickedFile = await ImagePicker().pickImage(source: imageSource);
    if (pickedFile != null) {
      image2.value = pickedFile.path;
      final bytes = await Io.File(image2.value).readAsBytes();
      image2Base64.value = base64Encode(bytes); //Base64 Image
    } else {
      Get.snackbar(
        'Error',
        'No Image Selected',
        margin: const EdgeInsets.all(20),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.primaryColor,
        colorText: Colors.white,
      );
    }
  }
  //Image3
  void getImage3(ImageSource imageSource) async {
    final pickedFile = await ImagePicker().pickImage(source: imageSource);
    if (pickedFile != null) {
      image3.value = pickedFile.path;
      final bytes = await Io.File(image3.value).readAsBytes();
      image3Base64.value = base64Encode(bytes); //Base64 Image
    } else {
      Get.snackbar(
        'Error',
        'No Image Selected',
        margin: const EdgeInsets.all(20),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.primaryColor,
        colorText: Colors.white,
      );
    }
  }
  //Image4
  void getImage4(ImageSource imageSource) async {
    final pickedFile = await ImagePicker().pickImage(source: imageSource);
    if (pickedFile != null) {
      image4.value = pickedFile.path;
      final bytes = await Io.File(image4.value).readAsBytes();
      image4Base64.value = base64Encode(bytes); //Base64 Image
    } else {
      Get.snackbar(
        'Error',
        'No Image Selected',
        margin: const EdgeInsets.all(20),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.primaryColor,
        colorText: Colors.white,
      );
    }
  }
  //Image5
  void getImage5(ImageSource imageSource) async {
    final pickedFile = await ImagePicker().pickImage(source: imageSource);
    if (pickedFile != null) {
      image5.value = pickedFile.path;
      final bytes = await Io.File(image5.value).readAsBytes();
      image5Base64.value = base64Encode(bytes); //Base64 Image
    } else {
      Get.snackbar(
        'Error',
        'No Image Selected',
        margin: const EdgeInsets.all(20),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.primaryColor,
        colorText: Colors.white,
      );
    }
  }
  //Image6
  void getImage6(ImageSource imageSource) async {
    final pickedFile = await ImagePicker().pickImage(source: imageSource);
    if (pickedFile != null) {
      image6.value = pickedFile.path;
      final bytes = await Io.File(image6.value).readAsBytes();
      image6Base64.value = base64Encode(bytes); //Base64 Image
    } else {
      Get.snackbar(
        'Error',
        'No Image Selected',
        margin: const EdgeInsets.all(20),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.primaryColor,
        colorText: Colors.white,
      );
    }
  }

  showDialogOptionAddProperty(final XController x) {
    return showCupertinoModalBottomSheet(
      barrierColor: Get.theme.disabledColor.withOpacity(.4),
      context: Get.context!,
      builder: (context) =>
          Container(
            width: Get.width,
            height: Get.height,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(15.0),
                topLeft: Radius.circular(15.0),
              ),
              gradient: LinearGradient(
                colors: [
                  mainBackgroundcolor,
                  mainBackgroundcolor2,
                  Colors.white,
                  Colors.white,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomRight,
              ),
            ),
            child: Container(
              width: Get.width,
              height: Get.height,
              padding: const EdgeInsets.only(top: 15),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 60),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          //Select Category
                          Container(
                            height: Get.width * 0.15,
                            width: Get.width,
                            margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                            padding: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(22),
                              gradient: LinearGradient(
                                colors: [
                                  Get.theme.canvasColor,
                                  Get.theme.canvasColor.withOpacity(.98)
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Get.theme.colorScheme.background,
                                  blurRadius: 1.0,
                                  offset: const Offset(1, 2),
                                )
                              ],
                            ),
                            child: Obx(() {
                              return Center(
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton2(
                                    dropdownDecoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.grey.shade400),
                                    ),
                                    isExpanded: true,
                                    isDense: true,
                                    hint: Text('Select Category'),
                                    icon: const Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Colors.grey,
                                    ),
                                    onChanged: (value) {
                                      categoryId.value = value.toString();
                                      print(categoryId.value);
                                    },
                                    value: categoryId.value,
                                    items: stateList.map<
                                        DropdownMenuItem<String>>((
                                        NameIdModel value) {
                                      return DropdownMenuItem<String>(
                                        value: value.id.toString(),
                                        child: Text(
                                          value.name,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              );
                            }),
                          ),
                          spaceHeight20,
                          //Title
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(22),
                              gradient: LinearGradient(
                                colors: [
                                  Get.theme.canvasColor,
                                  Get.theme.canvasColor.withOpacity(.98)
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Get.theme.colorScheme.background,
                                  blurRadius: 1.0,
                                  offset: const Offset(1, 2),
                                )
                              ],
                            ),
                            child: SizedBox(
                              width: Get.width,
                              child: TextField(
                                controller: title,
                                keyboardType: TextInputType.text,
                                style: const TextStyle(fontSize: 15),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Title",
                                ),
                              ),
                            ),
                          ),
                          spaceHeight20,
                          //Description
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 0),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(22),
                              gradient: LinearGradient(
                                colors: [
                                  Get.theme.canvasColor,
                                  Get.theme.canvasColor.withOpacity(.98)
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Get.theme.colorScheme.background,
                                  blurRadius: 1.0,
                                  offset: const Offset(1, 2),
                                )
                              ],
                            ),
                            child: SizedBox(
                              width: Get.width,
                              height: Get.height * 0.1,
                              child: TextField(
                                maxLines: 2,
                                controller: description,
                                keyboardType: TextInputType.multiline,
                                style: const TextStyle(fontSize: 15),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Description...",
                                ),
                              ),
                            ),
                          ),
                          spaceHeight20,
                          //Image 1, 2, 3
                          SizedBox(
                            height: Get.width * 0.2,
                            width: Get.width,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25),
                              child: Row(
                                children: [
                                  Expanded(flex: 1, child: InkWell(
                                        onTap: () {
                                          //IMage Picker Dialog
                                          Get.defaultDialog(
                                              middleText: 'Select ',
                                              title: 'Pick Image',
                                              barrierDismissible: true,
                                              radius: 5.0,
                                              confirm: InkWell(
                                                onTap: () {
                                                  Get.back();
                                                  getImage1(
                                                      ImageSource.gallery);
                                                },
                                                child: Card(
                                                  elevation: 5,
                                                  child: Container(
                                                      height: Get.width * 0.25,
                                                      width: Get.width * 0.25,
                                                      decoration: BoxDecoration(
                                                        color:
                                                        Get.theme.primaryColor,
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                        children: const [
                                                          Icon(
                                                            CupertinoIcons
                                                                .photo_on_rectangle,
                                                            size: 50,
                                                            color: Colors.white,
                                                          ),
                                                          Text(
                                                            "Gallery",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 15),
                                                          )
                                                        ],
                                                      )),
                                                ),
                                              ),
                                              cancel: InkWell(
                                                onTap: () {
                                                  Get.back();
                                                  getImage1(ImageSource.camera);
                                                },
                                                child: Card(
                                                  elevation: 5,
                                                  child: Container(
                                                      height: Get.width * 0.25,
                                                      width: Get.width * 0.25,
                                                      decoration: BoxDecoration(
                                                        color:
                                                        Get.theme.primaryColor,
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                        children: const [
                                                          Icon(
                                                            CupertinoIcons
                                                                .camera_on_rectangle,
                                                            size: 50,
                                                            color: Colors.white,
                                                          ),
                                                          Text(
                                                            "Camera",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 15),
                                                          )
                                                        ],
                                                      )),
                                                ),
                                              ));
                                        },
                                        child: Obx(() {
                                          return Container(
                                            padding: EdgeInsets.all(1),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(10),
                                                border: Border.all(
                                                    color: Get.theme
                                                        .primaryColor),
                                                color: Get.theme.primaryColor
                                                    .withOpacity(0.1)),
                                            child: image1.value.isEmpty
                                                ? Center(
                                              child: Icon(
                                                Icons.add_a_photo_outlined,
                                                color: Get.theme.primaryColor,
                                              ),
                                            )
                                                : ClipRRect(
                                                  borderRadius: BorderRadius
                                                      .all(
                                                      Radius.circular(10)),
                                                  child: Image.file(
                                                      height: Get.width * 0.2,
                                                      width: Get.width,
                                                      File(image1.value),
                                                      fit: BoxFit.cover),
                                                ),
                                          );
                                        }),
                                      )),
                                  spaceWidth10,
                                  Expanded(flex: 1, child: InkWell(
                                        onTap: () {
                                          //IMage Picker Dialog
                                          Get.defaultDialog(
                                              middleText: 'Select ',
                                              title: 'Pick Image',
                                              barrierDismissible: true,
                                              radius: 5.0,
                                              confirm: InkWell(
                                                onTap: () {
                                                  Get.back();
                                                  getImage2(
                                                      ImageSource.gallery);
                                                },
                                                child: Card(
                                                  elevation: 5,
                                                  child: Container(
                                                      height: Get.width * 0.25,
                                                      width: Get.width * 0.25,
                                                      decoration: BoxDecoration(
                                                        color:
                                                        Get.theme.primaryColor,
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                        children: const [
                                                          Icon(
                                                            CupertinoIcons
                                                                .photo_on_rectangle,
                                                            size: 50,
                                                            color: Colors.white,
                                                          ),
                                                          Text(
                                                            "Gallery",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 15),
                                                          )
                                                        ],
                                                      )),
                                                ),
                                              ),
                                              cancel: InkWell(
                                                onTap: () {
                                                  Get.back();
                                                  getImage2(ImageSource.camera);
                                                },
                                                child: Card(
                                                  elevation: 5,
                                                  child: Container(
                                                      height: Get.width * 0.25,
                                                      width: Get.width * 0.25,
                                                      decoration: BoxDecoration(
                                                        color:
                                                        Get.theme.primaryColor,
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                        children: const [
                                                          Icon(
                                                            CupertinoIcons
                                                                .camera_on_rectangle,
                                                            size: 50,
                                                            color: Colors.white,
                                                          ),
                                                          Text(
                                                            "Camera",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 15),
                                                          )
                                                        ],
                                                      )),
                                                ),
                                              ));
                                        },
                                        child: Obx(() {
                                          return Container(
                                            padding: EdgeInsets.all(1),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(10),
                                                border: Border.all(
                                                    color: Get.theme
                                                        .primaryColor),
                                                color: Get.theme.primaryColor
                                                    .withOpacity(0.1)),
                                            child: image2.value.isEmpty
                                                ? Center(
                                              child: Icon(
                                                Icons.add_a_photo_outlined,
                                                color: Get.theme.primaryColor,
                                              ),
                                            )
                                                : ClipRRect(
                                                  borderRadius: BorderRadius
                                                      .all(
                                                      Radius.circular(10)),
                                                  child: Image.file(
                                                      height: Get.width * 0.2,
                                                      width: Get.width,
                                                      File(image2.value),
                                                      fit: BoxFit.cover),
                                                ),
                                          );
                                        }),
                                      )),
                                  spaceWidth10,
                                  Expanded(
                                      flex: 1,
                                      child: InkWell(
                                        onTap: () {
                                          //IMage Picker Dialog
                                          Get.defaultDialog(
                                              middleText: 'Select ',
                                              title: 'Pick Image',
                                              barrierDismissible: true,
                                              radius: 5.0,
                                              confirm: InkWell(
                                                onTap: () {
                                                  Get.back();
                                                  getImage3(
                                                      ImageSource.gallery);
                                                },
                                                child: Card(
                                                  elevation: 5,
                                                  child: Container(
                                                      height: Get.width * 0.25,
                                                      width: Get.width * 0.25,
                                                      decoration: BoxDecoration(
                                                        color:
                                                        Get.theme.primaryColor,
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                        children: const [
                                                          Icon(
                                                            CupertinoIcons
                                                                .photo_on_rectangle,
                                                            size: 50,
                                                            color: Colors.white,
                                                          ),
                                                          Text(
                                                            "Gallery",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 15),
                                                          )
                                                        ],
                                                      )),
                                                ),
                                              ),
                                              cancel: InkWell(
                                                onTap: () {
                                                  Get.back();
                                                  getImage3(ImageSource.camera);
                                                },
                                                child: Card(
                                                  elevation: 5,
                                                  child: Container(
                                                      height: Get.width * 0.25,
                                                      width: Get.width * 0.25,
                                                      decoration: BoxDecoration(
                                                        color:
                                                        Get.theme.primaryColor,
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                        children: const [
                                                          Icon(
                                                            CupertinoIcons
                                                                .camera_on_rectangle,
                                                            size: 50,
                                                            color: Colors.white,
                                                          ),
                                                          Text(
                                                            "Camera",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 15),
                                                          )
                                                        ],
                                                      )),
                                                ),
                                              ));
                                        },
                                        child: Obx(() {
                                          return Container(
                                            padding: EdgeInsets.all(1),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(10),
                                                border: Border.all(
                                                    color: Get.theme
                                                        .primaryColor),
                                                color: Get.theme.primaryColor
                                                    .withOpacity(0.1)),
                                            child: image3.value.isEmpty
                                                ? Center(
                                              child: Icon(
                                                Icons.add_a_photo_outlined,
                                                color: Get.theme.primaryColor,
                                              ),
                                            )
                                                : ClipRRect(
                                                  borderRadius: BorderRadius
                                                      .all(
                                                      Radius.circular(10)),
                                                  child: Image.file(
                                                      height: Get.width * 0.2,
                                                      width: Get.width,
                                                      File(image3.value),
                                                      fit: BoxFit.cover),
                                                ),
                                          );
                                        }),
                                      )),
                                ],
                              ),
                            ),
                          ),
                          spaceHeight20,
                          //Image 4, 5, 6
                          SizedBox(
                            height: Get.width * 0.2,
                            width: Get.width,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25),
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: InkWell(
                                        onTap: () {
                                          //IMage Picker Dialog
                                          Get.defaultDialog(
                                              middleText: 'Select ',
                                              title: 'Pick Image',
                                              barrierDismissible: true,
                                              radius: 5.0,
                                              confirm: InkWell(
                                                onTap: () {
                                                  Get.back();
                                                  getImage4(
                                                      ImageSource.gallery);
                                                },
                                                child: Card(
                                                  elevation: 5,
                                                  child: Container(
                                                      height: Get.width * 0.25,
                                                      width: Get.width * 0.25,
                                                      decoration: BoxDecoration(
                                                        color:
                                                        Get.theme.primaryColor,
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                        children: const [
                                                          Icon(
                                                            CupertinoIcons
                                                                .photo_on_rectangle,
                                                            size: 50,
                                                            color: Colors.white,
                                                          ),
                                                          Text(
                                                            "Gallery",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 15),
                                                          )
                                                        ],
                                                      )),
                                                ),
                                              ),
                                              cancel: InkWell(
                                                onTap: () {
                                                  Get.back();
                                                  getImage4(ImageSource.camera);
                                                },
                                                child: Card(
                                                  elevation: 5,
                                                  child: Container(
                                                      height: Get.width * 0.25,
                                                      width: Get.width * 0.25,
                                                      decoration: BoxDecoration(
                                                        color:
                                                        Get.theme.primaryColor,
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                        children: const [
                                                          Icon(
                                                            CupertinoIcons
                                                                .camera_on_rectangle,
                                                            size: 50,
                                                            color: Colors.white,
                                                          ),
                                                          Text(
                                                            "Camera",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 15),
                                                          )
                                                        ],
                                                      )),
                                                ),
                                              ));
                                        },
                                        child: Obx(() {
                                          return Container(
                                            padding: EdgeInsets.all(1),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(10),
                                                border: Border.all(
                                                    color: Get.theme
                                                        .primaryColor),
                                                color: Get.theme.primaryColor
                                                    .withOpacity(0.1)),
                                            child: image4.value.isEmpty
                                                ? Center(
                                              child: Icon(
                                                Icons.add_a_photo_outlined,
                                                color: Get.theme.primaryColor,
                                              ),
                                            )
                                                : ClipRRect(
                                                  borderRadius: BorderRadius
                                                      .all(
                                                      Radius.circular(10)),
                                                  child: Image.file(
                                                      height: Get.width * 0.2,
                                                      width: Get.width,
                                                      File(image4.value),
                                                      fit: BoxFit.cover),
                                                ),
                                          );
                                        }),
                                      )),
                                  spaceWidth10,
                                  Expanded(
                                      flex: 1,
                                      child: InkWell(
                                        onTap: () {
                                          //IMage Picker Dialog
                                          Get.defaultDialog(
                                              middleText: 'Select ',
                                              title: 'Pick Image',
                                              barrierDismissible: true,
                                              radius: 5.0,
                                              confirm: InkWell(
                                                onTap: () {
                                                  Get.back();
                                                  getImage5(
                                                      ImageSource.gallery);
                                                },
                                                child: Card(
                                                  elevation: 5,
                                                  child: Container(
                                                      height: Get.width * 0.25,
                                                      width: Get.width * 0.25,
                                                      decoration: BoxDecoration(
                                                        color:
                                                        Get.theme.primaryColor,
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                        children: const [
                                                          Icon(
                                                            CupertinoIcons
                                                                .photo_on_rectangle,
                                                            size: 50,
                                                            color: Colors.white,
                                                          ),
                                                          Text(
                                                            "Gallery",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 15),
                                                          )
                                                        ],
                                                      )),
                                                ),
                                              ),
                                              cancel: InkWell(
                                                onTap: () {
                                                  Get.back();
                                                  getImage5(ImageSource.camera);
                                                },
                                                child: Card(
                                                  elevation: 5,
                                                  child: Container(
                                                      height: Get.width * 0.25,
                                                      width: Get.width * 0.25,
                                                      decoration: BoxDecoration(
                                                        color:
                                                        Get.theme.primaryColor,
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                        children: const [
                                                          Icon(
                                                            CupertinoIcons
                                                                .camera_on_rectangle,
                                                            size: 50,
                                                            color: Colors.white,
                                                          ),
                                                          Text(
                                                            "Camera",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 15),
                                                          )
                                                        ],
                                                      )),
                                                ),
                                              ));
                                        },
                                        child: Obx(() {
                                          return Container(
                                            padding: EdgeInsets.all(1),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(10),
                                                border: Border.all(
                                                    color: Get.theme
                                                        .primaryColor),
                                                color: Get.theme.primaryColor
                                                    .withOpacity(0.1)),
                                            child: image5.value.isEmpty
                                                ? Center(
                                              child: Icon(
                                                Icons.add_a_photo_outlined,
                                                color: Get.theme.primaryColor,
                                              ),
                                            )
                                                : ClipRRect(
                                                  borderRadius: BorderRadius
                                                      .all(
                                                      Radius.circular(10)),
                                                  child: Image.file(
                                                      height: Get.width * 0.2,
                                                      width: Get.width,
                                                      File(image5.value),
                                                      fit: BoxFit.cover),
                                                ),
                                          );
                                        }),
                                      )),
                                  spaceWidth10,
                                  Expanded(
                                      flex: 1,
                                      child: InkWell(
                                        onTap: () {
                                          //IMage Picker Dialog
                                          Get.defaultDialog(
                                              middleText: 'Select ',
                                              title: 'Pick Image',
                                              barrierDismissible: true,
                                              radius: 5.0,
                                              confirm: InkWell(
                                                onTap: () {
                                                  Get.back();
                                                  getImage6(
                                                      ImageSource.gallery);
                                                },
                                                child: Card(
                                                  elevation: 5,
                                                  child: Container(
                                                      height: Get.width * 0.25,
                                                      width: Get.width * 0.25,
                                                      decoration: BoxDecoration(
                                                        color:
                                                        Get.theme.primaryColor,
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                        children: const [
                                                          Icon(
                                                            CupertinoIcons
                                                                .photo_on_rectangle,
                                                            size: 50,
                                                            color: Colors.white,
                                                          ),
                                                          Text(
                                                            "Gallery",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 15),
                                                          )
                                                        ],
                                                      )),
                                                ),
                                              ),
                                              cancel: InkWell(
                                                onTap: () {
                                                  Get.back();
                                                  getImage6(ImageSource.camera);
                                                },
                                                child: Card(
                                                  elevation: 5,
                                                  child: Container(
                                                      height: Get.width * 0.25,
                                                      width: Get.width * 0.25,
                                                      decoration: BoxDecoration(
                                                        color:
                                                        Get.theme.primaryColor,
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                        children: const [
                                                          Icon(
                                                            CupertinoIcons
                                                                .camera_on_rectangle,
                                                            size: 50,
                                                            color: Colors.white,
                                                          ),
                                                          Text(
                                                            "Camera",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 15),
                                                          )
                                                        ],
                                                      )),
                                                ),
                                              ));
                                        },
                                        child: Obx(() {
                                          return Container(
                                            padding: EdgeInsets.all(1),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(10),
                                                border: Border.all(
                                                    color: Get.theme
                                                        .primaryColor),
                                                color: Get.theme.primaryColor
                                                    .withOpacity(0.1)),
                                            child: image6.value.isEmpty
                                                ? Center(
                                              child: Icon(
                                                Icons.add_a_photo_outlined,
                                                color: Get.theme.primaryColor,
                                              ),
                                            )
                                                : ClipRRect(
                                                  borderRadius: BorderRadius
                                                      .all(
                                                      Radius.circular(10)),
                                                  child: Image.file(
                                                      height: Get.width * 0.2,
                                                      width: Get.width,
                                                      File(image6.value),
                                                      fit: BoxFit.cover),
                                                ),
                                          );
                                        }),
                                      )),
                                ],
                              ),
                            ),
                          ),
                          spaceHeight20,
                          //Address
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 0),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(22),
                              gradient: LinearGradient(
                                colors: [
                                  Get.theme.canvasColor,
                                  Get.theme.canvasColor.withOpacity(.98)
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Get.theme.colorScheme.background,
                                  blurRadius: 1.0,
                                  offset: const Offset(1, 2),
                                )
                              ],
                            ),
                            child: SizedBox(
                              width: Get.width,
                              child: TextField(
                                controller: address,
                                keyboardType: TextInputType.multiline,
                                style: const TextStyle(fontSize: 15),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Address",
                                ),
                              ),
                            ),
                          ),
                          spaceHeight20,
                          //Phone
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 0),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(22),
                              gradient: LinearGradient(
                                colors: [
                                  Get.theme.canvasColor,
                                  Get.theme.canvasColor.withOpacity(.98)
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Get.theme.colorScheme.background,
                                  blurRadius: 1.0,
                                  offset: const Offset(1, 2),
                                )
                              ],
                            ),
                            child: SizedBox(
                              width: Get.width,
                              child: TextField(
                                controller: phone,
                                keyboardType: TextInputType.multiline,
                                style: const TextStyle(fontSize: 15),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Phone",
                                ),
                              ),
                            ),
                          ),
                          spaceHeight20,
                          //beds
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 0),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(22),
                              gradient: LinearGradient(
                                colors: [
                                  Get.theme.canvasColor,
                                  Get.theme.canvasColor.withOpacity(.98)
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Get.theme.colorScheme.background,
                                  blurRadius: 1.0,
                                  offset: const Offset(1, 2),
                                )
                              ],
                            ),
                            child: SizedBox(
                              width: Get.width,
                              child: TextField(
                                controller: beds,
                                keyboardType: TextInputType.multiline,
                                style: const TextStyle(fontSize: 15),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "No. of Bed Rooms",
                                ),
                              ),
                            ),
                          ),
                          spaceHeight20,
                          //baths
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 0),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(22),
                              gradient: LinearGradient(
                                colors: [
                                  Get.theme.canvasColor,
                                  Get.theme.canvasColor.withOpacity(.98)
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Get.theme.colorScheme.background,
                                  blurRadius: 1.0,
                                  offset: const Offset(1, 2),
                                )
                              ],
                            ),
                            child: SizedBox(
                              width: Get.width,
                              child: TextField(
                                controller: baths,
                                keyboardType: TextInputType.multiline,
                                style: const TextStyle(fontSize: 15),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "No. of Bathrooms",
                                ),
                              ),
                            ),
                          ),
                          spaceHeight20,
                          //sqft
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 0),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(22),
                              gradient: LinearGradient(
                                colors: [
                                  Get.theme.canvasColor,
                                  Get.theme.canvasColor.withOpacity(.98)
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Get.theme.colorScheme.background,
                                  blurRadius: 1.0,
                                  offset: const Offset(1, 2),
                                )
                              ],
                            ),
                            child: SizedBox(
                              width: Get.width,
                              child: TextField(
                                controller: sqft,
                                keyboardType: TextInputType.multiline,
                                style: const TextStyle(fontSize: 15),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "SQFT",
                                ),
                              ),
                            ),
                          ),
                          spaceHeight20,
                          //Price
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 0),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(22),
                              gradient: LinearGradient(
                                colors: [
                                  Get.theme.canvasColor,
                                  Get.theme.canvasColor.withOpacity(.98)
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Get.theme.colorScheme.background,
                                  blurRadius: 1.0,
                                  offset: const Offset(1, 2),
                                )
                              ],
                            ),
                            child: SizedBox(
                              width: Get.width,
                              child: TextField(
                                controller: price,
                                keyboardType: TextInputType.multiline,
                                style: const TextStyle(fontSize: 15),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Price",
                                ),
                              ),
                            ),
                          ),
                          spaceHeight20,
                          //Submit & Close button
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  image1.value = '';
                                  image2.value = '';
                                  image3.value = '';
                                  image4.value = '';
                                  image5.value = '';
                                  image6.value = '';
                                  Get.back();
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  margin: const EdgeInsets.only(
                                      left: 0, right: 0, bottom: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      Text(
                                        "close".tr,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              spaceWidth10,
                              InkWell(
                                onTap: () async {
                                  String titleString = title.text.trim();
                                  String descriptionString = description.text.trim();
                                  String addressString = address.text.trim();
                                  String phoneString = phone.text.trim();
                                  String priceString = price.text.trim();
                                  String bedsString = beds.text.trim();
                                  String bathsString = baths.text.trim();
                                  String sqftString = sqft.text.trim();
                                  if (titleString.isEmpty &&
                                  descriptionString.isEmpty &&
                                  addressString.isEmpty &&
                                  phoneString.isEmpty &&
                                  priceString.isEmpty &&
                                  bedsString.isEmpty &&
                                  bathsString.isEmpty &&
                                  sqftString.isEmpty) {
                                    MyTheme.showToast('Some Field is empty!');
                                    return;
                                  }
                                  Get.back();
                                  EasyLoading.show(status: 'Loading...');
                                  debugPrint('Add Property triggered');
                                  x.addProperty(
                                    categoryId.value,
                                    title.text,
                                    description.text,
                                    image1Base64.value,
                                    image2Base64.value,
                                    image3Base64.value,
                                    image4Base64.value,
                                    image5Base64.value,
                                    image6Base64.value,
                                    address.text,
                                    phone.text,
                                    beds.text,
                                    baths.text,
                                    sqft.text,
                                    price.text
                                  );
                                  Future.delayed(const Duration(seconds: 15), () {
                                    Get.back();
                                    image1.value = '';
                                    image2.value = '';
                                    image3.value = '';
                                    image4.value = '';
                                    image5.value = '';
                                    image6.value = '';
                                    categoryId.value = '1';
                                    title.clear();
                                    description.clear();
                                    address.clear();
                                    phone.clear();
                                    beds.clear();
                                    baths.clear();
                                    sqft.clear();
                                    price.clear();
                                    EasyLoading.dismiss();
                                      });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                  margin: const EdgeInsets.only(left: 0, right: 0, bottom: 10),
                                  decoration: BoxDecoration(
                                    color: Get.theme.colorScheme.secondary,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Submit",
                                        style: textBold.copyWith(
                                          color: Get.theme.canvasColor,
                                          fontSize: 14,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          spaceHeight50,
                          spaceHeight50,
                          spaceHeight50,
                          spaceHeight50,
                          spaceHeight50,
                          spaceHeight50,
                          spaceHeight50,
                        ],
                      ),
                    ),
                  ),
                  //Back Button
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      margin: const EdgeInsets.only(top: 0),
                      padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                      child: Row(
                        children: [
                          InkWell(
                              onTap: () {
                                image1.value = '';
                                image2.value = '';
                                image3.value = '';
                                image4.value = '';
                                image5.value = '';
                                image6.value = '';
                                Get.back();
                              },
                              child: const Icon(Feather.chevron_down, size: 30)),
                        ],
                      ),
                    ),
                  ),
                  //Header Text
                  Container(
                    alignment: Alignment.topCenter,
                    width: Get.width,
                    margin: const EdgeInsets.only(top: 0),
                    padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    child: Text(
                      "Add Property".tr,
                      style: Get.theme.textTheme.headlineSmall!.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  //change password
  final TextEditingController _oldPass = TextEditingController();
  final TextEditingController _newPass = TextEditingController();
  final TextEditingController _newRePass = TextEditingController();
  showDialogOptionChangePassword(final XController x, final UserModel thisUser) {
    _oldPass.text = '';
    _newPass.text = '';
    _newRePass.text = '';

    return showCupertinoModalBottomSheet(
      barrierColor: Get.theme.disabledColor.withOpacity(.4),
      context: Get.context!,
      builder: (context) =>
          Container(
            width: Get.width,
            height: Get.height / 1.3,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(15.0),
                topLeft: Radius.circular(15.0),
              ),
              gradient: LinearGradient(
                colors: [
                  mainBackgroundcolor,
                  mainBackgroundcolor2,
                  Colors.white,
                  Colors.white,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomRight,
              ),
            ),
            child: Container(
              width: Get.width,
              height: Get.height,
              padding: const EdgeInsets.only(top: 15),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Container(
                      width: Get.width,
                      height: Get.height,
                      padding:
                      const EdgeInsets.symmetric(vertical: 30, horizontal: 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: Get.width,
                            margin: const EdgeInsets.only(top: 0),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Container(
                              padding: const EdgeInsets.only(
                                  top: 0, bottom: 10),
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(MyTheme.conerRadius),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    "change_password".tr,
                                    style:
                                    Get.theme.textTheme.headlineSmall!.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          spaceHeight20,
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 0),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(22),
                              gradient: LinearGradient(
                                colors: [
                                  Get.theme.canvasColor,
                                  Get.theme.canvasColor.withOpacity(.98)
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Get.theme.colorScheme.background,
                                  blurRadius: 1.0,
                                  offset: const Offset(1, 2),
                                )
                              ],
                            ),
                            child: SizedBox(
                              width: Get.width,
                              child: TextField(
                                controller: _oldPass,
                                keyboardType: TextInputType.text,
                                style: const TextStyle(fontSize: 15),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Old Password",
                                ),
                              ),
                            ),
                          ),
                          spaceHeight10,
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 0),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(22),
                              gradient: LinearGradient(
                                colors: [
                                  Get.theme.canvasColor,
                                  Get.theme.canvasColor.withOpacity(.98)
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Get.theme.colorScheme.background,
                                  blurRadius: 1.0,
                                  offset: const Offset(1, 2),
                                )
                              ],
                            ),
                            child: SizedBox(
                              width: Get.width,
                              child: TextField(
                                controller: _newPass,
                                keyboardType: TextInputType.text,
                                style: const TextStyle(fontSize: 15),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "New Password",
                                ),
                              ),
                            ),
                          ),
                          spaceHeight10,
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 0),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(22),
                              gradient: LinearGradient(
                                colors: [
                                  Get.theme.canvasColor,
                                  Get.theme.canvasColor.withOpacity(.98)
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Get.theme.colorScheme.background,
                                  blurRadius: 1.0,
                                  offset: const Offset(1, 2),
                                )
                              ],
                            ),
                            child: SizedBox(
                              width: Get.width,
                              child: TextField(
                                controller: _newRePass,
                                keyboardType: TextInputType.text,
                                style: const TextStyle(fontSize: 15),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Retype New Password",
                                ),
                              ),
                            ),
                          ),
                          spaceHeight20,
                          spaceHeight10,
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  Get.back();
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  margin: const EdgeInsets.only(
                                      left: 0, right: 0, bottom: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      Text(
                                        "close".tr,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              spaceWidth10,
                              InkWell(
                                onTap: () async {
                                  String op = _oldPass.text.trim();
                                  String np = _newPass.text.trim();
                                  String rp = _newRePass.text.trim();
                                  if (op.isEmpty) {
                                    MyTheme.showToast('Old Password invalid!');
                                    return;
                                  }

                                  if (np.isEmpty || np.length < 6) {
                                    MyTheme.showToast(
                                        'New Password invalid! Min. 6 alphanumeric');
                                    return;
                                  }

                                  if (rp.isEmpty || rp.length < 6) {
                                    MyTheme.showToast(
                                        'Retype New Password invalid! Min. 6 alphanumeric');
                                    return;
                                  }

                                  if (np != rp) {
                                    MyTheme.showToast(
                                        'New Password  not equal');
                                    return;
                                  }

                                  if (op != x.myPref.pPassword.val) {
                                    MyTheme.showToast('Old Password  is wrong');
                                    return;
                                  }

                                  Get.back();
                                  EasyLoading.show(status: 'Loading...');
                                  x.updateUserById('change_password', op, np);
                                  await Future.delayed(
                                      const Duration(milliseconds: 1800));

                                  Future.delayed(
                                      const Duration(milliseconds: 800),
                                          () {
                                        EasyLoading.showSuccess(
                                            'Update successful...');
                                        x.setIndexBar(0);
                                        x.doLogout();

                                        Future.delayed(
                                            const Duration(
                                                milliseconds: 1000), () {
                                          EasyLoading.dismiss();
                                          Get.offAll(IntroScreen());
                                        });
                                      });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  margin: const EdgeInsets.only(
                                      left: 0, right: 0, bottom: 10),
                                  decoration: BoxDecoration(
                                    color: Get.theme.colorScheme.secondary,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      Text(
                                        "Submit",
                                        style: textBold.copyWith(
                                          color: Get.theme.canvasColor,
                                          fontSize: 14,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          spaceHeight20,
                          spaceHeight20,
                          spaceHeight50,
                          spaceHeight50,
                          spaceHeight50,
                          spaceHeight50,
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      margin: const EdgeInsets.only(top: 0),
                      padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                      child: InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: const Icon(Feather.chevron_down, size: 30)),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
