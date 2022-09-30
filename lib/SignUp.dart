import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_application/Server.dart';
import 'HostPage.dart';

class SignUpPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
bool isObscure = true;
Server server = Server();

  @override
  Widget build(BuildContext context) {
    Widget _account(BuildContext context){
      print('alert');

      return new AlertDialog(
        title: const Text('Failed to Sign Up'),
        content: new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children:<Widget>[
            Text('Sign up account fails'),
          ],
        ),
        actions: <Widget>[
          ElevatedButton(onPressed: (){
            Navigator.of(context).pop();
          },
              child: const Text('OK')
          ),
        ],
      );
    };
    void reset(){
      emailController.text = '';
      passwordController.text = '';
    }
    void signUp(){
      server.signUp(
        Email: emailController.text.trim(),
        Password: passwordController.text.trim(),
      ).then((response){
        if(response == "sign up successfully"){
          Navigator.pop(context);
          reset();
          Navigator.push(
            context, CupertinoPageRoute(builder: (context) => HostPage())
          );
        }
        else{
          showDialog(context:context, builder:(context) => _account(context));
        }
      });
    }
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15.0, 50, 15.0, 0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Host Family \n Sign Up', style: TextStyle(fontSize: 45, color: Colors.blue),),
              Image(image: AssetImage('asset/logo.jpg'),),
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
                      isObscure ? Icons.visibility: Icons.visibility_off,
                    ),
                    onPressed:(){
                      isObscure = !isObscure;
                      (context as Element).markNeedsBuild();
                    },
                  ),
                ),
                obscureText: isObscure,
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
              onPressed: (){signUp();},
                  child: Text('Sign Up')),
            ],
          ),
        ),
      ),
    );
  }
}
