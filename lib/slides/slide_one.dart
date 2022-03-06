import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:styled_text/styled_text.dart';

import '../screens/see_more.dart';
import '../models/tags.dart';
import '../models/slide.dart';

class SlideOne extends ConsumerStatefulWidget {
  final Slide slide;
  final int pages;
  final Function nextPage;
  final Function previousPage;
  const SlideOne({
    Key? key,
    required this.slide,
    required this.pages,
    required this.nextPage,
    required this.previousPage,
  }) : super(key: key);

  @override
  ConsumerState<SlideOne> createState() => _SlideOneState();
}

class _SlideOneState extends ConsumerState<SlideOne> {
  late FlipCardController _controller;
  Map<String, StyledTextTagBase> tags = Map();

  @override
  void initState() {
    widget.slide.tags.forEach((element) {
      int color = int.parse("0xff" + element.color);
      FontWeight fontWeight =
          element.fontWeight == "bold" ? FontWeight.bold : FontWeight.normal;
      setState(() {
        tags.putIfAbsent(
          element.tag,
          () => StyledTextTag(
            style: GoogleFonts.robotoCondensed(
                textStyle: TextStyle(
                    fontWeight: fontWeight,
                    fontSize: (element.fontSize != 0) ? element.fontSize : null,
                    color: (element.color != "") ? Color(color) : null)),
          ),
        );
      });
    });
    super.initState();
    _controller = FlipCardController();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
                image: DecorationImage(
                    colorFilter: ColorFilter.mode(
                        Theme.of(context).backgroundColor.withOpacity(0.9),
                        BlendMode.darken),
                    image: const AssetImage("assets/images/backLandscape.png"),
                    fit: BoxFit.cover)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Expanded(child: SizedBox()),
                Container(
                  width: width * .8,
                  height: height * .55,
                  margin: const EdgeInsets.only(
                      left: 32.0, right: 32.0, top: 0.0, bottom: 0.0),
                  color: Colors.transparent,
                  child: FlipCard(
                    controller: _controller,
                    direction: FlipDirection.VERTICAL,
                    speed: 1000,
                    onFlipDone: (status) {
                      //print(status);
                    },
                    front: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      child: Center(
                          child: StyledText(
                        textAlign: TextAlign.center,
                        text: widget.slide.firstSide,
                        style: GoogleFonts.robotoCondensed(
                          textStyle: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w400,
                            fontSize: 36,
                          ),
                        ),
                        tags: tags,
                      )),
                    ),
                    back: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      child: Center(
                          child: Column(
                        children: [
                          StyledText(
                            text: widget.slide.secondSide,
                            style: GoogleFonts.robotoCondensed(
                              textStyle: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w400,
                                fontSize: 19,
                                height: 1.7,
                              ),
                            ),
                            tags: tags,
                          ),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  text: "Learn more...",
                                  style: GoogleFonts.robotoCondensed(
                                      textStyle: const TextStyle(
                                    height: 1.7,
                                    color: Colors.blue,
                                    fontSize: 19,
                                  )),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => SeeMore(
                                                  tags: tags,
                                                  text:
                                                      widget.slide.learnMore)),
                                        ),
                                ),
                              ),
                            ],
                          )
                        ],
                      )),
                    ),
                  ),
                ),
                const Expanded(child: SizedBox()),
                const Divider(
                  thickness: 2,
                  height: 0,
                ),
                Container(
                  width: width,
                  decoration: const BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: const Icon(
                          Icons.arrow_left,
                          color: Colors.grey,
                        ),
                        iconSize: 50,
                        onPressed: () {
                          widget.previousPage();
                        },
                      ),
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: const Icon(
                          Icons.fiber_manual_record,
                          color: Colors.grey,
                        ),
                        iconSize: 27,
                        onPressed: () {
                          _controller.toggleCard();
                        },
                      ),
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: const Icon(
                          Icons.arrow_right,
                          color: Colors.grey,
                        ),
                        iconSize: 50,
                        onPressed: () {
                          widget.nextPage();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            )));
  }
}