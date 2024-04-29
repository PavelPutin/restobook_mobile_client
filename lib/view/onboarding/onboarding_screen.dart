import 'package:flutter/material.dart';

import '../main_screen/main_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _pageController;

  int _pageIndex = 0;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _pageIndex = index;
                      });
                    },
                    itemCount: datas.length,
                    itemBuilder: (context, index) => Padding(
                        padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                        child: OnboardContent(
                          text: datas[index].text,
                        ))),
              ),
              Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Spacer(),
                    ...List.generate(
                        datas.length,
                            (index) => Padding(
                            padding: EdgeInsets.all(16),
                            child: DotIndicator(
                              isActive: index == _pageIndex,
                            ))),
                    const Spacer(),
                  ],
                ),
              ),
              if (_pageIndex == datas.length - 1)
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                  child: SizedBox(
                    height: 60,
                    width: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => const MainScreen()));
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                      ),
                      child: Icon(Icons.arrow_forward),
                    ),
                  ),
                ),
              if (_pageIndex != datas.length - 1)
                const SizedBox(
                  height: 80,
                )
            ],
          ),
        ));
  }
}

class DotIndicator extends StatelessWidget {
  final bool isActive;

  const DotIndicator({super.key, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      width: 20,
      decoration: BoxDecoration(
          color: isActive ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.background,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          border: Border.all(color: Theme.of(context).colorScheme.primary, width: 1)),
    );
  }
}

class Data {
  final String text;

  Data({required this.text});
}

final List<Data> datas = [
  Data(
      text: "Onboarding 1"),
  Data(
      text:
      "Onboarding 2"),
  Data(
      text:
      "Onboarding 3"),
];

class OnboardContent extends StatelessWidget {
  final String text;

  const OnboardContent({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        const Spacer(),
        Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontSize: 28,

              fontWeight: FontWeight.w900),
        ),
        const Spacer()
      ],
    );
  }
}