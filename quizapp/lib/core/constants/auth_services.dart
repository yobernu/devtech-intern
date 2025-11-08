import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  static const String supabaseUrl = 'https://gxpexcwkxephfkhojlgd.supabase.co';
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imd4cGV4Y3dreGVwaGZraG9qbGdkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjI2MzIzMzksImV4cCI6MjA3ODIwODMzOX0.aS6wtjKIltzOoGS0-J0u50Bsw_GpjwRud6y1AXeEJOo';

  static final auth = Supabase.instance.client.auth;
  static final supabase = Supabase.instance.client;
}
