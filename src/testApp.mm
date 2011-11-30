#include "testApp.h"

//NOTE THIS IS A BETA movie player for iphone.
//full features of ofVideoPlayer will be implemented in the next minor release 

//--------------------------------------------------------------
void testApp::setup(){
	//ofSetOrientation(OF_ORIENTATION_90_LEFT);
	/////ofSetDataPathRoot("data");
	
	ofSetFrameRate(30);
	ofBackground(225, 225, 225);
	// register touch events
	ofRegisterTouchEvents(this);
	ofBackground(255,255,255);
	receiver.setup(PORT);
	mensaje = false;
	
	video.loadMovie("loop.mp4");
	video.setPixelFormat(OF_PIXELS_RGB);
	video.play();
	
	videoSopla.loadMovie("sopla.mp4");
	videoSopla.setPixelFormat(OF_PIXELS_RGB);
	
	videoLejos.loadMovie("lejos.mp4");
	videoLejos.setPixelFormat(OF_PIXELS_RGB);
	
	texturaLoop.allocate(1024,576,GL_RGB);
	textura.allocate(1024,576,GL_RGB);
	
	estado = "loop";
}

//--------------------------------------------------------------
void testApp::update(){
	
    while( receiver.hasWaitingMessages() ){
		// get the next message
		ofxOscMessage m;
		mensaje = true;
		receiver.getNextMessage(&m);
		
		if( m.getAddress() == "/video" ){
			string dices = m.getArgAsString(0);
			
			if(dices == "sopla")
			{
				dices = "sopla";
			}else if(dices == "loop"){
				dices = "loop";
			}else if(dices == "lejos"){
				dices = "lejos";
			}
			if(dices != estado){
				estado = dices;
				cout << estado << endl;
			}
			
			
		}
	}
	
	if(video.isLoaded()){
		if(video.isPaused() && estado=="loop"){
			video.setPaused(false);
		}else if(!video.isPaused() && estado =="loop"){
			if(!video.isPlaying()){video.play();}
			if(video.getIsMovieDone()){video.stop();video.play();}
			video.update();
			if(video.isFrameNew()){
				texturaLoop.loadData(video.getPixels(),1024,576,GL_RGB);
			}
		}
	}
	if(estado =="sopla"){
		if(videoSopla.isLoaded()){
			if(videoSopla.getIsMovieDone()){
				estado = "loop";
				if(video.isPaused()){video.setPaused(false);}
				videoSopla.stop();
				videoSopla.loadMovie("sopla.mp4");
				return;
			}else{
				if(!videoSopla.isPlaying()){videoSopla.play();}
				videoSopla.update();
				if(!video.isPaused()){video.setPaused(true);}
				if(videoSopla.isFrameNew()){
					textura.loadData(videoSopla.getPixels(),1024,576,GL_RGB);
				}
			}
		}
	}
	
	if(estado =="lejos"){
		if(videoLejos.isLoaded()){
			if(videoLejos.getIsMovieDone()){
				estado = "loop";
				if(video.isPaused()){video.setPaused(false);}
				videoLejos.stop();
				videoLejos.loadMovie("lejos.mp4");
				return;
			}else{
				if(!videoLejos.isPlaying()){videoLejos.play();}
				videoLejos.update();
				if(!video.isPaused()){video.setPaused(true);}
				if(videoLejos.isFrameNew()){
					textura.loadData(videoLejos.getPixels(),1024,576,GL_RGB);
				}
			}
		}
	}
	
	
}

//--------------------------------------------------------------
void testApp::draw(){
	ofSetColor(255);
	
	//foto.draw(0, 0);
	if(estado == "loop"){
		texturaLoop.draw(-100,1080-576,0);
	}else{
		textura.draw(-100,1080-576,0);
	}
	drawHighlightString(ofToString(estado),10,10,ofColor(255,0,0),ofColor(255,255,255));
}

//--------------------------------------------------------------
void testApp::touchDown(ofTouchEventArgs &touch){
}

//--------------------------------------------------------------
void testApp::touchMoved(ofTouchEventArgs &touch){
	
}

//--------------------------------------------------------------
void testApp::touchUp(ofTouchEventArgs &touch){
}

//--------------------------------------------------------------
void testApp::touchDoubleTap(ofTouchEventArgs &touch){
}

//--------------------------------------------------------------
void testApp::touchCancelled(ofTouchEventArgs& args){
	
}
void testApp::drawHighlightString(string text, int x, int y, ofColor background, ofColor foreground) {
	vector<string> lines = ofSplitString(text, "\n");
	int textLength = 0;
	for(int i = 0; i < lines.size(); i++) {
		// tabs are not rendered
		int tabs = count(lines[i].begin(), lines[i].end(), '\t');
		int curLength = lines[i].length() - tabs;
		// after the first line, everything is indented with one space
		if(i > 0) {
			curLength++;
		}
		if(curLength > textLength) {
			textLength = curLength;
		}
	}
	
	int padding = 4;
	int fontSize = 8;
	float leading = 1.7;
	int height = lines.size() * fontSize * leading - 1;
	int width = textLength * fontSize;
	
	ofPushStyle();
	ofSetColor(background);
	ofFill();
	ofRect(x, y, width + 2 * padding, height + 2 * padding);
	ofSetColor(foreground);
	ofNoFill();
	ofPushMatrix();
	ofTranslate(padding, padding);
	ofDrawBitmapString(text, x + 1, y + fontSize + 2);
	ofPopMatrix();
	ofPopStyle();
}
