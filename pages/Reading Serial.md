description:: Info about using serial for embedded code

- # Overview
- ## Functions
-
- # Example code
- ## Moving one servo
- Example code that mocks up reading input from serial for single motor control
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
      // If a command is received
      else{
        // Initilize array of the size of the serial input string. Print out over serial the value that the axis was commanded to move
        const int commandSize = command.length() +1; //Command size is equal to length of command string +1
        char commands[commandSize]; 
        command.toCharArray(commands,commandSize); //create commands array using commmands and commandSize
        
        char *token; //The * character means that this variable is a pointer value (a variable that points to another variable)
        int axis1move = 0; //Acess first value in array (corresponds to axis 1)
  
  
        token = strtok(commands,","); //Getting the first value before the first comma
        
        if(token != NULL){ //If the token is not null
          axis1move = atoi(token); //Convert token to an integer
         
  
        }
        else{
          Serial.println(("token was null"));
        }
  
        if(axis1move >=0){ //Check if the value passed is valid
            int convertToMicroseconds = map(axis1move,0,180,1000,2000); //Map the values of the angle over serial (i.e. 0-180) to a microsecond value (1000-2000)
        }
        else{
          Serial.println("Valid number could not be parsed");
        }  
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
- [View the original file here](https://github.com/jackrschumacher/TM-Optimized/blob/embedded-training/embedded-Examples/move-Single-Servo/move-Single-Servo.ino)
-
- ## Moving multiple servos
- Example code that mocks up reading input from serial for single motor control
- ```c++
  #include <Arduino.h>
  #include <Servo.h>
  
  
  #define NUM_MOTORS 4 //This will be used to iterate through the loop
  
  //Initialize servos-in this case we have 4 servos
  Servo servo1;
  Servo servo2;
  Servo servo3;
  Servo servo4;
  
  Servo* servos[] = {&servo1, &servo2, &servo3, &servo4}; //Array of servos
  
  int motorCommands[NUM_MOTORS]; //Create an array with size equal to the number of motors
  int commandsParsed = 0; //Set up the number of commands parsed
  void setup() {
    // put your setup code here, to run once:
    // Serial initilization at a baud rate of 9600
    Serial.begin(9600);
  
    // Attach servo to example pins
    servo1.attach(1);
    servo2.attach(2);
    servo3.attach(3);
    servo4.attach(4);
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
      // If a command is received
      else{
        // Initilize array of the size of the serial input string. Print out over serial the value that the axis was commanded to move
        const int commandSize = command.length() +1; //Command size is equal to length of command string +1
        char commands[commandSize]; 
        command.toCharArray(commands,commandSize); //create commands array using commmands and commandSize
        
        char *token; //The * character means that this variable is a pointer value (a variable that points to another variable)
        commandsParsed = 0;
  
        token = strtok(commands,","); //Getting the first value before the first comma (this only occurs the first time)
        while(token != NULL && commandsParsed < NUM_MOTORS){ //Loop through tokens, make sure array size not exceeded
          motorCommands[commandsParsed] = atoi(token); //Convert token to integer and store it within the array
  
          commandsParsed++; //Increment the counter  (so the loop does not run forever)
  
          token= strtok(NULL,","); //Will be null after the first time
        }
        if(commandsParsed >= 1){ //Check if the number of commands parsed is greater than 1
          for(int i =0; i < commandsParsed; i++){
            int moveAngle = motorCommands[i]; //Assign moveAngle to value in motorCommands array
  
            moveAngle = constrain(moveAngle, 0, 180); //Use inbuilt function to ensure that value is in valid angle range
            int convertToMicroseconds = map(moveAngle,0,180,1000,2000);
  
            if(i < NUM_MOTORS){
              servos[i]->writeMicroseconds(convertToMicroseconds); //Allows control of servo at iterated value
              Serial.print("Servo");
              Serial.print(i+1);
              Serial.print(" Moved to ");
              Serial.print(angle);
            }
          
          }
        }
        else{
          Serial.println("Could not parse motor values");
        }
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
- [View the original file here](https://github.com/jackrschumacher/TM-Optimized/blob/embedded-training/embedded-Examples/move-Multiple-Servos/move-Multiple-Servos.ino)