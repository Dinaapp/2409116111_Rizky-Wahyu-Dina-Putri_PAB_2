### NAMA: Rizky Wahyu Dina Putri
### NIM: 2409116111

# APLIKASI PENDAFTARAN RELAWAN KEGIATAN SOSIAL SAMARINDA

## Deskripsi
GoVolunteer adalah aplikasi mobile berbasis Flutter yang dirancang sebagai platform promosi dan manajemen kegiatan sosial di Kota Samarinda. Aplikasi ini menjadi jembatan antara organisasi atau komunitas sosial yang ingin menyelenggarakan kegiatan sosial dengan masyarakat umum yang ingin ikut berkontribusi dalam berbagai kegiatan sosial.

Aplikasi ini bertujuan untuk memberikan informasi lengkap mengenai kegiatan yang sedang berlangsung, termasuk lokasi, waktu pelaksanaan, serta manfaat atau benefit yang dapat diperoleh peserta. Selain itu, GoVolunteer memudahkan masyarakat untuk menemukan dan mengikuti kegiatan sosial dengan lebih cepat dan terorganisir. Data kegiatan dan peserta disimpan secara real-time menggunakan Supabase sebagai backend database.

## Fitur
### Autentikasi (Supabase Auth)
#### 1. Register Akun
Form pendaftaran akun dengan 4 field: Username, Email, Password, dan Konfirmasi Password. Username disimpan ke metadata akun Supabase dan digunakan sebagai nama sapaan di halaman utama. Validasi format email menggunakan regex dan password minimal 6 karakter.
#### 2. Login
Form login dengan email dan password yang terverifikasi melalui Supabase Auth. Jika sesi login masih aktif, pengguna langsung diarahkan ke halaman utama tanpa perlu login ulang.

### Halaman Publik (Masyarakat / Relawan)
#### 1. Daftar Kegiatan (Home)
Menampilkan semua kegiatan sosial dalam bentuk kartu bergambar dengan banner gradient berwarna berbeda per kategori. Dilengkapi filter kategori (Semua, Lingkungan, Kesehatan, Pendidikan, Sosial) sehingga pengguna dapat menyaring kegiatan sesuai minat. Data kegiatan diambil langsung dari database Supabase setiap kali halaman dibuka, dan dapat diperbarui dengan pull-to-refresh. Terdapat tombol toggle Light/Dark Mode dan tombol logout di AppBar.
#### 2. Detail Kegiatan
Halaman detail menampilkan informasi lengkap kegiatan: nama kegiatan, nama organisasi penyelenggara, tanggal pelaksanaan, waktu, lokasi, deskripsi kegiatan, dan benefit yang didapat relawan. Terdapat progress bar kapasitas peserta dan indikator sisa slot secara real-time.
#### 3. Form Pendaftaran Relawan
Form pendaftaran dengan 4 input field: Nama Lengkap, Nomor WhatsApp, Email, dan Asal Instansi/Kampus. Terdapat validasi seperti format email wajib menggunakan regex (harus ada karakter sebelum @, domain valid, ekstensi minimal 2 huruf), format nomor HP wajib diawali 08/+62, agar tidak ada kesalahan saat input data pribadi. Data peserta disimpan langsung ke tabel participants di Supabase.
#### 4. Kartu Kegiatan (ActivityCard)
Pada halaman Home terdapat komponen kartu kegiatan yang sedang berlangsung, terdapat deskripsi singkat mengenai kegiatan, tanggal, jam, progress bar slot dan sisa slot relawan yang dapat mendaftar. Di setiap card juga terdapat tombol detail dan registrasi untuk pengguna. Tampilan kartu menyesuaikan Light Mode dan Dark Mode.

### Halaman Admin
#### 1. CREATE - Tambah Kegiatan Baru
Form tambah kegiatan dengan 8+ input field: Nama Kegiatan, Nama Organisasi, Kategori, Tanggal, Waktu, Lokasi, Deskripsi, Benefit Relawan, dan Maksimal Peserta. Format tanggal menggunakan date picker kalender dan hanya dapat dipilih mulai hari ini atau ke depan. Format waktu menggunakan time picker dengan 2 field berdampingan (jam mulai dan jam selesai), output otomatis menjadi format "07.00 - 12.00 WITA". Data kegiatan baru langsung disimpan ke tabel activities di Supabase.
#### 2. READ - Tampilkan Semua Kegiatan
Panel admin menampilkan seluruh kegiatan dalam daftar tile beserta statistik seperti total kegiatan aktif dan total relawan yang sudah terdaftar di semua kegiatan. Data diambil dari Supabase secara real-time.
#### 3. UPDATE - Edit Kegiatan
Form edit kegiatan yang otomatis terisi dengan data kegiatan yang dipilih. Data dapat diubah dan semua informasi kegiatan diperbarui langsung ke database Supabase.
#### 4. DELETE - Hapus Kegiatan
Penghapusan kegiatan disertai dialog konfirmasi untuk mencegah penghapusan tidak sengaja. Saat kegiatan dihapus, seluruh data peserta yang terdaftar juga ikut terhapus secara otomatis melalui mekanisme ON DELETE CASCADE di Supabase.
#### 5. Kelola Peserta
Admin dapat melihat daftar lengkap peserta per kegiatan (nama, email, nomor HP, asal instansi) dan menghapus peserta tertentu. Slot kegiatan akan otomatis bertambah kembali setelah peserta dihapus, dan perubahan langsung tersimpan ke Supabase.

## Widget
### Widget Struktur & Layout
#### 1. Scaffold
Kerangka dasar halaman Flutter yang menyediakan AppBar, body, bottomNavigationBar, dan FloatingActionButton. Digunakan di semua screen untuk membentuk struktur utama halaman (home, detail, form, admin, peserta, register, login).
#### 2. AppBar
Bilah navigasi di bagian atas halaman yang berisi judul dan tombol aksi.
Digunakan untuk menampilkan identitas halaman serta tombol navigasi (toggle dark mode, admin, logout, tambah kegiatan, dll).
#### 3. SliverAppBar + CustomScrollView
AppBar yang dapat mengecil saat discroll. Digunakan di halaman detail kegiatan untuk efek banner collapse yang modern dan hemat ruang.
#### 4. Column
Menyusun widget secara vertikal (atas ke bawah).
Digunakan untuk menyusun form, isi kartu, dan konten halaman.
#### 5. Row
Menyusun widget secara horizontal (kiri ke kanan). Digunakan untuk menampilkan ikon dan teks sejajar atau kartu statistik berdampingan.
#### 6. Expanded
Membuat widget mengisi sisa ruang dalam Row/Column. Digunakan untuk mengatur proporsi tombol dan kartu agar responsif.
#### 7. Stack + Positioned
Menumpuk widget seperti layer dan mengatur posisinya.
Digunakan pada banner kartu kegiatan (badge kategori, status penuh, ikon, judul).
#### 8. SingleChildScrollView
Membuat konten bisa discroll jika melebihi layar. Digunakan pada halaman form dengan banyak input.
#### 9. ListView.builder
Membuat daftar scrollable secara efisien. Digunakan untuk menampilkan daftar kegiatan dan peserta.

### Widget Tampilan & Dekorasi
#### 1. Container
Widget serbaguna untuk ukuran, warna, padding, border, dan bayangan.
Digunakan sebagai pembungkus kartu dan kotak informasi.
#### 2. BoxDecoration
Mengatur dekorasi Container (gradient, border radius, shadow).
Digunakan untuk membuat kartu dengan sudut melengkung dan efek bayangan.
#### 3. LinearGradient
Membuat latar belakang gradasi warna. Digunakan pada banner kategori kegiatan.
#### 4. ClipRRect
Memotong widget agar memiliki sudut melengkung. Digunakan pada banner kartu dan progress bar.
#### 5. LinearProgressIndicator
Progress bar horizontal (0.0–1.0). Digunakan untuk menampilkan jumlah slot peserta yang terisi.
#### 6. CircularProgressIndicator
Loading berbentuk lingkaran. Digunakan saat proses submit, login, atau saat mengambil data dari Supabase berlangsung.
#### 7. Icon
Menampilkan ikon Material Design. Digunakan sebagai elemen visual kategori, informasi, dan aksi.

