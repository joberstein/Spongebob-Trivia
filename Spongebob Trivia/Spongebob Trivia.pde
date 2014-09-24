/*
Jesse Oberstein
Spongebob Trivia
*/

// The XML for the quiz.
XML quizgame;
// An array of XML objects containing the questions of the quiz.
XML[] questionsXML;
// An array of strings containing the questions of the quiz.
String[] questions;
// An array of an array of XML objects containing the options
// for each question of the quiz.
XML[][] optionsXML;
// An image to be displayed on either the main page or for
// each question of the quiz.
PImage sbimage;
// The current index of each question.
int current;
// The current score of the player.
int score;
// A value used to count up the score on screen.
int countscore;
// The variable for the Avenir font.
PFont avenir;
// The variable for the bold Avenir Next font.
PFont avenirblack;
// The variable for the Rockwell font.
PFont rockwell;
// The variable for the Lucidia Calligraphy font.
PFont callig;
// Counts the total number of times keys have been pressed.
int typed;
// The time of the quiz that has passed, in 30 frames per second.
int time;
// Counts down per second the amount of time that has passed.
int timer;

// Sets the fps to 30, other variables to base values, 
// and sets up the questions and options for the quiz.
void setup() {
  size(1000, 500);
  frameRate(30);
  quizgame = loadXML("TriviaText.xml");
  questionsXML = quizgame.getChildren("quest");
  optionsXML = new XML[questionsXML.length][];
  time = 600;
  timer = 200;
  score = 0;
  countscore = 0;
  current = -1;
  typed = -1;
  setupQuestions();
  setupOptions();
  background(255);
  rockwell = loadFont("Rockwell-48.vlw");
  avenir = loadFont("Avenir-Black-48.vlw");
  avenirblack = loadFont("AvenirNext-Bold-48.vlw");
  callig = loadFont("LucidaCalligraphy-Italic-48.vlw");
}

