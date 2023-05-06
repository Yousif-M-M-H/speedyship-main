import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:speedyship/pages/shipments/showShipments.dart';
import '../../components/my_textfield.dart';
import '../../components/dropdown_form_field.dart';
import '../../components/city_dropdown_form_field.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ShipmentForm extends StatefulWidget {
  ShipmentForm({Key? key}) : super(key: key);

  @override
  State<ShipmentForm> createState() => _ShipmentFormState();
}

class _ShipmentFormState extends State<ShipmentForm> {
  String _selectedOption = 'food';
  String _citysSelectedOption = "magusa";

  final weightController = TextEditingController();

  final lengthController = TextEditingController();

  final widthController = TextEditingController();

  final heightController = TextEditingController();

  final locationController = TextEditingController();

  final destinationcontroller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _submitForm() async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      try {
        final user = _auth.currentUser;
        final userId = user?.uid;
        await FirebaseFirestore.instance.collection('shipments').add({
          'category': _selectedOption,
          'weight': int.tryParse(weightController.text) ?? 0,
          'length': int.tryParse(lengthController.text) ?? 0,
          'width': int.tryParse(widthController.text) ?? 0,
          'height': int.tryParse(heightController.text) ?? 0,
          'city': _citysSelectedOption,
          'location': locationController.text,
          'destination': destinationcontroller.text,
          'userId': userId,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Shipment added successfully')),
        );

        setState(() {});
        // Go back to previous screen
        // Navigator.pop(context);
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add shipment')),
        );
        print('Failed to add shipment: $error');
      }
    }
  }

  String? _validateText(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("shipment details")),
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            Column(
              children: [
                Text(
                  "shipment details",
                  style: TextStyle(fontSize: 25),
                ),
                SizedBox(
                  height: 25,
                ),
                MyDropdownButtonFormField(
                  selectedOption: _selectedOption,
                  onChanged: (value) {
                    setState(() {
                      _selectedOption = value.toString();
                    });
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: weightController,
                  decoration: InputDecoration(
                    labelText: 'Weight',
                    hintText: 'Enter weight',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field is required';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: lengthController,
                  decoration: InputDecoration(
                    labelText: 'length',
                    hintText: 'Enter length',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field is required';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: widthController,
                  decoration: InputDecoration(
                    labelText: 'width',
                    hintText: 'Enter width',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field is required';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: heightController,
                  decoration: InputDecoration(
                    labelText: 'height',
                    hintText: 'Enter height',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field is required';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Shipping Address",
                  style: TextStyle(fontSize: 25),
                ),
                SizedBox(
                  height: 20,
                ),
                MyCityDropdownButtonFormField(
                  selectedOption: _citysSelectedOption,
                  onChanged: (value) {
                    setState(() {
                      _citysSelectedOption = value.toString();
                    });
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: locationController,
                  decoration: InputDecoration(
                    labelText: 'location Name',
                    hintText: 'Enter location name',
                  ),
                  validator: _validateText,
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: destinationcontroller,
                  decoration: InputDecoration(
                    labelText: 'destination Name',
                    hintText: 'Enter desintation name',
                  ),
                  validator: _validateText,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState != null &&
                        _formKey.currentState!.validate()) {
                      _submitForm();

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ShipmentList(),
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('shipment added')));
                      _selectedOption = 'food';
                      _citysSelectedOption = 'magusa';
                      weightController.clear();
                      lengthController.clear();
                      widthController.clear();
                      heightController.clear();
                      locationController.clear();
                      destinationcontroller.clear();
                    }
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
