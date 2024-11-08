import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart'as http;
import 'package:online_store/users/authentication/login_screen.dart';


import '../../api_connection/api_connection.dart';
import '../model/user.dart';
class signupscreen extends StatefulWidget {
  const signupscreen({super.key});

  @override
  State<signupscreen> createState() => _signupscreenState();
}

class _signupscreenState extends State<signupscreen> {
  var emailcontroller = TextEditingController();
  final formKey = GlobalKey<FormState>();
  var passcontroller = TextEditingController();
  var namecontroller = TextEditingController();
  var is_obscure = true.obs;




  @override
  Widget build(BuildContext context) {
    return Scaffold
      (
        backgroundColor: const Color(0xFF181C14),
        body: LayoutBuilder(
            builder: (context, constrains) {
              return SafeArea(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constrains.maxHeight),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          width: 420,
                          height: 280,
                          child: ClipRRect(child: Image.asset(
                            'assets/images/signupscreenpic.jpg', width: 300,
                            fit: BoxFit.fitWidth,),
                            borderRadius: BorderRadius.circular(20),),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Container(
                            height: 600,
                            width: double.infinity,

                            decoration: BoxDecoration(borderRadius: BorderRadius
                                .circular(20),
                                color: Colors.white,
                                gradient: LinearGradient(
                                    colors: [Colors.red, Colors.white],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Form(
                                  key: formKey,
                                  child: Column
                                    (mainAxisAlignment: MainAxisAlignment
                                      .spaceEvenly,
                                    children: [ Container(
                                      width: 350,
                                      child: TextFormField(
                                        controller: namecontroller,
                                        validator: (val) =>
                                        val == ''
                                            ? 'Please enter name!'
                                            : null,
                                        decoration: InputDecoration(
                                            prefixIcon: Icon(
                                                CupertinoIcons.person_fill),
                                            label: Text('Enter your name'),
                                            border: OutlineInputBorder
                                              (
                                                borderRadius: BorderRadius
                                                    .circular(10)
                                            )
                                        ),
                                      ),
                                    ),
                                      SizedBox(height: 10,),
                                      Container(
                                        width: 350,
                                        child: TextFormField(
                                          controller: emailcontroller,
                                          validator: (val) =>
                                          val == ''
                                              ? 'Please enter email'
                                              : null,
                                          decoration: InputDecoration(
                                              prefixIcon: Icon(
                                                  CupertinoIcons.mail_solid),
                                              label: Text('Enter your email'),
                                              border: OutlineInputBorder
                                                (
                                                  borderRadius: BorderRadius
                                                      .circular(10)
                                              )
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10,),
                                      Obx(() =>
                                          Container(
                                              width: 350,

                                              child: TextFormField(
                                                controller: passcontroller,
                                                obscureText: is_obscure.value,

                                                validator: (val) =>
                                                val == ''
                                                    ? 'Please enter password'
                                                    : null,
                                                decoration: InputDecoration(
                                                    prefixIcon: Icon(
                                                        CupertinoIcons
                                                            .lock_fill),
                                                    suffixIcon: Obx(() =>
                                                        GestureDetector(
                                                          onTap: () {
                                                            is_obscure.value =
                                                            !is_obscure.value;
                                                          },
                                                          child: Icon(
                                                              is_obscure.value
                                                                  ? Icons
                                                                  .visibility_off
                                                                  : Icons
                                                                  .visibility),)),
                                                    label: Text('Password'),
                                                    border: OutlineInputBorder(
                                                      borderRadius: BorderRadius
                                                          .circular(10),

                                                    )
                                                ),
                                              ))),
                                      SizedBox(height: 30),
                                      Material(
                                        color: Colors.black38,
                                        borderRadius: BorderRadius.circular(30),
                                        child: InkWell(
                                          onTap: () {
                                            if (formKey.currentState!
                                                .validate()) {
                                              insertrecord();

                                            }
                                          },
                                          borderRadius: BorderRadius.circular(
                                              30),
                                          child: Padding(child: Text('SignUp'),
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 10,
                                                  horizontal: 20)),

                                        ),

                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .center,
                                        children: [
                                          Text("Already have an account?",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18),),
                                          TextButton(onPressed: () {
                                            Get.to(() => loginscreen());
                                          },
                                              child: Text('Login',
                                                style: TextStyle(
                                                    color: Colors.pink,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 19),))
                                        ],
                                      ),
                                      SizedBox(height: 80,)

                                    ],

                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
        )

    );
  }





Future<void> insertrecord() async
{
  if(namecontroller.text!=''||emailcontroller.text!=''||passcontroller.text!='') {
    try {
      String uri="http://10.0.2.2/clothesapp_api/user/insert_record.php";
      var res =await http.post(Uri.parse(uri),body:
      {
        "name":namecontroller.text,
        "email":emailcontroller.text,
        "password":passcontroller.text,
      }
      );
      if (res.statusCode == 200) {
        final responseData = json.decode(res.body);
        if (responseData['success'] == "true") {
          Fluttertoast.showToast(msg:'Signed Up Successfully');
          namecontroller.text='';
          emailcontroller.text='';
          passcontroller.text='';
          Get.to(()=>loginscreen());

          print('User registered successfully!');
        } else {
          Fluttertoast.showToast(msg:'User already exists');
          namecontroller.text='';
          emailcontroller.text='';
          passcontroller.text='';
          print('Registration failed: ${responseData['error']}');
        }
      } else {
        Fluttertoast.showToast(msg:"Some issue occured at server site");
        print('Server error: ${res.statusCode}');
      }
    }

    catch (e) {
      print(e);

    }
  }
}
  // Future<void> validateEmail() async {
  //   final String email =emailcontroller.text;
  //   String uri="http://10.0.2.2/clothesapp_api/user/validate_email.php";
  //   final res = await http.post(
  //     Uri.parse(uri),
  //     body: {'email': email},
  //   );
  //
  //   if (res.statusCode == 200) {
  //     var resBody=jsonDecode(res.body);
  //     if(resBody['success']==true)
  //       {
  //         Fluttertoast.showToast(msg:"email already exists");
  //       };
  //   } else {
  //     insertrecord();
  //   }
  // }

}
