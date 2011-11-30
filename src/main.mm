#include "ofMain.h"
#include "testApp.h"

int main(){
	ofSetupOpenGL(1024,576, OF_FULLSCREEN);			// <-------- setup the GL context
	ofRunApp(new testApp);
}
