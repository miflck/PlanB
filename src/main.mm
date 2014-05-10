#include "ofMain.h"
#include "ofApp.h"

int main(){
	ofSetupOpenGL(768,1024, OF_FULLSCREEN);			// <-------- setup the GL context

	ofRunApp(new ofApp);
}
