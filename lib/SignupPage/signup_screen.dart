// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sahada2_app/Services/global_methods.dart';

import '../Services/global_variables.dart';

class SignUp extends StatefulWidget {
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> with TickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _animationController;

  final TextEditingController _fullNameController =TextEditingController(text: " ");
  final TextEditingController _emailTextController =TextEditingController(text: " ");
  final TextEditingController _passTextController = TextEditingController(text: " ");
  final TextEditingController _phoneNumberController = TextEditingController(text: " ");



  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passFocusNode = FocusNode();
  final FocusNode _phoneNumberFocusNode = FocusNode();
  final FocusNode _positionCPFocusNode = FocusNode();



  final _signUpFromKey = GlobalKey<FormState>();
  bool _obscureText =true;
  File? imageFile;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading= false;
  String? imageUrl;

  @override
  void dispose() {
    _animationController.dispose();
    _fullNameController.dispose();
    _emailTextController.dispose();
    _passTextController.dispose();
    _phoneNumberController.dispose();
    _emailFocusNode.dispose();
    _passFocusNode.dispose();
    _positionCPFocusNode.dispose();
    _phoneNumberFocusNode.dispose();
    super.dispose();
  }
  void _showImageDialog(){
    showDialog(context:context,builder: (context){
      return AlertDialog(
        title: Text("Lütfen seçiniz"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: (){
                // create get from camera
                _getFromCamera();
              },
              child: Row(
                children: const [
                  Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Icon(
                      Icons.camera,
                      color: Colors.purple,

                    ),
                  ),
                  Text(
                    "Kamera",
                    style: TextStyle(color: Colors.purple),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: (){
                // create get from gallery
                _getFromGallery();
              },
              child: Row(
                children: const [
                  Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Icon(
                      Icons.image,
                      color: Colors.purple,

                    ),
                  ),
                  Text(
                    "Galeri",
                    style: TextStyle(color: Colors.purple),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
  void _getFromCamera() async{
    XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    _cropImage(pickedFile!.path);
    Navigator.pop(context);
  }

  void _getFromGallery() async{
    XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    _cropImage(pickedFile!.path);
    Navigator.pop(context);
  }

  void _cropImage(filePath) async{
    CroppedFile? croppedImage = await ImageCropper().cropImage(
        sourcePath: filePath, maxHeight: 1080, maxWidth: 1080
    );
    if(croppedImage != null){
      setState(() {
        imageFile = File(croppedImage.path);
      });
    }
  }

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 20));
    _animation =
    CurvedAnimation(parent: _animationController, curve: Curves.linear)
      ..addListener(() {})
      ..addStatusListener((animationStatus) {
        if (animationStatus == AnimationStatus.completed) {
          _animationController.reset();
          _animationController.forward();
        }
      });
    _animationController.forward();
    super.initState();
  }
  void _submitFormOnSignUp() async{

    final isValid = _signUpFromKey.currentState!.validate();
    if(isValid){
      if(imageFile == null){
        GlobalMethod.showErrorDialog(
          error: "Lütfen fotoğraf seçiniz",
          ctx: context,
        );
        return;
      }
      setState(() {
        _isLoading = true;
      });

      try{
        await _auth.createUserWithEmailAndPassword(
          email: _emailTextController.text.trim().toLowerCase(),
          password: _passTextController.text.trim(),
        );
        final User? user = _auth.currentUser;
        final _uid = user!.uid;
        final ref = FirebaseStorage.instance.ref().child("userImages").child(_uid + ".jpg");
        await ref.putFile(imageFile!);
        imageUrl = await ref.getDownloadURL();
        FirebaseFirestore.instance.collection("users").doc(_uid).set({
          "id": _uid,
          "name": _fullNameController.text,
          "email": _emailTextController.text,
          "userImage": imageUrl,
          "phoneNumber": _phoneNumberController.text,
          "createdAt": Timestamp.now(),
        });
        Navigator.canPop(context) ? Navigator.of(context) : null;

      }catch (error){
        setState(() {
          _isLoading = false;
        });
        GlobalMethod.showErrorDialog(error: error.toString(), ctx: context);
      }
    }
    setState(() {
      _isLoading = false;
    });

  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: signUpUrlImage,
            placeholder: (context, url) => Image.asset(
              "sahada_assets/images/wallpaper.jpg",
              fit: BoxFit.fill,
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            alignment: FractionalOffset(_animation.value, 0),
          ),
          Container(
              color: Colors.black54,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 80),
                child: ListView(
                  children: [
                    Form(
                      key: _signUpFromKey,
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _showImageDialog();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                  width: size.width * 0.17,
                                  height: size.height * 0.17,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1,
                                      color: Colors.cyanAccent,
                                    ),
                                    borderRadius: BorderRadius.circular(200),
                                  ),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: imageFile == null
                                          ? const Icon(
                                        Icons.camera_enhance_sharp,
                                        color: Colors.cyan,
                                        size: 30,
                                      )
                                          : Image.file(
                                        imageFile!,
                                        fit: BoxFit.fill,
                                      ))),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          //name

                          //İSİM
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () => FocusScope.of(context)
                                .requestFocus(_emailFocusNode),
                            keyboardType: TextInputType.name,
                            controller: _fullNameController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "İsim alanı eksik";
                              } else {
                                return null;
                              }
                            },
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              labelText: 'İsim' ,
                              hintText: 'Full name' ,
                              hintStyle: TextStyle(color: Colors.white),
                              labelStyle: TextStyle(color: Colors.white),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),

                          //email
                          /*TextFormField(
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () => FocusScope.of(context)
                                .requestFocus(_passFocusNode),
                            keyboardType: TextInputType.emailAddress,
                            controller: _emailTextController,
                            validator: (value) {
                              if (value!.isEmpty || !value.contains("@")) {
                                return "Lütfen geçerli bir email adresi giriniz";
                              } else {
                                return null;
                              }
                            },
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              labelText: 'Email' ,
                              hintText: 'Email',
                              hintStyle: TextStyle(color: Colors.white),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                              ),
                            ),
                          ),*/
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () => FocusScope.of(context)
                                .requestFocus(_emailFocusNode),
                            keyboardType: TextInputType.name,
                            controller: _emailTextController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Lütfen geçerli bir email adersi giriniz";
                              } else {
                                return null;
                              }
                            },
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              labelText: 'Email' ,
                              hintText: 'Email' ,
                              hintStyle: TextStyle(color: Colors.white),
                              labelStyle: TextStyle(color: Colors.white),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          //password
                          //şifre kısmında şifreyi gizle seçeneği gitti onu bir düzeltmek lazım
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () => FocusScope.of(context)
                                .requestFocus(_passFocusNode),
                            keyboardType: TextInputType.name,
                            controller: _passTextController,
                            validator: (value) {
                              if (value!.isEmpty || value.length < 7) {
                                return "Lütfen 7 karakterden fazla bir şifre seçiniz";
                              } else {
                                return null;
                              }
                            },
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              labelText: 'Şifre' ,
                              hintText: 'Şifre' ,
                              hintStyle: TextStyle(color: Colors.white),
                              labelStyle: TextStyle(color: Colors.white),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),

