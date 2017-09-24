<<<<<<< HEAD
import processing.sound.*;
// import java.util.ArrayList;
final int number = 11;
JSONObject json;
ArrayList<Song> song;
SoundFile []file = new SoundFile[number] ;
PImage []iconimg = new PImage[number];
PImage bysk;
int playedtime=0;
boolean clicked ;
int a=0,b=0;
int choosed = -1;
int lastChoosed =0;
int x,y,w,h,dx;
//--------------------end of param--------
void setup() {
	fullScreen();
	noStroke();
	textSize(width/30);

	song = new ArrayList<Song>();
	json = loadJSONObject("data.json");//jsonfileのロード

	JSONArray jsondatas = json.getJSONArray("songs");
	for (int i = 0 ; i<jsondatas.size() ; i++){
		JSONObject s = jsondatas.getJSONObject(i);
		int id = s.getInt("id");
		String title = s.getString("title");
		String musicpath = s.getString("musicpath");
		String imgpath = s.getString("imgpath");
		color bgcolor = unhex(s.getString("bgcolor"));
		file[i]		= new SoundFile(this, musicpath);
		iconimg[i]	=loadImage(imgpath);
		song.add(new Song(id, title, musicpath, imgpath ,bgcolor, file[i],iconimg[i], 0));
		println(id+","+ title+","+ musicpath+","+ imgpath +","+bgcolor);
		println("loaded ok: "+song.size());
	}
	println("-------stand by-------");
	bysk=loadImage("logow.png");
	x=width/28;
	y=height/2;
	w=width/15;
	h=w;
	dx=w+width/50;
	background(#4e1a68);
}



void draw() {
	if(choosed==-1)background(#4e1a68);
	else	background(song.get(choosed-1).bgcolor);

	if(choosed==-1)text("press any icon",width/28,height/7*5);
	else	text(song.get(choosed-1).title,width/28,height/7*5);

	imageMode(CENTER);
	image(bysk,width/2,height/7*2,width/10,width/10);
	imageMode(CORNER);
	for(int i=0; i<song.size(); i++){
		song.get(i).display(x+dx*i,y,w,h);
	}

}



class Song{
	int id;
	String title;
	String musicpath;
	String imgpath;
	color bgcolor;
	SoundFile file;
	PImage img;
	int play;
	int passed=0;
	int x,y,w,h;
	int lastsecond;
	int second;

	Song(int _id, String _title,String _musicpath, String _imgpath, color _bgcolor, SoundFile _file,PImage _img, int _play){
		id 			= _id;
		title 		= _title;
		musicpath 	= _musicpath;
		imgpath 	= _imgpath;
		bgcolor 	= _bgcolor;
		file 		= _file;
		img 		= _img;
		play 		= _play;//default 0
	}

	void playSong(){
		this.play=1;//再生状態
		this.file.play();//queから再生(基本は頭から)
	}
	void pauseSong(){
		this.file.cue(this.passed);//一時停止後再開位置を保存
		println("cued: "+this.passed);
		this.file.stop();//再生を停止
		this.play=0;//非再生状態
	}
	void stopSong(){
		if(this.play==1){
		this.file.stop();//現在の曲を停止して
		}
		this.file.cue(0);//再開位置を0にする
		this.play=0;//非再生状態
	}
	void timecount(){
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
			passed=0;
		}
	}
	public void display(int x, int y, int w, int h){
		image(img, x, y, w, h);
		this.timecount();
		if(x<mouseX&&mouseX<x+w&&y<mouseY&&mouseY<y+h){
			//-----------------
			statusOverRay(x,y,w,h,play);
			//------------------
			if(clicked){
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
					passed=0;//経過時間0
					clicked = false;
					this.playSong();
				}
				lastChoosed = choosed;
			}
		}
	}
}


void mouseReleased(){
	if(clicked){clicked=false;}
	else if (!clicked){clicked=true;}

}


