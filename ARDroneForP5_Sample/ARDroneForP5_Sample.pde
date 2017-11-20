/**
 * Original version of this program is:
 * https://github.com/shigeodayo/ARDroneForP5/blob/master/examples/ARDroneForP5_Sample/ARDroneForP5_Sample.pde
 * which is licensed under the Apache License, Version 2.0 (the "License")
 * as in
 * https://github.com/shigeodayo/ARDroneForP5/blob/master/LICENSE.txt
 */

import com.shigeodayo.ardrone.processing.*;

ARDroneForP5 ardrone;

void setup() {
  size(320, 240);

  ardrone=new ARDroneForP5("192.168.1.1");
  // connect to the AR.Drone
  ardrone.connect();
  // for getting sensor information
  ardrone.connectNav();
  // for getting video informationp
  ardrone.connectVideo();
  // start to control AR.Drone and get sensor and video data of it
  ardrone.start();
}

void draw() {
  background(204);  

  // getting image from AR.Drone
  // true: resizeing image automatically
  // false: not resizing
  PImage img = ardrone.getVideoImage(false);
  if (img == null)
    return;
  image(img, 0, 0);

  // print out AR.Drone information
  //ardrone.printARDroneInfo();

  // getting sensor information of AR.Drone
  float pitch = ardrone.getPitch();
  float roll = ardrone.getRoll();
  float yaw = ardrone.getYaw();
  float altitude = ardrone.getAltitude();
  float[] velocity = ardrone.getVelocity();
  int battery = ardrone.getBatteryPercentage();

  String attitude = "pitch:" + pitch + "\nroll:" + roll + "\nyaw:" + yaw + "\naltitude:" + altitude;
  text(attitude, 20, 85);
  String vel = "vx:" + velocity[0] + "\nvy:" + velocity[1];
  text(vel, 20, 140);
  String bat = "battery:" + battery + " %";
  text(bat, 20, 170);
}

//PCのキーに応じてAR.Droneを操作できる．
// controlling AR.Drone through key input
void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      ardrone.forward(100); // go forward
    } 
    else if (keyCode == DOWN) {
      ardrone.backward(); // go backward
    } 
    else if (keyCode == LEFT) {
      ardrone.goLeft(); // go left
    } 
    else if (keyCode == RIGHT) {
      ardrone.goRight(); // go right
    } 
    else if (keyCode == SHIFT) {
      ardrone.reset();
      ardrone.takeOff(); // take off, AR.Drone cannot move while landing
     delay(6000);
     float altitude = ardrone.getAltitude();
        while (altitude<=1500) {//1500mm
            ardrone.up(50); // go up
            altitude = ardrone.getAltitude();
            System.out.println(altitude);
            delay(70);
        }
        
        ardrone.stop();
          ardrone.forward(50); // go forward
               float distance_x = 0.0;
               float distance_y = 0.0;
               long prev =System.currentTimeMillis();
               for (int i = 0; i < 10; i++) {
                 float[] velocity = ardrone.getVelocity();
                 long now =System.currentTimeMillis();
                 System.out.println("now=" + now + "(+" + (now - prev) + ") velocity_x=" + velocity[0] + " velocity_y=" + velocity[1]);
                 distance_x += velocity[0] * (now - prev);
                 distance_y += velocity[1] * (now - prev);
                 delay(100);
                 prev = now;
               }
               System.out.println("distance_x=" + distance_x);
               System.out.println("distance_y=" + distance_y);
               ardrone.stop();
               delay(2000);
               
                ardrone.goRight(50); // go right
                prev =System.currentTimeMillis();
                for (int i = 0; i < 10; i++) {
                 float[] velocity = ardrone.getVelocity();
                 long now =System.currentTimeMillis();
                 System.out.println("now=" + now + "(+" + (now - prev) + ") velocity_x=" + velocity[0] + " velocity_y=" + velocity[1]);
                 distance_x += velocity[0] * (now - prev);
                 distance_y += velocity[1] * (now - prev);
                 delay(150);
                 prev = now;
               }
               System.out.println("distance_x=" + distance_x);
               System.out.println("distance_y=" + distance_y);
                 ardrone.stop();
                  delay(2000);
                /*  ardrone.backward(50); // go right
                delay(1500);
                 ardrone.stop();
                  delay(2000);
                  ardrone.goLeft(50); // go right
                delay(1500);
                 ardrone.stop();
               delay(2000);*/

     ardrone.landing();
    } 
    else if (keyCode == CONTROL) {
      ardrone.landing();
      // landing
    }
  } 
  else {
    if (key == 's') {
      ardrone.stop(); // hovering
    } 
    else if (key == 'r') {
      ardrone.spinRight(); // spin right
    } 
    else if (key == 'l') {
      ardrone.spinLeft(); // spin left
    } 
    else if (key == 'u') {
      ardrone.up(); // go up
    }
    else if (key == 'd') {
      ardrone.down(); // go down
    }
    else if (key == '1') {
      ardrone.setHorizontalCamera(); // set front camera
    }
    else if (key == '2') {
      ardrone.setHorizontalCameraWithVertical(); // set front camera with second camera (upper left)
    }
    else if (key == '3') {
      ardrone.setVerticalCamera(); // set second camera
    }
    else if (key == '4') {
      ardrone.setVerticalCameraWithHorizontal(); //set second camera with front camera (upper left)
    }
    else if (key == '5') {
      ardrone.toggleCamera(); // set next camera setting
    }
  }
}