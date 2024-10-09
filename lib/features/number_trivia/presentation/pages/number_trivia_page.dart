import 'package:clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NumberTriviaPage extends StatefulWidget {
  const NumberTriviaPage({super.key});

  @override
  State<NumberTriviaPage> createState() => _NumberTriviaPageState();
}

class _NumberTriviaPageState extends State<NumberTriviaPage> {
  TextEditingController textEditingController = TextEditingController();
  String inputStr = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Number trivia"),
        ),
        body: buildBody(context));
  }

  Widget buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22.0),
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
            builder: (context, state) {
              if (state is Empty) {
                return const MessageDisplay(message: "Start Searching !");
              } else if (state is Error) {
                return MessageDisplay(message: state.message);
              } else if (state is Loaded) {
                return TriviaDisplay(
                  numberTrivia: state.trivia,
                );
              } else if (state is Loading) {
                return const LoadingWidget();
              }
              return const SizedBox();
            },
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: textEditingController,
            decoration: const InputDecoration(hintText: "Input a number "),
            onChanged: (value) {
              setState(() {
                inputStr = value;
              });
            },
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                  child: ElevatedButton(
                onPressed: () {
                  addConcrete();
                },
                child: const Text("Search"),
              )),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                  child: ElevatedButton(
                onPressed: () {
                  addRandom();
                },
                child: const Text("Random"),
              ))
            ],
          )
        ],
      ),
    );
  }

  void addConcrete() {
    textEditingController.clear();
    BlocProvider.of<NumberTriviaBloc>(context)
        .add(GetTriviaForConcreteNumber(inputStr));
  }

  void addRandom() {
    textEditingController.clear();
    BlocProvider.of<NumberTriviaBloc>(context).add(GetTriviaForRandomNumber());
  }
}

class MessageDisplay extends StatelessWidget {
  final String message;
  const MessageDisplay({required this.message, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 3,
      child: Center(child: SingleChildScrollView(child: Text(message))),
    );
  }
}

class TriviaDisplay extends StatelessWidget {
  final NumberTrivia numberTrivia;
  const TriviaDisplay({required this.numberTrivia, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 3,
      child: Column(
        children: [
          Text(numberTrivia.number),
          Expanded(
              child: Center(
                  child:
                      SingleChildScrollView(child: Text(numberTrivia.text)))),
        ],
      ),
    );
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 3,
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}
