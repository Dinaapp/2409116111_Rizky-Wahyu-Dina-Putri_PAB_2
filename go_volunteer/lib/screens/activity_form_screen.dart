import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/activity.dart';
import '../providers/app_provider.dart';

class ActivityFormScreen extends StatefulWidget {
  final Activity? activity;
  const ActivityFormScreen({super.key, this.activity});
  @override
  State<ActivityFormScreen> createState() => _ActivityFormScreenState();
}

class _ActivityFormScreenState extends State<ActivityFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _organizerController;
  late final TextEditingController _descController;
  late final TextEditingController _locationController;
  late final TextEditingController _benefitsController;
  late final TextEditingController _maxController;

  String _selectedCategory = 'Lingkungan';
  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  bool _isSaving = false;

  final _categories = ['Lingkungan', 'Kesehatan', 'Pendidikan', 'Sosial'];
  bool get isEdit => widget.activity != null;

  @override
  void initState() {
    super.initState();
    final a = widget.activity;
    _titleController     = TextEditingController(text: a?.title ?? '');
    _organizerController = TextEditingController(text: a?.organizer ?? '');
    _descController      = TextEditingController(text: a?.description ?? '');
    _locationController  = TextEditingController(text: a?.location ?? '');
    _benefitsController  = TextEditingController(text: a?.benefits ?? '');
    _maxController       = TextEditingController(text: a?.maxParticipants.toString() ?? '50');

    if (a != null) {
      _selectedCategory = a.category;
      try {
        _selectedDate = DateFormat('d MMMM yyyy', 'id_ID').parse(a.date);
      } catch (_) { _selectedDate = null; }
      try {
        final parts = a.time.replaceAll(' WITA', '').split(' - ');
        if (parts.length == 2) {
          _startTime = _parseTimeOfDay(parts[0].trim());
          _endTime   = _parseTimeOfDay(parts[1].trim());
        }
      } catch (_) { _startTime = null; _endTime = null; }
    }
  }

  TimeOfDay _parseTimeOfDay(String s) {
    final parts = s.replaceAll('.', ':').split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  @override
  void dispose() {
    for (final c in [_titleController, _organizerController, _descController,
        _locationController, _benefitsController, _maxController]) {
      c.dispose();
    }
    super.dispose();
  }

  String _formatTime(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}.${t.minute.toString().padLeft(2, '0')}';

  String _formatDate(DateTime d) {
    const months = ['', 'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
        'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'];
    return '${d.day} ${months[d.month]} ${d.year}';
  }

  String get _timeString => (_startTime == null || _endTime == null)
      ? '' : '${_formatTime(_startTime!)} - ${_formatTime(_endTime!)} WITA';

  Future<void> _pickDate() async {
    final today = DateTime.now();
    final first = DateTime(today.year, today.month, today.day);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final picked = await showDatePicker(
      context: context,
      initialDate: (_selectedDate != null && _selectedDate!.isAfter(first)) ? _selectedDate! : first,
      firstDate: first,
      lastDate: DateTime(today.year + 3),
      locale: const Locale('id', 'ID'),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: isDark
              ? const ColorScheme.dark(primary: Color(0xFF1E88E5), onPrimary: Colors.white)
              : const ColorScheme.light(primary: Color(0xFF1565C0), onPrimary: Colors.white, onSurface: Color(0xFF1A1A1A)),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickTime({required bool isStart}) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final initial = isStart
        ? (_startTime ?? const TimeOfDay(hour: 7, minute: 0))
        : (_endTime   ?? const TimeOfDay(hour: 12, minute: 0));

    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
      helpText: isStart ? 'Pilih Jam Mulai' : 'Pilih Jam Selesai',
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: isDark
              ? const ColorScheme.dark(primary: Color(0xFF1E88E5), onPrimary: Colors.white)
              : const ColorScheme.light(primary: Color(0xFF1565C0), onPrimary: Colors.white, onSurface: Color(0xFF1A1A1A)),
          timePickerTheme: TimePickerThemeData(
            backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          ),
        ),
        child: child!,
      ),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
          if (_endTime != null) {
            final sm = picked.hour * 60 + picked.minute;
            final em = _endTime!.hour * 60 + _endTime!.minute;
            if (em <= sm) _endTime = null;
          }
        } else {
          _endTime = picked;
        }
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate == null) { _showError('Tanggal kegiatan wajib dipilih!'); return; }
    if (_startTime == null)    { _showError('Jam mulai kegiatan wajib dipilih!'); return; }
    if (_endTime == null)      { _showError('Jam selesai kegiatan wajib dipilih!'); return; }

    final sm = _startTime!.hour * 60 + _startTime!.minute;
    final em = _endTime!.hour * 60 + _endTime!.minute;
    if (em <= sm) { _showError('Jam selesai harus lebih akhir dari jam mulai!'); return; }

    setState(() => _isSaving = true);

    final provider = context.read<AppProvider>();

    if (isEdit) {
      final updated = Activity(
        id:              widget.activity!.id,
        title:           _titleController.text.trim(),
        organizer:       _organizerController.text.trim(),
        description:     _descController.text.trim(),
        location:        _locationController.text.trim(),
        date:            _formatDate(_selectedDate!),
        time:            _timeString,
        benefits:        _benefitsController.text.trim(),
        maxParticipants: int.tryParse(_maxController.text) ?? 50,
        registeredCount: widget.activity!.registeredCount,
        category:        _selectedCategory,
      );
      await provider.updateActivity(updated);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Kegiatan berhasil diperbarui!'),
        backgroundColor: Color(0xFF1565C0),
      ));
    } else {
      final newActivity = Activity(
        id:              '',
        title:           _titleController.text.trim(),
        organizer:       _organizerController.text.trim(),
        description:     _descController.text.trim(),
        location:        _locationController.text.trim(),
        date:            _formatDate(_selectedDate!),
        time:            _timeString,
        benefits:        _benefitsController.text.trim(),
        maxParticipants: int.tryParse(_maxController.text) ?? 50,
        category:        _selectedCategory,
      );
      await provider.addActivity(newActivity);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Kegiatan berhasil ditambahkan!'),
        backgroundColor: Color(0xFF1565C0),
      ));
    }

    if (mounted) {
      setState(() => _isSaving = false);
      Navigator.pop(context);
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: Colors.red.shade700,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final isDark    = Theme.of(context).brightness == Brightness.dark;
    final bgColor   = isDark ? const Color(0xFF121212) : const Color(0xFFF0F4FF);
    final fieldColor = isDark ? const Color(0xFF2A2A2A) : Colors.white;
    final borderColor = isDark ? Colors.grey.shade700 : Colors.grey.shade300;

    InputDecoration inputDeco(IconData icon, String hint) => InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 13),
      prefixIcon: Icon(icon, color: const Color(0xFF1565C0), size: 20),
      filled: true,
      fillColor: fieldColor,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF1565C0), width: 2)),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    );

    Widget field(TextEditingController ctrl, String label, String hint, IconData icon, {
      TextInputType? keyboardType, int? maxLines, String? Function(String?)? validator,
    }) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        const SizedBox(height: 6),
        TextFormField(
          controller: ctrl,
          keyboardType: keyboardType,
          maxLines: maxLines ?? 1,
          style: TextStyle(color: isDark ? Colors.white : Colors.black87),
          validator: validator ?? (v) => v == null || v.isEmpty ? '$label wajib diisi' : null,
          decoration: inputDeco(icon, hint),
        ),
      ]);
    }

    Widget pickerField({
      required IconData icon, required String label,
      required bool isSelected, required VoidCallback onTap, String? subLabel,
    }) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            color: fieldColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? const Color(0xFF1565C0) : borderColor,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
            if (subLabel != null)
              Text(subLabel, style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
            Row(children: [
              Icon(icon, color: const Color(0xFF1565C0), size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(label, style: TextStyle(
                  fontSize: 14,
                  color: isSelected ? (isDark ? Colors.white : const Color(0xFF1A1A1A)) : Colors.grey.shade500,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                )),
              ),
              Icon(Icons.arrow_drop_down, color: Colors.grey.shade500, size: 20),
            ]),
          ]),
        ),
      );
    }

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        title: Text(isEdit ? 'Edit Kegiatan' : 'Tambah Kegiatan'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            field(_titleController, 'Nama Kegiatan', 'Contoh: Bersih-Bersih Pantai', Icons.event),
            const SizedBox(height: 12),
            field(_organizerController, 'Nama Organisasi', 'Contoh: Komunitas Hijau Samarinda', Icons.groups),
            const SizedBox(height: 12),

            // Kategori
            const Text('Kategori', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              initialValue: _selectedCategory,
              dropdownColor: isDark ? const Color(0xFF2A2A2A) : Colors.white,
              decoration: inputDeco(Icons.category, 'Pilih kategori'),
              items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (v) => setState(() => _selectedCategory = v!),
            ),
            const SizedBox(height: 12),

            // Tanggal
            const Text('Tanggal Kegiatan', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
            const SizedBox(height: 6),
            pickerField(
              icon: Icons.calendar_month,
              label: _selectedDate == null ? 'Pilih tanggal kegiatan...' : _formatDate(_selectedDate!),
              isSelected: _selectedDate != null,
              onTap: _pickDate,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4, left: 4),
              child: Text('Hanya dapat memilih tanggal hari ini atau yang akan datang',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
            ),
            const SizedBox(height: 12),

            // Waktu
            const Text('Waktu Kegiatan', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
            const SizedBox(height: 6),
            Row(children: [
              Expanded(child: pickerField(
                icon: Icons.schedule,
                label: _startTime == null ? 'Jam mulai...' : _formatTime(_startTime!),
                isSelected: _startTime != null,
                onTap: () => _pickTime(isStart: true),
                subLabel: 'Mulai',
              )),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text('—', style: TextStyle(fontSize: 18, color: Colors.grey.shade500)),
              ),
              Expanded(child: pickerField(
                icon: Icons.schedule_outlined,
                label: _endTime == null ? 'Jam selesai...' : _formatTime(_endTime!),
                isSelected: _endTime != null,
                onTap: () => _pickTime(isStart: false),
                subLabel: 'Selesai',
              )),
            ]),
            if (_startTime != null && _endTime != null)
              Padding(
                padding: const EdgeInsets.only(top: 6, left: 4),
                child: Text('Waktu: $_timeString',
                    style: const TextStyle(fontSize: 12, color: Color(0xFF1565C0), fontWeight: FontWeight.w600)),
              ),
            Padding(
              padding: const EdgeInsets.only(top: 4, left: 4),
              child: Text('Zona waktu: WITA (Waktu Indonesia Tengah)',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
            ),
            const SizedBox(height: 12),

            field(_locationController, 'Lokasi Kegiatan', 'Contoh: Sungai Mahakam, Samarinda', Icons.location_on),
            const SizedBox(height: 12),
            field(_descController, 'Deskripsi Kegiatan', 'Jelaskan detail kegiatan ini...', Icons.description, maxLines: 4),
            const SizedBox(height: 12),
            field(_benefitsController, 'Benefit Relawan', 'Contoh: Sertifikat, Kaos, Snack', Icons.card_giftcard, maxLines: 2),
            const SizedBox(height: 12),
            field(_maxController, 'Maksimal Peserta', 'Contoh: 100', Icons.people,
              keyboardType: TextInputType.number,
              validator: (v) {
                if (v == null || v.isEmpty) return 'Wajib diisi';
                if (int.tryParse(v) == null || int.parse(v) <= 0) return 'Masukkan angka valid';
                return null;
              },
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity, height: 52,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1565C0),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _isSaving
                    ? const SizedBox(width: 22, height: 22,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                    : Text(isEdit ? 'Simpan Perubahan' : 'Tambah Kegiatan',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 20),
          ]),
        ),
      ),
    );
  }
}