import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../db/notes_database.dart';
import '../models/note.dart';
import 'edit_note_page.dart';
import '../widgets/note_card.dart';
import '../services/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Note>> _notesFuture;

  @override
  void initState() {
    super.initState();
    _refreshNotes();
  }

  void _refreshNotes() {
    final userId = context.read<AuthService>().userId;
    setState(() {
      _notesFuture = NotesDatabase.instance.readAllNotes(userId!);
    });
  }

  @override
  void dispose() {
    // Don't close the database here - it will be reused when logging back in
    super.dispose();
  }

  Future<void> _deleteNote(int id) async {
    await NotesDatabase.instance.delete(id);
    _refreshNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Text('Logout'),
                onTap: () {
                  context.read<AuthService>().logout();
                  Navigator.of(context).pushReplacementNamed('/login');
                },
              ),
            ],
          ),
        ],
      ),
      body: FutureBuilder<List<Note>>(
        future: _notesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final notes = snapshot.data ?? [];
            if (notes.isEmpty) {
              return const Center(child: Text('No notes yet. Tap + to add one.'));
            }
            return ListView.separated(
              padding: const EdgeInsets.all(8),
              itemCount: notes.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final note = notes[index];
                return NoteCard(
                  note: note,
                  onEdit: () async {
                    await Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => EditNotePage(note: note),
                    ));
                    _refreshNotes();
                  },
                  onDelete: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Delete note?'),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete')),
                        ],
                      ),
                    );
                    if (confirm == true) {
                      await _deleteNote(note.id!);
                    }
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => const EditNotePage(),
          ));
          _refreshNotes();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
