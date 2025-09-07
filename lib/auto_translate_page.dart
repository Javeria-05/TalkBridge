import 'package:flutter/material.dart';
import 'package:translator/translator.dart';

class AutoTranslatePage extends StatefulWidget {
  const AutoTranslatePage({Key? key}) : super(key: key);

  @override
  _AutoTranslatePageState createState() => _AutoTranslatePageState();
}

class _AutoTranslatePageState extends State<AutoTranslatePage> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final translator = GoogleTranslator();

  String translatedText = "";
  String? targetLang = "ur"; // Default Urdu
  List<Map<String, String>> filteredLanguages = [];

  // Simplified languages list (add all 100+ languages)
  final List<Map<String, String>> languages = [
    { "id": "af", "name": "Afrikaans", "code": "af" }, 
    { "id": "sq", "name": "Albanian", "code": "sq" }, 
    { "id": "am", "name": "Amharic", "code": "am" }, 
    { "id": "ar", "name": "Arabic", "code": "ar" }, 
    { "id": "hy", "name": "Armenian", "code": "hy" }, 
    { "id": "az", "name": "Azerbaijani", "code": "az" }, 
    { "id": "eu", "name": "Basque", "code": "eu" }, 
    { "id": "be", "name": "Belarusian", "code": "be" }, 
    { "id": "bn", "name": "Bengali", "code": "bn" }, 
    { "id": "bs", "name": "Bosnian", "code": "bs" }, 
    { "id": "bg", "name": "Bulgarian", "code": "bg" }, 
    { "id": "ca", "name": "Catalan", "code": "ca" }, 
    { "id": "ceb", "name": "Cebuano", "code": "ceb" }, 
    { "id": "zh-CN", "name": "Chinese (Simplified)", "code": "zh-CN" }, 
    { "id": "zh-TW", "name": "Chinese (Traditional)", "code": "zh-TW" }, 
    { "id": "co", "name": "Corsican", "code": "co" }, 
    { "id": "hr", "name": "Croatian", "code": "hr" }, 
    { "id": "cs", "name": "Czech", "code": "cs" }, 
    { "id": "da", "name": "Danish", "code": "da" }, 
    { "id": "nl", "name": "Dutch", "code": "nl" }, 
    { "id": "en", "name": "English", "code": "en" }, 
    { "id": "eo", "name": "Esperanto", "code": "eo" }, 
    { "id": "et", "name": "Estonian", "code": "et" }, 
    { "id": "fi", "name": "Finnish", "code": "fi" }, 
    { "id": "fr", "name": "French", "code": "fr" }, 
    { "id": "fy", "name": "Frisian", "code": "fy" }, 
    { "id": "gl", "name": "Galician", "code": "gl" }, 
    { "id": "ka", "name": "Georgian", "code": "ka" }, 
    { "id": "de", "name": "German", "code": "de" }, 
    { "id": "el", "name": "Greek", "code": "el" }, 
    { "id": "gu", "name": "Gujarati", "code": "gu" }, 
    { "id": "ht", "name": "Haitian Creole", "code": "ht" }, 
    { "id": "ha", "name": "Hausa", "code": "ha" }, 
    { "id": "haw", "name": "Hawaiian", "code": "haw" }, 
    { "id": "he", "name": "Hebrew", "code": "he" }, 
    { "id": "hi", "name": "Hindi", "code": "hi" }, 
    { "id": "hmn", "name": "Hmong", "code": "hmn" }, 
    { "id": "hu", "name": "Hungarian", "code": "hu" }, 
    { "id": "is", "name": "Icelandic", "code": "is" }, 
    { "id": "ig", "name": "Igbo", "code": "ig" }, 
    { "id": "id", "name": "Indonesian", "code": "id" }, 
    { "id": "ga", "name": "Irish", "code": "ga" }, 
    { "id": "it", "name": "Italian", "code": "it" }, 
    { "id": "ja", "name": "Japanese", "code": "ja" }, 
    { "id": "jv", "name": "Javanese", "code": "jv" }, 
    { "id": "kn", "name": "Kannada", "code": "kn" }, 
    { "id": "kk", "name": "Kazakh", "code": "kk" }, 
    { "id": "km", "name": "Khmer", "code": "km" }, 
    { "id": "rw", "name": "Kinyarwanda", "code": "rw" }, 
    { "id": "ko", "name": "Korean", "code": "ko" }, 
    { "id": "ku", "name": "Kurdish", "code": "ku" }, 
    { "id": "ky", "name": "Kyrgyz", "code": "ky" }, 
    { "id": "lo", "name": "Lao", "code": "lo" }, 
    { "id": "la", "name": "Latin", "code": "la" }, 
    { "id": "lv", "name": "Latvian", "code": "lv" }, 
    { "id": "lt", "name": "Lithuanian", "code": "lt" }, 
    { "id": "lb", "name": "Luxembourgish", "code": "lb" }, 
    { "id": "mk", "name": "Macedonian", "code": "mk" }, 
    { "id": "mg", "name": "Malagasy", "code": "mg" }, 
    { "id": "ms", "name": "Malay", "code": "ms" }, 
    { "id": "ml", "name": "Malayalam", "code": "ml" }, 
    { "id": "mt", "name": "Maltese", "code": "mt" }, 
    { "id": "mi", "name": "Maori", "code": "mi" }, 
    { "id": "mr", "name": "Marathi", "code": "mr" }, 
    { "id": "mn", "name": "Mongolian", "code": "mn" }, 
    { "id": "my", "name": "Myanmar (Burmese)", "code": "my" }, 
    { "id": "ne", "name": "Nepali", "code": "ne" }, 
    { "id": "no", "name": "Norwegian", "code": "no" }, 
    { "id": "ny", "name": "Nyanja (Chichewa)", "code": "ny" }, 
    { "id": "or", "name": "Odia (Oriya)", "code": "or" }, 
    { "id": "ps", "name": "Pashto", "code": "ps" }, 
    { "id": "fa", "name": "Persian", "code": "fa" }, 
    { "id": "pl", "name": "Polish", "code": "pl" }, 
    { "id": "pt", "name": "Portuguese", "code": "pt" }, 
    { "id": "pa", "name": "Punjabi", "code": "pa" }, 
    { "id": "ro", "name": "Romanian", "code": "ro" }, 
    { "id": "ru", "name": "Russian", "code": "ru" }, 
    { "id": "sm", "name": "Samoan", "code": "sm" }, 
    { "id": "gd", "name": "Scots Gaelic", "code": "gd" }, 
    { "id": "sr", "name": "Serbian", "code": "sr" }, 
    { "id": "st", "name": "Sesotho", "code": "st" }, 
    { "id": "sn", "name": "Shona", "code": "sn" }, 
    { "id": "sd", "name": "Sindhi", "code": "sd" }, 
    { "id": "si", "name": "Sinhala (Sinhalese)", "code": "si" }, 
    { "id": "sk", "name": "Slovak", "code": "sk" }, 
    { "id": "sl", "name": "Slovenian", "code": "sl" }, 
    { "id": "so", "name": "Somali", "code": "so" }, 
    { "id": "es", "name": "Spanish", "code": "es" }, 
    { "id": "su", "name": "Sundanese", "code": "su" }, 
    { "id": "sw", "name": "Swahili", "code": "sw" }, 
    { "id": "sv", "name": "Swedish", "code": "sv" }, 
    { "id": "tl", "name": "Tagalog (Filipino)", "code": "tl" }, 
    { "id": "tg", "name": "Tajik", "code": "tg" }, 
    { "id": "ta", "name": "Tamil", "code": "ta" }, 
    { "id": "tt", "name": "Tatar", "code": "tt" }, 
    { "id": "te", "name": "Telugu", "code": "te" }, 
    { "id": "th", "name": "Thai", "code": "th" }, 
    { "id": "tr", "name": "Turkish", "code": "tr" }, 
    { "id": "tk", "name": "Turkmen", "code": "tk" }, 
    { "id": "uk", "name": "Ukrainian", "code": "uk" }, 
    { "id": "ur", "name": "Urdu", "code": "ur" }, 
    { "id": "ug", "name": "Uyghur", "code": "ug" }, 
    { "id": "uz", "name": "Uzbek", "code": "uz" }, 
    { "id": "vi", "name": "Vietnamese", "code": "vi" }, 
    { "id": "cy", "name": "Welsh", "code": "cy" }, 
    { "id": "xh", "name": "Xhosa", "code": "xh" }, 
    { "id": "yi", "name": "Yiddish", "code": "yi" }, 
    { "id": "yo", "name": "Yoruba", "code": "yo" }, 
    { "id": "zu", "name": "Zulu", "code": "zu" },
  ];

  @override
  void initState() {
    super.initState();
    filteredLanguages = List.from(languages);
  }

  void filterLanguages(String query) {
    setState(() {
      filteredLanguages = languages
          .where((lang) =>
              lang['name']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Future<void> translateText() async {
    if (_controller.text.isEmpty || targetLang == null) return;

    final translation =
        await translator.translate(_controller.text, to: targetLang!);

    setState(() {
      translatedText = translation.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Auto Translate", style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.grey[900],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Input box
            TextField(
              controller: _controller,
              maxLength: 600, // ~100 words
              maxLines: 4,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Type your text here...",
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 10),

           // Dropdown for language selection
            DropdownButton<String>(
              value: targetLang,
              dropdownColor: Colors.grey[900],
              style: const TextStyle(color: Colors.white),
              items: languages.map((lang) {
                return DropdownMenuItem<String>(
                  value: lang['code'],
                  child: Text(lang['name']!),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  targetLang = value!;
                });
              },
            ),

            const SizedBox(height: 20),

            // Translate button
            ElevatedButton(
              onPressed: translateText,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: const Text(
                "Translate",
                style: TextStyle(fontSize: 18),
              ),
            ),

            const SizedBox(height: 20),

            // Output box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                translatedText,
                style: const TextStyle(
                  color: Colors.greenAccent,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}