// The starting page of the quiz.  The timer has not started.
void startPage() {
  background(#FFFF89);
  fill(0);
  textFont(callig, 41);
  text("Welcome to Spongebob Squarepants Trivia!", 20, 60);
  
  fill(#000000);
  textFont(callig, 20);
  text("Press any key to start the game", 325, 90);
  
  fill(#5CD0FC);
  noStroke();
  rect(-1, 330, width + 1, 35);
  fill(0);
  textFont(callig, 20);
  text("Answer each question with either 'a', 'b', " 
    + "'c', or 'd'. as quick as you can.", 120, 355);

  fill(#FF95A2);
  noStroke();
  rect(-1, 375, width + 1, 35);
  fill(0);
  textFont(callig, 20);
  text("After receiving feedback, press any "
    + "key to go to the next question.", 140, 400);

  fill(#E3A16E);
  noStroke();
  rect(-1, 420, width + 1, 35);
  fill(0);
  textFont(callig, 20);
  text("A correct answer to a question will " 
    + "earn you 10 points.", 200, 445);

  fill(#FA3A40);
  noStroke();
  rect(-1, 465, width + 1, 35);
  fill(255);
  textFont(callig, 20);
  text("Press the 'r' key to restart the quiz at anytime.", 250, 490);

  sbimage = loadImage("spongebobchars.jpg");
  sbimage.resize(500, 220);
  image(sbimage, 250, 100);

  current = -1;
  typed = -1;
}

// Sets up each question.  
// Creates an array of strings containing the questions.
void setupQuestions() {
  questions = new String[questionsXML.length];
  for (int i = 0; i < questionsXML.length; i++) {
    questions[i] = questionsXML[i].getChild("words").getContent();
  }
}

// Sets up the options for each question. 
// Creates an array of an array of XML objects for each question.
void setupOptions() {
  for (int i = 0; i < questionsXML.length; i++) {
    optionsXML[i] = questionsXML[i].getChildren("opt");
  }
}

// Displays each question.
void displayQuestion() {
  fill(#CE0007);
  textFont(avenirblack, 19);
  text((questionsXML[current].getInt("id") + 1)
    + ". "
    + questions[current], 30, 50);
}

// Displays the options for each.
void displayOptions() {
  textFont(avenir, 20);
  for (int i = 0; i < optionsXML[current].length; i++) {
    fill(#000000);
    text(optionsXML[current][i].getString("id") 
      + ") " 
      + optionsXML[current][i].getContent(), 50, 120 + 80 * i);
  }
}

// Displays the image for each question.
void displayImage() {
  sbimage = loadImage(questionsXML[current].getString("img"));
  sbimage.resize(250, 200);
  image(sbimage, 730, 150);
}

// Displays the player's score.
void displayScore() {
  noFill();
  stroke(0);
  rect(890, 25, 40, 40);
  text(score, 900, 50);
}

// Displays the current question, its options, the player's
// score, and the question's image on a blue background.
void display() { 
  background(#5CD0FC);
  displayQuestion();
  displayOptions();
  displayScore();
  displayImage();
}

// Shows the timer as a not filled bar, that gradually fills
// with red after each second (30 fps) passes.  The timer starts
// when the first question is displayed.
void showTimer() {
  if (typed >= 0) {
    time--;
    if ((600 - time) % 30 == 0) {
      timer--;
      time = time - 30;
    }
    fill(0);
    textFont(avenir, 20);
    text("Time Remaining: ", 90, 485);
    fill(255);
    rect(250, 470, 600, 20);
    fill(255, 0, 0);
    rect(250, 470, (600 - timer * 3), 20);
  }
}

// Has a question already been answered?
boolean alreadyAnswered() {
  return typed - 2 == current;
}

// Is the given key a correct answer for the current question?
boolean checkAnswer(char in) {
  return questionsXML[current].getString("ans").charAt(0) == in;
}

// The screen displayed if player answers the question correctly.
// Gives the player 10 points and shows the correct answer.
void goodFeedback() {
  fill(#00B72C);
  textFont(rockwell, 76);
  text("YOU'RE BRILLIANT!", 150, 100);
  fill(#000000);
  textFont(rockwell, 50);
  fill(#F77073);
  text("+10 Points", 360, 200);
  text("And pats for Patrick!", 250, 250);
  fill(0, 0, 255);
  text("The correct answer was:", 210, 350);
  textFont(rockwell, 24);
  text(showAnswer(), 90, 400);
}

// The screen displayed if player answers the question wrong.
// Doesn't give the player any points, but shows the correct answer.
void badFeedback() {
  fill(255, 0, 0);
  textFont(rockwell, 76);
  text("SORRY, NOT QUITE!", 140, 100);
  fill(#000000);
  textFont(rockwell, 50);
  fill(#1E8E6B);
  text("+0 Points", 370, 200);
  text("Try again, Plankton.", 260, 250);
  fill(0, 0, 255);
  text("The correct answer was:", 210, 350);
  textFont(rockwell, 24);
  text(showAnswer(), 90, 400);
}

// Shows the correct answer to the previous question.
String showAnswer() {
  String ans = "";
  for (int i = 0; i < optionsXML[current].length; i++) {
    if (checkAnswer(optionsXML[current][i].getString("id").charAt(0))) {
      ans = optionsXML[current][i].getString("id") + ") " 
        + optionsXML[current][i].getContent();
    }
  }
  return ans;
}

// Displays the start page.
// Displays each question and its options.
// Displays the final page when the player reaches the end of the quiz.
// Resets the game if the 'r' key is pressed.
void draw() {
  if (current < 0) {
    startPage();
  }
  if (keyPressed && key == 'r') {
    resetGame();
  }
  if (current == questionsXML.length - 1) {
    if (alreadyAnswered()) {
      if (checkAnswer(key)) {
        score-=10;
      }
      typed++;
      current = questionsXML.length;
      showTimer();
    }
  }
  if (current == questionsXML.length) {
    stopTimer();
    finalPage();
  }
  if (current < questionsXML.length && current > -1) {
    if (alreadyAnswered()) {
      current++;
      typed--;
      display();
    }
    showTimer();
  }
}

// Displays feedback for each key press, and transitions
// to the next screen when appropriate.
// Adds points to the player's score for answering a new
// question correctly.
void keyPressed() {
  background(#FFFF89);
  typed++;
  if (current < 0) {
    startPage();
    current++;
    display();
  }
  if (current == questionsXML.length) {
    stopTimer();
    finalPage();
  }
  if (current <= questionsXML.length - 1 
    && current > -1 
    && typed > 0 
    && !(key == 'r')) {
    if (!alreadyAnswered()) {
      if (checkAnswer(key)) {
        goodFeedback();
        score+=10;
      }
      else {
        badFeedback();
      }
      fill(255, 0, 0);
      text("Press any key to move on to the next question.", 230, 290);
    }
  }
  else {
    typed++;
  }
}

// Stops the timer by equalizing the time decrement on every tick.
void stopTimer() {
  time++;
}

// Calculates the player's score.
int calculateScore() {
  return (score / 5) * timer;
}

// The screen displayed when the player reaches the end of the quiz.
// Displays the score and counts it up by 25 for the player to see.
void finalPage() {
  background(#FFFF89);
  fill(0);
  textFont(rockwell, 76);
  text("Your final score is:", 160, 150);
  if (countscore >= calculateScore()) {
    fill(255, 0, 0);
    text(calculateScore(), 410, 250);
    fill(0);
    textFont(rockwell, 44);
    text("Press 'r' to play again and beat your score!", 60, 350);
  }
  else {
    fill(255, 0, 0);
    text(countscore+=25, 410, 250);
  }
}

// Resets the quiz and puts the player at the start page.
void resetGame() {
  background(255);
  setup();
}