### Widget Teks & Input
#### 1. TextFormField
Input teks dengan validasi Form. Digunakan untuk input nama, email, WA, instansi, data kegiatan, username, dan password.
#### 2. TextEditingController
Mengontrol dan membaca nilai input. Digunakan untuk mengambil dan mengisi data form.
#### 3. InputDecoration
Mengatur tampilan TextFormField (hint, border, warna error). Memberikan feedback visual pada kondisi normal, fokus, dan error. Warna field menyesuaikan Light Mode dan Dark Mode.
#### 4. DropdownButtonFormField
Dropdown terintegrasi dengan Form. Digunakan untuk memilih kategori kegiatan.
#### 5. Form + GlobalKey<FormState>
Mengelompokkan input dan menjalankan validasi sekaligus. Digunakan saat submit form register, login, dan tambah/edit kegiatan.
Widget Interaksi & Navigasi
#### 6. ElevatedButton
Tombol utama yang digunakan untuk aksi penting seperti daftar, simpan, masuk, dan daftar akun.
#### 7. OutlinedButton
Tombol dengan border tanpa background. Digunakan untuk aksi sekunder seperti tombol "Detail".
#### 8. TextButton
Tombol sederhana berbasis teks. Digunakan pada dialog konfirmasi.
#### 9. IconButton
Tombol berbentuk ikon. Digunakan di AppBar dan daftar admin (edit, hapus, peserta, logout, toggle dark mode).
#### 10. FloatingActionButton.extended
Tombol aksi mengambang dengan ikon dan teks. Digunakan untuk menambah kegiatan di halaman admin.
#### 11. GestureDetector
Mendeteksi gesture (tap). Digunakan agar seluruh kartu dapat diklik, membuka halaman detail, dan membuka date/time picker.
#### 12. AlertDialog
Dialog popup untuk konfirmasi atau informasi. Digunakan saat hapus data, notifikasi sukses pendaftaran, dan konfirmasi logout.
#### 13. SnackBar
Notifikasi singkat di bagian bawah layar. Digunakan untuk pesan sukses dan error.

## Navigasi
### 1. Navigator.push + MaterialPageRoute
Berpindah ke halaman baru. Digunakan untuk membuka detail, register, form, peserta, dan admin.
### 2. Navigator.pushReplacement + MaterialPageRoute
Berpindah ke halaman baru dengan mengganti halaman sebelumnya di stack. Digunakan setelah login berhasil menuju HomeScreen dan setelah logout menuju LoginScreen.
### 3. Navigator.pop
Kembali ke halaman sebelumnya. Digunakan setelah submit berhasil atau menutup dialog.

## State Management (Provider)
### 1. StatefulWidget + setState()
Mengelola state lokal dalam satu halaman. Digunakan untuk filter kategori, status loading, dan toggle visibilitas password.
### 2. ChangeNotifierProvider + MultiProvider
Menyediakan state global ke seluruh aplikasi. Digunakan di main.dart dengan MultiProvider untuk mengelola AppProvider (data kegiatan & peserta) dan ThemeProvider (light/dark mode).

## Dark Mode
### 1. ThemeProvider
ChangeNotifier khusus untuk mengelola tema aplikasi. Menyimpan ThemeMode (light/dark) dan menyediakan fungsi toggleTheme() yang dapat dipanggil dari mana saja. Setiap perubahan tema langsung memperbarui seluruh tampilan aplikasi.
### 2. ThemeMode di MaterialApp
MaterialApp dikonfigurasi dengan theme (light) dan darkTheme (dark) sekaligus, serta themeMode yang dikontrol oleh ThemeProvider. Seluruh halaman secara otomatis mengikuti tema aktif.

## Supabase Integration
### 1. SupabaseService
Class static yang mengelola semua komunikasi dengan Supabase, mencakup operasi CRUD pada tabel activities dan participants, serta autentikasi (register, login, logout). URL dan API Key dibaca dari file .env menggunakan flutter_dotenv agar tidak ter-push ke GitHub.
### 2. FutureBuilder
Menampilkan UI berdasarkan state async dari Future. Digunakan di halaman peserta untuk menampilkan loading indicator saat data sedang diambil dari Supabase, lalu menampilkan daftar peserta setelah data tersedia.
### 3. RefreshIndicator
Memungkinkan pengguna melakukan pull-to-refresh. Digunakan di halaman home untuk memuat ulang data kegiatan dari Supabase.

## Dependencies
```dart
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  provider: ^6.1.1            # State management reaktif
  uuid: ^4.2.1                # Generate ID unik
  intl: ^0.20.2               # Format tanggal Bahasa Indonesia
  cupertino_icons: ^1.0.6
  supabase_flutter: ^2.3.4    # Koneksi ke Supabase (database & auth)
  flutter_dotenv: ^5.1.0      # Baca file .env untuk menyimpan API Key
```
## CODE
### Package Models
#### activity.dart
```dart
class Activity {
  final String id;
  String title, organizer, description, location, date, time, benefits, category;
  int maxParticipants, registeredCount;

  Activity({
    required this.id,
    required this.title,
    required this.organizer,
    required this.description,
    required this.location,
    required this.date,
    required this.time,
    required this.benefits,
    required this.maxParticipants,
    this.registeredCount = 0,
    required this.category,
  });

  int get availableSlots => maxParticipants - registeredCount;
  bool get isFull => registeredCount >= maxParticipants;

  factory Activity.fromMap(Map<String, dynamic> m) => Activity(
        id:               m['id'] as String,
        title:            m['title'] as String,
        organizer:        m['organizer'] as String,
        description:      m['description'] as String,
        location:         m['location'] as String,
        date:             m['date'] as String,
        time:             m['time'] as String,
        benefits:         m['benefits'] as String,
        maxParticipants:  m['max_participants'] as int,
        registeredCount:  m['registered_count'] as int? ?? 0,
        category:         m['category'] as String,
      );

  Map<String, dynamic> toMap() => {
        'title':            title,
        'organizer':        organizer,
        'description':      description,
        'location':         location,
        'date':             date,
        'time':             time,
        'benefits':         benefits,
        'max_participants': maxParticipants,
        'registered_count': registeredCount,
        'category':         category,
      };
}
```
Pada code ini berisi blueprint data setiap kegiatan yang nantinya diisi oleh admin, untuk id dibuat final karena saat membuat kegiatan baru id tidak bisa berubah meski nantinya informasi kegiatan di update. Untuk informasi kegiatan lain seperti judul, tanggal, dll dapat berubah karena tidak menggunakan final.

Ditambahkan dua method baru yaitu fromMap() untuk mengubah data dari Supabase menjadi object Activity, dan toMap() untuk mengubah object Activity menjadi Map yang dikirim ke Supabase. Nama kolom di toMap() menggunakan snake_case (max_participants, registered_count) sesuai dengan nama kolom di tabel Supabase.

code ini adalah visualisasi dari jumlah peserta yang dapat mendaftar di kegiatan, contoh saat kegiatan memiliki jumlah maksimal pesertanya 50 dan pendaftar telah mencapai 30, maka di total slot yang tersedia akan menampilkan angka 20. Dan jika sudah mencapai 50 pendaftar maka status pendaftar di kegiatan akan full.

