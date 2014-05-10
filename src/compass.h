#pragma once
#include "ofMain.h"
#include "ofxiOSExtras.h"


class Compass{
	
    public:
        void setup();
        void update();
        void draw();
        void exit();
	
    
    void setDevicePosition(float lat, float lon);
    ofPoint devicePosition;

    void setHeading(float heading);
    float getDistance();
    float getDirection();
    
    void setPointOfInterest(ofPoint p);
    ofPoint pointOfInterest;

    ofTrueTypeFont franklinBook14;

    ofTrueTypeFont TTF;
    
    
    
    bool bIsEnabled;
    void setIsEnabled(bool enable);
    bool getIsEnabled();
    
private:
    
    ofImage compassImg;
    float heading;
    
    
    float computeDistance(float lat1,float lon1, float lat2, float lon2);
    float distance;
    
    float computeDirection(float lat1,float lon1, float lat2, float lon2);
    float direction;
    
    vector<ofPoint> pointsOfInterest;
    int actualPointofInterest;

    
    
};


