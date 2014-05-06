#include "compass.h"

//--------------------------------------------------------------
void Compass::setup(){
    pointOfInterest.set(0,0);
    
    compassImg.loadImage("windrose.png");
    compassImg.resize(200, 200);
    compassImg.setAnchorPoint(compassImg.width/2, compassImg.height/2);
    compassImg.update();
    
}

//--------------------------------------------------------------
void Compass::update(){

        distance=computeDistance(devicePosition.x,devicePosition.y,pointOfInterest.x,pointOfInterest.y);
        direction=computeDirection(devicePosition.x,devicePosition.y,pointOfInterest.x,pointOfInterest.y);
}

//--------------------------------------------------------------
void Compass::draw(){
    ofPushMatrix();
    ofTranslate(ofGetWidth()/2, ofGetHeight()/2, 0);
    ofRotateZ(direction+heading);
    compassImg.draw(0,0);
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
