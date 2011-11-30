#pragma once

#include "ofMain.h"
#include "ofxiPhone.h"
#include "ofxiPhoneExtras.h"
#include "ofxOsc.h"

#define PORT 12345

class testApp : public ofxiPhoneApp{
	
	public:
		
		void setup();
		void update();
		void draw();
		
		void touchDown(ofTouchEventArgs &touch);
		void touchMoved(ofTouchEventArgs &touch);
		void touchUp(ofTouchEventArgs &touch);
		void touchDoubleTap(ofTouchEventArgs &touch);
		void touchCancelled(ofTouchEventArgs &touch);
	void drawHighlightString(string text, int x, int y, ofColor background, ofColor foreground);

	ofiPhoneVideoPlayer video,videoSopla,videoLejos;
	
	
	ofTexture textura,texturaLoop;
	ofImage foto;
	
	bool mensaje;
	ofxOscReceiver	receiver;
	string soplidoActivo,videoActivo;
	string estado;
};
