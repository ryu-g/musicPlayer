import processing.sound.*;
// import java.util.ArrayList;
JSONObject json;
ArrayList<Song> song;
SoundFile file[];
int playedtime=0;
int passed=0;
int lastsecond;
int second;

void setup() {
	size(900,600);
	song = new ArrayList<Song>();
	json = loadJSONObject("data.json");//jsonfileのロード
	JSONArray jsondatas = json.getJSONArray("songs");

	for (int i = 0 ; i<json.size() ; i++){
		JSONObject s = jsondatas.getJSONObject(i);
		int id = s.getInt("id");
		String title = s.getString("title");
		String musicpath = s.getString("musicpath");
		String imgpath = s.getString("imgpath");
		String bgcolor = s.getString("bgcolor");
		file[i]= new SoundFile(this, musicpath);
		song.add(new Song(id, title, musicpath, imgpath ,bgcolor, file[i], 0));

		// song[i].id = s.getInt("id");
		// song[i].title = s.getString("title");
		// song[i].musicpath = s.getString("musicpath");
		// song[i].imgpath = s.getString("imgpath");
		// song[i].bgcolor = s.getString("bgcolor");
	}
}


void draw() {
	background(0);
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
	int play;

	Song(int _id, String _title,String _musicpath, String _imgpath, String _bgcolor, SoundFile _file, int _play){
		id 			= _id;
		title 		= _title;
		musicpath 	= _musicpath;
		imgpath 	= _imgpath;
		bgcolor 	= _bgcolor;
		file 		= _file;
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
		lastsecond=second;
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
