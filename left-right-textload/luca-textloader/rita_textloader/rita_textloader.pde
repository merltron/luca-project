import rita.*;

RiString rs;
String line = "click to (re)generate!";
String[] files = { "wittgenstein.txt", "kafka.txt" };
String text;
String sentence;
String[] words;
String word1;
String word2;
int counter = 1;
int x = 160, y = 240;

void setup()
{
  size(500, 500);

  fill(0);
  textFont(createFont("times", 16));

  // create a markov model w' n=3 from the files
  
  String[] rawtext = loadStrings("wittgenstein.txt");
  // println("there are " + text.length + " lines");
  text=rawtext[0];
  text = text.replace("--", " ");
/*  for (int i = 0 ; i < lines.length; i++) {
    println(lines[i]);
  } */
  
  // rs = new RiString("Fuck you. Fuck him. Fuck Her.");
  // rs.analyze();
  String[] sentences = RiTa.splitSentences(text);
  
  for (int i = 0 ; i < sentences.length; i++) {
    sentence = RiTa.stripPunctuation(sentences[i]);
    words = RiTa.tokenize(sentence);
    println("LENGTH IS ",words.length);
      for (int w = 0 ; w < words.length; w++) {
        print(w," ");
        if (w >= words.length-2)
          {  
            if(w == 0){word1 = words[w];} else{word1 = words[w-1];};
             word2 = words[w];
           } 
           else 
         {
             word1 = words[w];
             word2 = words[w+1];
             println("expectedindex: ",w+1);
             w = w + 1;
           }; // Test that w doesn't go out of bounds
        
        println("Word pair #",counter,": ",word1," | ",word2);
        counter++;
        }
        
  }
  


}
