import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PricingPage(),
    );
  }
}

class PricingPage extends StatelessWidget {
  const PricingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
                alignment: Alignment.topLeft,
                child: ElevatedButton(
                  onPressed: () {
                    // Exit the app (only works on Android)
                    Navigator.of(context).pop();
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)))),
                  child: //x icon
                      const Icon(Icons.close),
                )),
            const Padding(
                padding: EdgeInsetsDirectional.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Text(
                      'Best AI Assistant Powered by GPT',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'Upgrade plan now for a seamless, user-friendly experience.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    )
                  ],
                )),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPricingCard(
                    context,
                    title: 'Basic',
                    tier: 'Basic',
                    price: 'Free',
                    features: [
                      'AI Chat Model GPT-3.5',
                      'AI Action Injection',
                      'Select Text for AI Action',
                      '50 free queries per day',
                      'Lower response speed during high-traffic',
                    ],
                  ),
                  _buildPricingCard(
                    context,
                    title: 'Starter',
                    tier: 'Starter',
                    price: '\$9.99/month',
                    features: [
                      'AI Chat Models GPT-3.5 & GPT-4.0/Turbo & Gemini Pro',
                      'Unlimited queries per month',
                      'Real-time Web Access',
                      'AI Writing Assistant',
                      '2X faster response speed',
                      'Priority email support',
                    ],
                  ),
                  _buildPricingCard(
                    context,
                    title: 'Pro',
                    tier: 'Pro',
                    price: '\$99/year',
                    features: [
                      'AI Chat Models GPT-3.5 & GPT-4.0/Turbo & Gemini Pro',
                      'Unlimited queries per year',
                      'Real-time Web Access',
                      'Jira Copilot Assistant',
                      'GitHub Copilot Assistant',
                      '2X faster response speed',
                      'Priority email support',
                    ],
                    highlight: true,
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: _launchURL,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.orange),
              ),
              child: const Text(
                'Upgrade Now!',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  _launchURL() async {
    const url = 'https://admin.jarvis.cx/pricing/overview';
    try {
      print("test");
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalNonBrowserApplication);
    } catch (e) {
      print(e);
    }
  }

  Widget _buildPricingCard(
    BuildContext context, {
    required String title,
    required String price,
    required String tier,
    required List<String> features,
    bool highlight = false,
  }) {
    return Expanded(
      child: Card(
        color: tier == 'Pro' ? Colors.orange[100] : (tier == 'Starter' ? Colors.blue[100] : Colors.white),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: highlight ? Colors.orange : Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                price,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              const Divider(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: features
                    .map((feature) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            children: [
                              // const Icon(
                              //   Icons.check_circle,
                              //   color: Colors.green,
                              //   size: 20,
                              // ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  feature,
                                  style: const TextStyle(fontSize: 10),
                                ),
                              ),
                            ],
                          ),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BlinkAnimation extends StatefulWidget {
  final Widget child;

  const BlinkAnimation({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<BlinkAnimation> createState() => _BlinkAnimationState();
}

class _BlinkAnimationState extends State<BlinkAnimation> with SingleTickerProviderStateMixin {
  late final AnimationController controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..repeat(reverse: true);
  late final Animation<double> animation = CurvedAnimation(
    parent: controller,
    curve: Curves.easeInQuart,
  );

  @override
  Widget build(BuildContext context) {
    return FadeTransition(opacity: animation, child: widget.child);
  }

  @override
  dispose() {
    controller.dispose();
    super.dispose();
  }
}
