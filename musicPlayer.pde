import processing.sound.*;
// import java.util.ArrayList;
final int number = 11;
JSONObject json;
ArrayList<Song> song;
SoundFile []file = new SoundFile[number] ;
PImage []iconimg = new PImage[number];

int playedtime=0;
int passed=0;
int lastsecond;
int second;
boolean clicked ;
int a=0,b=0;
int choosed = 0;
int lastChoosed =0;

void setup() {
	noStroke();
	size(900,600);
	song = new ArrayList<Song>();
	json = loadJSONObject("data.json");//jsonfileのロード
	JSONArray jsondatas = json.getJSONArray("songs");
	for (int i = 0 ; i<jsondatas.size() ; i++){
		JSONObject s = jsondatas.getJSONObject(i);
		int id = s.getInt("id");
		String title = s.getString("title");
		String musicpath = s.getString("musicpath");
		String imgpath = s.getString("imgpath");
		String bgcolor = s.getString("bgcolor");
		file[i]		= new SoundFile(this, "Silver Cluster.wav");
		iconimg[i]	=loadImage(imgpath);
		song.add(new Song(id, title, musicpath, imgpath ,bgcolor, file[i],iconimg[i], 0));
		println(id+","+ title+","+ musicpath+","+ imgpath +","+bgcolor);
		println("loaded ok: "+song.size());

	}
	println("-------stand by-------");
}


void draw() {
	background(0);
	int count=0;
	for(int j=0 ; j<3 ; j++){
		for(int i=0; i<6 ; i++){
			song.get(count).display(100+120*i,100+120*j,100,100);
			count++;
			if(count==11){i=6;j=3;}
		}
	}
}


class Song{
	//int xposition;
	//int yposition;
	int id;
	String title;
	String musicpath;
	String imgpath;
	String bgcolor;
	SoundFile file;
	PImage img;
	int play;

	int x,y,w,h;

	Song(int _id, String _title,String _musicpath, String _imgpath, String _bgcolor, SoundFile _file,PImage _img, int _play){
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
		play=1;//再生状態
		this.file.play();//queから再生(基本は頭から)
	}
	void pauseSong(){
		this.file.cue(passed);//一時停止後再開位置を保存
		println("cued: "+passed);
		this.file.stop();//再生を停止
		play=0;//非再生状態
	}
	void stopSong(){
		this.file.stop();//現在の曲を停止して
		this.file.cue(0);//再開位置を0にする
		play=0;//非再生状態
		passed=0;//経過時間0
	}
	void timecount(){
		second=second();
		if(play==1){
			if(lastsecond!=second){passed+=1;println("passed: "+passed);}
		}
		lastsecond=second;
	}
	public void display(int x, int y, int w, int h){
		image(img, x, y, w, h);
		this.timecount();
		if(x<mouseX&&mouseX<x+w&&y<mouseY&&mouseY<y+h){
			fill(0,128);
			rect(x,y,w,h);
			fill(255);
			if(play==0)triangle(x+w/3, y+h/3, x+w/3, y+h/3*2, x+w/3*2, y+h/2);
			if(play==1){rect(x+w/3,y+h/3,w/9,h/3);rect(x+w/9*5,y+h/3,w/9,h/3);}
			noFill();
			if(clicked){
				choosed = this.id;println("lastChoosed: "+lastChoosed);
				if(choosed==lastChoosed)
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
				if(choosed!=lastChoosed){
					this.stopSong();
					clicked = false;
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

