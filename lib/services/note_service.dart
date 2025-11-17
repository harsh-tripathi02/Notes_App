import 'dart:io';
import 'dart:convert';
import '../models/note.dart';

/// Service for managing note persistence using local file storage.
/// 
/// IMPORTANT: Uses [Directory.systemTemp] as fallback storage.
/// This location may be cleared by the OS, especially on mobile platforms.
/// 
/// For production apps, use `path_provider` package:
/// ```
/// import 'package:path_provider/path_provider.dart';
/// final dir = await getApplicationDocumentsDirectory();
/// ```
/// This provides a stable, app-specific directory.
class NotesService {
  static const String _fileName = 'notes_data.json';
  
  List<Note> _notes = [];
  late Directory _storageDir;
  bool _initialized = false;

  /// Initialize the service and load notes from storage.
  /// Must be called before any other methods.
  Future<void> initialize() async {
    if (_initialized) return;

    try {
      // Using systemTemp as fallback. In production, use path_provider.
      _storageDir = Directory.systemTemp;
      await _load();
      _initialized = true;
    } catch (e) {
      print('Error initializing NotesService: $e');
      _notes = _getDefaultNotes();
      _initialized = true;
    }
  }

  /// Retrieve all notes, optionally sorted by pinned status then date.
  Future<List<Note>> getAll() async {
    _ensureInitialized();
    return _notes
        .toList()
        ..sort((a, b) {
          if (a.pinned != b.pinned) {
            return b.pinned ? 1 : -1;
          }
          return b.updatedAt.compareTo(a.updatedAt);
        });
  }

  /// Search notes by title or content.
  Future<List<Note>> search(String query) async {
    _ensureInitialized();
    if (query.isEmpty) return getAll();
    
    final lowerQuery = query.toLowerCase();
    return _notes
        .where((note) =>
            note.title.toLowerCase().contains(lowerQuery) ||
            note.content.toLowerCase().contains(lowerQuery))
        .toList()
        ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  /// Create a new note and persist it.
  Future<Note> create(String title, String content) async {
    _ensureInitialized();
    final now = DateTime.now();
    final note = Note(
      id: _generateId(),
      title: title.isEmpty ? 'Untitled' : title,
      content: content,
      createdAt: now,
      updatedAt: now,
    );
    _notes.add(note);
    await _save();
    return note;
  }

  /// Update an existing note.
  Future<Note> update(Note note) async {
    _ensureInitialized();
    final index = _notes.indexWhere((n) => n.id == note.id);
    if (index == -1) throw Exception('Note not found');
    
    final updated = note.copyWith(updatedAt: DateTime.now());
    _notes[index] = updated;
    await _save();
    return updated;
  }

  /// Delete a note by ID.
  Future<void> delete(String id) async {
    _ensureInitialized();
    _notes.removeWhere((note) => note.id == id);
    await _save();
  }

  /// Toggle the pinned status of a note.
  Future<Note> togglePin(Note note) async {
    return update(note.copyWith(pinned: !note.pinned));
  }

  // Private methods for file I/O and utilities

  /// Load notes from JSON file.
  Future<void> _load() async {
    final file = File('${_storageDir.path}/$_fileName');
    if (!await file.exists()) {
      _notes = _getDefaultNotes();
      return;
    }

    try {
      final contents = await file.readAsString();
      final jsonData = jsonDecode(contents) as List;
      _notes = jsonData.map((item) => Note.fromJson(item as Map<String, dynamic>)).toList();
    } catch (e) {
      print('Error loading notes: $e');
      _notes = _getDefaultNotes();
    }
  }

  /// Persist notes to JSON file.
  Future<void> _save() async {
    try {
      final file = File('${_storageDir.path}/$_fileName');
      final jsonData = jsonEncode(_notes.map((note) => note.toJson()).toList());
      await file.writeAsString(jsonData);
    } catch (e) {
      print('Error saving notes: $e');
    }
  }

  /// Generate a unique ID for new notes (simple UUID-style).
  String _generateId() {
    return '${DateTime.now().millisecondsSinceEpoch}-${(DateTime.now().microsecond % 1000)}';
  }

  /// Provide default seed notes on first run.
  List<Note> _getDefaultNotes() {
    final now = DateTime.now();
    return [
      Note(
        id: _generateId(),
        title: 'Welcome to Notes App',
        content: 'Create, edit, and organize your notes effortlessly. Tap a note to edit it, or swipe to delete.',
        createdAt: now,
        updatedAt: now,
        color: '#E8F5E9',
      ),
      Note(
        id: _generateId(),
        title: 'Pro Tips',
        content: 'Tap the search icon to find notes quickly. Pin important notes for quick access. Use dark mode for comfortable reading.',
        createdAt: now.subtract(const Duration(days: 1)),
        updatedAt: now.subtract(const Duration(days: 1)),
        color: '#FFF3E0',
        pinned: true,
      ),
    ];
  }

  void _ensureInitialized() {
    if (!_initialized) {
      throw StateError('NotesService not initialized. Call initialize() first.');
    }
  }
}