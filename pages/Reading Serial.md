description:: Info about using serial for embedded code

- # Example code
- Example code that mocks up reading input from serial for motor control
- ```c++
  #include <Arduino.h>
  #include <Servo.h>
  
  //Initialize servo
  Servo servo1;
  
  void setup() {
    // put your setup code here, to run once:
    // Serial initilization at a baud rate of 9600
    Serial.begin(9600);
  }
  
  void readSerial(){
    // Checks if serial is avaliable (value greater than 0)
    if(Serial.available() >0){
      String command = Serial.readStringUntil('\n'); //Read serial until newline
      command.trim(); //Remove whitespace
      // If no command is received
      if(command.length() == 0){
        Serial.println("No motor command received");
        return;
      }
      else{
        // Initilize array of the size of the serial input string. Print out over serial the value that the axis was commanded to move
        const int commandSize = command.length() +1; //Command size is equal to length of command string +1
        char commands[commandSize]; 
        command.toCharArray(commands,commandSize); //create commands array using commmands and commandSize
        int axis1move = command[0]; //Acess first value in array (corresponds to axis 1)
        servo1.write(axis1move); //Move axis 1
        Serial.print(axis1move);
      }
    }
    else{
      // If not print no serial avaliable
      Serial.println("No serial avaliable");
    }
  }
  
  void loop() {
    // put your main code here, to run repeatedly:
    readSerial(); //Call the read serial function
  }
  ```