void statusOverRay(int x,int y,int w,int h,int status){
	fill(0,128);
	rect(x,y,w,h);
	fill(255);
	if(status==0)triangle(x+w/3, y+h/3, x+w/3, y+h/3*2, x+w/3*2, y+h/2);
	if(status==1){rect(x+w/3,y+h/3,w/9,h/3);rect(x+w/9*5,y+h/3,w/9,h/3);}
	noFill();
}
=======
import processing.sound.*;
// import java.util.ArrayList;
final int number = 11;
JSONObject json;
ArrayList<Song> song;
SoundFile []file = new SoundFile[number] ;
PImage []iconimg = new PImage[number];
PImage bysk;
int playedtime=0;
boolean clicked ;
int a=0,b=0;
int choosed = -1;
int lastChoosed =0;
int x,y,w,h,dx;
//--------------------end of param--------
void setup() {
	fullScreen();
	noStroke();

	song = new ArrayList<Song>();
	json = loadJSONObject("data.json");//jsonfileのロード
	JSONArray jsondatas = json.getJSONArray("songs");
	for (int i = 0 ; i<jsondatas.size() ; i++){
		JSONObject s = jsondatas.getJSONObject(i);
		int id = s.getInt("id");
		String title = s.getString("title");
		String musicpath = s.getString("musicpath");
		String imgpath = s.getString("imgpath");
		color bgcolor = unhex(s.getString("bgcolor"));
		file[i]		= new SoundFile(this, musicpath);
		iconimg[i]	=loadImage(imgpath);
		song.add(new Song(id, title, musicpath, imgpath ,bgcolor, file[i],iconimg[i], 0));
		println(id+","+ title+","+ musicpath+","+ imgpath +","+bgcolor);
		println("loaded ok: "+song.size());
	}
	println("-------stand by-------");
	bysk=loadImage("logow.png");
	x=width/28;
	y=height/2;
	w=width/15;
	h=w;
	dx=w+width/50;
	background(#4e1a68);
}



void draw() {
	if(choosed==-1)background(#4e1a68);
	else	background(song.get(choosed-1).bgcolor);
	int count=0;
	// for(int j=0 ; j<3 ; j++){
	// 	for(int i=0; i<6 ; i++){
	// 		song.get(count).display(100+120*i,100+120*j,100,100);
	// 		count++;
	// 		if(count==11){i=6;j=3;}
	// 	}
	// }
	imageMode(CENTER);
	image(bysk,width/2,height/7*2,width/10,width/10);
	imageMode(CORNER);
	for(int i=0; i<song.size(); i++){
		song.get(i).display(x+dx*i,y,w,h);
	}
}


class Song{
	int id;
	String title;
	String musicpath;
	String imgpath;
	color bgcolor;
	SoundFile file;
	PImage img;
	int play;
	int passed=0;
	int x,y,w,h;
	int lastsecond;
	int second;

	Song(int _id, String _title,String _musicpath, String _imgpath, color _bgcolor, SoundFile _file,PImage _img, int _play){
		id 			= _id;
		title 		= _title;
		musicpath 	= _musicpath;
		imgpath 	= _imgpath;
		bgcolor 	= _bgcolor;
		file 		= _file;
		img 		= _img;
		play 		= _play;//default 0
	}
	void infomation(){
		textSize(20);
		stroke(255);
		text(this.title,width/28,height/7*5);
		noStroke();
	}

	void playSong(){
		this.play=1;//再生状態
		this.file.play();//queから再生(基本は頭から)
	}
	void pauseSong(){
		this.file.cue(this.passed);//一時停止後再開位置を保存
		println("cued: "+this.passed);
		this.file.stop();//再生を停止
		this.play=0;//非再生状態
	}
	void stopSong(){
		if(this.play==1){
		this.file.stop();//現在の曲を停止して
		}
		this.file.cue(0);//再開位置を0にする
		this.play=0;//非再生状態
	}
	void timecount(){
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
			passed=0;
		}
	}
	public void display(int x, int y, int w, int h){
		image(img, x, y, w, h);
		this.timecount();
		this.infomation();
		if(this.play==1){
			fill(0,128);
			rect(x,y,w,h);
			fill(255);

			if(play==1){rect(x+w/3,y+h/3,w/9,h/3);rect(x+w/9*5,y+h/3,w/9,h/3);}
		}
		if(x<mouseX&&mouseX<x+w&&y<mouseY&&mouseY<y+h){
			//-----------------
			fill(0,128);
			rect(x,y,w,h);
			fill(255);
			if(play==0)triangle(x+w/3, y+h/3, x+w/3, y+h/3*2, x+w/3*2, y+h/2);
			if(play==1){rect(x+w/3,y+h/3,w/9,h/3);rect(x+w/9*5,y+h/3,w/9,h/3);}
			noFill();
			//------------------
			if(clicked){
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
					passed=0;//経過時間0
					clicked = false;
					this.playSong();
				}
				lastChoosed = choosed;
			}
		}
	}
}


void mouseReleased(){
	if(clicked){clicked=false;}
	else if (!clicked){clicked=true;}

}

>>>>>>> 5538edab6b6ead4762e085c9ccc2fd910caec8d0
