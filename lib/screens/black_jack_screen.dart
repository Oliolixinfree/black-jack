import 'dart:math';

import 'package:black_jack/widgets/my_button.dart';
import 'package:flutter/material.dart';

import '../widgets/cards_grid_view.dart';

class BlackJackScreen extends StatefulWidget {
  const BlackJackScreen({super.key});

  @override
  State<BlackJackScreen> createState() => _BlackJackScreenState();
}

class _BlackJackScreenState extends State<BlackJackScreen> {
  bool isGameStarted = false;

  List<Image> myCards = [];
  List<Image> dealersCards = [];

  String? playerFirstCard;
  String? playerSecondCard;

  String? dealersFirstCard;
  String? dealersSecondCard;

  int playerScore = 0;
  int dealerScore = 0;

  bool winnerDealer = false;
  bool winnerPlayer = false;
  bool isDraw = false;

  String isWinner = '';
  bool isStand = false;

  bool isShowScore = false;

  final Map<String, int> deckOfCards = {
    "cards/2.1.png": 2,
    "cards/2.2.png": 2,
    "cards/2.3.png": 2,
    "cards/2.4.png": 2,
    "cards/3.1.png": 3,
    "cards/3.2.png": 3,
    "cards/3.3.png": 3,
    "cards/3.4.png": 3,
    "cards/4.1.png": 4,
    "cards/4.2.png": 4,
    "cards/4.3.png": 4,
    "cards/4.4.png": 4,
    "cards/5.1.png": 5,
    "cards/5.2.png": 5,
    "cards/5.3.png": 5,
    "cards/5.4.png": 5,
    "cards/6.1.png": 6,
    "cards/6.2.png": 6,
    "cards/6.3.png": 6,
    "cards/6.4.png": 6,
    "cards/7.1.png": 7,
    "cards/7.2.png": 7,
    "cards/7.3.png": 7,
    "cards/7.4.png": 7,
    "cards/8.1.png": 8,
    "cards/8.2.png": 8,
    "cards/8.3.png": 8,
    "cards/8.4.png": 8,
    "cards/9.1.png": 9,
    "cards/9.2.png": 9,
    "cards/9.3.png": 9,
    "cards/9.4.png": 9,
    "cards/10.1.png": 10,
    "cards/10.2.png": 10,
    "cards/10.3.png": 10,
    "cards/10.4.png": 10,
    "cards/J1.png": 10,
    "cards/J2.png": 10,
    "cards/J3.png": 10,
    "cards/J4.png": 10,
    "cards/Q1.png": 10,
    "cards/Q2.png": 10,
    "cards/Q3.png": 10,
    "cards/Q4.png": 10,
    "cards/K1.png": 10,
    "cards/K2.png": 10,
    "cards/K3.png": 10,
    "cards/K4.png": 10,
    "cards/A1.png": 11,
    "cards/A2.png": 11,
    "cards/A3.png": 11,
    "cards/A4.png": 11,
  };

  Map<String, int> playingCards = {};

  @override
  void initState() {
    super.initState();

    playingCards.addAll(deckOfCards);
  }

  void changeCards() {
    setState(() {
      isGameStarted = true;
      winnerDealer = false;
      winnerPlayer = false;
      isDraw = false;
      isWinner = '';
      isStand = false;
    });

    playingCards = {};

    playingCards.addAll(deckOfCards);

    myCards = [];
    dealersCards = [];

    Random random = Random();

    String cardOneKey =
        playingCards.keys.elementAt(random.nextInt(playingCards.length));
    // Making sure cards are unique and remove cardOneKey from playingCards
    playingCards.removeWhere((key, value) => key == cardOneKey);

    String cardTwoKey =
        playingCards.keys.elementAt(random.nextInt(playingCards.length));
    playingCards.removeWhere((key, value) => key == cardTwoKey);

    String cardThreeKey =
        playingCards.keys.elementAt(random.nextInt(playingCards.length));
    playingCards.removeWhere((key, value) => key == cardThreeKey);

    String cardFourKey =
        playingCards.keys.elementAt(random.nextInt(playingCards.length));
    playingCards.removeWhere((key, value) => key == cardFourKey);

    dealersFirstCard = cardOneKey;
    dealersSecondCard = cardTwoKey;

    playerFirstCard = cardThreeKey;
    playerSecondCard = cardFourKey;

    dealersCards.add(Image.asset(dealersFirstCard!));
    dealersCards.add(Image.asset(dealersSecondCard!));

    dealerScore =
        deckOfCards[dealersFirstCard]! + deckOfCards[dealersSecondCard]!;

    myCards.add(Image.asset(playerFirstCard!));
    myCards.add(Image.asset(playerSecondCard!));

    playerScore =
        deckOfCards[playerFirstCard]! + deckOfCards[playerSecondCard]!;

    // IS WORK
    if (playerScore == 21) {
      isWinner = 'Player';
      winnerPlayer = true;
      showAlertDialog();
    }
    // else if (dealerScore == 21) {
    //   isWinner = 'Dealer';
    //   winnerDealer = true;
    // }
  }

