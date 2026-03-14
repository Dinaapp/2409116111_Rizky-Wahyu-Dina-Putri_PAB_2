## NAMA: Rizky Wahyu Dina Putri
## NIM: 2409116111

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

### Navigasi
#### 1. Navigator.push + MaterialPageRoute
Berpindah ke halaman baru. Digunakan untuk membuka detail, register, form, peserta, dan admin.
#### 2. Navigator.pushReplacement + MaterialPageRoute
Berpindah ke halaman baru dengan mengganti halaman sebelumnya di stack. Digunakan setelah login berhasil menuju HomeScreen dan setelah logout menuju LoginScreen.
#### 3. Navigator.pop
Kembali ke halaman sebelumnya. Digunakan setelah submit berhasil atau menutup dialog.

### State Management (Provider)
#### 1. StatefulWidget + setState()
Mengelola state lokal dalam satu halaman. Digunakan untuk filter kategori, status loading, dan toggle visibilitas password.
#### 2. ChangeNotifierProvider + MultiProvider
Menyediakan state global ke seluruh aplikasi. Digunakan di main.dart dengan MultiProvider untuk mengelola AppProvider (data kegiatan & peserta) dan ThemeProvider (light/dark mode).

### Dark Mode
#### 1. ThemeProvider
ChangeNotifier khusus untuk mengelola tema aplikasi. Menyimpan ThemeMode (light/dark) dan menyediakan fungsi toggleTheme() yang dapat dipanggil dari mana saja. Setiap perubahan tema langsung memperbarui seluruh tampilan aplikasi.
#### 2. ThemeMode di MaterialApp
MaterialApp dikonfigurasi dengan theme (light) dan darkTheme (dark) sekaligus, serta themeMode yang dikontrol oleh ThemeProvider. Seluruh halaman secara otomatis mengikuti tema aktif.
Supabase Integration
#### 1. SupabaseService
Class static yang mengelola semua komunikasi dengan Supabase, mencakup operasi CRUD pada tabel activities dan participants, serta autentikasi (register, login, logout). URL dan API Key dibaca dari file .env menggunakan flutter_dotenv agar tidak ter-push ke GitHub.
#### 2. FutureBuilder
Menampilkan UI berdasarkan state async dari Future. Digunakan di halaman peserta untuk menampilkan loading indicator saat data sedang diambil dari Supabase, lalu menampilkan daftar peserta setelah data tersedia.
#### 3. RefreshIndicator
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
### Package Providers
### Package Screens
### Package Services
### Package Widgets
### Main

## Dokumentasi Aplikasi