#### participant.dart
```dart
class Participant {
  final String id, activityId, name, phone, email, institution, registeredAt;

  Participant({
    required this.id,
    required this.activityId,
    required this.name,
    required this.phone,
    required this.email,
    required this.institution,
    required this.registeredAt,
  });

  factory Participant.fromMap(Map<String, dynamic> m) => Participant(
        id:           m['id'] as String,
        activityId:   m['activity_id'] as String,
        name:         m['name'] as String,
        phone:        m['phone'] as String,
        email:        m['email'] as String,
        institution:  m['institution'] as String,
        registeredAt: m['registered_at'] as String? ?? '',
      );

  Map<String, dynamic> toMap() => {
        'activity_id': activityId,
        'name':        name,
        'phone':       phone,
        'email':       email,
        'institution': institution,
      };
}
```
Pada code ini adalah blueprint dari peserta yang mendaftar di kegiatan, semua field dari data peserta dibuat final karena peserta tidak dapat mengedit lagi data diri yang didaftarkan. Maka dari itu saat mendaftar terdapat validasi saat mengisi form agar mengurangi kesalahan dalam mengisi data.

Ditambahkan fromMap() untuk membaca data peserta dari Supabase dan toMap() untuk mengirim data peserta baru ke Supabase. Pada toMap() field id dan registered_at tidak dimasukkan karena keduanya dibuat otomatis oleh Supabase.
### Package Providers
#### app_provider.dart
```dart
import 'package:flutter/foundation.dart';
import '../models/activity.dart';
import '../models/participant.dart';
import '../services/supabase_service.dart';

class AppProvider extends ChangeNotifier {
  List<Activity> _activities = [];
  bool isLoading = false;
  String? errorMessage;

  List<Activity> get activities => List.unmodifiable(_activities);

  // READ
  Future<void> fetchActivities() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      _activities = await SupabaseService.fetchActivities();
    } catch (e) {
      errorMessage = 'Gagal memuat kegiatan: $e';
    }
    isLoading = false;
    notifyListeners();
  }

  // CREATE
  Future<void> addActivity(Activity activity) async {
    try {
      final inserted = await SupabaseService.insertActivity(activity);
      _activities.insert(0, inserted);
      notifyListeners();
    } catch (e) {
      errorMessage = 'Gagal menambah kegiatan: $e';
      notifyListeners();
    }
  }

  // UPDATE
  Future<void> updateActivity(Activity updated) async {
    try {
      await SupabaseService.updateActivity(updated);
      final i = _activities.indexWhere((a) => a.id == updated.id);
      if (i != -1) { _activities[i] = updated; notifyListeners(); }
    } catch (e) {
      errorMessage = 'Gagal update kegiatan: $e';
      notifyListeners();
    }
  }

  // DELETE
  Future<void> deleteActivity(String id) async {
    try {
      await SupabaseService.deleteActivity(id);
      _activities.removeWhere((a) => a.id == id);
      notifyListeners();
    } catch (e) {
      errorMessage = 'Gagal hapus kegiatan: $e';
      notifyListeners();
    }
  }

  // REGISTER PARTICIPANT
  Future<bool> registerParticipant({
    required String activityId,
    required String name,
    required String phone,
    required String email,
    required String institution,
  }) async {
    final idx = _activities.indexWhere((a) => a.id == activityId);
    if (idx == -1 || _activities[idx].isFull) return false;

    try {
      final p = Participant(
        id: '', activityId: activityId, name: name,
        phone: phone, email: email, institution: institution,
        registeredAt: DateTime.now().toIso8601String(),
      );
      await SupabaseService.insertParticipant(p);
      final newCount = _activities[idx].registeredCount + 1;
      await SupabaseService.updateRegisteredCount(activityId, newCount);

      // update lokal
      final a = _activities[idx];
      _activities[idx] = Activity(
        id: a.id, title: a.title, organizer: a.organizer,
        description: a.description, location: a.location,
        date: a.date, time: a.time, benefits: a.benefits,
        maxParticipants: a.maxParticipants, registeredCount: newCount,
        category: a.category,
      );
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = 'Gagal mendaftar: $e';
      notifyListeners();
      return false;
    }
  }

  // DELETE PARTICIPANT
  Future<void> removeParticipant(String participantId, String activityId) async {
    try {
      await SupabaseService.deleteParticipant(participantId);
      final idx = _activities.indexWhere((a) => a.id == activityId);
      if (idx != -1 && _activities[idx].registeredCount > 0) {
        final a = _activities[idx];
        final newCount = a.registeredCount - 1;
        await SupabaseService.updateRegisteredCount(activityId, newCount);
        _activities[idx] = Activity(
          id: a.id, title: a.title, organizer: a.organizer,
          description: a.description, location: a.location,
          date: a.date, time: a.time, benefits: a.benefits,
          maxParticipants: a.maxParticipants, registeredCount: newCount,
          category: a.category,
        );
        notifyListeners();
      }
    } catch (e) {
      errorMessage = 'Gagal hapus peserta: $e';
      notifyListeners();
    }
  }

  // Fetch peserta langsung dari Supabase
  Future<List<Participant>> getParticipantsFor(String activityId) async {
    return await SupabaseService.fetchParticipants(activityId);
  }
}
```
Pada bagian ini berisi logic utama aplikasi yang diatur melalui AppProvider dengan ChangeNotifier sebagai state management. Berbeda dari versi sebelumnya yang menggunakan List lokal, seluruh operasi CRUD kini terhubung langsung ke Supabase melalui SupabaseService. Setiap fungsi dibuat async karena operasi ke database memerlukan waktu. Saat peserta mendaftar, sistem mengecek apakah slot masih tersedia, menyimpan data peserta ke Supabase, lalu memperbarui registered_count di database. Jika terjadi kesalahan koneksi atau operasi gagal, pesan error disimpan ke errorMessage agar bisa ditampilkan di UI. Setiap perubahan data tetap memperbarui tampilan melalui notifyListeners().

#### theme_provider.dart
```dart
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode;
  bool get isDark => _themeMode == ThemeMode.dark;

  void toggleTheme() {
    _themeMode = isDark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }
}
```
Class ini mengelola tema tampilan aplikasi. Menyimpan state ThemeMode yang bisa berupa light atau dark, dan menyediakan fungsi toggleTheme() untuk berpindah antar tema. Saat toggleTheme() dipanggil, seluruh tampilan aplikasi langsung memperbarui diri karena menggunakan notifyListeners().

