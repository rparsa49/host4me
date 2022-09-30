import 'package:flutter/material.dart';
import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'HostInfo.dart';
import 'Server.dart';
import 'Distance.dart';
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map hosts = {};
  List<String> options = ['None', 'Distance', 'Transportation', 'Nationality'];
  String dropDownFilter = 'None';
  List allData = [];

  TextEditingController _addressController = TextEditingController();
  bool isDistance = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _get_hosts();
  }
  void _get_hosts() {
    Server server = Server();
    server.getUsers()!.then((querySnapshot) {
      allData = querySnapshot.docs.map((doc) => doc.data()).toList();
      print(allData);
      setState(() {
        hosts['All'] = allData;
        print(hosts);
      });
    });
  }
_buildDropdownFilter(BuildContext context){
  return DropdownButton<String>(value: dropDownFilter,
      icon: const Icon(Icons.arrow_downward_rounded),
      elevation: 16,
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? newValue){
    setState(() {
      dropDownFilter = newValue!;
      _filterby(context);
    });

},
  items: options.map<DropdownMenuItem<String>>((String Value) {
    return DropdownMenuItem<String>(
     value: Value,
       child: Text(Value),
  );}).toList(),
  );
}
    void _filterby(BuildContext context){
      hosts = {};
      isDistance = false;
      if(dropDownFilter == 'Nationality'){
        for(int i = 0; i < allData.length; i++){
          String nationality = allData[i]['nationality'];
          List host = hosts[nationality] ?? [];
          host.add(allData[i]);
          hosts[nationality] = host;
        }
      }
      else if(dropDownFilter == 'Transportation'){
        for(int i = 0; i < allData.length; i++){
          _setTransport(allData[i], 'bus');
          _setTransport(allData[i], 'metro/subway');
          _setTransport(allData[i], 'trolley');
          _setTransport(allData[i], 'train');
        }
      }
      else if(dropDownFilter == 'None'){
        hosts['All'] = allData;
      } else{
        _displayTextInputDialog(context);
      }
    }
    void _setTransport(Map data, String transport){
      bool transportation = data[transport];
      if(transportation){
        List host = hosts[transport] ?? [];
        host.add(data);
        hosts[transport] = host;
      }
    }
    _filterByDistance() async{
    List unsortedHosts = [];
    Map<int, double> distanceMap = {};
    for(int i = 0; i < allData.length; i++) {
      String address = allData[i]['address'];
      unsortedHosts.add(allData[i]);
      double distance = await Distance.getDistance(
          _addressController.text, address);
      distanceMap[i] = distance;
    }
    _sortDistance(distanceMap, unsortedHosts);
    }
    void _sortDistance(Map<int, double> distanceMap, List<dynamic> unsortedHosts){
    var sortedKeys = distanceMap.keys.toList(growable: false)..sort((k1,k2) => distanceMap[k1]!.compareTo(distanceMap[k2]!));
    LinkedHashMap sortedMap = new LinkedHashMap.fromIterable(sortedKeys, key: (k) => k, value: (k) => distanceMap[k]);
    print(distanceMap);
    List sortedHosts = [];
    sortedMap.forEach((k, d) {
      String n = d.toStringAsFixed(2);
      unsortedHosts[k]['distance'] = n;
      sortedHosts.add(unsortedHosts[k]);
      });
    setState(() {
      isDistance = true;
      hosts['Distance'] = sortedHosts;
      _addressController.text = '';
    });
    }
Future<void> _displayTextInputDialog(BuildContext context) async{
    return showDialog(context: context,
        builder: (context){
      return AlertDialog(
        title: Text('Address'),
        content: TextField(
          controller: _addressController,
          decoration: InputDecoration(hintText: 'Address'),
        ),
        actions: <Widget>[
          ElevatedButton(
            onPressed: (){
              Navigator.pop(context);
            } ,
            child: Text('CANCEL'),),
          ElevatedButton(
            onPressed: (){
            _filterByDistance();
            Navigator.pop(context);},
            child: Text('OK'),)
        ]
      );
    });
}

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Hosts'),
      ),
      body: ListView(
        children: [
          Padding(padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Filter by: ', style: TextStyle(fontSize: 20),),
                  _buildDropdownFilter(context),
                ],
              ),
          ),
          ListView.builder(
            padding: const EdgeInsets.all(8),
            physics: ScrollPhysics(),
            shrinkWrap: true,
            itemCount: hosts.length,
            itemBuilder: (BuildContext context, int index){
              String host = hosts.keys.elementAt(index);
              return ListView(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                children: [
                  buildCustomBar(size,host),
                  ListView.builder(
                      padding: const EdgeInsets.all(8),
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: hosts[host].length,
                      itemBuilder: (BuildContext context, int i) {
                        return Card(
                          child: ListTile(
                            leading: isDistance ? Text('${hosts[host][i]['distance']}mile',
                            style: TextStyle(color: Colors.green),
                          ): Icon(Icons.holiday_village_outlined),
                            title: Text(
                        hosts[host][i]['name'],
                        style: TextStyle(fontSize:20)
                        ),
                            trailing: IconButton(
                              icon: const Icon(Icons.info_outline, color: Colors.amber,),
                              tooltip: 'More Info',
                              onPressed: (){
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(builder: (context) => HostInfoPage(info: hosts[host][i],))
                                );
                              },
                            ),
                          ));
                      }
                  )],
              );
            },
          )



        ],
      ),
    );
  }
  Widget buildCustomBar(Size size, String text){
    return Container(
      height: size.height*0.04,
      width: double.infinity,
      margin:EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color:Colors.white,
        boxShadow:[
          BoxShadow(
            offset: Offset(0,-5),
            color: Colors.grey,
            blurRadius: 15,
            spreadRadius: 5
          )
        ]
      ),
      child: Center(
        child: Text(
          text, style: TextStyle(fontWeight: FontWeight.w300, color: Colors.black54, fontSize: 25),
        ),
      ),
    );
  }
}

