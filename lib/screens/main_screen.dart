import 'package:flutter/material.dart';
import 'package:flutter_flashcards_portrait/models/slide.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';

import '../state_managment/dark_mode_state_manager.dart';
import '../state_managment/current_card_state_manager.dart';
import '../slides/slide_zero.dart';
import '../slides/slide_one.dart';
import 'categories_screen.dart';
import 'credential_screen.dart';

class MainScreen extends ConsumerStatefulWidget {
  final List<Slide> slides;
  final String title;
  final String lesson;
  const MainScreen(
      {Key? key,
      required this.slides,
      required this.lesson,
      required this.title})
      : super(key: key);

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  void startLesson() {
    pageControllerH.nextPage(
        duration: const Duration(milliseconds: 3), curve: Curves.fastOutSlowIn);
  }

  int page = 0;
  List<Widget> list = [];

  PageController pageControllerH = PageController();

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    list = [
      SlideZero(startLesson, widget.title),
      CredentialScreen(startLesson),
    ];
    loadData();
  }

  void nextPage() {
    if (page < list.length) {
      pageControllerH.nextPage(
          duration: const Duration(milliseconds: 3),
          curve: Curves.fastOutSlowIn);
    }
  }

  void previousPage() {
    if (page > 0) {
      pageControllerH.previousPage(
          duration: const Duration(milliseconds: 3),
          curve: Curves.fastOutSlowIn);
    }
  }

  Future<void> loadData() async {
    setState(() {
      widget.slides.forEach((newslide) {
        list.add(SlideOne(
          slide: newslide,
          nextPage: nextPage,
          previousPage: previousPage,
          pages: widget.slides.length,
        ));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const Border(top: BorderSide(color: Colors.green, width: 3)),
        backgroundColor: Theme.of(context).cardColor,
        centerTitle: false,
        titleSpacing: 0,
        shadowColor: Theme.of(context).shadowColor,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 30,
                      child: Image.asset('assets/images/LogoMaster.png'),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      page > 0 ? '${page - 1}' : '$page',
                      style: GoogleFonts.robotoCondensed(
                        textStyle: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Text(
                      '/',
                      style: GoogleFonts.robotoCondensed(
                        textStyle: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Text(
                      '${list.length - 2}',
                      style: GoogleFonts.robotoCondensed(
                        textStyle: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context)
                                .primaryColor
                                .withOpacity(0.6)),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    PopupMenuButton<String>(
                      child: Icon(
                        Icons.more_vert,
                        color: Theme.of(context).primaryColor,
                      ),
                      onSelected: (String value) => value == 'Categories'
                          ? Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const CategoriesScreen()),
                            )
                          : ref
                              .read(darkModeStateManagerProvider.notifier)
                              .switchDarkMode(),
                      itemBuilder: (BuildContext context) {
                        return {
                          Theme.of(context).brightness == Brightness.light
                              ? 'enable dark mode'
                              : 'disable dark mode, Categories',
                          'Categories'
                        }.map((String choice) {
                          return PopupMenuItem<String>(
                            value: choice,
                            child: Text(choice),
                          );
                        }).toList();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              onPageChanged: (int newpage) {
                setState(() {
                  page = newpage;
                });
                ref
                    .read(currentPageStateManagerProvider.notifier)
                    .changepage(page);
              },
              scrollDirection: Axis.horizontal,
              controller: pageControllerH,
              scrollBehavior:
                  ScrollConfiguration.of(context).copyWith(dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
              }),
              children: list,
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 20, right: 12),
            color: Colors.blue,
            width: double.infinity,
            height: 45,
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.title,
                      style: GoogleFonts.robotoSlab(
                        textStyle: GoogleFonts.robotoSlab(
                            textStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500)),
                      )),
                  Text(
                    widget.lesson,
                    style: GoogleFonts.robotoSlab(
                        textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500)),
                  ),
                ]),
          ),
        ],
      ),
    );
  }
}