### Package Screens
#### login_screen.dart
```dart
import 'package:flutter/material.dart';
import '../services/supabase_service.dart';
import 'home_screen.dart';
import 'register_screen_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey   = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl  = TextEditingController();
  bool _obscure = true, _isLoading = false;

  @override
  void dispose() { _emailCtrl.dispose(); _passCtrl.dispose(); super.dispose(); }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      await SupabaseService.login(_emailCtrl.text.trim(), _passCtrl.text);
      if (!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Login gagal: email atau password salah'),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ));
    }
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
            colors: isDark
                ? [const Color(0xFF0A1929), const Color(0xFF0D47A1)]
                : [const Color(0xFF0D47A1), const Color(0xFF1E88E5)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(children: [
              const SizedBox(height: 60),
              Container(
                width: 90, height: 90,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.volunteer_activism, size: 50, color: Colors.white),
              ),
              const SizedBox(height: 16),
              const Text('GoVolunteer',
                  style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text('Platform Kegiatan Sosial Samarinda',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 13)),
              const SizedBox(height: 40),
              // Card form
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 20, offset: const Offset(0, 8))],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('Masuk', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('Masuk untuk melihat kegiatan sosial',
                        style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
                    const SizedBox(height: 24),
                    _label('Email'),
                    TextFormField(
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Email wajib diisi';
                        if (!RegExp(r'^[\w\.\-]+@[\w\-]+\.[a-zA-Z]{2,}$').hasMatch(v.trim())) {
                          return 'Format email tidak valid';
                        }
                        return null;
                      },
                      decoration: _deco('Masukkan email', Icons.email_outlined),
                    ),
                    const SizedBox(height: 16),
                    _label('Password'),
                    TextFormField(
                      controller: _passCtrl,
                      obscureText: _obscure,
                      validator: (v) => v == null || v.isEmpty ? 'Password wajib diisi' : null,
                      decoration: _deco('Masukkan password', Icons.lock_outline,
                          suffix: IconButton(
                            icon: Icon(_obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: Colors.grey),
                            onPressed: () => setState(() => _obscure = !_obscure),
                          )),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity, height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1565C0), foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: _isLoading
                            ? const SizedBox(width: 22, height: 22,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                            : const Text('Masuk', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text('Belum punya akun? ', style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
                      GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreenAuth())),
                        child: const Text('Daftar di sini',
                            style: TextStyle(color: Color(0xFF1565C0), fontWeight: FontWeight.bold, fontSize: 13)),
                      ),
                    ]),
                  ]),
                ),
              ),
              const SizedBox(height: 40),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _label(String t) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(t, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
  );

  InputDecoration _deco(String hint, IconData icon, {Widget? suffix}) => InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
    prefixIcon: Icon(icon, color: const Color(0xFF1565C0), size: 20),
    suffixIcon: suffix,
    filled: true, fillColor: Colors.grey.shade50,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF1565C0), width: 2)),
    errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.red)),
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
  );
}
```
Code ini menampilkan halaman login dengan form email dan password. Validasi format email menggunakan regex dan terdapat toggle visibilitas password. Jika login berhasil melalui Supabase Auth, pengguna langsung diarahkan ke HomeScreen menggunakan Navigator.pushReplacement. Jika gagal, ditampilkan SnackBar dengan pesan error. Tampilan menyesuaikan Light Mode dan Dark Mode.

#### register_screen_auth.dart
```dart
import 'package:flutter/material.dart';
import '../services/supabase_service.dart';
import 'login_screen.dart';

class RegisterScreenAuth extends StatefulWidget {
  const RegisterScreenAuth({super.key});
  @override
  State<RegisterScreenAuth> createState() => _RegisterScreenAuthState();
}

class _RegisterScreenAuthState extends State<RegisterScreenAuth> {
  final _formKey      = GlobalKey<FormState>();
  final _usernameCtrl = TextEditingController();
  final _emailCtrl    = TextEditingController();
  final _passCtrl     = TextEditingController();
  final _confirmCtrl  = TextEditingController();
  bool _obscurePass = true, _obscureConfirm = true, _isLoading = false;

  @override
  void dispose() {
    _usernameCtrl.dispose(); _emailCtrl.dispose();
    _passCtrl.dispose(); _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      await SupabaseService.register(
        _emailCtrl.text.trim(),
        _passCtrl.text,
        username: _usernameCtrl.text.trim(),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Akun berhasil dibuat! Silakan masuk.'),
        backgroundColor: Color(0xFF1565C0),
      ));
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Gagal daftar: email sudah digunakan atau tidak valid'),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ));
    }
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fieldColor = isDark ? const Color(0xFF2A2A2A) : Colors.grey.shade50;

    InputDecoration deco(String hint, IconData icon, {Widget? suffix}) => InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
      prefixIcon: Icon(icon, color: const Color(0xFF1565C0), size: 20),
      suffixIcon: suffix,
      filled: true,
      fillColor: fieldColor,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF1565C0), width: 2)),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    );

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
            colors: isDark
                ? [const Color(0xFF0A1929), const Color(0xFF0D47A1)]
                : [const Color(0xFF0D47A1), const Color(0xFF1E88E5)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(children: [
              const SizedBox(height: 50),
              Container(
                width: 80, height: 80,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person_add, size: 42, color: Colors.white),
              ),
              const SizedBox(height: 14),
              const Text('Buat Akun Baru',
                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text('Daftar untuk mulai menjadi relawan',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 13)),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 20, offset: const Offset(0, 8),
                  )],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('Daftar', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),

                    // Username
                    _label('Username'),
                    TextFormField(
                      controller: _usernameCtrl,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Username wajib diisi';
                        if (v.trim().length < 3) return 'Username minimal 3 karakter';
                        return null;
                      },
                      decoration: deco('Masukkan username', Icons.person_outline),
                    ),
                    const SizedBox(height: 16),

                    // Email
                    _label('Email'),
                    TextFormField(
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Email wajib diisi';
                        if (!RegExp(r'^[\w\.\-]+@[\w\-]+\.[a-zA-Z]{2,}$').hasMatch(v.trim())) {
                          return 'Format email tidak valid';
                        }
                        return null;
                      },
                      decoration: deco('Masukkan email', Icons.email_outlined),
                    ),
                    const SizedBox(height: 16),

                    // Password
                    _label('Password'),
                    TextFormField(
                      controller: _passCtrl,
                      obscureText: _obscurePass,
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Password wajib diisi';
                        if (v.length < 6) return 'Password minimal 6 karakter';
                        return null;
                      },
                      decoration: deco('Minimal 6 karakter', Icons.lock_outline,
                          suffix: IconButton(
                            icon: Icon(_obscurePass
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined, color: Colors.grey),
                            onPressed: () => setState(() => _obscurePass = !_obscurePass),
                          )),
                    ),
                    const SizedBox(height: 16),

                    // Konfirmasi Password
                    _label('Konfirmasi Password'),
                    TextFormField(
                      controller: _confirmCtrl,
                      obscureText: _obscureConfirm,
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Konfirmasi password wajib diisi';
                        if (v != _passCtrl.text) return 'Password tidak cocok';
                        return null;
                      },
                      decoration: deco('Ulangi password', Icons.lock_outline,
                          suffix: IconButton(
                            icon: Icon(_obscureConfirm
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined, color: Colors.grey),
                            onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                          )),
                    ),
                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity, height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1565C0),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: _isLoading
                            ? const SizedBox(width: 22, height: 22,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                            : const Text('Daftar Sekarang',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text('Sudah punya akun? ',
                          style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Text('Masuk di sini',
                            style: TextStyle(
                              color: Color(0xFF1565C0),
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            )),
                      ),
                    ]),
                  ]),
                ),
              ),
              const SizedBox(height: 40),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _label(String t) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(t, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
  );
}
```
Code ini menampilkan halaman pendaftaran akun baru dengan 4 field: Username, Email, Password, dan Konfirmasi Password. Username minimal 3 karakter dan disimpan ke metadata akun Supabase sehingga dapat digunakan sebagai nama sapaan. Validasi memastikan password minimal 6 karakter dan konfirmasi password harus cocok. Setelah berhasil daftar, pengguna diarahkan ke halaman login.
#### Activity_detail_screen.dart
```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/activity.dart';
import '../providers/app_provider.dart';
import 'register_screen.dart';

class ActivityDetailScreen extends StatelessWidget {
  final Activity activity;
  const ActivityDetailScreen({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final bgColor   = isDark ? const Color(0xFF121212) : const Color(0xFFF0F4FF);

    final provider = context.watch<AppProvider>();
    final current = provider.activities.firstWhere(
      (a) => a.id == activity.id,
      orElse: () => activity,
    );
    final slotPercent = current.maxParticipants > 0
        ? current.registeredCount / current.maxParticipants
        : 0.0;

    return Scaffold(
      backgroundColor: bgColor,
      body: CustomScrollView(
        slivers: [
          // AppBar dengan gradient
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            backgroundColor: const Color(0xFF1565C0),
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF0D47A1), Color(0xFF1E88E5)],
                  ),
                ),
                child: const Center(
                  child: Icon(Icons.volunteer_activism, size: 72, color: Colors.white24),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // Title card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8)],
                    ),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1565C0).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(current.category,
                            style: const TextStyle(color: Color(0xFF1565C0), fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 10),
                      Text(current.title,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('oleh ${current.organizer}',
                          style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
                    ]),
                  ),
                  const SizedBox(height: 12),

                  // Info Grid
                  Row(children: [
                    Expanded(child: _infoTile(Icons.calendar_today, 'Tanggal', current.date, cardColor)),
                    const SizedBox(width: 12),
                    Expanded(child: _infoTile(Icons.access_time, 'Waktu', current.time, cardColor)),
                  ]),
                  const SizedBox(height: 12),
                  _infoTile(Icons.location_on, 'Lokasi', current.location, cardColor),
                  const SizedBox(height: 12),

                  // Kapasitas slot
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8)],
                    ),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        const Text('Kapasitas Relawan', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(
                          '${current.registeredCount}/${current.maxParticipants} terdaftar',
                          style: TextStyle(
                            color: slotPercent > 0.8 ? Colors.red : const Color(0xFF1565C0),
                            fontWeight: FontWeight.bold, fontSize: 13,
                          ),
                        ),
                      ]),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: slotPercent.toDouble(),
                          backgroundColor: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                          valueColor: AlwaysStoppedAnimation(
                            slotPercent > 0.8 ? Colors.red : const Color(0xFF1E88E5),
                          ),
                          minHeight: 8,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        current.isFull ? 'Slot penuh! Pendaftaran ditutup.' : '${current.availableSlots} slot tersisa',
                        style: TextStyle(
                          fontSize: 12,
                          color: current.isFull ? Colors.red : Colors.blue.shade400,
                        ),
                      ),
                    ]),
                  ),
                  const SizedBox(height: 12),

                  // Deskripsi & Benefit
                  _sectionCard('Deskripsi Kegiatan', current.description, cardColor, isDark),
                  const SizedBox(height: 12),
                  _sectionCard('Benefit Relawan', current.benefits, cardColor, isDark),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),

      // Bottom button
      bottomNavigationBar: Container(
        color: bgColor,
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: current.isFull
            ? ElevatedButton(
                onPressed: null,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Slot Penuh'),
              )
            : ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => RegisterScreen(activity: current)),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1565C0),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Daftar Sekarang',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
      ),
    );
  }

  Widget _infoTile(IconData icon, String label, String value, Color cardColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8)],
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, color: const Color(0xFF1565C0), size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
            const SizedBox(height: 2),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          ]),
        ),
      ]),
    );
  }

  Widget _sectionCard(String title, String content, Color cardColor, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8)],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        const SizedBox(height: 8),
        Text(content,
            style: TextStyle(
              height: 1.5,
              color: isDark ? Colors.grey.shade300 : const Color(0xFF444444),
            )),
      ]),
    );
  }
}
```
Code ini menampilkan informasi lengkap mengenai kegiatan seperti judul, penyelenggara, tanggal, lokasi, deskripsi, benefit, serta visualisasi jumlah peserta melalui progress bar. Sistem secara otomatis menghitung sisa slot berdasarkan jumlah maksimal peserta dikurangi jumlah pendaftar. Jika kuota sudah terpenuhi, tombol pendaftaran akan nonaktif dan status kegiatan berubah menjadi "slot penuh". Seluruh tampilan card, teks, dan background menyesuaikan Light Mode dan Dark Mode.

