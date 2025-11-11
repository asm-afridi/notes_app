# Notes App

A secure, multi-user note-taking application built with Flutter. Create, edit, and manage your personal notes with user authentication and local database storage.

## Features

✨ **User Authentication**
- User registration and login system
- Secure password hashing using SHA256
- Session management with logout functionality

📝 **Note Management**
- Create, read, update, and delete notes
- Organize notes by creation date (newest first)
- Rich text editor for note content
- User-specific note isolation (each user sees only their own notes)

💾 **Data Storage**
- SQLite database for persistent local storage
- Separate databases for authentication and notes
- Automatic database migration support

🔒 **Security**
- Password hashing with SHA256 encryption
- User isolation (notes are user-specific)
- Secure database connection handling

## Project Structure

```
lib/
├── main.dart                 # App entry point and initialization
├── db/
│   ├── auth_database.dart   # Authentication database operations
│   └── notes_database.dart  # Notes database operations
├── models/
│   └── note.dart            # Note data model
├── services/
│   └── auth_service.dart    # Authentication state management
├── pages/
│   ├── login_page.dart      # Login/Registration UI
│   ├── home_page.dart       # Notes list and navigation
│   └── edit_note_page.dart  # Note creation/editing
└── widgets/
    └── note_card.dart       # Note display widget
```

## Dependencies

- **sqflite** - SQLite database for Flutter
- **sqflite_common_ffi** - FFI support for desktop platforms
- **path_provider** - Access application documents directory
- **path** - Path manipulation utilities
- **crypto** - SHA256 password hashing
- **provider** - State management
- **intl** - Internationalization

## Getting Started

### Prerequisites

- Flutter SDK (3.9.2 or later)
- Dart SDK
- Android SDK (for Android) or Xcode (for iOS)
- For Linux desktop: `libsqlite3-dev`
  ```bash
  sudo apt-get install -y libsqlite3-dev
  ```

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/asm-afridi/notes_app.git
   cd notes_app
   ```

2. Get dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

## Usage

### First Time Setup

1. Launch the app
2. Choose between **Login** or **Register**
3. For new users, click "Don't have an account? Register" to create an account
4. Enter a username and password (minimum 6 characters)
5. Click **Register** to create your account

### Creating Notes

1. After logging in, you'll see your notes list
2. Tap the **+** button to create a new note
3. Enter a title and content
4. Tap **Save** to store the note

### Managing Notes

- **Edit Note**: Tap on any note to edit its content
- **Delete Note**: Swipe or tap the delete option on a note card
- **Logout**: Tap the menu icon (three dots) in the top-right corner and select **Logout**

## Database Schema

### Users Table (auth.db)
```sql
CREATE TABLE users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  username TEXT UNIQUE NOT NULL,
  password TEXT NOT NULL,
  createdAt TEXT NOT NULL
)
```

### Notes Table (notes.db)
```sql
CREATE TABLE notes (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  userId INTEGER NOT NULL,
  title TEXT,
  content TEXT,
  createdAt TEXT
)
```

## Security Notes

- Passwords are hashed using SHA256 before storage
- Each user's notes are isolated and only visible to that user
- Database files are stored in the application documents directory
- No sensitive data is transmitted over the network (local storage only)

## File Storage Locations

- **Android**: `/data/data/com.example.notes_app/`
- **iOS**: `/var/mobile/Containers/Data/Application/.../Documents/`
- **Linux**: `~/.local/share/notes_app/`
- **macOS**: `~/Library/Application Support/com.example.notes_app/`
- **Windows**: `%APPDATA%/notes_app/`

## Development

### Running Tests

```bash
flutter test
```

### Building for Production

**Android:**
```bash
flutter build apk
flutter build appbundle
```

**iOS:**
```bash
flutter build ios
```

**Web:**
```bash
flutter build web
```

**Desktop (Linux):**
```bash
flutter build linux
```

## Troubleshooting

### Database Connection Errors
If you encounter `DatabaseException(database_closed)`:
- Restart the app
- Delete the database files and create a new account

### SQLite Library Not Found
On Linux, install the required library:
```bash
sudo apt-get install -y libsqlite3-dev
```

### Port Already in Use
If developing with a running instance, use:
```bash
flutter run --no-fast-start
```

## Future Enhancements

- [ ] Cloud synchronization
- [ ] Note sharing between users
- [ ] Rich text formatting (bold, italic, etc.)
- [ ] Note categories/tags
- [ ] Search functionality
- [ ] Dark mode support
- [ ] Note encryption
- [ ] Backup and restore functionality

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is open source and available under the MIT License.

## Contact

For questions or feedback, please open an issue on the GitHub repository.

---

**Built with ❤️ using Flutter**
