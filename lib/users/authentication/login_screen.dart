import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:online_store/users/authentication/signup_screen.dart';
import 'package:http/http.dart' as http;
import 'package:online_store/users/fragments/dashBoard.dart';
import 'package:online_store/users/model/user.dart';
import 'package:online_store/users/userPreferences/user_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class loginscreen extends StatefulWidget {
  const loginscreen({super.key});

  @override
  State<loginscreen> createState() => _loginscreenState();
}

class _loginscreenState extends State<loginscreen> {
  final formKey = GlobalKey<FormState>();
  var emailcontroller=TextEditingController();
  var passcontroller=TextEditingController();
  var is_obscure=true.obs;


  @override
  Widget build(BuildContext context) {
    return Scaffold
      (
      backgroundColor: const Color(0xFF181C14),
      body: LayoutBuilder(
          builder:(context,constrains)
          {
            return SafeArea(
              child: ConstrainedBox(
                  constraints:BoxConstraints(minHeight: constrains.maxHeight),
                      child:SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              width:  420,
                              height: 280,
                              child: ClipRRect(child:Image.asset('assets/images/shopping.jpg',width:300,fit: BoxFit.fitWidth,),borderRadius: BorderRadius.circular(20),),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: Container(
                                height: 600,
                                width: double.infinity,

                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Colors.white,gradient:LinearGradient(colors:[Colors.purpleAccent.shade700,Colors.white],begin:Alignment.bottomCenter,end:Alignment.topCenter)),
                                child: Column(
                                  children: [
                                    Form(
                                      key: formKey,
                                      child: Column
                                        (mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          SizedBox(height: 100,),
                                          Container(
                                            width: 350,
                                            child: TextFormField(
                                              controller: emailcontroller,
                                              validator:(val)=>val==''?'Please enter email!':null,
                                              decoration:InputDecoration(
                                                prefixIcon: Icon(CupertinoIcons.mail_solid),
                                                label:Text('Enter your email'),
                                                border: OutlineInputBorder
                                                  (
                                                  borderRadius: BorderRadius.circular(10)
                                                )
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 10,),
                                          Obx(()=> Container(
                                              width: 350,

                                              child: TextFormField(
                                                controller: passcontroller,
                                                obscureText: is_obscure.value,

                                                validator:(val)=>val==''?'Please enter password!':null,
                                                decoration: InputDecoration(
                                                    prefixIcon: Icon(CupertinoIcons.lock_fill),
                                                    suffixIcon: Obx(()=>GestureDetector(onTap:(){is_obscure.value=!is_obscure.value;},child: Icon(is_obscure.value?Icons.visibility_off:Icons.visibility),)),
                                                    label: Text('Password'),
                                                    border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(10),

                                                    )
                                                ),
                                              ))),
                                          SizedBox(height:30),
                                          ElevatedButton(onPressed:(){if(formKey.currentState!.validate())
                                          {
                                            loginUserNow();
                                          }
                                                }, child:Text('Login'),),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text("Don't have an account?",style:TextStyle(color: Colors.white,fontSize: 18),),
                                              TextButton(onPressed: (){Get.to(()=>signupscreen());}, child:Text('Signup Now.',style:TextStyle(color: Colors.pink,fontWeight: FontWeight.bold,fontSize: 19),))
                                            ],
                                          ),
                                          Text('Or',style: TextStyle(color: Colors.white,fontSize: 17),),
                                          Row(mainAxisAlignment:MainAxisAlignment.center,children: [Text('Are you an admin?',style: TextStyle(color: Colors.white,fontSize: 18),),TextButton(onPressed: (){}, child:Text('Click here!',style:TextStyle(color:Colors.pink,fontWeight: FontWeight.bold,fontSize: 19),))],),
                                          SizedBox(height: 60,)

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

  void loginUserNow() async
  {
   try{
     String uri="http://10.0.2.2/clothesapp_api/user/login.php";
     var res =await http.post(Uri.parse(uri),body:
     {
       "email":emailcontroller.text,
       "password":passcontroller.text,
     }
     );
     if (res.statusCode == 200) {
       final responseData = json.decode(res.body);
       if (responseData['success'] == "true") {
         Fluttertoast.showToast(msg:'Logged In Successfully');

         User userInfo=User.fromJson(responseData["userData"]);
         await RememberUserPrefs.storeUserInfo(userInfo);
         Future.delayed(Duration(milliseconds:200),()
         {
           Get.to(DashboardOfFragments());
         });

         print('User loggged in  successfully!');
       }
     } else {
       Fluttertoast.showToast(msg:"Incorrect email or password");
       print('Server error: ${res.statusCode}');
     }
   }
   catch(e)
    {
      print(e.toString());
    }


  }
}
