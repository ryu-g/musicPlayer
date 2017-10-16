import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.sound.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class musicPlayer extends PApplet {


// import java.util.ArrayList;
final int number = 11;
JSONObject json;
ArrayList<Song> song;
SoundFile[] file = new SoundFile[number] ;
PShape[] iconimg = new PShape[number];
PShape bysk;
boolean clicked;
boolean onMouse = false;
int a=0,b=0;
int choosed = -1;
int lastChoosed =0;
int x,y,w,h,dx;
//--------------------end of param--------
public void setup() {
	println("aaaa"+iconimg.length);
	
	noStroke();
	textSize(width/30);

	song = new ArrayList<Song>();
	json = loadJSONObject("data.json");//jsonfile\u306e\u30ed\u30fc\u30c9
	JSONArray jsondatas = json.getJSONArray("songs");
	for (int i = 0 ; i<jsondatas.size() ; i++){
		JSONObject s 		= jsondatas.getJSONObject(i);
		int id 				= s.getInt("id");
		String title 		= s.getString("title");
		String musicpath 	= s.getString("musicpath");
		String imgpath 		= s.getString("imgpath");
		int bgcolor 		= unhex(s.getString("bgcolor"));
		file[i]				= new SoundFile(this, musicpath);
		iconimg[i]			= loadShape(imgpath);
		song.add(new Song(id, title, musicpath, imgpath ,bgcolor, file[i],iconimg[i], 0));
		println(id+","+ title+","+ musicpath+","+ imgpath +","+bgcolor);
		println("loaded ok: "+song.size());
	}
	println("-------stand by-------");
	bysk=loadShape("logow.svg");
	y=height/7*4;
	w=width/15;
	h=w;
	dx=width/50;
	x=(width-((number-1)*(dx+w)))/2;
	dx+=w;

	background(0xff4e1a68);
}



public void draw() {
	if(choosed==-1)background(0xff4e1a68);
	else	background(song.get(choosed-1).bgcolor);

	if(choosed==-1)text("press any icon",width/28,height/7*5);
	else	text(song.get(choosed-1).title,width/28,height/7*5);

	imageMode(CENTER);
	rectMode(CENTER);
	shapeMode(CENTER);
	shape(bysk,width/2,height/7*2,width/10,width/10);
	for(int i=0; i<song.size(); i++){
		song.get(i).display(x+dx*i,y,w,h);
	}
}


class Song{
	int id;
	String title;
	String musicpath;
	String imgpath;
	int bgcolor;
	SoundFile file;
	PShape img;
	int play;
	int passed=0;
	int paused=0;
	int x,y,w,h;
	int lastsecond;
	int second;

	Song(int _id, String _title,String _musicpath, String _imgpath, int _bgcolor, SoundFile _file,PShape _img, int _play){
		id			= _id;
		title		= _title;
		musicpath	= _musicpath;
		imgpath	= _imgpath;
		bgcolor	= _bgcolor;
		file 		= _file;
		img 		= _img;
		play 		= _play;//default 0
	}

	public void playSong(){
		this.play=1;//\u518d\u751f\u72b6\u614b
		this.file.play();//que\u304b\u3089\u518d\u751f(\u57fa\u672c\u306f\u982d\u304b\u3089)
	}
	public void pauseSong(){
		this.file.cue(this.passed);//\u4e00\u6642\u505c\u6b62\u5f8c\u518d\u958b\u4f4d\u7f6e\u3092\u4fdd\u5b58
		println("cued: "+this.passed);
		this.file.stop();//\u518d\u751f\u3092\u505c\u6b62
		this.play=0;//\u975e\u518d\u751f\u72b6\u614b
	}
	public void stopSong(){
		if(this.play==1){
		this.file.stop();//\u73fe\u5728\u306e\u66f2\u3092\u505c\u6b62\u3057\u3066

}		this.file.cue(0);//\u518d\u958b\u4f4d\u7f6e\u30920\u306b\u3059\u308b
		this.play=0;//\u975e\u518d\u751f\u72b6\u614b
		passed=0;
		paused=0;
	}
	public void timeCount(){
		second=second();
		if(this.play==1){
			if(lastsecond!=second){
				passed+=1;
				println("now passed: "+passed);
				println("now id: "+id);
			}
		}
		lastsecond=second;
		if(this.file.duration()<passed){
			stopSong();
			choosed=-1;
		}
	}

	public void display(int x, int y, int w, int h){
		fill(this.bgcolor);
		rect(x,y,w,h);
		if(play==1&&lastChoosed==this.id)shape(img, x, y, w*1.3f, h*1.3f);
		else shape(img, x, y, w, h);
		fill(255);
		this.timeCount();
		if(x-w/2<mouseX&&mouseX<x+w/2&&y-h/2<mouseY&&mouseY<y+h/2){
			//-----------------
			statusOverRay(x,y,w,h,play);
			//------------------
			if(clicked&&onMoused(x,y,w,h)){
				choosed = this.id;
				println("(nowchoosed,lastChoosed)="+"("+choosed+","+lastChoosed+")");
				if(choosed==lastChoosed||lastChoosed==0){
					switch(play){
						case 0:
						this.playSong();
						clicked = false;
						break;
						case 1:
						this.pauseSong();
						clicked = false;
						break;
					}
				}
				if(choosed!=lastChoosed&&lastChoosed!=0){
					song.get(lastChoosed-1).stopSong();
					passed=0;//\u7d4c\u904e\u6642\u95930
					clicked = false;
					this.playSong();
				}
				lastChoosed = choosed;
			}
		}
	}
}

public boolean onMoused(int x,int y,int w,int h){
	if(x-w/2<mouseX&&mouseX<x+w/2&&y-h/2<mouseY&&mouseY<y+h/2)
		onMouse=true;
	return onMouse;
}
public void mouseMoved() {
	clicked=false;
}

public void mouseReleased(){
	if(clicked){clicked=false;}
	else if (!clicked){clicked=true;}
}


public void statusOverRay(int x,int y,int w,int h,int status){
	fill(0,128);
	rect(x,y,w,h);
	fill(255);
	if(status==0)triangle(x-w/6, y-h/6, x+w/6, y, x-w/6, y+h/6);
	if(status==1){rect(x-w/8,y,w/9,h/3);rect(x+w/8,y,w/9,h/3);}
	noFill();
}

  public void settings() { 	fullScreen(); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "musicPlayer" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
