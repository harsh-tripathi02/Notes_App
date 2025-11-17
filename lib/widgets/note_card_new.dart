import 'package:flutter/material.dart';
import '../models/note.dart';
import '../themes/app_themes.dart';
import '../utils/data_formatter.dart';

/// Modern, elegant note card with gradients and animations
class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final ValueChanged<bool> onPinChanged;

  const NoteCard({
    super.key,
    required this.note,
    required this.onTap,
    required this.onDelete,
    required this.onPinChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = AppThemes.hexToColor(note.color);
    
    // Create a lighter/darker variant for gradient
    final gradientColor = HSLColor.fromColor(cardColor);
    final endColor = isDark
        ? gradientColor.withLightness((gradientColor.lightness - 0.1).clamp(0.0, 1.0)).toColor()
        : gradientColor.withLightness((gradientColor.lightness + 0.1).clamp(0.0, 1.0)).toColor();

    return Dismissible(
      key: ValueKey(note.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        onDelete();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Note deleted'),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            duration: const Duration(seconds: 2),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {},
            ),
          ),
        );
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red.shade400, Colors.red.shade600],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(Icons.delete_rounded, color: Colors.white, size: 28),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Hero(
          tag: 'note_${note.id}',
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [cardColor, endColor],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: cardColor.withValues(alpha: 0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withValues(alpha: isDark ? 0.05 : 0.3),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Header with title and pin
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                note.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : Colors.grey[900],
                                  letterSpacing: -0.5,
                                  height: 1.3,
                                ),
                              ),
                            ),
                            if (note.pinned)
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.push_pin_rounded,
                                  size: 16,
                                  color: Colors.orange.shade700,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        
                        // Content preview
                        note.formatting != null && note.formatting!.segments.isNotEmpty
                            ? RichText(
                                text: note.formatting!.toTextSpan(
                                  baseStyle: TextStyle(
                                    fontSize: 14,
                                    color: isDark ? Colors.grey[300] : Colors.grey[700],
                                    height: 1.5,
                                  ),
                                ),
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                              )
                            : Text(
                                note.content.isEmpty ? 'No content' : note.content,
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isDark ? Colors.grey[300] : Colors.grey[700],
                                  height: 1.5,
                                ),
                              ),
                        
                        const SizedBox(height: 12),
                        
                        // Footer with tags and date
                        Row(
                          children: [
                            // Tags
                            if (note.tags.isNotEmpty)
                              Expanded(
                                child: Wrap(
                                  spacing: 6,
                                  runSpacing: 6,
                                  children: note.tags.take(2).map((tag) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: (isDark ? Colors.white : Colors.black)
                                            .withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: (isDark ? Colors.white : Colors.black)
                                              .withValues(alpha: 0.2),
                                          width: 1,
                                        ),
                                      ),
                                      child: Text(
                                        tag,
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: isDark ? Colors.grey[200] : Colors.grey[800],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            
                            // Date
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: (isDark ? Colors.white : Colors.black)
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.access_time_rounded,
                                    size: 12,
                                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    DateFormatter.formatDate(note.updatedAt),
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
