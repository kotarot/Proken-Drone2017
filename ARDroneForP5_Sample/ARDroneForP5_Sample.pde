/** //<>// //<>//
 * Original version of this program is:
 * https://github.com/shigeodayo/ARDroneForP5/blob/master/examples/ARDroneForP5_Sample/ARDroneForP5_Sample.pde
 * which is licensed under the Apache License, Version 2.0 (the "License")
 * as in
 * https://github.com/shigeodayo/ARDroneForP5/blob/master/LICENSE.txt
 */

import com.shigeodayo.ardrone.processing.*;

//import pFaceDetect.*;

import gab.opencv.*;
import processing.video.*;
import java.awt.*;

Capture video;
OpenCV opencv;
PImage canny;

void captureEvent(Capture c) {
  c.read();
}

ARDroneForP5 ardrone;

ARDroneForP5_Sample ardrone_sample;
Rectangle[] faces;

//PFaceDetect face;
//PImage img;

void setup() {
  //size(320, 240);

  ardrone=new ARDroneForP5("192.168.1.1");
  // connect to the AR.Drone
  ardrone.connect();
  // for getting sensor information
  ardrone.connectNav();
  // for getting video informationp
  ardrone.connectVideo();
  // start to control AR.Drone and get sensor and video data of it
  ardrone.start();

  size(640, 360);

  // capture: 320 x 240
  //video = new Capture(this, width/2, height/2);  
  //opencv = new OpenCV(this, width, height);
  //opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);

  //video.start(); // start capture
  
  ardrone_sample = this;
}

void draw() {
  //background(204);  

  // getting image from AR.Drone
  // true: resizeing image automatically
  // false: not resizing
  PImage img = ardrone.getVideoImage(false);
  if (img == null)
    return;
  //image(img, 0, 0);

  //scale(2);  // 2 times
  //opencv.loadImage(img);

  // canny edge filter
  //opencv.findCannyEdges(50, 200);
  //canny = opencv.getSnapshot();

  // display
  image(img, 0, 0 );

  // Face detection
  faces = get_faces(img);
  noFill();
  stroke(0, 255, 0);
  strokeWeight(3);
  if (faces != null) {
    println(faces.length);
    for (int i = 0; i < faces.length; i++) {
      println(faces[i].x + "," + faces[i].y);
      rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
    }
  }

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

Rectangle[] get_faces(PImage img) {
  Rectangle[] faces;

  try {
    opencv = new OpenCV(ardrone_sample, img);
    opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);

    faces = opencv.detect();
  } catch (NullPointerException e) {
    return null;
  }
  return faces;
}

void kaiten(float beforeyaw, float target){
  System.out.println("beforeyaw: " + beforeyaw);
  ardrone.spinRight(25);
  for(int i=0;i<=300;i++){
    float yaw = ardrone.getYaw() + 180;
    System.out.println("yaw:" + yaw);
    float delta_yaw = yaw-beforeyaw ;
    if(delta_yaw<-10){
      delta_yaw += 360;
    } 
    System.out.println("delta_yaw: " + delta_yaw);
    if((delta_yaw)>=target) break;
    ardrone.spinRight(25);
    delay(100);
  }
  ardrone.stop();
  delay(1000);
}

void chokushin(int forwardis){
  ardrone.stop();
  ardrone.forward(20); // go forward
  float distance_x = 0.0;
  float distance_y = 0.0;
  long prev =System.currentTimeMillis();
  float speed_before_stop=1;
  //////
  for (int i = 0; i < 100; i++) {
    float[] velocity = ardrone.getVelocity();
    long now =System.currentTimeMillis();
    System.out.println("now=" + now + "(+" + (now - prev) + ") velocity_x=" + velocity[0] + " velocity_y=" + velocity[1]);
    distance_x += velocity[0] * (now - prev);
    distance_y += velocity[1] * (now - prev);
    ardrone.forward((int)((forwardis-distance_x)/forwardis*20));
    delay(90);
    if(velocity[1]>0){
      ardrone.goLeft(5);
    }else if(velocity[1]<0){
      ardrone.goRight(5);
    }
    delay(10);
    prev = now;
    if (distance_x >forwardis) {
      System.out.println("distance_x=" + distance_x + " (break)");
      System.out.println("distance_y=" + distance_y + " (break)");
      speed_before_stop=velocity[0];
      break;
    }
  }
  
  //float speed_before_stop=velocity[0];
  if(speed_before_stop<=0)speed_before_stop=2;
 
  ardrone.stop();
 
  prev =System.currentTimeMillis();
  for(int i=0;i<40;i++){
   
    float[] velocity = ardrone.getVelocity();
    float vel=velocity[0];
    if(vel> speed_before_stop)vel= speed_before_stop;
    if(vel<=0)vel=1;
    ardrone.backward((int)(vel/speed_before_stop*20));
    long now =System.currentTimeMillis();
    System.out.println("now=" + now + "(+" + (now - prev) + ") velocity_x=" + velocity[0] + " velocity_y=" + velocity[1]);
    distance_x += velocity[0] * (now - prev);
    distance_y += velocity[1] * (now - prev);
    delay(100);
    prev = now;
  }
  System.out.println("distance_x=" + distance_x);
  System.out.println("distance_y=" + distance_y);

}

