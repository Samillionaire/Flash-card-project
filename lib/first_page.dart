import 'package:flutter/material.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  final List<Map<String, String>> _flashcards = [];

  void _addFlashcard(String question, String answer) {
    setState(() {
      _flashcards.add({'question': question, 'answer': answer});
    });
  }

  void _editFlashcard(int index, String question, String answer) {
    setState(() {
      _flashcards[index] = {'question': question, 'answer': answer};
    });
  }

  void _deleteFlashcard(int index) {
    setState(() {
      _flashcards.removeAt(index);
    });
  }

  void _showDeleteConfirmation(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title:  Text('Delete Flashcard'),
        content:  Text('Are you sure you want to delete this flashcard?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child:  Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _deleteFlashcard(index);
              Navigator.of(context).pop();
            },
            child:  Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showFlashcardForm({int? index}) {
    final TextEditingController questionController = TextEditingController();
    final TextEditingController answerController = TextEditingController();

    if (index != null) {
      questionController.text = _flashcards[index]['question']!;
      answerController.text = _flashcards[index]['answer']!;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(index == null ? 'Add Flashcard' : 'Edit Flashcard'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: questionController,
              decoration:  InputDecoration(labelText: 'Question'),
            ),
            TextField(
              controller: answerController,
              decoration:  InputDecoration(labelText: 'Answer'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child:  Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final question = questionController.text;
              final answer = answerController.text;
              if (question.isNotEmpty) {
                if (index == null) {
                  _addFlashcard(question, answer);
                } else {
                  _editFlashcard(index, question, answer);
                }
                Navigator.of(context).pop();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                   SnackBar(content: Text('Question cannot be empty')),
                );
              }
            },
            child:  Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('Flashcards'),
      ),
      body: ListView.builder(
        itemCount: _flashcards.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(_flashcards[index]['question']!),
              subtitle: TextButton(
                onPressed: () {
                  setState(() {
                    _flashcards[index]['showAnswer'] =
                    _flashcards[index]['showAnswer'] == 'true' ? 'false' : 'true';
                  });
                },
                child: Text(
                  _flashcards[index]['showAnswer'] == 'true'
                      ? _flashcards[index]['answer']!
                      : 'Tap to show answer',
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon:  Icon(Icons.edit),
                    onPressed: () => _showFlashcardForm(index: index),
                  ),
                  IconButton(
                    icon:  Icon(Icons.delete),
                    onPressed: () => _showDeleteConfirmation(index),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showFlashcardForm(),
        child:  Icon(Icons.add),
      ),
    );
  }
}
