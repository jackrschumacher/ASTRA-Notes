description:: Information about setting up the SD card

- [A guide for setting up SD card writing on the Pico](https://medium.com/@cemmreis/logging-data-with-an-sd-card-module-and-raspberry-pi-pico-in-arduino-ide-5b280382527e)
- [Arduino SD card library](https://docs.arduino.cc/libraries/sd/)
-
- # Overview
- ## Functions
-
-
- # Example Code
- ## Writing random values to a file
- This example code generates random values using the inbuilt random() function and puts them into a file on the SD card.
- ```c++
  #include <SPI.h>
  #include <SD.h>
  
  int sdOutputPin =1; //Change this
  
  File randomFile; //Initialize file variable
  
  void setup() {
    // put your setup code here, to run once:
    Serial.begin(9600);
  
    if(!SD.begin(sdOutputPin)){
      Serial.println("SD Card Initialization failed. Check card formatting and wiring.");
    }
    else{
      Serial.println("SD Card initialization succeeded");
    }
  
  }
  
  void loop() {
    // put your main code here, to run repeatedly:
    // Set up some random variables for mocking up data
    long random1 = random(1,200);
    long random2 = random(1,200);
    long random3 = random(1,200);
    long random4 = random(1,200);
  
  
  
    randomFile = SD.open("data.txt" ,FILE_WRITE); //Write to file
    // Check if file exists
    if(randomFile){
      // Write values to file
      randomFile.print("Random 1: ");
      randomFile.print(random1);
      randomFile.print("Random 2: ");
      randomFile.print(random2);
      randomFile.print("Random 3: ");
      randomFile.print(random3);
      randomFile.print("Random 4: ");
      randomFile.print(random4);
      // Close file
      randomFile.close();
    }
    else{
      // If cannot open file (file does not exist)
      Serial.println("Cannot open file.");
    }
  }
  
  ```
- [View the original file here](https://github.com/jackrschumacher/TM-Optimized/blob/embedded-training/embedded-Examples/SD-write/SD-write.ino)