#### activity_form_screen.dart
```dart
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
```
Code ini digunakan untuk menambahkan dan mengedit kegiatan. Form ini sudah dilengkapi validasi input untuk memastikan setiap field terisi dengan benar dan sesuai format. Tanggal kegiatan hanya dapat dipilih mulai dari hari ini hingga tiga tahun ke depan menggunakan date picker. Waktu kegiatan menggunakan time picker dengan dua field berdampingan (jam mulai dan jam selesai) yang outputnya otomatis menjadi format "07.00 - 12.00 WITA", menggantikan input teks bebas sebelumnya. Terdapat loading indicator di tombol simpan saat data sedang dikirim ke Supabase. Seluruh tampilan form menyesuaikan Light Mode dan Dark Mode.

#### admin_screen.dart
```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/activity.dart';
import 'activity_form_screen.dart';
import 'participants_screen.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final activities = provider.activities;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF0F4FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D47A1),
        foregroundColor: Colors.white,
        title: const Text('Admin Panel'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'Tambah Kegiatan',
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ActivityFormScreen())),
          ),
        ],
      ),
      body: Column(children: [
        // Stats header
        Container(
          color: const Color(0xFF0D47A1),
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
          child: Row(children: [
            _statCard('Kegiatan', activities.length.toString(), Icons.event),
            const SizedBox(width: 12),
            _statCard('Total Relawan',
                activities.fold(0, (s, a) => s + a.registeredCount).toString(), Icons.people),
          ]),
        ),
        const Padding(
          padding: EdgeInsets.all(16),
          child: Row(children: [
            Text('Daftar Kegiatan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ]),
        ),
        Expanded(
          child: activities.isEmpty
              ? Center(child: Text('Belum ada kegiatan', style: TextStyle(color: Colors.grey.shade500)))
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                  itemCount: activities.length,
                  itemBuilder: (context, i) => _AdminActivityTile(activity: activities[i]),
                ),
        ),
      ]),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ActivityFormScreen())),
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Kegiatan'),
      ),
    );
  }

  Widget _statCard(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(children: [
          Icon(icon, color: Colors.white70, size: 24),
          const SizedBox(width: 10),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
            Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
          ]),
        ]),
      ),
    );
  }
}

class _AdminActivityTile extends StatelessWidget {
  final Activity activity;
  const _AdminActivityTile({required this.activity});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 6)],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.fromLTRB(16, 10, 8, 10),
        title: Text(activity.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(height: 4),
          Text(activity.organizer, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
          const SizedBox(height: 4),
          Row(children: [
            Icon(Icons.people, size: 13, color: Colors.grey.shade500),
            const SizedBox(width: 4),
            Text('${activity.registeredCount}/${activity.maxParticipants} relawan',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFF1565C0).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(activity.category,
                  style: const TextStyle(fontSize: 10, color: Color(0xFF1565C0), fontWeight: FontWeight.bold)),
            ),
          ]),
        ]),
        trailing: Row(mainAxisSize: MainAxisSize.min, children: [
          IconButton(
            icon: const Icon(Icons.group, color: Colors.blue, size: 20),
            tooltip: 'Lihat Peserta',
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => ParticipantsScreen(activity: activity))),
          ),
          IconButton(
            icon: const Icon(Icons.edit, color: Color(0xFF1565C0), size: 20),
            tooltip: 'Edit',
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => ActivityFormScreen(activity: activity))),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red, size: 20),
            tooltip: 'Hapus',
            onPressed: () => _confirmDelete(context),
          ),
        ]),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Kegiatan?'),
        content: Text('Kegiatan "${activity.title}" akan dihapus beserta semua data peserta.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () {
              context.read<AppProvider>().deleteActivity(activity.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Kegiatan berhasil dihapus'), backgroundColor: Colors.red),
              );
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}
```
Code ini digunakan sebagai panel pengelolaan kegiatan. Pada halaman ini admin dapat melihat total jumlah kegiatan dan total relawan yang terdaftar, menambahkan kegiatan baru, mengedit kegiatan, melihat daftar peserta pada setiap kegiatan, serta menghapus kegiatan dengan dialog konfirmasi. Jika kegiatan dihapus, maka seluruh data peserta yang terdaftar pada kegiatan tersebut juga akan ikut terhapus melalui mekanisme ON DELETE CASCADE di Supabase. Tampilan menyesuaikan Light Mode dan Dark Mode.

