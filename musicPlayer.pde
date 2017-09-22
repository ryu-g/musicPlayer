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

void setup() {
	noStroke();
	size(900,600);
	song = new ArrayList<Song>();
	json = loadJSONObject("data.json");//jsonfileのロード
	JSONArray jsondatas = json.getJSONArray("songs");
	for (int i = 0 ; i<jsondatas.size() ; i++){
		println("song.size(): "+song.size());
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

	}
	println("song.size(): "+song.size());
}


void draw() {
	background(0);
	int count=0;
	for(int i=0 ; i<5 ; i++){
		for(int j=0; j<3 ; j++){
			song.get(count).display(100+120*i,100+120*j,100,100);
			count++;
			if(count==11){i=5;j=3;}
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

	Song(int _id, String _title,String _musicpath, String _imgpath, String _bgcolor, SoundFile _file,PImage _img, int _play){
		id 			= _id;
		title 		= _title;
		musicpath 	= _musicpath;
		imgpath 	= _imgpath;
		bgcolor 	= _bgcolor;
		file 		= _file;
		img 		= _img;
		play 		= _play;
	}

	void playSong(){
		play=1;//再生状態
		this.file.play();//queから再生(基本は頭から)
	}
	void pauseSong(){
		this.file.cue(passed-1);//一時停止後再開位置を保存
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
			if(lastsecond!=second)passed+=1;
		}
		lastsecond=second;
	}
	public void display(int x, int y, int w, int h){
		image(img, x, y, w, h);

		if(x<mouseX&&mouseX<x+w&&y<mouseY&&mouseY<y+h){
			fill(0,128);
			rect(x,y,w,h);
			fill(255);
			triangle(x+w/3, y+h/3, x+w/3, y+h/3*2, x+w/3*2, y+h/2);
			noFill();
			}

	}
}




// void keyReleased() { //キーボード入力があったら
// 	songname="silverCraster";
// 	switch (key) {
// 		case 'p'://一時停止中に再生
// 			if(play==0)file.play(); //音を鳴らす
// 			play=1;//再生中にする
// 			break;
// 		case 'q'://再生中に一時停止
// 			if(play==1){
// 			file.cue(passed-1);
// 			println("cued in "+passed);
// 			file.stop();
// 			}
// 			play=0;
// 			break;
// 		case 's'://完全停止、待機状態
// 			if(play==1){
// 			file.stop();
// 			file.cue(0);
// 			}
// 			if(play==0){
// 			file.cue(0);
// 			println("cued in "+0);
// 			}
// 			play=0;
// 			passed=0;
// 			songname="now stand by";
// 			break;
// 	}
// }
