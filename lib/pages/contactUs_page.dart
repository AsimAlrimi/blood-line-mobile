import 'package:blood_line_mobile/theme/app_theme.dart';
import 'package:blood_line_mobile/widgets/CustomAppBarRed.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ContactusPage extends StatefulWidget {
  const ContactusPage({super.key});

  @override
  State<ContactusPage> createState() => _ContactusPageState();
}

class _ContactusPageState extends State<ContactusPage> {
  // Form controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  // Contact methods
  final List<Map<String, dynamic>> _contactMethods = [
    {
      'icon': Icons.email,
      'title': 'Email',
      'subtitle': 'bloodlineplatform@gmail.com',
      'onCopy': (BuildContext context) {
        Clipboard.setData(
          ClipboardData(text: 'bloodlineplatform@gmail.com')
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Email copied to clipboard'))
        );
      }
    },
    {
      'icon': Icons.phone,
      'title': 'Phone',
      'subtitle': '(06) 520 0230',
      'onCopy': (BuildContext context) {
        Clipboard.setData(
          ClipboardData(text: '+1 (555) 123-4567')
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Phone number copied to clipboard'))
        );
      }
    },
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(
            viewType: 'oneLine',
            Content: 'Contact US',
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Intro Text
                  Text(
                    "Get In Touch",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.red,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Don't hesitate to contact us whether you have a suggestion on our improvement, a complaint to discuss, or an issue to solve.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 20),

                  // Contact Methods
                  Text(
                    "Contact Methods",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.red,
                    ),
                  ),
                  SizedBox(height: 10),
                  ...(_contactMethods.map((method) => _buildContactMethodTile(method)).toList()),

                  SizedBox(height: 20),

                  /*
                  // Message Form
                  Text(
                    "Send us a Message",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.red,
                    ),
                  ),
                  SizedBox(height: 10),
                  _buildMessageForm(),*/
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Custom widget for contact method tiles
  Widget _buildContactMethodTile(Map<String, dynamic> method) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(method['icon'], color: AppTheme.red),
        title: Text(method['title']),
        subtitle: Text(method['subtitle']),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.content_copy, size: 20),
              onPressed: () => method['onCopy'](context),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up controllers
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }
}