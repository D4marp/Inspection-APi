import 'package:flutter/material.dart';
import 'inspection.dart';
import 'validation.dart';

void main() => runApp(MaterialApp(
  theme: ThemeData(useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal)),
  home: const InspectionListScreen()));

List<Inspection> seed() => List.generate(3, (i) => Inspection(
  id: 'seed-$i', assetCode: 'PMP-00${i + 1}', location: 'Workshop A',
  condition: i == 1 ? 'needs_action' : 'good',
  note: i == 1 ? 'Getaran motor perlu diperiksa' : '',
  createdAt: DateTime.utc(2026, 10, 3, 1, i)));
String conditionLabel(String value) => value == 'good' ? 'Baik' : 'Perlu tindak lanjut';

class InspectionListScreen extends StatefulWidget {
  const InspectionListScreen({super.key});
  @override
  State<InspectionListScreen> createState() => _InspectionListState();
}
class _InspectionListState extends State<InspectionListScreen> {
  List<Inspection> items = [];
  bool loading = true;
  String? error;
  @override
  void initState() { super.initState(); load(); }
  Future<void> load({bool fail = false}) async {
    setState(() { loading = true; error = null; });
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() {
      loading = false;
      if (fail) { error = 'Data gagal dimuat'; }
      else if (items.isEmpty) { items = seed(); }
    });
  }
  Future<void> add() async {
    final created = await Navigator.of(context).push<Inspection>(
      MaterialPageRoute(builder: (_) => const InspectionForm()));
    if (!mounted || created == null) return;
    setState(() => items = [created, ...items]);
  }
  @override
  Widget build(BuildContext context) {
    Widget body;
    if (loading) {
      body = const Center(child: CircularProgressIndicator());
    } else if (error != null) {
      body = Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text(error!), FilledButton(onPressed: () => load(), child: const Text('Coba lagi'))]));
    } else if (items.isEmpty) {
      body = Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Text('Belum ada inspeksi'),
        FilledButton(onPressed: add, child: const Text('Tambah inspeksi'))]));
    } else {
      body = ListView.builder(itemCount: items.length, itemBuilder: (context, index) {
        final item = items[index];
        return ListTile(key: ValueKey(item.id), title: Text(item.assetCode),
          subtitle: Text('${item.location}\n${conditionLabel(item.condition)}'),
          isThreeLine: true, onTap: () => Navigator.of(context).push<void>(
            MaterialPageRoute(builder: (_) => InspectionDetail(item: item))));
      });
    }
    return Scaffold(appBar: AppBar(title: const Text('Daftar inspeksi'), actions: [
      PopupMenuButton<String>(enabled: !loading, onSelected: (value) {
        if (value == 'empty') { setState(() { items = []; error = null; }); }
        if (value == 'error') { load(fail: true); }
        if (value == 'reload') { load(); }
      }, itemBuilder: (_) => const [
        PopupMenuItem(value: 'empty', child: Text('Demo kosong')),
        PopupMenuItem(value: 'error', child: Text('Demo error')),
        PopupMenuItem(value: 'reload', child: Text('Muat demo'))])]),
      body: SafeArea(child: body), floatingActionButton: loading || error != null ? null :
        FloatingActionButton(onPressed: add, child: const Icon(Icons.add)));
  }
}

class InspectionDetail extends StatelessWidget {
  final Inspection item;
  const InspectionDetail({super.key, required this.item});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(item.assetCode)),
    body: SingleChildScrollView(padding: const EdgeInsets.all(20), child:
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(item.location, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16), Text(conditionLabel(item.condition)),
        const SizedBox(height: 16), Text(item.note.isEmpty ? 'Tanpa catatan' : item.note),
        const SizedBox(height: 16), Text('Waktu lokal: ${item.createdAt.toLocal()}'),
        const SizedBox(height: 16), Text('ID: ${item.id}')])));
}

class InspectionForm extends StatefulWidget {
  const InspectionForm({super.key});
  @override
  State<InspectionForm> createState() => _InspectionFormState();
}
class _InspectionFormState extends State<InspectionForm> {
  final formKey = GlobalKey<FormState>();
  final asset = TextEditingController();
  final location = TextEditingController();
  final note = TextEditingController();
  String condition = 'good';
  @override
  void dispose() { asset.dispose(); location.dispose(); note.dispose(); super.dispose(); }
  void save() {
    if (!formKey.currentState!.validate()) return;
    final now = DateTime.now().toUtc();
    Navigator.of(context).pop(Inspection(id: 'local-${now.microsecondsSinceEpoch}',
      assetCode: asset.text.trim(), location: location.text.trim(),
      condition: condition, note: note.text.trim(), createdAt: now));
  }
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Tambah inspeksi')),
    body: SingleChildScrollView(padding: const EdgeInsets.all(20), child:
      Form(key: formKey, child: Column(children: [
        TextFormField(key: const Key('assetField'), controller: asset, maxLength: 30,
          decoration: const InputDecoration(labelText: 'Kode aset'),
          validator: (v) => (v ?? '').trim().isEmpty ? 'Kode aset wajib diisi' : null),
        TextFormField(key: const Key('locationField'), controller: location, maxLength: 80,
          decoration: const InputDecoration(labelText: 'Lokasi'),
          validator: (v) => (v ?? '').trim().isEmpty ? 'Lokasi wajib diisi' : null),
        DropdownButtonFormField<String>(value: condition,
          decoration: const InputDecoration(labelText: 'Kondisi'),
          items: const [DropdownMenuItem(value: 'good', child: Text('Baik')),
            DropdownMenuItem(value: 'needs_action', child: Text('Perlu tindak lanjut'))],
          onChanged: (v) { if (v != null) setState(() => condition = v); }),
        TextFormField(key: const Key('noteField'), controller: note, maxLength: 500,
          minLines: 2, maxLines: 4, decoration: const InputDecoration(labelText: 'Catatan'),
          validator: (v) => validateNote(condition, v ?? '')),
        const SizedBox(height: 16), FilledButton(key: const Key('saveButton'),
          onPressed: save, child: const Text('Simpan')),
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Batal'))]))));
}
