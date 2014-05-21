#pragma once

#include "ofMain.h"
#include "ofxiOS.h"
#include "ofxiOSExtras.h"
#include "compass.h"
#include "quest.h"
#include "ofxXmlSettings.h"

class ofApp : public ofxiOSApp{
	
    public:
        void setup();
        void update();
        void draw();
        void exit();
	
        void touchDown(ofTouchEventArgs & touch);
        void touchMoved(ofTouchEventArgs & touch);
        void touchUp(ofTouchEventArgs & touch);
        void touchDoubleTap(ofTouchEventArgs & touch);
        void touchCancelled(ofTouchEventArgs & touch);

    void gotMessage(ofMessage &msg);
    
        void lostFocus();
        void gotFocus();
        void gotMemoryWarning();
        void deviceOrientationChanged(int newOrientation);
    
    Compass compass;
    
    
    //Location Management
    ofxiPhoneCoreLocation * coreLocation;
	bool bHasCompass;
	bool bHasGPS;
    float heading;

    //Points of Interest
    vector<ofPoint> pointsOfInterest;
    int actualPointofInterest;
    
    void setupQuests();
    
    
    //Quests
    vector<Quest> quests;
    int numberOfQuests;
    bool everythingIsSolved;
    bool everythingIsSolvedBefore;

    
    
    bool isKeybord();
    float keyboardShift;
    
    
    ofxiOSVideoPlayer video;

    
    
private:
    float intervallMin;
    float intervallMax;
    float timer;
    
    void reset();
    
    ofImage backgroundImage;
    bool bIsReset;
    
    
  

};