#### home_screen.dart
```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../providers/theme_provider.dart';
import '../services/supabase_service.dart';
import '../widgets/activity_card.dart';
import 'activity_detail_screen.dart';
import 'register_screen.dart';
import 'admin_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategory = 'Semua';
  final _categories = ['Semua', 'Lingkungan', 'Kesehatan', 'Pendidikan', 'Sosial'];

  @override
  void initState() {
    super.initState();
    // Fetch data dari Supabase di halaman pertama
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<AppProvider>().fetchActivities();
    });
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Keluar?'),
        content: const Text('Kamu akan keluar dari akun ini.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await SupabaseService.logout();
      if (!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final activities = provider.activities.where((a) {
      if (_selectedCategory == 'Semua') return true;
      return a.category == _selectedCategory;
    }).toList();

    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFF0F4FF);
    final appBarColor = isDark ? const Color(0xFF0A1929) : const Color(0xFF1565C0);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        foregroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Row(children: [
          Icon(Icons.volunteer_activism, color: Colors.white),
          SizedBox(width: 8),
          Text('GoVolunteer', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        ]),
        actions: [
          // Toggle Dark/Light Mode
          IconButton(
            icon: Icon(themeProvider.isDark ? Icons.light_mode : Icons.dark_mode),
            tooltip: themeProvider.isDark ? 'Mode Terang' : 'Mode Gelap',
            onPressed: () => context.read<ThemeProvider>().toggleTheme(),
          ),
          // Admin Panel
          IconButton(
            icon: const Icon(Icons.admin_panel_settings),
            tooltip: 'Admin Panel',
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminScreen())),
          ),
          // Logout
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Keluar',
            onPressed: _logout,
          ),
        ],
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF1565C0)))
          : provider.errorMessage != null
              ? Center(
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    const Icon(Icons.wifi_off, size: 60, color: Colors.grey),
                    const SizedBox(height: 12),
                    Text(provider.errorMessage!, textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.grey)),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => context.read<AppProvider>().fetchActivities(),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Coba Lagi'),
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1565C0), foregroundColor: Colors.white),
                    ),
                  ]),
                )
              : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  // Header Banner
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: appBarColor,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(24),
                        bottomRight: Radius.circular(24),
                      ),
                    ),
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(
                        'Halo, ${SupabaseService.currentUsername}!',
                        style: const TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      const Text('Temukan kegiatan sosial\ndi Samarinda',
                          style: TextStyle(color: Colors.white, fontSize: 22,
                              fontWeight: FontWeight.bold, height: 1.3)),
                    ]),
                  ),
                  const SizedBox(height: 14),

                  // Category chips
                  SizedBox(
                    height: 36,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _categories.length,
                      itemBuilder: (context, i) {
                        final cat = _categories[i];
                        final isSelected = cat == _selectedCategory;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedCategory = cat),
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFF1565C0) : (isDark ? const Color(0xFF1E1E1E) : Colors.white),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected ? const Color(0xFF1565C0) : Colors.grey.shade400,
                              ),
                              boxShadow: isSelected
                                  ? [BoxShadow(color: const Color(0xFF1565C0).withValues(alpha: 0.3), blurRadius: 6)]
                                  : null,
                            ),
                            child: Text(cat,
                              style: TextStyle(
                                color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.grey.shade700),
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                fontSize: 13,
                              )),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text('${activities.length} Kegiatan Tersedia',
                        style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
                  ),
                  const SizedBox(height: 6),

                  Expanded(
                    child: activities.isEmpty
                        ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                            Icon(Icons.event_busy, size: 64, color: Colors.grey.shade400),
                            const SizedBox(height: 12),
                            Text('Belum ada kegiatan',
                                style: TextStyle(color: Colors.grey.shade500, fontSize: 15)),
                          ]))
                        : RefreshIndicator(
                            color: const Color(0xFF1565C0),
                            onRefresh: () => context.read<AppProvider>().fetchActivities(),
                            child: ListView.builder(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                              itemCount: activities.length,
                              itemBuilder: (context, i) {
                                final act = activities[i];
                                return ActivityCard(
                                  activity: act,
                                  onTap: () => Navigator.push(context,
                                      MaterialPageRoute(builder: (_) => ActivityDetailScreen(activity: act))),
                                  onRegister: () => Navigator.push(context,
                                      MaterialPageRoute(builder: (_) => RegisterScreen(activity: act))),
                                );
                              },
                            ),
                          ),
                  ),
                ]),
    );
  }
}
```
Code ini berfungsi sebagai halaman utama yang menampilkan seluruh daftar kegiatan yang tersedia. Data kegiatan diambil dari Supabase saat halaman pertama kali dibuka dan dapat diperbarui dengan pull-to-refresh. Pengguna dapat memfilter kegiatan berdasarkan kategori. AppBar dilengkapi tombol toggle Light/Dark Mode, tombol Admin Panel, dan tombol logout dengan dialog konfirmasi. Sapaan pengguna di header menampilkan username yang didaftarkan saat pembuatan akun.

#### participants_screen.dart
```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/activity.dart';
import '../models/participant.dart';
import '../providers/app_provider.dart';

class ParticipantsScreen extends StatefulWidget {
  final Activity activity;
  const ParticipantsScreen({super.key, required this.activity});
  @override
  State<ParticipantsScreen> createState() => _ParticipantsScreenState();
}

class _ParticipantsScreenState extends State<ParticipantsScreen> {
  late Future<List<Participant>> _future;

  @override
  void initState() {
    super.initState();
    _loadParticipants();
  }

  void _loadParticipants() {
    _future = context.read<AppProvider>().getParticipantsFor(widget.activity.id);
  }

  void _refresh() => setState(() => _loadParticipants());

  Future<void> _confirmRemove(BuildContext context, String participantId, String name) async {
    // Simpan provider sebelum async gap
    final provider = context.read<AppProvider>();

    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Peserta?'),
        content: Text('Data "$name" akan dihapus dari kegiatan ini.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      if (!mounted) return;
      await provider.removeParticipant(participantId, widget.activity.id);
      _refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF0F4FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D47A1),
        foregroundColor: Colors.white,
        title: Text('Peserta: ${widget.activity.title}', maxLines: 1, overflow: TextOverflow.ellipsis),
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _refresh, tooltip: 'Refresh'),
        ],
      ),
      body: FutureBuilder<List<Participant>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF1565C0)));
          }
          if (snap.hasError) {
            return Center(child: Text('Gagal memuat peserta: ${snap.error}',
                style: const TextStyle(color: Colors.red)));
          }
          final participants = snap.data ?? [];
          return Column(children: [
            Container(
              color: const Color(0xFF0D47A1),
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                '${participants.length} dari ${widget.activity.maxParticipants} slot terisi',
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ),
            participants.isEmpty
                ? const Expanded(
                    child: Center(child: Text('Belum ada peserta terdaftar',
                        style: TextStyle(color: Colors.grey))))
                : Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: participants.length,
                      itemBuilder: (context, i) {
                        final p = participants[i];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 6)],
                          ),
                          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Expanded(
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                const SizedBox(height: 4),
                                Text(p.email, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                                Text(p.phone, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                                Text(p.institution, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                              ]),
                            ),
                            TextButton(
                              onPressed: () => _confirmRemove(context, p.id, p.name),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.red, padding: EdgeInsets.zero,
                                minimumSize: const Size(48, 32),
                              ),
                              child: const Text('Hapus', style: TextStyle(fontSize: 12)),
                            ),
                          ]),
                        );
                      },
                    ),
                  ),
          ]);
        },
      ),
    );
  }
}
```
Code ini menampilkan daftar peserta yang telah mendaftar pada suatu kegiatan, diambil langsung dari Supabase menggunakan FutureBuilder sehingga terdapat loading indicator saat data sedang dimuat. Admin dapat melihat detail data peserta dan menghapus peserta dengan dialog konfirmasi. Ketika peserta dihapus, jumlah slot yang tersedia pada kegiatan akan otomatis diperbarui di Supabase. Tampilan menyesuaikan Light Mode dan Dark Mode.

