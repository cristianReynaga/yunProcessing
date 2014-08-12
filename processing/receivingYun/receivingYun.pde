import com.jcraft.jsch.ChannelSftp;
import com.jcraft.jsch.JSch;
import com.jcraft.jsch.Session;
import java.io.*;
import oscP5.*;
import netP5.*;


String user = "root";
String password = "isabel09";
String host = "yunlab.local";
int port=22;

//Variables OSC
OscP5 oscP5;
NetAddress myRemoteLocation;
int portOsc=12000;
String ip="127.0.0.1";

//////Create instances
JSch jsch;
Session session;
Channel channel;
DataOutputStream dataOut;
InputStream in;

boolean prendido= false;
int timerPrendido=0;
int timerApagado=0;

int ARRAY_SIZE= 4;
int end=10;
String ss;
String header="S";
String tail="E";

void setup() {
  size(100, 100);
  oscP5 = new OscP5(this, portOsc);
  myRemoteLocation = new NetAddress("127.0.0.1", 12000);

  try {
    jsch = new JSch();
    session = jsch.getSession(user, host, port);
    session.setPassword(password);
    session.setConfig("StrictHostKeyChecking", "no");  // less than maximally secure
    System.out.println("Establishing Connection...");
    session.connect();
    System.out.println("Connection established.");


    // this stream will be used to send data to the Yun
    channel = session.openChannel("exec");
    channel.setInputStream(null);

    // this jsch member class provides remote execution of a shell command
    ((ChannelExec) channel).setCommand("telnet localhost 6571");
    // see <a href="http://arduino.cc/en/Guide/ArduinoYun#toc17" target="_blank" rel="nofollow">http://arduino.cc/en/Guide/ArduinoYun#toc17</a> for why this command
    dataOut = new DataOutputStream(channel.getOutputStream());
    ((ChannelExec)channel).setErrStream(System.err);

    /*
    java.util.Properties config = new java.util.Properties(); 
     config.put("StrictHostKeyChecking", "no");
     session.setConfig(config);
     */
    // after configuring all channel parameters, we connect, causing the
    // command to be executed. Results and further input will be handled
    // by the streams
    in=channel.getInputStream();
    channel.connect();
  }
  catch(Exception e) {
    System.err.print(e);
  }

  timerApagado=millis();
}


void draw() {
  background(255, 22, 100);
  byte[] tmp=new byte[1024];

  try {
    while (in.available ()>0) {


      int i=in.read(tmp, 0, 1024);
      if (i<0)break;
      String s=new String(tmp, 0, i);

      if (s != null) {
        String ss=trim(s);
        String[]ii= split(ss, ',');
        //println(ii[0]);
          int a= Integer.parseInt(ii[0]);

        //OSC
        OscMessage myMessage = new OscMessage("/sensor_0");
        myMessage.add(a);
        oscP5.send(myMessage, myRemoteLocation);
        if (ii[0].equals(header)) {
          println("check");
          String iii=ii[1];
          println("completo:     "+iii);
        }
        if (ii.length==4) {

          String s1=ii[0];
          String s2=ii[1];
          String s3=ii[2];
          String statusCheck="";
          if (!s1.equals(statusCheck)) {
            println("s1: "+s1+ " s2:  " +s2+ " s3: "+s3);
          }
        }


        // println("sending: "+ii[0]);

        //  int a= Integer.parseInt(s);
        // a=a+3;
        int a= Integer.parseInt(ii[0]);
        a=a+3;
        //int iiCount= ii.length();


        // println(ii.length+"  "+ii[0]);


        //  System.out.print(s);
      }
    }



    if (channel.isClosed()) {
      System.out.println("exit-status: "+channel.getExitStatus());
      //      break;
    }
  }




  catch(Exception IOException) {
    System.err.print(IOException);
  }


  /*
  try {
   // if used with the Console example code, this will blink the LED
   // in time with polling events
   
   if (prendido) {
   if (( millis()-timerPrendido )>1000) {
   dataOut.writeBytes("L\n");
   dataOut.flush();
   timerApagado=millis();
   prendido=false;
   println("apaga!");
   }
   }
   else{
   if (( millis()-timerApagado)>1000) {
   dataOut.writeBytes("H\n");
   dataOut.flush();
   timerPrendido=millis();
   prendido=true;
   println("prende!");
   }
   
   }
   
   
   }
   catch(Exception ee) {
   System.err.print(ee);
   }
   */
}

void mousePressed() {
  /* in the following different ways of creating osc messages are shown by example */
  OscMessage myMessage = new OscMessage("/test");

  myMessage.add(123); /* add an int to the osc message */
  myMessage.add(12.34); /* add a float to the osc message */
  myMessage.add("some text"); /* add a string to the osc message */
  myMessage.add(new byte[] {
    0x00, 0x01, 0x10, 0x20
  }
  ); /* add a byte blob to the osc message */
  myMessage.add(new int[] {
    1, 2, 3, 4
  }
  ); /* add an int array to the osc message */

  /* send the message */
  oscP5.send(myMessage, myRemoteLocation);
}


void stop() {
  System.out.println("disconnecting...\n");
  channel.disconnect();
  session.disconnect();
  System.out.println("Finished.\n");
}

