#include "ofApp.h"

//--------------------------------------------------------------
void ofApp::setup(){	

    
    // register touch events
	ofRegisterTouchEvents(this);
	
	// initialize the accelerometer
	ofxAccelerometer.setup();
	
	//iPhoneAlerts will be sent to this.
	ofxiPhoneAlerts.addListener(this);
    
    coreLocation = new ofxiPhoneCoreLocation();
	bHasCompass = coreLocation->startHeading();
    bHasGPS = coreLocation->startLocation();
    
    
    
    compass=*new Compass();
    compass.setup();

    
    
    
  /*  for(int i=0; i<5; i++)
	{
        ofPoint p =*new ofPoint(47.365880,8.520409);
        pointsOfInterest.push_back(p);
    }
    */
    
    ofPoint p =*new ofPoint(47.365880,8.520409);
    pointsOfInterest.push_back(p);
    
    p.set(47.365679,8.521542);
    pointsOfInterest.push_back(p);
    
    actualPointofInterest=0;
    compass.setPointOfInterest(pointsOfInterest[actualPointofInterest]);
    
}

//--------------------------------------------------------------
void ofApp::update(){
   
    heading = ofLerpDegrees(heading, -coreLocation->getTrueHeading(), 0.7);
    compass.setHeading(heading);
     if(bHasGPS){
        compass.setDevicePosition(coreLocation->getLatitude(), coreLocation->getLongitude());
        compass.update();
    }
}

//--------------------------------------------------------------
void ofApp::draw(){
    compass.draw();
}

//--------------------------------------------------------------
void ofApp::exit(){

}

//--------------------------------------------------------------
void ofApp::touchDown(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void ofApp::touchMoved(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void ofApp::touchUp(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void ofApp::touchDoubleTap(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void ofApp::touchCancelled(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------
void ofApp::lostFocus(){

}

//--------------------------------------------------------------
void ofApp::gotFocus(){

}

//--------------------------------------------------------------
void ofApp::gotMemoryWarning(){

}

//--------------------------------------------------------------
void ofApp::deviceOrientationChanged(int newOrientation){

}

