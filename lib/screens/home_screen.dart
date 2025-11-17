import 'package:flutter/material.dart';
import '../models/note.dart';
import '../services/note_service.dart';
import '../widgets/note_card.dart';
import '../widgets/empty_state.dart';
import '../widgets/search_bar.dart' as search_widgets;
import 'editor_screen.dart';

/// Home screen displaying all notes with search and create functionality.
class HomeScreen extends StatefulWidget {
  final NotesService notesService;

  const HomeScreen({Key? key, required this.notesService}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Note> _notes = [];
  List<Note> _filteredNotes = [];
  String _searchQuery = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    setState(() => _isLoading = true);
    try {
      final notes = await widget.notesService.getAll();
      setState(() {
        _notes = notes;
        _applySearch(_searchQuery);
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading notes: $e')),
      );
      setState(() => _isLoading = false);
    }
  }

  void _applySearch(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredNotes = _notes;
      } else {
        _filteredNotes = _notes
            .where((note) =>
                note.title.toLowerCase().contains(query.toLowerCase()) ||
                note.content.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _navigateToEditor({Note? note}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditorScreen(
          notesService: widget.notesService,
          note: note,
          onSave: _loadNotes,
        ),
      ),
    );
  }

  Future<void> _deleteNote(Note note) async {
    try {
      await widget.notesService.delete(note.id);
      await _loadNotes();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting note: $e')),
      );
    }
  }

  Future<void> _togglePin(Note note) async {
    try {
      await widget.notesService.togglePin(note);
      await _loadNotes();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating note: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notes',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('About'),
                  content: const Text(
                    'Flutter Notes App\n\nA production-ready notes app with local storage, themes, and animations.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                search_widgets.SearchBar(
                  onChanged: _applySearch,
                ),
                Expanded(
                  child: _filteredNotes.isEmpty
                      ? EmptyState(searchQuery: _searchQuery)
                      : ListView.builder(
                          itemCount: _filteredNotes.length,
                          itemBuilder: (context, index) {
                            final note = _filteredNotes[index];
                            return NoteCard(
                              note: note,
                              onTap: () => _navigateToEditor(note: note),
                              onDelete: () => _deleteNote(note),
                              onPinChanged: (_) => _togglePin(note),
                            );
                          },
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToEditor(),
        tooltip: 'Create new note',
        child: const Icon(Icons.add),
      ),
    );
  }
}