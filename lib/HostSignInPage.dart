import 'package:my_application/HostPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_application/Server.dart';
import 'package:my_application/SignUp.dart';

class SignInPage extends StatelessWidget {
 final TextEditingController emailController = TextEditingController();
 final TextEditingController passwordController = TextEditingController();
 bool isObscure = true;
 Server server = Server();


  @override
  Widget build(BuildContext context) {
    Widget _account(BuildContext context){
      return new AlertDialog(
        title: const Text('Failed to Log in'),
        content: new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Log Into Account Fails')
          ],
        ),
        actions: <Widget>[
          ElevatedButton(onPressed: (){
            Navigator.of(context).pop();
          }, child: const Text('OK'))
        ],
      );
    }
    void reset(){
      emailController.text = '';
      passwordController.text = '';
    }
    void signIn(){
      server.signIn(
        Email: emailController.text.trim(),
        Password: passwordController.text.trim()).then((response){
          if (response == 'sign in successfully'){
            reset();
            Navigator.push(context, CupertinoPageRoute(builder: (context) => HostPage()));
          } else{
            showDialog(context: context, builder: (context) => _account(context));
          }
      });
    }
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15.0, 50, 15, 0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Host Family \n Login', style: TextStyle(fontSize: 45, color: Colors.blue),),
              Image(image: AssetImage('asset/logo.jpg')),
              SizedBox(height: 25,),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      isObscure ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed:(){
                      isObscure = !isObscure;
                      (context as Element).markNeedsBuild();
                    },
                  )
                ),
                obscureText: isObscure,
              ),
              SizedBox(height: 10),
              ElevatedButton(
                  onPressed: (){
                    signIn();
                  },
                  child: Text('Sign In')),
              SizedBox(height: 10),
              GestureDetector(
                child: Text("I don't have an account", style: TextStyle(color: Colors.blue),),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage()));
                },
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
