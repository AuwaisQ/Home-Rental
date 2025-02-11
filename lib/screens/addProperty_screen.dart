import 'dart:convert';
import 'dart:io';
import 'dart:io' as Io;
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:homerental/core/my_pref.dart';
import 'package:homerental/core/size_config.dart';
import 'package:homerental/core/xcontroller.dart';
import 'package:homerental/models/user_model.dart';
import 'package:homerental/theme.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../models/name_id_model.dart';

class AddProperty extends StatelessWidget {
  final XController x = XController.to;
  final MyPref myPref = MyPref.to;

  AddProperty({Key? key}) : super(key: key) {
    updateUser.value = x.thisUser.value;
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

  final updateUser = UserModel().obs;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainBackgroundcolor,
        leading: IconButton(
            onPressed: ()=> Get.back(),
            icon: Icon(Icons.keyboard_arrow_down,color: Colors.red,size: 40,)),
        title: Text(
          "Add Property",
          style: const TextStyle(
            fontSize: 18,
            color: colorTrans2,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0.1,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 10),
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
    );
  }
}
