import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:live_score/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Onboard {
  final String image, title, description;
  Onboard({
    required this.image,
    required this.description,
    required this.title,
  });
}

final List<Onboard> onboardData = [
  Onboard(
    description: "Watch professional league football matches",
    title: "Stream Football Match",
    image: 'images/onboard1.png',
  ),
  Onboard(
    description: "Real-time football live scores and match statistics",
    title: "Realtime Statistics",
    image: "images/onboard2.png",
  ),
  Onboard(
    description: "Club statistics and league standings around the world",
    title: "League Standings",
    image: "images/onboard3.png",
  ),
];

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final controller = PageController();
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      setState(() {
        currentPage = controller.page?.round() ?? 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.only(bottom: 80.0),
          child: PageView(
            controller: controller,

            children: [
              ...onboardData.map(
                (data) => Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(image: AssetImage(data.image), width: 200.0),
                      const SizedBox(height: 20),
                      Text(
                        data.title,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        data.description,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomSheet:
          (currentPage == onboardData.length - 1)
              ? Container(
                height: 80.0,
                child: FilledButton(
                  onPressed: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setBool('showHome', true);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Homepage()),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                      Colors.blue.shade800,
                    ),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                    ),
                    minimumSize: WidgetStatePropertyAll(
                      Size(double.infinity, double.infinity),
                    ),
                  ),
                  child: Text("Get Started", style: TextStyle(fontSize: 20.0)),
                ),
              )
              : Container(
                height: 80.0,
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => controller.jumpToPage(3),
                      child: Text(
                        "SKIP",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Center(
                      child: SmoothPageIndicator(
                        controller: controller,
                        count: 3,
                        effect: WormEffect(),
                        onDotClicked:
                            (index) => controller.animateToPage(
                              index,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeIn,
                            ),
                      ),
                    ),
                    TextButton(
                      onPressed:
                          () => controller.nextPage(
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeIn,
                          ),
                      child: Text(
                        "NEXT",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