#### register_screen.dart
```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/activity.dart';
import '../providers/app_provider.dart';

class RegisterScreen extends StatefulWidget {
  final Activity activity;
  const RegisterScreen({super.key, required this.activity});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey        = GlobalKey<FormState>();
  final _nameCtrl       = TextEditingController();
  final _phoneCtrl      = TextEditingController();
  final _emailCtrl      = TextEditingController();
  final _institutionCtrl = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameCtrl.dispose(); _phoneCtrl.dispose();
    _emailCtrl.dispose(); _institutionCtrl.dispose();
    super.dispose();
  }

  String? _validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email wajib diisi';
    if (!RegExp(r'^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$').hasMatch(v.trim())) {
      return 'Format email tidak valid (contoh: nama@gmail.com)';
    }
    return null;
  }

  String? _validatePhone(String? v) {
    if (v == null || v.trim().isEmpty) return 'Nomor WhatsApp wajib diisi';
    final cleaned = v.trim().replaceAll(RegExp(r'[\s\-]'), '');
    if (!RegExp(r'^(\+62|62|0)[0-9]{9,12}$').hasMatch(cleaned)) {
      return 'Format nomor tidak valid (contoh: 08123456789)';
    }
    return null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final success = await context.read<AppProvider>().registerParticipant(
      activityId:  widget.activity.id,
      name:        _nameCtrl.text.trim(),
      phone:       _phoneCtrl.text.trim(),
      email:       _emailCtrl.text.trim(),
      institution: _institutionCtrl.text.trim(),
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.check_circle, color: Color(0xFF1565C0), size: 64),
            const SizedBox(height: 16),
            const Text('Pendaftaran Berhasil!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              'Kamu telah terdaftar sebagai relawan di kegiatan "${widget.activity.title}". Sampai jumpa di lokasi!',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ]),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1565C0), foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 44),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () { Navigator.pop(context); Navigator.pop(context); },
              child: const Text('Kembali ke Detail Kegiatan'),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Slot penuh! Pendaftaran tidak dapat dilakukan.'),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF0F4FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        title: const Text('Form Pendaftaran'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Info kegiatan
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF1565C0).withValues(alpha: 0.07),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF1565C0).withValues(alpha: 0.25)),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Mendaftar untuk:', style: TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 4),
                Text(widget.activity.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 2),
                Text(widget.activity.date, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ]),
            ),
            const SizedBox(height: 20),
            const Text('Data Diri', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 14),
            _field(_nameCtrl, 'Nama Lengkap', 'Masukkan nama lengkap',
                validator: (v) => v == null || v.trim().isEmpty ? 'Nama wajib diisi' : null),
            const SizedBox(height: 14),
            _field(_phoneCtrl, 'Nomor WhatsApp', 'Contoh: 08123456789',
                keyboardType: TextInputType.phone, validator: _validatePhone),
            const SizedBox(height: 14),
            _field(_emailCtrl, 'Email', 'Contoh: nama@gmail.com',
                keyboardType: TextInputType.emailAddress, validator: _validateEmail),
            const SizedBox(height: 14),
            _field(_institutionCtrl, 'Asal Instansi / Kampus', 'Contoh: Universitas Mulawarman',
                validator: (v) => v == null || v.trim().isEmpty ? 'Asal instansi wajib diisi' : null),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity, height: 52,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1565C0), foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _isLoading
                    ? const SizedBox(width: 22, height: 22,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                    : const Text('Konfirmasi Pendaftaran',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 20),
          ]),
        ),
      ),
    );
  }

  Widget _field(TextEditingController ctrl, String label, String hint,
      {TextInputType? keyboardType, String? Function(String?)? validator}) {
    // Ambil isDark dari context langsung di dalam method
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
      const SizedBox(height: 6),
      TextFormField(
        controller: ctrl,
        keyboardType: keyboardType,
        validator: validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        style: TextStyle(color: isDark ? Colors.white : Colors.black87),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
          filled: true,
          fillColor: isDark ? const Color(0xFF2A2A2A) : Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF1565C0), width: 2)),
          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 1.5)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        ),
      ),
    ]);
  }
}
```
Code ini merupakan form pendaftaran relawan untuk mendaftar ke suatu kegiatan. Form ini dilengkapi dengan validasi input seperti pengecekan format email dan nomor WhatsApp agar sesuai standar, serta memastikan semua field wajib terisi. Jika data valid dan slot masih tersedia, maka data peserta disimpan ke Supabase dan jumlah peserta pada kegiatan akan bertambah otomatis. Namun jika kuota sudah penuh, sistem akan menampilkan notifikasi bahwa pendaftaran tidak dapat dilakukan. Tampilan form menyesuaikan Light Mode dan Dark Mode.

### Package Services
#### supabase_service.dart
```dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/activity.dart';
import '../models/participant.dart';

class SupabaseService {
  static final _db = Supabase.instance.client;

  // ACTIVITIES
  static Future<List<Activity>> fetchActivities() async {
    final res = await _db
        .from('activities')
        .select()
        .order('created_at', ascending: false);
    return (res as List).map((e) => Activity.fromMap(e)).toList();
  }

  static Future<Activity> insertActivity(Activity a) async {
    final res = await _db.from('activities').insert(a.toMap()).select().single();
    return Activity.fromMap(res);
  }

  static Future<void> updateActivity(Activity a) async {
    await _db.from('activities').update(a.toMap()).eq('id', a.id);
  }

  static Future<void> deleteActivity(String id) async {
    await _db.from('activities').delete().eq('id', id);
  }

  static Future<void> updateRegisteredCount(String activityId, int count) async {
    await _db.from('activities').update({'registered_count': count}).eq('id', activityId);
  }

  // PARTICIPANTS
  static Future<List<Participant>> fetchParticipants(String activityId) async {
    final res = await _db
        .from('participants')
        .select()
        .eq('activity_id', activityId)
        .order('registered_at', ascending: false);
    return (res as List).map((e) => Participant.fromMap(e)).toList();
  }

  static Future<Participant> insertParticipant(Participant p) async {
    final res = await _db.from('participants').insert(p.toMap()).select().single();
    return Participant.fromMap(res);
  }

  static Future<void> deleteParticipant(String id) async {
    await _db.from('participants').delete().eq('id', id);
  }

  // ── AUTH ─────────────────────────────────────────────
  static Future<AuthResponse> register(String email, String password, {String? username}) async {
    return await _db.auth.signUp(
      email: email,
      password: password,
      data: username != null ? {'username': username} : null,
    );
  }

  // Ambil username dari metadata user yang sedang login
  static String get currentUsername {
    final meta = _db.auth.currentUser?.userMetadata;
    return meta?['username'] as String? ??
        _db.auth.currentUser?.email?.split('@').first ??
        'Relawan';
  }

  static Future<AuthResponse> login(String email, String password) async {
    return await _db.auth.signInWithPassword(email: email, password: password);
  }

  static Future<void> logout() async => await _db.auth.signOut();

  static User? get currentUser => _db.auth.currentUser;
  static bool get isLoggedIn => _db.auth.currentUser != null;
}
```
Class ini merupakan pusat komunikasi antara aplikasi Flutter dengan Supabase. Semua operasi database dan autentikasi dilakukan di sini secara terpusat menggunakan static method agar bisa dipanggil dari mana saja tanpa perlu membuat instance. Untuk kegiatan dan peserta, setiap operasi CRUD langsung mengakses tabel yang sesuai di Supabase. Untuk autentikasi, fungsi register menyimpan username ke userMetadata Supabase sehingga dapat diambil kembali menggunakan getter currentUsername sebagai nama sapaan pengguna di halaman utama. URL dan API Key Supabase tidak ditulis langsung di kode, melainkan dibaca dari file .env melalui flutter_dotenv.

