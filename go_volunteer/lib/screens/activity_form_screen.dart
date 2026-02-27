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
  late final TextEditingController _timeController;
  late final TextEditingController _benefitsController;
  late final TextEditingController _maxController;

  String _selectedCategory = 'Lingkungan';
  DateTime? _selectedDate;

  final _categories = ['Lingkungan', 'Kesehatan', 'Pendidikan', 'Sosial'];

  bool get isEdit => widget.activity != null;

  @override
  void initState() {
    super.initState();
    final a = widget.activity;
    _titleController = TextEditingController(text: a?.title ?? '');
    _organizerController = TextEditingController(text: a?.organizer ?? '');
    _descController = TextEditingController(text: a?.description ?? '');
    _locationController = TextEditingController(text: a?.location ?? '');
    _timeController = TextEditingController(text: a?.time ?? '');
    _benefitsController = TextEditingController(text: a?.benefits ?? '');
    _maxController = TextEditingController(text: a?.maxParticipants.toString() ?? '50');
    if (a != null) {
      _selectedCategory = a.category;
      try {
        _selectedDate = DateFormat('d MMMM yyyy', 'id_ID').parse(a.date);
      } catch (_) {
        _selectedDate = null;
      }
    }
  }

  @override
  void dispose() {
    for (final c in [
      _titleController, _organizerController, _descController,
      _locationController, _timeController, _benefitsController, _maxController,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  // Format tanggal ke bahasa Indonesia
  String _formatDate(DateTime date) {
    final months = [
      '', 'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
    ];
    return '${date.day} ${months[date.month]} ${date.year}';
  }

  Future<void> _pickDate() async {
    final today = DateTime.now();
    final firstDate = DateTime(today.year, today.month, today.day);

    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate != null && _selectedDate!.isAfter(firstDate)
          ? _selectedDate!
          : firstDate,
      firstDate: firstDate,           
      lastDate: DateTime(today.year + 3), // max 3 tahun ke depan
      locale: const Locale('id', 'ID'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1565C0),
              onPrimary: Colors.white,
              onSurface: Color(0xFF1A1A1A),
              surface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tanggal kegiatan wajib dipilih!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final provider = context.read<AppProvider>();
    final dateString = _formatDate(_selectedDate!);

    if (isEdit) {
      final updated = Activity(
        id: widget.activity!.id,
        title: _titleController.text.trim(),
        organizer: _organizerController.text.trim(),
        description: _descController.text.trim(),
        location: _locationController.text.trim(),
        date: dateString,
        time: _timeController.text.trim(),
        benefits: _benefitsController.text.trim(),
        maxParticipants: int.tryParse(_maxController.text) ?? 50,
        registeredCount: widget.activity!.registeredCount,
        category: _selectedCategory,
      );
      provider.updateActivity(updated);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kegiatan berhasil diperbarui!'), backgroundColor: Color(0xFF1565C0)),
      );
    } else {
      final activity = provider.createNewActivity(
        title: _titleController.text.trim(),
        organizer: _organizerController.text.trim(),
        description: _descController.text.trim(),
        location: _locationController.text.trim(),
        date: dateString,
        time: _timeController.text.trim(),
        benefits: _benefitsController.text.trim(),
        maxParticipants: int.tryParse(_maxController.text) ?? 50,
        category: _selectedCategory,
      );
      provider.addActivity(activity);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kegiatan berhasil ditambahkan!'), backgroundColor: Color(0xFF1565C0)),
      );
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _field(_titleController, 'Nama Kegiatan', 'Contoh: Bersih-Bersih Pantai', Icons.event),
              const SizedBox(height: 12),
              _field(_organizerController, 'Nama Organisasi', 'Contoh: Komunitas Hijau Samarinda', Icons.groups),
              const SizedBox(height: 12),

              // Category Dropdown
              const Text('Kategori', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                decoration: _inputDecoration(Icons.category, 'Pilih kategori'),
                items: _categories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => setState(() => _selectedCategory = v!),
              ),

              const SizedBox(height: 12),

              // Kalender Tanggal
              const Text('Tanggal Kegiatan', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: _pickDate,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _selectedDate == null
                          ? Colors.grey.shade300
                          : const Color(0xFF1565C0),
                      width: _selectedDate == null ? 1 : 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_month,
                        color: _selectedDate == null
                            ? const Color(0xFF1565C0)
                            : const Color(0xFF1565C0),
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _selectedDate == null
                              ? 'Pilih tanggal kegiatan...'
                              : _formatDate(_selectedDate!),
                          style: TextStyle(
                            fontSize: 14,
                            color: _selectedDate == null
                                ? Colors.grey.shade400
                                : const Color(0xFF1A1A1A),
                            fontWeight: _selectedDate == null
                                ? FontWeight.normal
                                : FontWeight.w600,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.arrow_drop_down,
                        color: Colors.grey.shade400,
                      ),
                    ],
                  ),
                ),
              ),
              // Hint text under date picker
              Padding(
                padding: const EdgeInsets.only(top: 4, left: 4),
                child: Text(
                  'Hanya dapat memilih tanggal hari ini atau yang akan datang',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                ),
              ),

              const SizedBox(height: 12),
              _field(_timeController, 'Waktu Kegiatan', 'Contoh: 07.00 - 12.00 WITA', Icons.access_time),
              const SizedBox(height: 12),
              _field(_locationController, 'Lokasi Kegiatan', 'Contoh: Sungai Mahakam, Samarinda', Icons.location_on),
              const SizedBox(height: 12),
              _field(
                _descController,
                'Deskripsi Kegiatan',
                'Jelaskan detail kegiatan ini...',
                Icons.description,
                maxLines: 4,
              ),
              const SizedBox(height: 12),
              _field(
                _benefitsController,
                'Benefit Relawan',
                'Contoh: Sertifikat, Kaos, Snack',
                Icons.card_giftcard,
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              _field(
                _maxController,
                'Maksimal Peserta',
                'Contoh: 100',
                Icons.people,
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Wajib diisi';
                  if (int.tryParse(v) == null || int.parse(v) <= 0) return 'Masukkan angka valid';
                  return null;
                },
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1565C0),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    isEdit ? 'Simpan Perubahan' : 'Tambah Kegiatan',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(IconData icon, String hint) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: const Color(0xFF1565C0), size: 20),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF1565C0), width: 2)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label,
    String hint,
    IconData icon, {
    TextInputType? keyboardType,
    int? maxLines,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines ?? 1,
          validator: validator ?? (v) => v == null || v.isEmpty ? '$label wajib diisi' : null,
          decoration: _inputDecoration(icon, hint),
        ),
      ],
    );
  }
}