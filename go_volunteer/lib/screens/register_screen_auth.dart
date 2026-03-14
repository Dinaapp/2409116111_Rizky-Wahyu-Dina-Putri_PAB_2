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