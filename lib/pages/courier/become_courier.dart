import 'package:flutter/material.dart';
import 'package:speedyship/components/my_button2.dart';
import 'package:speedyship/pages/courier/courier_main.dart';
import 'package:speedyship/pages/courier/courier_register.dart';

class BecomeCourierPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Become a Courier'),
        backgroundColor: Colors.teal, // Set the background color to teal
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Why work with us?',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                '- Flexible hours: Choose when and where you want to work. Whether you\'re looking for a full-time gig or just some extra cash on the side, we\'ve got you covered.',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 8.0),
              Text(
                '- Competitive pay: We offer competitive rates based on distance and delivery type.',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 8.0),
              Text(
                '- Easy to use app: Our user-friendly app makes it easy to manage your deliveries and track your earnings.',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 8.0),
              Text(
                '- Supportive team: Our team is always here to help, whether you have questions about the app or need assistance with a delivery.',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 16.0),
              Text(
                'Requirements',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                '- A reliable vehicle (car, truck, or van)',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 8.0),
              Text(
                '- A valid driver\'s license and insurance',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 8.0),
              Text(
                '- A smartphone with internet access',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 8.0),
              Text(
                '- Basic navigation skills',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 8.0),
              Text(
                '- A positive attitude and excellent customer service skills',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 16.0),
              Text(
                'How to apply',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'To apply to become a courier, simply fill out our online application form. We\'ll review your application and get back to you within 48 hours.',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 16.0),
              MyButton2(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DocumentUploader(),
                    ),
                  );
                },
                buttonText: 'Continue',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