### Package Widgets
#### activity_card.dart
```dart
import 'package:flutter/material.dart';
import '../models/activity.dart';

class ActivityCard extends StatelessWidget {
  final Activity activity;
  final VoidCallback onTap;
  final VoidCallback? onRegister;

  const ActivityCard({
    super.key,
    required this.activity,
    required this.onTap,
    this.onRegister,
  });

  List<Color> get _gradientColors {
    switch (activity.category) {
      case 'Lingkungan': return [const Color(0xFF0D47A1), const Color(0xFF64B5F6)];
      case 'Kesehatan':  return [const Color(0xFFB71C1C), const Color(0xFFEF9A9A)];
      case 'Pendidikan': return [const Color(0xFF0D47A1), const Color(0xFF64B5F6)];
      case 'Sosial':     return [const Color(0xFF4A148C), const Color(0xFFCE93D8)];
      default:           return [const Color(0xFF263238), const Color(0xFF90A4AE)];
    }
  }

  IconData get _categoryIcon {
    switch (activity.category) {
      case 'Lingkungan': return Icons.park;
      case 'Kesehatan':  return Icons.favorite;
      case 'Pendidikan': return Icons.school;
      case 'Sosial':     return Icons.people;
      default:           return Icons.volunteer_activism;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.grey.shade300 : const Color(0xFF444444);
    final subTextColor = isDark ? Colors.grey.shade400 : Colors.grey.shade600;
    final progressBg = isDark ? Colors.grey.shade800 : Colors.grey.shade100;

    final slotPercent = activity.maxParticipants > 0
        ? activity.registeredCount / activity.maxParticipants
        : 0.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _gradientColors[0].withValues(alpha: isDark ? 0.25 : 0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner gradient
          GestureDetector(
            onTap: onTap,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: Container(
                height: 155,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: _gradientColors,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(right: -24, top: -24,
                      child: Container(width: 130, height: 130,
                        decoration: BoxDecoration(shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.08)))),
                    Positioned(right: 24, bottom: -36,
                      child: Container(width: 100, height: 100,
                        decoration: BoxDecoration(shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.08)))),
                    Positioned(left: -16, bottom: -16,
                      child: Container(width: 80, height: 80,
                        decoration: BoxDecoration(shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.06)))),
                    // Category badge
                    Positioned(
                      top: 12, left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.22),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white30),
                        ),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          Icon(_categoryIcon, size: 12, color: Colors.white),
                          const SizedBox(width: 5),
                          Text(activity.category,
                              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                        ]),
                      ),
                    ),
                    // PENUH badge
                    if (activity.isFull)
                      Positioned(
                        top: 12, right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.red.shade700,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text('PENUH',
                              style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    Center(child: Icon(_categoryIcon, size: 68, color: Colors.white.withValues(alpha: 0.22))),
                    Positioned(
                      bottom: 12, left: 14, right: 14,
                      child: Text(activity.title,
                        style: const TextStyle(color: Colors.white, fontSize: 17,
                            fontWeight: FontWeight.bold, shadows: [Shadow(blurRadius: 8, color: Colors.black38)]),
                        maxLines: 2, overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Body info
          GestureDetector(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Icon(Icons.business_outlined, size: 14, color: subTextColor),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(activity.organizer,
                        style: TextStyle(color: subTextColor, fontSize: 12, fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis),
                  ),
                ]),
                const SizedBox(height: 8),
                Text(activity.description,
                    style: TextStyle(fontSize: 13, color: textColor, height: 1.45),
                    maxLines: 3, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 10),
                Row(children: [
                  Icon(Icons.calendar_today_outlined, size: 13, color: _gradientColors[0]),
                  const SizedBox(width: 5),
                  Text(activity.date,
                      style: TextStyle(fontSize: 12, color: _gradientColors[0], fontWeight: FontWeight.w600)),
                  const SizedBox(width: 12),
                  Icon(Icons.access_time_outlined, size: 13, color: subTextColor),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(activity.time,
                        style: TextStyle(fontSize: 12, color: subTextColor),
                        overflow: TextOverflow.ellipsis),
                  ),
                ]),
                const SizedBox(height: 5),
                Row(children: [
                  Icon(Icons.location_on_outlined, size: 13, color: subTextColor),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(activity.location,
                        style: TextStyle(fontSize: 12, color: subTextColor),
                        overflow: TextOverflow.ellipsis),
                  ),
                ]),
                const SizedBox(height: 10),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('Slot Tersedia', style: TextStyle(fontSize: 11, color: subTextColor)),
                  Text(
                    '${activity.availableSlots} / ${activity.maxParticipants} relawan',
                    style: TextStyle(
                      fontSize: 11, fontWeight: FontWeight.bold,
                      color: slotPercent > 0.8 ? Colors.red : _gradientColors[0],
                    ),
                  ),
                ]),
                const SizedBox(height: 5),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: slotPercent.toDouble(),
                    backgroundColor: progressBg,
                    valueColor: AlwaysStoppedAnimation(
                      slotPercent > 0.8 ? Colors.red : _gradientColors[0],
                    ),
                    minHeight: 6,
                  ),
                ),
              ]),
            ),
          ),

          // Buttons
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
            child: Row(children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onTap,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: _gradientColors[0]),
                    foregroundColor: _gradientColors[0],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 11),
                  ),
                  child: const Text('Detail', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: activity.isFull ? null : onRegister,
                  icon: Icon(activity.isFull ? Icons.lock_outline : Icons.how_to_reg, size: 16),
                  label: Text(
                    activity.isFull ? 'Slot Penuh' : 'Daftar Sekarang',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: activity.isFull ? Colors.grey.shade400 : _gradientColors[0],
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: isDark ? Colors.grey.shade700 : Colors.grey.shade200,
                    disabledForegroundColor: isDark ? Colors.grey.shade400 : Colors.grey.shade500,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 11),
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
```
Code ini merupakan widget yang digunakan untuk menampilkan informasi kegiatan dalam bentuk card. Setiap card memiliki warna menyesuaikan kategori kegiatan seperti Lingkungan, Kesehatan, Pendidikan, dan Sosial, lengkap dengan ikon kategori, badge status "Penuh" jika kuota sudah habis, serta informasi detail seperti penyelenggara, deskripsi singkat, tanggal, waktu, lokasi, dan sisa slot relawan. Bagian bawah card yaitu background, teks, dan progress bar menyesuaikan Light Mode dan Dark Mode.

### Main
```dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'providers/app_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await Supabase.initialize(
    url:      dotenv.env['SUPABASE_URL']!,
    anonKey:  dotenv.env['SUPABASE_ANON_KEY']!,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const GoVolunteerApp(),
    ),
  );
}

class GoVolunteerApp extends StatelessWidget {
  const GoVolunteerApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    return MaterialApp(
      title: 'GoVolunteer',
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1565C0), brightness: Brightness.light),
        scaffoldBackgroundColor: const Color(0xFFF0F4FF),
        fontFamily: 'Roboto',
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1565C0), brightness: Brightness.dark),
        scaffoldBackgroundColor: const Color(0xFF121212),
        fontFamily: 'Roboto',
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('id', 'ID'), Locale('en', 'US')],
      locale: const Locale('id', 'ID'),
      // Cek session: sudah login → Home, belum → Login
      home: Supabase.instance.client.auth.currentSession != null
          ? const HomeScreen()
          : const LoginScreen(),
    );
  }
}
```
Code main merupakan code yang menjalankan seluruh aplikasi. Sebelum aplikasi dijalankan, dilakukan dua inisialisasi: memuat file .env menggunakan flutter_dotenv untuk membaca URL dan API Key Supabase, lalu menginisialisasi koneksi Supabase. Aplikasi menggunakan MultiProvider untuk menyediakan dua provider secara global yaitu AppProvider untuk data kegiatan dan peserta, serta ThemeProvider untuk mengatur tema. Pengecekan sesi login dilakukan saat aplikasi pertama kali dibuka, jika sesi masih aktif maka langsung menuju HomeScreen, jika tidak maka menuju LoginScreen.

## Dokumentasi Aplikasi
