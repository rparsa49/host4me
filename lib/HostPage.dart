import 'package:flutter/material.dart';
import 'package:my_application/Server.dart';
import 'package:fluttertoast/fluttertoast.dart';
class HostPage extends StatefulWidget {
  const HostPage({Key? key}) : super(key: key);

  @override
  State<HostPage> createState() => _HostPageState();
}

class _HostPageState extends State<HostPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController membersController = TextEditingController();
  final TextEditingController nationalityController = TextEditingController();
  Server server = Server();

  late FToast fluttertoast;



  Map transportMap = {
    'Bus': false,
    'Trolley': false,
    'Metro/Subway': false,
    'Train': false,
  };

  @override
  void initState(){
    super.initState();
    _get_info();
    fluttertoast = FToast();
    fluttertoast.init(context);
  }

  showNotif(){
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(25),color: Colors.green,),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [Icon(Icons.check_box,),
        SizedBox(width: 12,),
          Text('Info Updated!',style: TextStyle(color: Colors.white),)
        ],
      ),
    );

    fluttertoast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 4),positionedToastBuilder: (context, child) {
      return Positioned(
        child: child,
        top: 320.0,
        left: 120.0,
      );
    }

    );
  }

  void _get_info(){
    try{
      server.getUserInfo()?.then((snapshot){
        if (snapshot != null && snapshot.data() != null){
          Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
          setState(() {
            nameController.text = data["name"];
            addressController.text = data["address"];
            emailController.text = data["email"];
            phoneController.text = data["phone"];
            transportMap['Bus'] = data["bus"];
            transportMap['Train'] = data["train"];
            transportMap['Trolley'] = data["trolley"];
            transportMap['Metro/Subway'] = data["metro/subway"];
            membersController.text = data["members"];
            nationalityController.text = data["nationality"];
          });
        }
      });
    }catch (e) {
      print(e);
    }
  }

  void _updateInfo(){
    Map<String, dynamic> info = {
      'name': nameController.text.trim(),
      'address': addressController.text.trim(),
      'email': emailController.text.trim(),
      'phone': phoneController.text.trim(),
      'members': membersController.text.trim(),
      'nationality': nationalityController.text.trim(),
      'bus': transportMap['Bus'],
      'train': transportMap['Train'],
      'trolley': transportMap['Trolley'],
      'metro/subway': transportMap['Metro/Subway'],
    };
    server.setUserInfo(info);
  }

  Widget _deleteAccount(BuildContext context){
    print('alert');

    return new AlertDialog(
      title: const Text('Delete Account'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Do you want to delete your account?'),
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
            onPressed: (){
              server.deleteUser();
              Navigator.of(context).pop();
              Navigator.pop(context);
            },
            child: const Text('Yes')),
        ElevatedButton(
            onPressed: (){
              Navigator.of(context).pop();
            },
            child: const Text('No')),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Host Page'),
        actions: <Widget>[
          IconButton(
            onPressed: (){
              showDialog(
                context: context,
                builder: (context) => _deleteAccount(context)
              );
            },
            icon: Icon(Icons.delete),
            tooltip: 'Delete Account',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                ),
              ),
              TextField(
                controller: addressController,
                decoration: InputDecoration(
                  labelText: 'Address(Example: 300 Amherst Rd Belchertown, MA 01007)',
                ),
                ),

              TextField(
                controller: nationalityController,
                decoration: InputDecoration(
                  labelText: 'Nationality',
                ),
              ),
              TextField(
                controller: membersController,
                decoration: InputDecoration(
                  labelText: 'Number of Family Members',
                ),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
              ),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                ),
              ),
              const Text('Transportation', style: TextStyle(fontSize: 20),),
              SizedBox(height: 10,),
              ListView.builder(
                  primary: false,
                  shrinkWrap: true,
                  itemCount: transportMap.length,
                  itemBuilder: (BuildContext context, int index) {
                    String key = transportMap.keys.elementAt(index);
                    return CheckboxListTile(
                        title: Text(key),
                        value: transportMap[key],
                        onChanged: (bool? value){
                          setState(() {
                            transportMap[key] = value;
                          });
                        });
                  }
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: (){ //add alert button
                  _updateInfo();
                  showNotif();
                  },
                child: Text('Update Info'),
              ),
            ],
          ),
        )

      )
    );
  }
}
