import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:waste_food_management/main.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:waste_food_management/sellerDetailsPage.dart';

class PostingPage extends StatefulWidget {
  PostingPage({this.posting});

  final dynamic posting;
  @override
  State<StatefulWidget> createState() => new _PostingPageState();
}

class _PostingPageState extends State<PostingPage> {
  final _formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  double actualQuantity;
  double paymentAmount;
  File _image;

  Future clickImage() async {
    var image = await ImagePicker()
        .getImage(source: ImageSource.camera, imageQuality: 20);

    setState(() {
      _image = File(image.path);
    });
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
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

  void _showPaymentDialog(String payment) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Payment Amount"),
          content: new Text("Payment Amount to be given (in Rs.): " + payment),
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
          title: new Text("No Payment Generated"),
          content: new Text(
              "Please generate the ayment amount before confirming the Pickup."),
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

  void _showPickedUpDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Pickup Successful"),
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

  _routeToSellerDetailsPage(String sellerId) async {
    var url = Uri.parse("http://192.168.29.132:3000/sellers/sellerDetails");
    // print("_id={$sellerId}");
    url = url.replace(query: "_id=$sellerId");
    var result = await http.get(url);
    print(result.statusCode);
    if (result.statusCode == 200) {
      print(json.decode(result.body));
      var seller = json.decode(result.body);
      print(result.statusCode);
      print(seller);

      var route = new MaterialPageRoute(
        builder: (BuildContext context) => new SellerDetailsPage(
          seller: seller,
        ),
      );
      Navigator.of(context).push(route);
    } else {
      toast(result.body);
    }
  }

  _generatePayment(
      File image, String name, String category, String price) async {
    if (_validateAndSave()) {
      print("////////////////sending req**************************");
      // inventory server
      var request = http.MultipartRequest(
        "POST",
        Uri.parse("http://a-b84328f3.localhost.run/api/quality/"),
      );
      request.headers["Content-Type"] = "application/json";
      request.fields['name'] = name;
      request.fields['category'] = category;
      request.fields['quantity'] = actualQuantity.toString();
      request.fields['price'] = price;
      var pic = await http.MultipartFile.fromPath("image", image.path);

      request.files.add(pic);
      // var response = await request.send();

      http.StreamedResponse response = await request.send();
      print(response.statusCode);
      print("////////////////////////////////////**************************");

      //Get the response from the server
      // var responseData = await response.stream.toBytes();
      // print(responseData);
      // var responseString = String.fromCharCodes(responseData);

      // print(json.decode(responseString));
    } else {
      print("error");
      toast("Inpt a valid quantity");
    }
  }

  Widget _showPostingId() {
    return Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.fromLTRB(10, 30, 10, 10),
        child: new Text(
          "Posting Id: " + widget.posting['_id'],
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
        ));
  }

  Widget _showItemName() {
    return Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.fromLTRB(10, 30, 10, 10),
        child: new Text(
          "Item Name: " + widget.posting['item']['name'],
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
        ));
  }

  Widget _showItemCategory() {
    return Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.fromLTRB(10, 30, 10, 10),
        child: widget.posting['item']['category'] == null
            ? new Text("Item Category: ",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400))
            : new Text(
                "Item Category: " + widget.posting['item']['category'],
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
              ));
  }

  Widget _showItemQuantity() {
    return Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.fromLTRB(10, 30, 10, 10),
        child: new Text(
          "Posted Quantity: " + widget.posting['quantity'].toString(),
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
        ));
  }

  Widget _showImage() {
    return Container(
        height: 300,
        child: Center(
          child:
              _image == null ? Text('No image Clicked.') : Image.file(_image),
        ));
  }

  Widget _showActualQuantityInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.number,
        autofocus: false,
        decoration: new InputDecoration(
            labelText: 'Actual Quantity',
            icon: new Icon(
              Icons.line_weight,
              color: Colors.grey,
            )),
        validator: (value) => isNumeric(value) ? null : 'Input a valid number',
        onSaved: (value) => actualQuantity = double.parse(value),
      ),
    );
  }

  Widget _showSellerDetailsButton() {
    return Padding(
        padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
        child: new MaterialButton(
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(18.0)),
          elevation: 5.0,
          minWidth: 200.0,
          height: 42.0,
          color: Colors.blue,
          child: new Text('Seller Details',
              style: new TextStyle(fontSize: 20.0, color: Colors.white)),
          onPressed: () {
            print("Seller details");
            _routeToSellerDetailsPage(widget.posting['createdBy']);
          },
        ));
  }

  Widget _showUploadImageButton() {
    return Padding(
        padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
        child: new MaterialButton(
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(18.0)),
          elevation: 5.0,
          minWidth: 200.0,
          height: 42.0,
          color: Colors.blue,
          child: new Text('Upload Image',
              style: new TextStyle(fontSize: 20.0, color: Colors.white)),
          onPressed: () {
            clickImage();
          },
        ));
  }

  Widget _showGeneratePaymentButton() {
    return Padding(
        padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
        child: new MaterialButton(
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(18.0)),
          elevation: 5.0,
          minWidth: 200.0,
          height: 42.0,
          color: Colors.blue,
          child: new Text('Generate Payment',
              style: new TextStyle(fontSize: 20.0, color: Colors.white)),
          onPressed: () {
            if (_image == null) {
              toast("Click image First");
            } else {
              _generatePayment(
                  _image,
                  widget.posting['item']['name'],
                  widget.posting['item']['category'],
                  widget.posting['item']['defaultPrice'].toString());
            }
            //_generateBill(widget.subscription['details']);
          },
        ));
  }

  Widget _showConfirmPickupButton() {
    return Padding(
        padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 20.0),
        child: new MaterialButton(
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(18.0)),
          elevation: 5.0,
          minWidth: 200.0,
          height: 42.0,
          color: Colors.blue,
          child: new Text('Confirm Pickup',
              style: new TextStyle(fontSize: 20.0, color: Colors.white)),
          onPressed: () {
            if (paymentAmount == null) {
              print("No Payment Amount");
              _showMessageDialog();
            } else {
              print("HAHAHAH");
              //_confirmPickup(widget.posting);
            }
          },
        ));
  }

  Widget _showDivider() {
    return Divider(
      thickness: 5,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text(widget.posting['item']['name']),
      ),
      body: ListView(
        children: <Widget>[
          _showPostingId(),
          _showDivider(),
          _showItemName(),
          _showDivider(),
          _showItemCategory(),
          _showDivider(),
          _showItemQuantity(),
          _showDivider(),
          _showSellerDetailsButton(),
          _showDivider(),
          _showImage(),
          _showDivider(),
          _showUploadImageButton(),
          _showDivider(),
          new Form(
              key: _formKey,
              autovalidate: false,
              child: new ListView(shrinkWrap: true, children: <Widget>[
                _showActualQuantityInput(),
              ])),
          _showGeneratePaymentButton(),
          _showConfirmPickupButton()
        ],
      ),
    );
  }
}
