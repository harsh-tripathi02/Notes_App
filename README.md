"# 📝 Flutter Notes App - Enhanced Edition

A beautiful, feature-rich notes application built with Flutter, featuring rich text formatting, colorful text support, and comprehensive export capabilities including PDF generation.

## ✨ Features

### 🎨 Rich Text Editing
- **Text Formatting**: Bold, Italic, Underline, Strikethrough
- **Headings**: H1, H2, H3 support for structured notes
- **Colorful Text**: Choose from a vibrant color palette for text
- **Text Highlighting**: Background color support for important sections
- **Live Preview**: See formatting changes in real-time

### 📤 Export & Share
- **PDF Export**: Generate beautifully formatted, colorful PDFs preserving all text colors and styles
- **Multiple Formats**: Export as PDF, TXT, Markdown, or HTML
- **Printing**: Direct print support with print preview
- **Share**: Native sharing via WhatsApp, Email, and other apps
- **Copy to Clipboard**: Quick copy functionality

### 🎯 Core Features
- **Create & Edit Notes**: Intuitive note creation and editing
- **Rich Formatting Toolbar**: Easy-to-use formatting controls
- **Search**: Quickly find notes by title or content
- **Pin Notes**: Keep important notes at the top
- **Color Coding**: Assign colors to notes for visual organization
- **Tags**: Organize notes with tags (coming soon)
- **Auto-save**: Never lose your work with smart auto-save indicators

### 🌓 UI/UX
- **Dark Mode**: Beautiful dark theme support
- **Material Design 3**: Modern, clean interface
- **Smooth Animations**: Polished user experience
- **Character/Word Count**: Track your writing progress
- **Reading Time**: Estimated reading time for each note
- **Formatted Previews**: See formatted text in note cards

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd Notes_App
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  path_provider: ^2.1.1          # Reliable storage
  shared_preferences: ^2.2.2     # User preferences
  intl: ^0.18.1                  # Date formatting
  pdf: ^3.10.7                   # PDF generation
  printing: ^5.12.0              # PDF preview & printing
  share_plus: ^7.2.1             # Native sharing
  flex_color_picker: ^3.4.1      # Color picker
  permission_handler: ^11.1.0    # Permissions
```

## 🎨 How to Use

### Creating a Note
1. Tap the **+** button on the home screen
2. Enter a title and start typing
3. Use the formatting toolbar to style your text
4. Tap the **Save** button when done

### Formatting Text
1. Select the text you want to format
2. Use the toolbar at the bottom:
   - **B** for Bold
   - **I** for Italic
   - **U** for Underline
   - **S** for Strikethrough
   - **H1/H2/H3** for headings
   - **Color icons** for text and highlight colors

### Exporting Notes
1. Open a note
2. Tap the **Share** icon in the app bar
3. Choose your export format:
   - **PDF**: Colorful, formatted PDF
   - **Text**: Plain text file
   - **Markdown**: For developers
   - **HTML**: Web format
4. Share via your preferred app or save to device

### Color Picker
- Tap the text color or highlight color button
- Choose from preset colors or use the color wheel
- Your selection is applied to selected text immediately

## 🏗️ Architecture

```
lib/
├── main.dart                    # App entry point
├── models/
│   ├── note.dart                # Note data model with formatting
│   └── text_format.dart         # Rich text formatting structures
├── screens/
│   ├── home_screen.dart         # Note list view
│   └── enhanced_editor_screen.dart  # Rich text editor
├── services/
│   ├── note_service.dart        # Note CRUD operations
│   ├── pdf_generator_service.dart   # PDF generation
│   ├── export_service.dart      # Multi-format export
│   └── share_service.dart       # Sharing functionality
├── widgets/
│   ├── note_card.dart           # Note list item
│   ├── formatting_toolbar.dart  # Text formatting controls
│   ├── color_picker_dialog.dart # Color selection
│   ├── export_options_sheet.dart # Export menu
│   ├── empty_state.dart         # Empty state view
│   └── search_bar.dart          # Search widget
├── themes/
│   └── app_themes.dart          # Light/Dark themes
└── utils/
    ├── data_formatter.dart      # Date formatting
    └── rich_text_controller.dart # Rich text control logic
```

## 🎯 Features in Detail

### PDF Generation
- Preserves all text colors and formatting
- Includes note metadata (created/updated dates, tags)
- Beautiful layout with color-coded headers
- Page numbers and generation timestamp
- Optimized for both viewing and printing

### Rich Text Controller
- Custom controller extending TextEditingController
- Manages formatting segments with precise positioning
- Supports overlapping and adjacent formatting
- Efficient rendering with TextSpan composition

### Storage
- Uses `path_provider` for reliable, app-specific storage
- JSON-based persistence for cross-platform compatibility
- Automatic data migration from temp storage
- Crash-resistant save operations

## 🔮 Upcoming Features

- [ ] Grid view for notes
- [ ] Advanced search with filters
- [ ] Bulk operations (delete, export multiple notes)
- [ ] Note templates
- [ ] Reminders and notifications
- [ ] Biometric lock
- [ ] Cloud sync
- [ ] Collaborative editing

## 🐛 Known Issues

- None currently reported

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

## 👏 Acknowledgments

- Flutter team for the amazing framework
- All the package maintainers whose work made this possible
- The open-source community

## 📧 Contact

For questions or feedback, please open an issue on GitHub.

---

**Made with ❤️ using Flutter**" 
