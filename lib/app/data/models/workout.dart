
class Workout {
  final String id;
  final String name;
  final String bodyPart;
  final String animationPath;
  final List<AudioPhrase> phrases;

  Workout({
    required this.id,
    required this.name,
    required this.bodyPart,
    required this.animationPath,
    required this.phrases,
  });
}

class AudioPhrase {
  final String audioPathEn;
  final String audioPathJp;
  final String englishText;
  final String japaneseText;

  AudioPhrase({
    required this.audioPathEn,
    required this.audioPathJp,
    required this.englishText,
    required this.japaneseText,
  });
}
