import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Data model for managing timer state.
class TimerProvider with ChangeNotifier {
  Duration _currentDuration;
  Duration _targetDuration;
  bool _isRunning;
  bool _isCountdown;
  Timer? _timer;

  TimerProvider()
      : _currentDuration = Duration.zero,
        _targetDuration = const Duration(minutes: 5), // Default target
        _isRunning = false,
        _isCountdown = false; // Default to stopwatch

  Duration get currentDuration => _currentDuration;
  Duration get targetDuration => _targetDuration;
  bool get isRunning => _isRunning;
  bool get isCountdown => _isCountdown;

  void _tick() {
    if (_isCountdown) {
      if (_currentDuration > Duration.zero) {
        _currentDuration = _currentDuration - const Duration(seconds: 1);
      } else {
        _timer?.cancel();
        _isRunning = false;
        // Optionally, trigger an event for countdown completion
      }
    } else {
      _currentDuration = _currentDuration + const Duration(seconds: 1);
    }
    notifyListeners();
  }

  void start() {
    if (!_isRunning) {
      _isRunning = true;
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) => _tick());
      notifyListeners();
    }
  }

  void pause() {
    if (_isRunning) {
      _timer?.cancel();
      _isRunning = false;
      notifyListeners();
    }
  }

  void reset() {
    _timer?.cancel();
    _isRunning = false;
    _currentDuration = _isCountdown ? _targetDuration : Duration.zero;
    notifyListeners();
  }

  void setTargetDuration(Duration duration) {
    if (!_isRunning) {
      _targetDuration = duration;
      if (_isCountdown) {
        _currentDuration = duration;
      }
      notifyListeners();
    }
  }

  void addTime(Duration duration) {
    if (!_isRunning && _isCountdown) {
      _targetDuration += duration;
      _currentDuration = _targetDuration;
      notifyListeners();
    }
  }

  void subtractTime(Duration duration) {
    if (!_isRunning && _isCountdown) {
      if (_targetDuration > duration) {
        _targetDuration -= duration;
      } else {
        _targetDuration = Duration.zero;
      }
      _currentDuration = _targetDuration;
      notifyListeners();
    }
  }

  void toggleMode() {
    if (!_isRunning) {
      _isCountdown = !_isCountdown;
      _currentDuration = _isCountdown ? _targetDuration : Duration.zero;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vortex Timer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF8A2BE2), // Purple accent
        scaffoldBackgroundColor: const Color(0xFF0A0A0A), // Deep black background
        cardColor: const Color(0xFF1A1A1A), // Slightly lighter black for cards/containers
        canvasColor: const Color(0xFF0A0A0A), // For things like bottom sheets
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF8A2BE2), // Purple
          secondary: Color(0xFFC700FF), // Brighter purple for secondary actions
          background: Color(0xFF0A0A0A), // Deep black
          surface: Color(0xFF1A1A1A), // Slightly lighter black
          error: Color(0xFFCF6679), // Standard dark theme error color
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onBackground: Colors.white,
          onSurface: Colors.white70,
          onError: Colors.black,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0A0A0A),
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(color: Colors.white, fontSize: 56, fontWeight: FontWeight.bold, letterSpacing: 2),
          displayMedium: TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold, letterSpacing: 2),
          displaySmall: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
          headlineLarge: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
          headlineMedium: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
          headlineSmall: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          titleLarge: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w600),
          titleMedium: TextStyle(color: Colors.white70, fontSize: 18, fontWeight: FontWeight.w500),
          titleSmall: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w500),
          bodyLarge: TextStyle(color: Colors.white70, fontSize: 16),
          bodyMedium: TextStyle(color: Colors.white70, fontSize: 14),
          labelLarge: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          labelMedium: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
          labelSmall: TextStyle(color: Colors.white70, fontSize: 12),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF1A1A1A),
          hintStyle: const TextStyle(color: Colors.white38),
          labelStyle: const TextStyle(color: Colors.white70),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF8A2BE2), width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFCF6679), width: 2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFCF6679), width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          errorStyle: const TextStyle(color: Color(0xFFCF6679), fontSize: 12),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: const Color(0xFF8A2BE2),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/home': (context) => ChangeNotifierProvider<TimerProvider>(
              create: (context) => TimerProvider(),
              builder: (context, child) => const TimerAppScreen(),
            ),
      },
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vortex Login'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.hourglass_empty,
                size: 120,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 32),
              Text(
                'Welcome to Vortex Timer',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Focus your time, master your day.',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/home');
                },
                child: const Text('Start Focusing'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TimerAppScreen extends StatelessWidget {
  const TimerAppScreen({super.key});

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final String hours = twoDigits(duration.inHours);
    final String minutes = twoDigits(duration.inMinutes.remainder(60));
    final String seconds = twoDigits(duration.inSeconds.remainder(60));
    return [if (duration.inHours > 0) hours, minutes, seconds].join(':');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vortex Timer'),
        centerTitle: true,
      ),
      body: Consumer<TimerProvider>(
        builder: (context, timerProvider, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  timerProvider.isCountdown ? 'COUNTDOWN' : 'STOPWATCH',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                        letterSpacing: 3,
                      ),
                ),
                const SizedBox(height: 16),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    _formatDuration(timerProvider.currentDuration),
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontSize: 80,
                          color: Colors.white,
                        ),
                  ),
                ),
                if (timerProvider.isCountdown && !timerProvider.isRunning) ...[
                  Text(
                    'Target: ${_formatDuration(timerProvider.targetDuration)}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white70,
                        ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _buildTimeAdjustmentButton(
                          context, '-1m', () => timerProvider.subtractTime(const Duration(minutes: 1))),
                      const SizedBox(width: 10),
                      _buildTimeAdjustmentButton(
                          context, '+1m', () => timerProvider.addTime(const Duration(minutes: 1))),
                      const SizedBox(width: 10),
                      _buildTimeAdjustmentButton(
                          context, '-10s', () => timerProvider.subtractTime(const Duration(seconds: 10))),
                      const SizedBox(width: 10),
                      _buildTimeAdjustmentButton(
                          context, '+10s', () => timerProvider.addTime(const Duration(seconds: 10))),
                    ],
                  ),
                ],
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton.icon(
                      onPressed: timerProvider.isRunning ? timerProvider.pause : timerProvider.start,
                      icon: Icon(timerProvider.isRunning ? Icons.pause : Icons.play_arrow),
                      label: Text(timerProvider.isRunning ? 'PAUSE' : 'START'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: timerProvider.isRunning
                            ? Theme.of(context).colorScheme.secondary.withOpacity(0.2)
                            : Theme.of(context).colorScheme.secondary,
                        foregroundColor: timerProvider.isRunning
                            ? Theme.of(context).colorScheme.secondary
                            : Colors.white,
                        side: BorderSide(
                          color: timerProvider.isRunning
                              ? Theme.of(context).colorScheme.secondary
                              : Colors.transparent,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton.icon(
                      onPressed: timerProvider.reset,
                      icon: const Icon(Icons.refresh),
                      label: const Text('RESET'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).cardColor,
                        foregroundColor: Colors.white70,
                        side: const BorderSide(color: Colors.white38),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: timerProvider.toggleMode,
                  icon: Icon(timerProvider.isCountdown ? Icons.timer_off : Icons.timer),
                  label: Text(timerProvider.isCountdown ? 'SWITCH TO STOPWATCH' : 'SWITCH TO COUNTDOWN'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).cardColor,
                    foregroundColor: Theme.of(context).colorScheme.primary,
                    side: BorderSide(color: Theme.of(context).colorScheme.primary.withOpacity(0.5)),
                  ),
                ),
                const SizedBox(height: 20),
                TextButton.icon(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('/');
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text('Log Out'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white54,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTimeAdjustmentButton(
      BuildContext context, String text, VoidCallback onPressed) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: Theme.of(context).colorScheme.primary,
        side: BorderSide(color: Theme.of(context).colorScheme.primary.withOpacity(0.7)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: Theme.of(context).textTheme.labelMedium,
      ),
      child: Text(text),
    );
  }
}

void main() {
  runApp(const MyApp());
}
