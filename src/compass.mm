#include "compass.h"

//--------------------------------------------------------------
void Compass::setup(){
    pointOfInterest.set(0,0);
    
    compassImg.loadImage("windrose.png");
    compassImg.resize(200, 200);
    compassImg.setAnchorPoint(compassImg.width/2, compassImg.height/2);
    compassImg.update();
    
    franklinBook14.loadFont("GStyle.ttf", 14);
	franklinBook14.setLineHeight(18.0f);
	franklinBook14.setLetterSpacing(1.037);
    
    
    TTF.loadFont("Brown-Regular.otf", 15);
    
    bIsEnabled=false;

    
    
}

//--------------------------------------------------------------
void Compass::update(){

    if(bIsEnabled){
        distance=computeDistance(devicePosition.x,devicePosition.y,pointOfInterest.x,pointOfInterest.y);
        direction=computeDirection(devicePosition.x,devicePosition.y,pointOfInterest.x,pointOfInterest.y);
    }
}

//--------------------------------------------------------------
void Compass::draw(){
    ofPushMatrix();
    ofTranslate(ofGetWidth()/2, ofGetHeight()/6, 0);
   
    if(bIsEnabled){
    ofRotateZ(direction+heading);
    }
    ofSetColor(255, 255, 255);
    compassImg.draw(0,0);
    if(!bIsEnabled){
        
        ofSetColor(0, 0, 0,100);
        ofRect(-compassImg.width/2, -compassImg.height/2, compassImg.width, compassImg.height);

    ofSetColor(255, 0, 0);
    string drawstring="Nicht Freigeschaltet";
    TTF.drawString(drawstring, -compassImg.width/2, 0);
    }
  
	ofPopMatrix();
    
    ofPushMatrix();
    ofTranslate(ofGetWidth()/2, ofGetHeight()/2, 0);
    ofSetColor(255, 0, 0);
    //ofRect(0,0,20,100);
    ofRect(0, 0, 20, ofMap(distance, 0, 1, 0, 500,true));
    ofSetColor(245, 58, 135);
    string drawstring="Distanz ";
    drawstring+=ofToString(distance*1000);
    drawstring+=" Meter";
    TTF.drawString(drawstring, 0, 0);
    ofPopMatrix();


}

//--------------------------------------------------------------
void Compass::exit(){

}

//--------------------------------------------------------------
void Compass::setPointOfInterest(ofPoint p){
    pointOfInterest=p;

}

//--------------------------------------------------------------
void Compass::setHeading(float _heading){
    heading=_heading;
    
}
//---------------------------------------------------------------
void Compass::setDevicePosition(float lat, float lon){
    devicePosition.set(lat, lon);
}


void Compass::setIsEnabled(bool enable){
    bIsEnabled=enable;
}


bool Compass::getIsEnabled(){
    return bIsEnabled;
}


//--------------------------------------------------------------

float Compass::computeDirection(float lat1,float lon1,float lat2, float lon2){
    
    
    float dLon = ofDegToRad(lon2-lon1);
    lat1 = ofDegToRad(lat1);
    lat2 = ofDegToRad(lat2);
    
    float y = sin(dLon) * cos(lat2);
    float x = cos(lat1)*sin(lat2)-sin(lat1)*cos(lat2)*cos(dLon);
    float brng = ofRadToDeg(atan2(y, x));
    
    return brng;
    
}


//--------------------------------------------------------------

float Compass::computeDistance(float lat1,float lon1,float lat2, float lon2){
    
    int R = 6371; // km
    float dLat = ofDegToRad(lat2-lat1);
    float dLon = ofDegToRad(lon2-lon1);
    lat1 = ofDegToRad(lat1);
    lat2 = ofDegToRad(lat2);
    
    float a = sin(dLat/2) * sin(dLat/2)+sin(dLon/2) * sin(dLon/2) * cos(lat1) * cos(lat2);
    float c = 2 * atan2(sqrt(a), sqrt(1-a));
    float d = R * c;
    return d;
}
