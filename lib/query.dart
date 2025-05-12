import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class QueryPage extends StatefulWidget {
  const QueryPage({Key? key}) : super(key: key);

  @override
  _QueryPageState createState() => _QueryPageState();
}

class _QueryPageState extends State<QueryPage> {
  final TextEditingController _controller = TextEditingController();
  String _response = '';
  List<String> _chatHistory = [];

  Future<void> _askQuestion(String question) async {
    if (question.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a question')),
      );
      return;
    }

    final url = Uri.parse('http://127.0.0.1:8050/ask');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'query': question}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      final answer =
          data['answer'] + '\nResponse time: ' + data['response_time'].toString();

      String sourceDetails = '\n\nSource Documents:';
      for (var doc in data['source_documents']) {
        sourceDetails += '\n\nDocument Name: ${doc['document_name']}';
        sourceDetails += '\nPage Number: ${doc['page_number']}';
        sourceDetails += '\nSource Text: ${doc['source_text']}';
      }

      setState(() {
        _response = answer + sourceDetails;
        _chatHistory.insert(0, 'Q: $question\nA: $answer$sourceDetails');
      });
    } else {
      setState(() {
        _response = 'Error: Unable to get response';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Chat'),
        backgroundColor: const Color.fromARGB(255, 184, 188, 190),
        elevation: 5,
      ),
      body: Row(
        children: [
          // Chat History Panel
          Container(
            width: MediaQuery.of(context).size.width * 0.35,
            color: Colors.blueGrey.shade800,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    'Chat History',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const Divider(color: Colors.white54),
                Expanded(
                  child: ListView.builder(
                    itemCount: _chatHistory.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: Colors.blueGrey.shade700,
                        margin: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            _chatHistory[index],
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Main Panel
          Expanded(
            child: Container(
              color: Colors.blueGrey.shade900,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Response Section
                    const Text(
                      'Response:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.blueGrey.shade800,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _response.isNotEmpty
                                ? _response
                                : 'Your response will appear here.',
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Input Section
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'Enter your question...',
                              hintStyle: TextStyle(color: Colors.grey.shade400),
                              filled: true,
                              fillColor: Colors.blueGrey.shade700,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            final question = _controller.text;
                            _controller.clear();
                            _askQuestion(question);
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 16),
                            backgroundColor: const Color.fromARGB(255, 127, 171, 248),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text('Ask'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
