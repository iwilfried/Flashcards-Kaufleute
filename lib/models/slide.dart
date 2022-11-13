import 'package:equatable/equatable.dart';

class Slide extends Equatable {
  final String firstSide;
  final String secondSide;
  final String learnMore;
  bool? answer;

  Slide({
    required this.firstSide,
    required this.secondSide,
    required this.learnMore,
  });

  Map<String, dynamic> toJson() => {
        "First Side": firstSide,
        "Second Side": secondSide,
        "Learn more": learnMore,
        "answer": answer,
      };

  Slide.fromJson(Map<String, dynamic> json)
      : firstSide = json["First Side"],
        secondSide = json['Second Side'],
        learnMore = json['Learn more'],
        answer = json['answer'];

  @override
  List<Object> get props => [firstSide, secondSide, learnMore];
}