  void stand() {
    Random random = Random();

    while (dealerScore < 17) {
      String thirdDealersCardKey =
          playingCards.keys.elementAt(random.nextInt(playingCards.length));
      playingCards.removeWhere((key, value) => key == thirdDealersCardKey);

      dealersCards.add(Image.asset(thirdDealersCardKey));

      dealerScore = dealerScore + deckOfCards[thirdDealersCardKey]!;
    }

    if (dealerScore == 21) {
      isWinner = 'Dealer';
      winnerDealer = true;
    } else if (playerScore == dealerScore) {
      isDraw = true;
    }

    if (dealerScore > 21) {
      isWinner = 'Player';
      winnerPlayer = true;
    }

    if (playerScore < 22 && dealerScore < 22 && dealerScore < playerScore) {
      isWinner = 'Player';
      winnerPlayer = true;
    } else if (dealerScore < 22 &&
        playerScore < 22 &&
        playerScore < dealerScore) {
      isWinner = 'Dealer';
      winnerDealer = true;
    }

    setState(() {
      isStand = !isStand;
      isWinner;
    });
  }

  void addCard() {
    Random random = Random();

    if (playingCards.length > 0) {
      String cardKey =
          playingCards.keys.elementAt(random.nextInt(playingCards.length));

      playingCards.removeWhere((key, value) => key == cardKey);

      setState(() {
        myCards.add(Image.asset(cardKey));
      });

      playerScore = playerScore + deckOfCards[cardKey]!;
    }

    if (playerScore > 21) {
      isStand = !isStand;
      isWinner = 'Dealer';
      winnerDealer = true;
    }

    if (dealerScore > 21) {
      isWinner = 'Player';
      winnerPlayer = true;
    }

    if (playerScore == 21) {
      isWinner = 'Player';
      winnerPlayer = true;
      showAlertDialog();
      stand();
    }
  }

  void showAlertDialog() {
    showDialog(
        context: context,
        builder: (context) {
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.of(context).pop(true);
          });
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.local_fire_department,
                  color: Color.fromARGB(210, 201, 43, 11),
                ),
                const Icon(
                  Icons.local_fire_department,
                  color: Color.fromARGB(210, 201, 43, 11),
                ),
                const Icon(
                  Icons.local_fire_department,
                  color: Color.fromARGB(210, 201, 43, 11),
                ),
                Text(
                  '$playerScore',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const Icon(
                  Icons.local_fire_department,
                  color: Color.fromARGB(210, 201, 43, 11),
                ),
                const Icon(
                  Icons.local_fire_department,
                  color: Color.fromARGB(210, 201, 43, 11),
                ),
                const Icon(
                  Icons.local_fire_department,
                  color: Color.fromARGB(210, 201, 43, 11),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
          child: SafeArea(
        child: Column(
          children: [
            CheckboxListTile(
              title: const Text('Show Score'),
              activeColor: Colors.deepPurple[200],
              value: isShowScore,
              onChanged: (bool? value) {
                setState(() {
                  isShowScore = value!;
                });
              },
            ),
          ],
        ),
      )),
      appBar: AppBar(
        title: const Text('Black Jack'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple[200],
      ),
      body: isGameStarted
          ? SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // dealer cards
                    Column(
                      children: [
                        Text(
                          'Dealer score $dealerScore',
                          style: TextStyle(
                            color: dealerScore <= 21
                                ? Colors.green[900]
                                : Colors.red[900],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Stack(children: [
                          CardsGridView(cards: dealersCards),
                          isStand
                              ? Container()
                              : Positioned(
                                  width: 85,
                                  height: 200,
                                  left: 155,
                                  bottom: 35,
                                  child: Image.asset('cards/shirt.png'),
                                ),
                        ]),
                      ],
                    ),
                    Center(
                      child: isDraw
                          ? const Text('DRAW')
                          : winnerDealer || winnerPlayer
                              ? Text('The Winner is $isWinner')
                              : Container(),
                    ),
                    // Center(
                    //   child: Text('$isStand'),
                    // ),
                    // player cards
                    Column(
                      children: [
                        isShowScore
                            ? Text(
                                'Player score $playerScore',
                                style: TextStyle(
                                  color: playerScore <= 21
                                      ? Colors.green[900]
                                      : Colors.red[900],
                                ),
                              )
                            : Container(),
                        const SizedBox(
                          height: 20,
                        ),
                        CardsGridView(cards: myCards),
                      ],
                    ),
                    // 2 buttons
                    IntrinsicWidth(
                      child: Column(
                        // mainAxisSize: MainAxisSize.min,
                        // crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: winnerDealer || winnerPlayer || isDraw
                                ? [Container()]
                                : [
                                    MyButton(
                                      onPressed: addCard,
                                      label: 'Hit',
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    MyButton(
                                      onPressed: stand,
                                      label: 'Stand',
                                    ),
                                  ],
                          ),
                          winnerDealer || winnerPlayer || isDraw
                              ? MyButton(
                                  onPressed: changeCards, label: 'Next Round')
                              : Container(),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          : Center(
              child: MyButton(
                onPressed: () => changeCards(),
                label: 'Start Game',
              ),
            ),
    );
  }
}
