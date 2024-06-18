import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> with TickerProviderStateMixin {
  // String keyboardStatus = 'OFF';

  String keyboardStatus = 'OFF';
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 10000), // Adjust animation duration as needed
    vsync: this, // Pass the TickerProvider
  );

  void updateKeyboardStatus() {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    keyboardStatus = bottomInset > 0 ? 'ON' : 'OFF';
    _controller.forward(); // Start the animation
  }

  @override
  void initState() {
    super.initState();
    // Listen for keyboard changes and update state
    WidgetsBinding.instance.addPostFrameCallback((_) => updateKeyboardStatus());
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the animation controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final bottomInset = MediaQuery.of(context).viewInsets.bottom; // Get keyboard height
    // keyboardStatus = bottomInset > 0 ? 'ON' : 'OFF'; // Update text value

    updateKeyboardStatus();

    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'Test Screen',
        ),
      ),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Keyboard Status: $keyboardStatus'),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                hintText: 'Enter your email',
                isDense: true,
                prefixIcon: const Icon(Icons.email),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
