import 'package:flutter/material.dart';

class BuyerDetailsPage extends StatefulWidget {
  BuyerDetailsPage({this.buyer});

  final dynamic buyer;
  @override
  State<StatefulWidget> createState() => new _BuyerDetailsPageState();
}

class _BuyerDetailsPageState extends State<BuyerDetailsPage> {
  @override
  void initState() {
    super.initState();
  }

  Widget _showBuyerId() {
    return Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.fromLTRB(10, 30, 10, 10),
        child: new Text(
          "Buyer Id: " + widget.buyer[0]['_id'],
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
        ));
  }

  Widget _showBuyerAddress() {
    return Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.fromLTRB(10, 30, 10, 10),
        child: new Text(
          "Address: " +
              widget.buyer[0]['address']['line1'] +
              "," +
              widget.buyer[0]['address']['city'] +
              "," +
              widget.buyer[0]['address']['state'] +
              "," +
              widget.buyer[0]['address']['pincode'].toString(),
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
        ));
  }

  Widget _showBuyerPhone() {
    return Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.fromLTRB(10, 30, 10, 10),
        child: new Text(
          "Contact: " + widget.buyer[0]['phone'].toString(),
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
        ));
  }

  Widget _showBuyerEmail() {
    return Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.fromLTRB(10, 30, 10, 10),
        child: new Text(
          "Email id: " + widget.buyer[0]['email'],
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
        ));
  }

  Widget _showBuyerBill() {
    return Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.fromLTRB(10, 30, 10, 10),
        child: new Text(
          "Outstanding Bill: " + widget.buyer[0]['outstandingBill'].toString(),
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
        ));
  }

  Widget _showDivider() {
    return Divider(
      thickness: 5,
    );
  }

// Displaying the details of the buyer
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text(widget.buyer[0]['firstName']),
      ),
      body: ListView(
        children: <Widget>[
          _showBuyerId(),
          _showDivider(),
          _showBuyerAddress(),
          _showDivider(),
          _showBuyerPhone(),
          _showDivider(),
          _showBuyerEmail(),
          _showDivider(),
          _showBuyerBill(),
          _showDivider()
        ],
      ),
    );
  }
}
