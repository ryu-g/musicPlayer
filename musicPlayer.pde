import processing.sound.*;
final int number = 11;//曲数の指定
JSONObject json;
ArrayList<Song> song;
SoundFile[] file = new SoundFile[number];
PShape[] iconimg = new PShape[number];
int[] prevcolor	 = new int[3];//for change color with easing
int[] nowcolor	 = new int[3];//desu
PShape bysk;
boolean clicked;
boolean onMouse = false;
boolean dispConsole = false;
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
		JSONObject s 		= jsondatas.getJSONObject(i);
		int id 				= s.getInt("id");
		String title 		= s.getString("title");
		String musicpath 	= s.getString("musicpath");
		String imgpath 		= s.getString("imgpath");
		color bgcolor 		= unhex(s.getString("bgcolor"));
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

	background(#4e1a68);
}



void draw() {
	if(choosed==-1)background(#4e1a68);
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
	color bgcolor;
	SoundFile file;
	PShape img;
	int play;
	int passed=0;
	int paused=0;
	int x,y,w,h;
	int lastsecond;
	int second;
	float dw=2;
	int step;

	Song(int _id, String _title,String _musicpath, String _imgpath, color _bgcolor, SoundFile _file,PShape _img, int _play){
		id			= _id;
		title		= _title;
		musicpath	= _musicpath;
		imgpath		= _imgpath;
		bgcolor		= _bgcolor;
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
		this.file.stop();//曲が再生中であれば現在の曲を停止して
		}		
		this.file.cue(0);//再開位置を0にする
		this.play=0;//非再生状態
		passed=0;
		paused=0;
	}
	void timeCount(){
		second=second();
		if(this.play==1){
			if(lastsecond!=second){
				passed+=1;
				if (dispConsole) {
				println("now passed: "+passed);
				println("now id: "+id);
				}
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

		if(x-w/2<mouseX&&mouseX<x+w/2&&y-h/2<mouseY&&mouseY<y+h/2||play==1){
			if(w+dw<w*1.3){
				this.dw+=9/(step+1)*cos(radians(dw));
				step++;
			}
		}else if(w+dw>w){
			step=0;
				this.dw/=1.15;
			}

			shape(img, x, y, w+dw, h+dw);
		fill(255);
		this.timeCount();
		if(x-w/2<mouseX&&mouseX<x+w/2&&y-h/2<mouseY&&mouseY<y+h/2){
			//-----------------
			statusOverRay(x,y,w,h,play);
			//------------------
			if(clicked){
				choosed = this.id;
				if(dispConsole)
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

boolean onMoused(int x,int y,int w,int h){
	if(x-w/2<mouseX&&mouseX<x+w/2&&y-h/2<mouseY&&mouseY<y+h/2)
		onMouse=true;
	return onMouse;
}
void mouseMoved() {
	clicked=false;
}

void mouseReleased(){
	if(clicked){clicked=false;}
	else if (!clicked){clicked=true;}
}


void statusOverRay(int x,int y,int w,int h,int status){
	//再生中アイコンと都知事停止アイコンの表示
	fill(0,128);
	rect(x,y,w,h);
	fill(255);
	if(status==0)triangle(x-w/6, y-h/6, x+w/6, y, x-w/6, y+h/6);
	if(status==1){rect(x-w/8,y,w/9,h/3);rect(x+w/8,y,w/9,h/3);}
	noFill();
}