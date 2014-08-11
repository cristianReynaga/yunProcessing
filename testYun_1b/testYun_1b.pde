import com.jcraft.jsch.ChannelSftp;
import com.jcraft.jsch.JSch;
import com.jcraft.jsch.Session;
import java.io.*;

String user = "root";
String password = "isabel09";
String host = "yunlab.local";
int port=22;

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

void setup() {
  size(600, 600);
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
      //      int b= tmp[1];
      //      print("b:    ");
      // println(i);
      //      
      //       b=int(map(i, 0, 1023, 0, height ));
      //      ellipse(width*.5, b+100, 50, 50);

      if (i<0)break;

      //   print("sensor 0: ");
      String s=new String(tmp, 0, i);

      String[]ii= split(s, ',');

      //  int a= Integer.parseInt(s);
      // a=a+3;

      int a= Integer.parseInt(ii[0]);
      a=a+3;

      println(a);
      //  System.out.print(s);
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


void stop() {
  System.out.println("disconnecting...\n");
  channel.disconnect();
  session.disconnect();
  System.out.println("Finished.\n");
}

