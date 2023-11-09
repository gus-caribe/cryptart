
import 'package:cool_alert/cool_alert.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class Encrypter extends StatefulWidget {
  const Encrypter({super.key});

  @override
  State<Encrypter> createState() => _EncrypterState();
}

class _EncrypterState extends State<Encrypter> {
  final _inputController = TextEditingController();
  final _outputController = TextEditingController();
  final FocusNode _inputFocusNode = FocusNode();
  final FocusNode _outputFocusNode = FocusNode();
  final String _caesarSeed = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";

  void _onInputFocusChange() => setState(() {
    _outputFocusNode.unfocus();
  });

  void _onOutputFocusChange() => setState(() {
    _inputFocusNode.unfocus();
  });

  void _grabFileContent() async {
    if(_inputController.text.isNotEmpty) {
      bool canceled = false;

      await CoolAlert.show(
        context: context,
        type: CoolAlertType.confirm,
        width: MediaQuery.sizeOf(context).width > 700
        ? 300 : null,
        showCancelBtn: true,
        title: "Do you want to discard the current content?",
        onConfirmBtnTap: () {},
        cancelBtnTextStyle: const TextStyle(color: Colors.blue),
        onCancelBtnTap: () => canceled = true,
      );

      if(canceled) {
        return;
      }
    }

    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      _inputController.text = String.fromCharCodes(
        result.files.single.bytes ?? []
      );
    }
  }

  void _encrypt() async {
    String result = "";

    for(String character in _inputController.text.characters) {
      bool isLowerCase = character == character.toLowerCase();
      int index = _caesarSeed.indexOf(character.toUpperCase());

      if(index != -1) {
        if(index > 22) {
          character = _caesarSeed[index - 23]; 
        } else {
          character = _caesarSeed[index + 3];
        }

        if(isLowerCase) {
          character = character.toLowerCase();
        }
      }

      result += character;
    }

    _outputController.text = result;
  }

  void _decrypt() async {
    String result = "";

    for(String character in _inputController.text.characters) {
      bool isLowerCase = character == character.toLowerCase();
      int index = _caesarSeed.indexOf(character.toUpperCase());

      if(index != -1) {
        if(index < 3) {
          character = _caesarSeed[index + 23];
        } else {
          character = _caesarSeed[index - 3];
        }

        if(isLowerCase) {
          character = character.toLowerCase();
        }
      }

      result += character;
    }

    _outputController.text = result;
  }

  @override
  void initState() {
    super.initState();
    _inputFocusNode.addListener(_onInputFocusChange);
    _outputFocusNode.addListener(_onOutputFocusChange);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.blue.shade200,
    body: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        constraints: const BoxConstraints(minWidth: 400),
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            30, 
            MediaQuery.sizeOf(context).height * 0.07, 
            30, 
            MediaQuery.sizeOf(context).height / 2
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Case Sensitive Caesar Cypher",
                style: TextStyle(
                  color: Colors.blue.shade900,
                  fontWeight: FontWeight.bold,
                  fontSize: 22
                ),
              ),
              Text(
                "Input Text",
                style: TextStyle(
                  color: Colors.blueAccent.shade700,
                  fontWeight: FontWeight.bold,
                  fontSize: 20
                ),
              ),
              Container(
                height: MediaQuery.sizeOf(context).height * 0.3,
                constraints: const BoxConstraints(maxWidth: 700),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: _inputFocusNode.hasFocus
                  ? Border.all(
                    color: Colors.blue.shade800,
                    width: 2
                  )
                  : null,
                ),
                padding: const EdgeInsets.all(10),
                margin: EdgeInsets.only(
                  top: MediaQuery.sizeOf(context).height * 0.025,
                  bottom: MediaQuery.sizeOf(context).height * 0.025,
                ),
                child: TextField(
                  controller: _inputController,
                  focusNode: _inputFocusNode,
                  maxLines: null,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none
                    )
                  ),
                ),
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 700),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox.shrink(),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextButton.icon(
                          onPressed: _encrypt, 
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white
                          ),
                          icon: const Icon(Icons.lock_rounded), 
                          label: const Text("Encrypt")
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Icon(Icons.arrow_downward_rounded),
                        ),
                        TextButton.icon(
                          onPressed: _decrypt, 
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.blue
                          ),
                          icon: const Icon(Icons.lock_open_rounded), 
                          label: const Text("Decrypt")
                        ),
                      ],
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: IconButton(
                        onPressed: _grabFileContent, 
                        icon: const Icon(Icons.attach_file_rounded)
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.sizeOf(context).height * 0.025,
                ),
                child: Text(
                  "Output Text",
                  style: TextStyle(
                    color: Colors.blueAccent.shade700,
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                  ),
                ),
              ),
              Container(
                height: MediaQuery.sizeOf(context).height * 0.3,
                constraints: const BoxConstraints(maxWidth: 700),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: _outputFocusNode.hasFocus
                  ? Border.all(
                    color: Colors.blue.shade800,
                    width:2
                  )
                  : null,
                ),
                padding: const EdgeInsets.all(10),
                margin: EdgeInsets.only(
                  top: MediaQuery.sizeOf(context).height * 0.025,
                ),
                child: TextField(
                  controller: _outputController,
                  focusNode: _outputFocusNode,
                  readOnly: true,
                  maxLines: null,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none
                    )
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  @override
  void dispose() {
    super.dispose();
    _inputFocusNode.removeListener(_onInputFocusChange);
    _inputFocusNode.dispose();
    _outputFocusNode.removeListener(_onOutputFocusChange);
    _outputFocusNode.dispose();
  }
}