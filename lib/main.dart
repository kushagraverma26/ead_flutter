import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:waste_food_management/postingPage.dart';
import 'dart:convert';

import 'package:waste_food_management/subscriptionPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Waste Food Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Home'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    fetchPostings();
    fetchSubscriptions();
  }

  List<dynamic> postings = [];
  List<dynamic> subscriptions = [];

//-------------------------------------------------Postings list------------------------------------------------------------------

 _routeToPostingPage(dynamic posting) {
    var route = new MaterialPageRoute(
      builder: (BuildContext context) => new PostingPage(
        posting: posting,
      ),
    );
    Navigator.of(context).push(route);
  }

  void fetchPostings() async {
    var url = Uri.parse("http://192.168.29.132:3000/postings/allPostings");
    url = url.replace(query: "isPicked=false");
    var result = await http.get(url, headers: {"Accept": "application/json"});
    print(result.statusCode);
    print(json.decode(result.body));
    setState(() {
      postings = json.decode(result.body);
    });
  }

  Future<void> _getPostingsData() async {
    setState(() {
      fetchPostings();
    });
  }

  Widget _buildPostingsList() {
    return postings.length != 0
        ? RefreshIndicator(
            child: ListView.builder(
                padding: EdgeInsets.all(8),
                itemCount: postings.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      _routeToPostingPage(postings[index]);
                    },
                                      child: Card(
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            title: Text("Item Name: " + postings[index]['item']['name']),
                             subtitle: Text("Quantity: " + postings[index]['quantity'].toString()),
                          )
                        ],
                      ),
                    ),
                  );
                }),
            onRefresh: _getPostingsData,
          )
        : Center(child: CircularProgressIndicator());
  }
//-------------------------------------------------Subscriptions list------------------------------------------------------------------
  _routeToSubscriptionPage(dynamic subscription) {
    var route = new MaterialPageRoute(
      builder: (BuildContext context) => new SubscriptionPage(
        subscription: subscription,
      ),
    );
    Navigator.of(context).push(route);
  }

  void fetchSubscriptions() async {
    var url =
        Uri.parse("http://192.168.29.132:3002/subscriptions/allSubscriptions");
    url = url.replace(query: "deliveredToday=false");
    var result = await http.get(url, headers: {"Accept": "application/json"});

    print(json.decode(result.body));
    setState(() {
      subscriptions = json.decode(result.body);
    });
  }

  Future<void> _getSubscriptionsData() async {
    setState(() {
      fetchSubscriptions();
    });
  }

  Widget _buildSubscriptionsList() {
    return subscriptions.length != 0
        ? RefreshIndicator(
            child: ListView.builder(
                padding: EdgeInsets.all(8),
                itemCount: subscriptions.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      _routeToSubscriptionPage(subscriptions[index]);
                    },
                    child: Card(
                      child: Column(
                        children: <Widget>[
                          ListTile(
                              title: Text("Subscription Name: " +
                                  subscriptions[index]['name']),
                              subtitle: Text("Item: " +
                                  subscriptions[index]['details']['name']),
                              trailing: Text("Quantity: " +
                                  (subscriptions[index]['details']['quantity'])
                                      .toString()))
                        ],
                      ),
                    ),
                  );
                }),
            onRefresh: _getSubscriptionsData,
          )
        : Center(child: CircularProgressIndicator());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(text: "Pickup", icon: Icon(Icons.file_upload)),
                Tab(text: "Delivery", icon: Icon(Icons.file_download)),
              ],
            ),
            title: Text('Select Operation'),
          ),
          body: TabBarView(
            children: [
              _buildPostingsList(),
              _buildSubscriptionsList(),
            ],
          ),
        ),
      ),
    );
  }
}