void chokushin2(int forwardis){
  ardrone.stop();
  ardrone.forward(20); // go forward
  float distance_x = 0.0;
  float distance_y = 0.0;
  long prev =System.currentTimeMillis();
  float speed_before_stop=1;
  //////
  for (int i = 0; i < 100; i++) {
    float[] velocity = ardrone.getVelocity();
    long now =System.currentTimeMillis();
    System.out.println("now=" + now + "(+" + (now - prev) + ") velocity_x=" + velocity[0] + " velocity_y=" + velocity[1]);
    distance_x += velocity[0] * (now - prev);
    distance_y += velocity[1] * (now - prev);
    ardrone.forward((int)((forwardis-distance_x)/forwardis*20));
    delay(90);
    if(velocity[1]>0){
      ardrone.goLeft(5);
    }else if(velocity[1]<0){
      ardrone.goRight(5);
    }
    delay(10);
    prev = now;
    if (distance_x >forwardis) {
      System.out.println("distance_x=" + distance_x + " (break)");
      System.out.println("distance_y=" + distance_y + " (break)");
      speed_before_stop=velocity[0];
      break;
    }
  }
  
  //float speed_before_stop=velocity[0];
  if(speed_before_stop<=0)speed_before_stop=2;
 
  ardrone.stop();
 
  System.out.println("distance_x=" + distance_x);
  System.out.println("distance_y=" + distance_y);

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
      
      //ardrone.goRight(); // go right
      
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
      delay(2000);
        
      ardrone.spinRight();
      for(int i=0;i<=20;i++){
        float yaw = ardrone.getYaw();
        System.out.println(yaw);
        delay(100);
      }
      ardrone.stop();
      delay(2000);

      ardrone.landing();
      
    } 

    // ================================
    // Heya wo isshuu
    // ================================
    else if (keyCode == SHIFT) {
      ardrone.reset();
      ardrone.takeOff(); // take off, AR.Drone cannot move while landing
      delay(3000);
      float altitude = ardrone.getAltitude();
      while (altitude<=1500) {//1500mm
        ardrone.up(50); // go up
        altitude = ardrone.getAltitude();
        System.out.println(altitude);
        delay(70);
      }
      float beforeyow = ardrone.getYaw() + 180;
      
      chokushin(1200000);
      
      kaiten(beforeyow, 80);
      
      chokushin(1700000);
      
      kaiten(beforeyow,165);
      
      chokushin(1400000);
      
      kaiten(beforeyow,245);
      
      chokushin(1200000);
      
      ardrone.landing();
    }

    // ================================
    // Kao ninshiki
    // ================================
    else if (keyCode == CONTROL) {
      Thread t = new Thread(new KaoThread());
      t.start();
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
      for(int ii=0;ii<20;ii++){
        System.out.println("faces[0].width=" + faces[0].width);
        System.out.println("faces[0].height=" + faces[0].height);
        delay(1000);
      }
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

// ================================
// [THREAD] Kao ninshiki
// ================================
class KaoThread implements Runnable {
  public synchronized void run() {
    ardrone.reset();

    // kokoni takeoff
  ardrone.takeOff(); // take off, AR.Drone cannot move while landing
      delay(6000);
      float altitude = ardrone.getAltitude();
      while (altitude<=1500) {//1500mm
        ardrone.up(50); // go up
        altitude = ardrone.getAltitude();
        System.out.println(altitude);
        delay(70);
      }
    while(true){
      //System.out.println("!!!! " + i);
  
      if (faces != null) {
        System.out.println(faces.length);
        for (int face = 0; face<faces.length;face++) {
          System.out.println("face " + face + " x:" + faces[face].x + " y:" + faces[face].y + " width:" + faces[face].width + " height:" + faces[face].height);
        }

        // kokode kaono ichini motozuite drone ugoku shori
        // example: sayuuni kaiten, zenshin, etc...
        if (1 <= faces.length&&faces[0].y>=150-30&&faces[0].y<150+30) {
          // example
          
          if (270+20 <= faces[0].x) {
            ardrone.spinRight(25);
            delay(100);
            ardrone.stop();
            ; // migi-kaiten suru
          }else if(faces[0].x<270-20){
            ardrone.spinLeft(25);
            delay(100);
            ardrone.stop();
          }else{
            System.out.println("faces[0].width=" + faces[0].width);
            System.out.println("faces[0].height=" + faces[0].height);
            System.out.println("faces[0].x=" + faces[0].x);
            System.out.println("faces[0].y=" + faces[0].y);
            
            
            if(faces.length>=1&&faces[0].width>10)chokushin2(1200000/5);
            else ardrone.stop();
            if(faces[0].width>120){
              ardrone.stop();
              break;
            }
          }
        }
        //printf("face.x=%d",faces[0].x);
        delay(100);
      } else {
        delay(20);
      }
    }

    ardrone.landing();
  }
}