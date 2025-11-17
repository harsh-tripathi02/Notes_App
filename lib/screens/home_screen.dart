import 'package:flutter/material.dart';
import '../models/note.dart';
import '../services/note_service.dart';
import '../widgets/note_card.dart';
import '../widgets/empty_state.dart';
import 'enhanced_editor_screen.dart';
import 'settings_screen.dart';

/// Home screen displaying all notes with search and create functionality.
class HomeScreen extends StatefulWidget {
  final NotesService notesService;

  const HomeScreen({super.key, required this.notesService});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Note> _notes = [];
  List<Note> _filteredNotes = [];
  String _searchQuery = '';
  bool _isLoading = true;
  bool _isGridView = false; // Grid/List view toggle

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
        builder: (context) => EnhancedEditorScreen(
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0A0E21) : const Color(0xFFF5F7FA),
      body: CustomScrollView(
        slivers: [
          // Modern App Bar with gradient
          SliverAppBar(
            expandedHeight: 160.0,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDark
                        ? [const Color(0xFF1E2A47), const Color(0xFF2D3E5F)]
                        : [const Color(0xFF667EEA), const Color(0xFF764BA2)],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Icon(
                                Icons.note_alt_outlined,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const Spacer(),
                            // View toggle
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: IconButton(
                                icon: Icon(
                                  _isGridView ? Icons.view_agenda_rounded : Icons.grid_view_rounded,
                                  color: Colors.white,
                                ),
                                onPressed: () => setState(() => _isGridView = !_isGridView),
                                tooltip: _isGridView ? 'List View' : 'Grid View',
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Settings
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.settings_rounded, color: Colors.white),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SettingsScreen(
                                        onThemeChanged: (mode) {},
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'My Notes',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${_filteredNotes.length} ${_filteredNotes.length == 1 ? 'note' : 'notes'}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withValues(alpha: 0.8),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          // Search bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E2A47) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  onChanged: _applySearch,
                  decoration: InputDecoration(
                    hintText: 'Search notes...',
                    hintStyle: TextStyle(
                      color: isDark ? Colors.grey[500] : Colors.grey[400],
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  ),
                ),
              ),
            ),
          ),
          
          // Content
          _isLoading
              ? const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                )
              : _filteredNotes.isEmpty
                  ? SliverFillRemaining(
                      child: EmptyState(searchQuery: _searchQuery),
                    )
                  : _isGridView
                      ? SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          sliver: SliverGrid(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.75,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final note = _filteredNotes[index];
                                return NoteCard(
                                  note: note,
                                  onTap: () => _navigateToEditor(note: note),
                                  onDelete: () => _deleteNote(note),
                                  onPinChanged: (_) => _togglePin(note),
                                );
                              },
                              childCount: _filteredNotes.length,
                            ),
                          ),
                        )
                      : SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final note = _filteredNotes[index];
                                return NoteCard(
                                  note: note,
                                  onTap: () => _navigateToEditor(note: note),
                                  onDelete: () => _deleteNote(note),
                                  onPinChanged: (_) => _togglePin(note),
                                );
                              },
                              childCount: _filteredNotes.length,
                            ),
                          ),
                        ),
          
          // Bottom padding for FAB
          const SliverToBoxAdapter(
            child: SizedBox(height: 80),
          ),
        ],
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: isDark
                ? [const Color(0xFF667EEA), const Color(0xFF764BA2)]
                : [const Color(0xFF667EEA), const Color(0xFF764BA2)],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF667EEA).withValues(alpha: 0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          heroTag: 'home_fab',
          onPressed: () => _navigateToEditor(),
          backgroundColor: Colors.transparent,
          elevation: 0,
          label: const Text(
            'New Note',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          icon: const Icon(Icons.add_rounded, size: 24),
        ),
      ),
    );
  }
}