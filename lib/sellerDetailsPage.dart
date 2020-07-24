import 'package:flutter/material.dart';

class SellerDetailsPage extends StatefulWidget {
  SellerDetailsPage({this.seller});

  final dynamic seller;
  @override
  State<StatefulWidget> createState() => new _SellerDetailsPageState();
}

class _SellerDetailsPageState extends State<SellerDetailsPage> {
  @override
  void initState() {
    super.initState();
  }

  Widget _showSellerId() {
    return Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.fromLTRB(10, 30, 10, 10),
        child: new Text(
          "Seller Id: " + widget.seller[0]['_id'],
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
        ));
  }

  Widget _showSellerAddress() {
    return Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.fromLTRB(10, 30, 10, 10),
        child: new Text(
          "Address: " +
              widget.seller[0]['address']['line1'] +
              "," +
              widget.seller[0]['address']['city'] +
              "," +
              widget.seller[0]['address']['state'] +
              "," +
              widget.seller[0]['address']['pincode'].toString(),
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
        ));
  }

  Widget _showSellerPhone() {
    return Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.fromLTRB(10, 30, 10, 10),
        child: new Text(
          "Contact: " + widget.seller[0]['phone'].toString(),
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
        ));
  }

  Widget _showSellerEmail() {
    return Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.fromLTRB(10, 30, 10, 10),
        child: new Text(
          "Email id: " + widget.seller[0]['email'],
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
        ));
  }

  Widget _showDivider() {
    return Divider(
      thickness: 5,
    );
  }

// Displaying the details of the seller
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text(widget.seller[0]['firstName']),
      ),
      body: ListView(
        children: <Widget>[
          _showSellerId(),
          _showDivider(),
          _showSellerAddress(),
          _showDivider(),
          _showSellerPhone(),
          _showDivider(),
          _showSellerEmail(),
          _showDivider(),
        ],
      ),
    );
  }
}
