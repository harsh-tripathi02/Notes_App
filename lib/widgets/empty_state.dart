import 'package:flutter/material.dart';

/// Widget displayed when there are no notes to show.
class EmptyState extends StatelessWidget {
  final String? searchQuery;

  const EmptyState({
    Key? key,
    this.searchQuery,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              searchQuery != null && searchQuery!.isNotEmpty
                  ? Icons.search_off
                  : Icons.note_add_outlined,
              size: 64,
              color: isDark ? Colors.grey[600] : Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              searchQuery != null && searchQuery!.isNotEmpty
                  ? 'No notes found'
                  : 'No notes yet',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              searchQuery != null && searchQuery!.isNotEmpty
                  ? 'Try a different search term'
                  : 'Create your first note by tapping the + button',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}