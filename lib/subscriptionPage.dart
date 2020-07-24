import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:waste_food_management/buyerDetailsPage.dart';
import 'package:waste_food_management/main.dart';

class SubscriptionPage extends StatefulWidget {
  SubscriptionPage({this.subscription});

  final dynamic subscription;
  @override
  State<StatefulWidget> createState() => new _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  @override
  void initState() {
    super.initState();
  }

  double billAmount;

  void _showBillDialog(String bill) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Bill Generated"),
          content: new Text("Bill Amount(in Rs.): " + bill),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Continue"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showMessageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("No Bill Generated"),
          content: new Text(
              "Please generate the bill before confirming the delivery."),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Continue"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showDeliveredDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Delivery Successful"),
          content:
              new Text("Please click continue to go back to the home page."),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Continue"),
              onPressed: () {
                var route = new MaterialPageRoute(
                    builder: (BuildContext context) => new MyHomePage(
                          title: "Home",
                        ));

                Navigator.of(context)
                    .pushAndRemoveUntil(route, (Route<dynamic> route) => false);
              },
            ),
          ],
        );
      },
    );
  }

  void toast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.grey,
        textColor: Colors.black,
        fontSize: 16.0);
  }

  _routeToBuyerDetailsPage(String buyerId) async {
    // Buyer server
    var url = Uri.parse("http://192.168.29.132:3002/buyers/buyerDetails");
    // print("_id={$buyerId}");
    url = url.replace(query: "_id=$buyerId");
    var result = await http.get(url);
    print(result.statusCode);
    if (result.statusCode == 200) {
      print(json.decode(result.body));
      var buyer = json.decode(result.body);
      print(result.statusCode);
      print(buyer);

      var route = new MaterialPageRoute(
        builder: (BuildContext context) => new BuyerDetailsPage(
          buyer: buyer,
        ),
      );
      Navigator.of(context).push(route);
    } else {
      toast(result.body);
    }
  }


  _generateBill(dynamic item) async {
    //Inventory Server
    var url = "http://782adbc77eb0.ngrok.io/api/inventory/remove";
    var response = await http.post(url,
        headers: {'Content-Type': "application/x-www-form-urlencoded"},
        body: {'name': item['name'], 'quantity': item['quantity'].toString()});
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      var price = json.decode(response.body);
      print(price);
      setState(() {
        billAmount = price['price'];
      });
      _showBillDialog(price['price'].toString());
    } else {
      toast(response.body);
    }
  }

  _confirmDelivery(dynamic body) async {
    var url = "http://192.168.29.132:3002/subscriptions/delivered";
    var response = await http.post(url, body: {
      'id': body['_id'],
      'createdBy': body['createdBy'],
      "amount": billAmount.toString()
    });
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      _showDeliveredDialog();
    } else {
      toast(response.body);
    }
  }

  Widget _showSubscriptionId() {
    return Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.fromLTRB(10, 30, 10, 10),
        child: new Text(
          "Subscription Id: " + widget.subscription['_id'],
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
        ));
  }

  Widget _showItemName() {
    return Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.fromLTRB(10, 30, 10, 10),
        child: new Text(
          "Item Name: " + widget.subscription['details']['name'],
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
        ));
  }

  Widget _showItemCategory() {
    return Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.fromLTRB(10, 30, 10, 10),
        child: new Text(
          "Item Category: " + widget.subscription['details']['category'],
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
        ));
  }

  Widget _showItemQuantity() {
    return Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.fromLTRB(10, 30, 10, 10),
        child: new Text(
          "Item Quantity: " +
              widget.subscription['details']['quantity'].toString(),
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
        ));
  }

  Widget _showDivider() {
    return Divider(
      thickness: 5,
    );
  }

  Widget _showBuyerDetailsButton() {
    return Padding(
        padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
        child: new MaterialButton(
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(18.0)),
          elevation: 5.0,
          minWidth: 200.0,
          height: 42.0,
          color: Colors.blue,
          child: new Text('Buyer Details',
              style: new TextStyle(fontSize: 20.0, color: Colors.white)),
          onPressed: () {
            _routeToBuyerDetailsPage(widget.subscription['createdBy']);
          },
        ));
  }

  Widget _showGenerateBillButton() {
    return Padding(
        padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
        child: new MaterialButton(
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(18.0)),
          elevation: 5.0,
          minWidth: 200.0,
          height: 42.0,
          color: Colors.blue,
          child: new Text('Generate Bill',
              style: new TextStyle(fontSize: 20.0, color: Colors.white)),
          onPressed: () {
            _generateBill(widget.subscription['details']);
          },
        ));
  }

  Widget _showConfirmDeliveryButton() {
    return Padding(
        padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 20.0),
        child: new MaterialButton(
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(18.0)),
          elevation: 5.0,
          minWidth: 200.0,
          height: 42.0,
          color: Colors.blue,
          child: new Text('Confirm Delivery',
              style: new TextStyle(fontSize: 20.0, color: Colors.white)),
          onPressed: () {
            if (billAmount == null) {
              print("noBill");
              _showMessageDialog();
            } else {
              print("HAHAHAH");
              _confirmDelivery(widget.subscription);
            }
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text(widget.subscription['name']),
      ),
      body: ListView(
        children: <Widget>[
          _showSubscriptionId(),
          _showDivider(),
          _showItemName(),
          _showDivider(),
          _showItemCategory(),
          _showDivider(),
          _showItemQuantity(),
          _showDivider(),
          _showBuyerDetailsButton(),
          _showGenerateBillButton(),
          _showConfirmDeliveryButton()
        ],
      ),
    );
  }
}