                          TextFormField(
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () => FocusScope.of(context) .requestFocus(_positionCPFocusNode),
                            keyboardType: TextInputType.phone,
                            controller:_phoneNumberController ,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Lütfen  bir telefon numarası giriniz";
                              } else {
                                return null;
                              }
                            },
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              labelText: 'Telefon numarası' ,
                              hintText: 'Telefon numarası' ,
                              hintStyle: TextStyle(color: Colors.white),
                              labelStyle: TextStyle(color: Colors.white),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                              ),
                            ),
                          ),

                          const SizedBox(height: 25,),
                          _isLoading
                              ?
                          Center(
                            child: Container(
                              width: 70,
                              height: 70,
                              child: CircularProgressIndicator(),
                            ),
                          )
                              :
                          MaterialButton(
                            onPressed: (){
                              //Create submitFormOnSignUp
                              _submitFormOnSignUp();

                            },
                            color:Colors.cyan ,
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(13)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 14, ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text('Kayıt Ol',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),

                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 40,),
                          Center(
                            child: RichText(
                              text:  TextSpan(
                                  children: [
                                    const TextSpan(
                                        text: 'Zaten bir hesabınız var mı?',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        )
                                    ),
                                    const TextSpan(
                                        text: '       '
                                    ),
                                    TextSpan(
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () => Navigator.canPop(context)
                                              ? Navigator.pop(context)
                                              : null,
                                        text: 'Giriş',
                                        style: const TextStyle(
                                          color: Colors.cyan,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        )

                                    )
                                  ]
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }
}