#include "testApp.h"

//NOTE THIS IS A BETA movie player for iphone.
//full features of ofVideoPlayer will be implemented in the next minor release 

//--------------------------------------------------------------
void testApp::setup(){
	ofSetOrientation(OF_ORIENTATION_90_LEFT);
	ofBackground(225, 225, 225);
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
		ofxOscMessage m;
		controlaEstado(m);
	}
	if(estado == "loop"){
		videoLoop();
	}else if(estado == "sopla"){
		soplando();
	}else if(estado == "lejos"){
		alejandose();
	}
}

//--------------------------------------------------------------
void testApp::draw(){
	ofSetColor(255);
	
	if(estado == "loop"){
		texturaLoop.draw(0,0,0);
	}else{
		textura.draw(0,0,0);
	}
	drawHighlightString(ofToString(estado),10,10,ofColor(255,0,0),ofColor(255,255,255));
}


void testApp::controlaEstado(ofxOscMessage m){
	receiver.getNextMessage(&m);
	string dices = m.getArgAsString(0);
	if(dices != estado){
		//cout << "hemos cambiado de estado, en anterior era::" << estado << " y el nuevo es::" << dices << endl;
		cambiaEstado(dices);
		//estado = dices; ///vas a cambiar el estado
	}
}
void testApp::cambiaEstado(string _nuevoEstado){
	if(_nuevoEstado != estado){
		/// pa facer stop
		if(estado=="loop"){
			video.stop();
		}else if(estado=="sopla"){
			videoSopla.stop();
		}else if(estado=="lejos"){
			videoLejos.stop();
		}
		//// pa facer play //////////////////////////////
		if(_nuevoEstado=="loop"){
			video.play();
		}else if(_nuevoEstado=="sopla"){
			videoSopla.play();
		}else if(_nuevoEstado=="lejos"){
			videoLejos.play();
		}
		
		//cout << "hemos cambiado de estado, A MANO en anterior era::" << estado << " y el nuevo es::" << _nuevoEstado << endl;
		estado = _nuevoEstado; ///vas a cambiar el estado
	}
}


void testApp::videoLoop(){
	/// video base que se ejecuta cuando el estado es looop
	video.update();
	if(video.getIsMovieDone()){
		//// loop
		video.stop();
		video.play();
	}
	if(video.isFrameNew()){
		texturaLoop.loadData(video.getPixels(),1024,576,GL_RGB);
	}
}

void testApp::soplando(){
	videoSopla.update();
	if(videoSopla.getIsMovieDone()){
		cambiaEstado("loop");
	}
	if(videoSopla.isFrameNew()){
		textura.loadData(videoSopla.getPixels(),1024,576,GL_RGB);
	}
}

void testApp::alejandose(){
	videoLejos.update();
	if(videoLejos.getIsMovieDone()){
		cambiaEstado("loop");
	}
	if(videoLejos.isFrameNew()){
		textura.loadData(videoLejos.getPixels(),1024,576,GL_RGB);
	}
}

/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

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
	cambiaEstado("lejos");
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
