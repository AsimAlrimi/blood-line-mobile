import 'package:blood_line_mobile/theme/app_theme.dart';
import 'package:blood_line_mobile/widgets/CustomAppBarRed.dart';
import 'package:flutter/material.dart';
import 'package:blood_line_mobile/services/faq_service.dart'; // Import FAQService

class FaqPage extends StatefulWidget {
  const FaqPage({super.key});

  @override
  State<FaqPage> createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  List<Map<String, dynamic>> dataRecords = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFAQs();
  }

  Future<void> _loadFAQs() async {
    final faqs = await FAQService.fetchFAQs(context);
    if (faqs != null) {
      setState(() {
        dataRecords = faqs;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(
            viewType: 'oneLine',
            Content: 'FAQ',
          ),
          isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : dataRecords.isEmpty
                  ? const Center(
                      child: Text(
                        'No FAQs available.',
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                    )
                  : Flexible(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16.0),
                        itemCount: dataRecords.length,
                        itemBuilder: (context, index) {
                          final record = dataRecords[index];
                          return FAQItem(
                            question: record['question'] ?? 'No question provided',
                            answer: record['answer'] ?? 'No answer provided',
                          );
                        },
                      ),
                    ),
        ],
      ),
    );
  }
}

class FAQItem extends StatefulWidget {
  final String question;
  final String answer;

  const FAQItem({
    required this.question,
    required this.answer,
    super.key,
  });

  @override
  _FAQItemState createState() => _FAQItemState();
}

class _FAQItemState extends State<FAQItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.question,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: AppTheme.red,
                      ),
                    ),
                  ),
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: AppTheme.red,
                  ),
                ],
              ),
            ),
            if (_isExpanded)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  widget.answer,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}