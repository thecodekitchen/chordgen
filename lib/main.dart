import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flython Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flython Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String intention = 'enter your intention';
  String _chords = '';
  TextEditingController intentionController = TextEditingController();
  String mode = 'Major';
  TextEditingController i = TextEditingController();
  TextEditingController ii = TextEditingController();
  TextEditingController iii = TextEditingController();
  TextEditingController iv = TextEditingController();
  TextEditingController v = TextEditingController();
  TextEditingController vi = TextEditingController();
  TextEditingController vii = TextEditingController();
  List<DropdownMenuEntry<String>> modes = [
    const DropdownMenuEntry<String>(value: 'Major', label: 'Major'),
    const DropdownMenuEntry<String>(value: 'Minor', label: 'Minor'),
    const DropdownMenuEntry<String>(value: 'Dorian', label: 'Dorian'),
    const DropdownMenuEntry<String>(value: 'Mixolydian', label: 'Mixolydian'),
    const DropdownMenuEntry<String>(value: 'Custom', label: 'Custom'),
  ];
  final List<String> majorChords = ['C', 'Dm', 'Em', 'F', 'G', 'Am', 'Bdim7'];
  final List<String> minorChords = ['Am', 'Bdim7', 'C', 'Dm', 'Em', 'F', 'G'];
  final List<String> mixolydianChords = [
    'G',
    'Am',
    'Bdim7',
    'C',
    'Dm',
    'Em',
    'F'
  ];
  final List<String> dorianChords = ['Dm', 'Em', 'F', 'G', 'Am', 'Bdim7', 'C'];
  final map = {
    'a': 1,
    'b': 2,
    'c': 3,
    'd': 4,
    'e': 5,
    'f': 6,
    'g': 7,
    'h': 1,
    'i': 2,
    'j': 3,
    'k': 4,
    'l': 5,
    'm': 6,
    'n': 7,
    'o': 1,
    'p': 2,
    'q': 3,
    'r': 4,
    's': 5,
    't': 6,
    'u': 7,
    'v': 1,
    'w': 2,
    'x': 3,
    'y': 4,
    'z': 5
  };
  String sanitizeIntention() {
    return intention.replaceAll(' ', '').toLowerCase();
  }

  List<String> removeRepeats(List<String> strings) {
    Set<String> chars = {};
    List<String> output = [];
    for (String s in strings) {
      for (int i = 0; i < s.length; i++) {
        final char = s[i];
        if (!chars.contains(char)) {
          chars.add(char);
          output.add(char);
        }
        if (output.length == 16) {
          return output;
        }
      }
    }
    return output;
  }

  List<int> convertToScaleDegrees(List<String> charArray) {
    List<int> ints = [];
    for (String char in charArray) {
      ints.add(map[char] ?? 0);
    }
    if (ints.contains(0)) {
      setState(() {
        _chords =
            'invalid character entered. Please only enter alphabetical characters';
      });
    }
    return ints;
  }

  void getChords() async {
    String sanitized = sanitizeIntention();
    List<String> charArray = sanitized.split('');
    if (charArray.length < 16) {
      setState(() {
        _chords = 'Please elaborate. Use more words.';
      });
    }
    if (charArray.length > 16) {
      charArray = removeRepeats(charArray);
    }
    List<int> scaleDegreeArray = convertToScaleDegrees(charArray);
    List<List<int>> chordArrays = [];
    for (int i = 0; i < scaleDegreeArray.length; i += 4) {
      chordArrays.add(scaleDegreeArray.sublist(i, i + 4));
    }
    List<int> scaleDegrees = [];
    for (List<int> chunk in chordArrays) {
      double sum = 0;
      for (int value in chunk) {
        sum += value;
      }
      double average = sum / chunk.length;
      scaleDegrees.add(average.round());
    }
    List<String> chords = [];
    switch (mode) {
      case 'Major':
        {
          for (int degree in scaleDegrees) {
            chords.add(majorChords[degree - 1]);
          }
        }
        break;
      case 'Minor':
        {
          for (int degree in scaleDegrees) {
            chords.add(minorChords[degree - 1]);
          }
        }
        break;
      case 'Mixolydian':
        {
          for (int degree in scaleDegrees) {
            chords.add(mixolydianChords[degree - 1]);
          }
        }
        break;
      case 'Dorian':
        {
          for (int degree in scaleDegrees) {
            chords.add(dorianChords[degree - 1]);
          }
        }
        break;
      case 'Custom':
        {
          List<String> customChords = [
            i.text,
            ii.text,
            iii.text,
            iv.text,
            v.text,
            vi.text,
            vii.text
          ];

          for (int degree in scaleDegrees) {
            chords.add(customChords[degree - 1]);
          }
        }
        break;
      default:
        setState(() {
          _chords = 'invalid mode';
        });
        return;
    }
    String chordString = chords.join(', ');
    setState(() {
      _chords = chordString;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text(widget.title),
      ),
      body: Center(
        child: SizedBox(
          width: 500,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            TextField(
                controller: intentionController,
                onChanged: (text) => {setState(() => intention = text)},
                decoration: const InputDecoration(hintText: 'Enter your name')),
            DropdownMenu<String>(
                onSelected: (item) {
                  setState(() {
                    mode = item ?? 'Major';
                  });
                },
                dropdownMenuEntries: modes,
                initialSelection: 'Major'),
            mode == 'Custom'
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                        TextField(
                            controller: i,
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(hintText: 'I')),
                        TextField(
                            controller: ii,
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(hintText: 'II')),
                        TextField(
                            controller: iii,
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(hintText: 'III')),
                        TextField(
                            controller: iv,
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(hintText: 'IV')),
                        TextField(
                            controller: v,
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(hintText: 'V')),
                        TextField(
                            controller: vi,
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(hintText: 'VI')),
                        TextField(
                            controller: vii,
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(hintText: 'VII')),
                      ])
                : const SizedBox(height: 10),
            FloatingActionButton(
              onPressed: getChords,
              backgroundColor: Colors.indigo,
              child: const Text('Get Chords'),
            ),
            Text(_chords)
          ]),
        ),
      ),
    );
  }
}
