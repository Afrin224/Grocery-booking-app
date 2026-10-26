import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_app/widgets/user_image_picker.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();

  var _isLogin = true;
  var _enteredEmail = '';
  var _enteredPassword = '';
  var _enteredUsername = '';
  var _obscurePassword = true;
  File? _selectedImage;
  var _isAuthenticating = false;

  void _submit() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;

    _formKey.currentState!.save();

    try {
      setState(() {
        _isAuthenticating = true;
      });

      if (_isLogin) {
        // ---------- LOG IN ----------
        await _firebase.signInWithEmailAndPassword(
          email: _enteredEmail.trim(),
          password: _enteredPassword.trim(),
        );
      } else {
        // ---------- SIGN UP ----------
        final userCredentials = await _firebase.createUserWithEmailAndPassword(
          email: _enteredEmail.trim(),
          password: _enteredPassword.trim(),
        );

        String? imageUrl;
        if (_selectedImage != null) {
          try {
            final storageRef = FirebaseStorage.instance
                .ref()
                .child('user_images')
                .child('${userCredentials.user!.uid}.jpg');

            await storageRef.putFile(_selectedImage!);
            imageUrl = await storageRef.getDownloadURL();
          } catch (_) {
            // Storage upload can fail if rules are not set; continue smoothly
          }
        }

        // Update display name & photo URL
        await userCredentials.user!.updateDisplayName(_enteredUsername);
        if (imageUrl != null) {
          await userCredentials.user!.updatePhotoURL(imageUrl);
        }

        // Save to Firestore
        try {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userCredentials.user!.uid)
              .set({
            'username': _enteredUsername,
            'email': _enteredEmail.trim(),
            'image_url': imageUrl ?? '',
            'created_at': Timestamp.now(),
          });
        } catch (_) {
          // Firestore write failure shouldn't block login
        }
      }
    } on FirebaseAuthException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? 'Authentication failed.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An unexpected error occurred: $error'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isAuthenticating = false;
        });
      }
    }
  }

  void _quickGuestLogin() async {
    setState(() {
      _isAuthenticating = true;
    });

    try {
      await _firebase.signInAnonymously();
    } catch (e) {
      // If anonymous auth is disabled in Firebase console, try demo account or notify user
      try {
        await _firebase.signInWithEmailAndPassword(
          email: 'demo@freshmart.com',
          password: 'Password123!',
        );
      } catch (_) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Please enter your email and password above to sign in or create an account.',
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isAuthenticating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F3820), Color(0xFF1B5E20), Color(0xFF132F1A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App Branding Header
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.shopping_bag_rounded,
                      size: 64,
                      color: Color(0xFF2ECC71),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'FreshMart Groceries',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Book fresh groceries delivered to your door',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 28),

                  // Auth Card
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Tab switcher: Login / Signup
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        setState(() => _isLogin = true);
                                      },
                                      borderRadius: BorderRadius.circular(12),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          color: _isLogin
                                              ? const Color(0xFF1E824C)
                                              : Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Log In',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: _isLogin
                                                  ? Colors.white
                                                  : Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        setState(() => _isLogin = false);
                                      },
                                      borderRadius: BorderRadius.circular(12),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          color: !_isLogin
                                              ? const Color(0xFF1E824C)
                                              : Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Sign Up',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: !_isLogin
                                                  ? Colors.white
                                                  : Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Image picker on signup
                            if (!_isLogin) ...[
                              UserImagePicker(
                                onPickImage: (pickedImage) {
                                  _selectedImage = pickedImage;
                                },
                              ),
                              const SizedBox(height: 12),
                            ],

                            // Username for signup
                            if (!_isLogin) ...[
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Full Name',
                                  prefixIcon: const Icon(
                                    Icons.person_outline,
                                    color: Color(0xFF1E824C),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                textCapitalization: TextCapitalization.words,
                                validator: (value) {
                                  if (value == null ||
                                      value.trim().length < 3) {
                                    return 'Please enter at least 3 characters.';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _enteredUsername = value!.trim();
                                },
                              ),
                              const SizedBox(height: 14),
                            ],

                            // Email
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Email Address',
                                hintText: 'you@example.com',
                                prefixIcon: const Icon(
                                  Icons.email_outlined,
                                  color: Color(0xFF1E824C),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              autocorrect: false,
                              textCapitalization: TextCapitalization.none,
                              validator: (value) {
                                if (value == null ||
                                    value.trim().isEmpty ||
                                    !value.contains('@')) {
                                  return 'Please enter a valid email address.';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _enteredEmail = value!.trim();
                              },
                            ),
                            const SizedBox(height: 14),

                            // Password
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Password',
                                prefixIcon: const Icon(
                                  Icons.lock_outline,
                                  color: Color(0xFF1E824C),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              obscureText: _obscurePassword,
                              validator: (value) {
                                if (value == null ||
                                    value.trim().length < 6) {
                                  return 'Password must be at least 6 characters.';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _enteredPassword = value!.trim();
                              },
                            ),
                            const SizedBox(height: 20),

                            // Submit Button
                            if (_isAuthenticating)
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(
                                  color: Color(0xFF1E824C),
                                ),
                              )
                            else
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: _submit,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF1E824C),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 2,
                                  ),
                                  child: Text(
                                    _isLogin ? 'Log In' : 'Create Account',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),

                            const SizedBox(height: 12),

                            // Quick Guest / Demo Option
                            if (!_isAuthenticating)
                              TextButton.icon(
                                onPressed: _quickGuestLogin,
                                icon: const Icon(
                                  Icons.explore_outlined,
                                  size: 18,
                                  color: Color(0xFF2ECC71),
                                ),
                                label: const Text(
                                  'Explore as Guest',
                                  style: TextStyle(
                                    color: Color(0xFF2ECC71),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
