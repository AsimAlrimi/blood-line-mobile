import 'package:blood_line_mobile/theme/app_theme.dart';
import 'package:flutter/material.dart';

class FAQContactCard extends StatelessWidget {
  final VoidCallback onFAQTap;
  final VoidCallback onContactUsTap;

  const FAQContactCard({
    Key? key,
    required this.onFAQTap,
    required this.onContactUsTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.0,
      margin: const EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: AppTheme.lightgrey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text('FAQ'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: onFAQTap,
          ),
          const Divider(
            thickness: 1.0,
            height: 1.0,
          ),
          ListTile(
            title: const Text('Contact Us'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: onContactUsTap,
          ),
        ],
      ),
    );
  }
}
