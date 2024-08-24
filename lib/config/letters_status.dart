enum LettersStatus {
  initial,
  yellow,
  green,
  notInWord,
}

Map<String, LettersStatus> letterStatus = {
  // First Row
  'Q': LettersStatus.initial,
  'W': LettersStatus.initial,
  'E': LettersStatus.initial,
  'R': LettersStatus.initial,
  'T': LettersStatus.initial,
  'Y': LettersStatus.initial,
  'U': LettersStatus.initial,
  'I': LettersStatus.initial,
  'O': LettersStatus.initial,
  'P': LettersStatus.initial,
  // Second Row
  'A': LettersStatus.initial,
  'S': LettersStatus.initial,
  'D': LettersStatus.initial,
  'F': LettersStatus.initial,
  'G': LettersStatus.initial,
  'H': LettersStatus.initial,
  'J': LettersStatus.initial,
  'K': LettersStatus.initial,
  'L': LettersStatus.initial,
  // Third Row
  'ENTER': LettersStatus.initial,
  'Z': LettersStatus.initial,
  'X': LettersStatus.initial,
  'C': LettersStatus.initial,
  'V': LettersStatus.initial,
  'B': LettersStatus.initial,
  'N': LettersStatus.initial,
  'M': LettersStatus.initial,
  'DELETE': LettersStatus.initial,
};
