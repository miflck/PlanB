#include "ofApp.h"

//--------------------------------------------------------------
void ofApp::setup(){
    
    
    
    bool reset_all=false;
    
    
     keyboardShift=0;
    // register touch events
	ofRegisterTouchEvents(this);
	
	// initialize the accelerometer
	ofxAccelerometer.setup();
	
	//iPhoneAlerts will be sent to this.
	ofxiPhoneAlerts.addListener(this);
    
   // ofSetOrientation(OF_ORIENTATION_90_LEFT);
    
    coreLocation = new ofxiPhoneCoreLocation();
	bHasCompass = coreLocation->startHeading();
    bHasGPS = coreLocation->startLocation();
    
    ofRegisterGetMessages(this);

    
    compass=*new Compass();
    compass.setup();
    
    numberOfQuests=5;
    for(int i=0; i<numberOfQuests; i++)
     {
         Quest q =*new Quest();
         q.setup();
         q.setId(i);
         q.setWidth(ofGetWidth());
         float h=100;
         q.setHeight(h);
         q.setScreenPosition(ofPoint(0,(h*i)+500));
         q.setSecret("S");
         quests.push_back(q);
     }
    
    
    
    ofxXmlSettings settings;
    settings.loadFile(ofxiPhoneGetDocumentsDirectory()+"settings.xml");

    int pOi=settings.getValue("settings:actualPointOfInterest", 0);
    settings.setValue("settings:actualPointOfInterest",0);
   
    if(reset_all){
    settings.saveFile(ofxiPhoneGetDocumentsDirectory()+"settings.xml"); //puts settings.xml file in the bin/data folder
    pOi=0;
    }

    cout<<"Loaded "<<pOi<<endl;
    
    
    
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
    
    p.set(47.36566,8.5211);
    pointsOfInterest.push_back(p);
    
    p.set(47.1,9.521542);
    pointsOfInterest.push_back(p);
    
    p.set(47.365679,8.521542);
    pointsOfInterest.push_back(p);
    
    actualPointofInterest=pOi;
    compass.setPointOfInterest(pointsOfInterest[actualPointofInterest]);
    
    
    for(int i=0; i<pOi; i++)
    {
        quests[i].setIsSolved(true);
    }
    
    
	video.loadMovie("endfilm.mov");
    
    //quests[0].setIsSolved(true);
    //quests[1].setIsSolved(true);

    
}

//--------------------------------------------------------------
void ofApp::update(){
    

    heading = ofLerpDegrees(heading, -coreLocation->getTrueHeading(), 0.7);
    compass.setHeading(heading);
     if(bHasGPS){
        compass.setDevicePosition(coreLocation->getLatitude(), coreLocation->getLongitude());
        compass.update();
    }
    
    
    for(int i=0; i<quests.size(); i++)
    {
        quests[i].update();
    }
    
    
    
    //Check if Secret 2 is solved to enable the compass
    compass.setIsEnabled(quests[1].getIsSolved());
    
    // Check if all is solved and the video has to be desplayed
    everythingIsSolved=true;
    for(int i=0; i<quests.size(); i++)
    {
        if(!quests[i].getIsSolved()){
            everythingIsSolved=false;
            break;
        }
    }
    
    
    //Start Video if Solved
    if(!everythingIsSolvedBefore && everythingIsSolved){
        cout<<"-----------------------YOU WON--------------------------"<<endl;
        video.play();
        
    }

    if(everythingIsSolved){
        video.update();

    }
    everythingIsSolvedBefore=everythingIsSolved;

    
}

//--------------------------------------------------------------
void ofApp::draw(){
    compass.draw();
    

    if(!everythingIsSolved){
        for(int i=0; i<quests.size(); i++)
        {
            quests[i].draw();
        }
    }else{
    
        ofSetColor(255);
        ofPushMatrix();
        ofTranslate(ofGetScreenWidth(), 0);
        ofRotate(90);
        
        video.getTexture()->draw(0, 0);
        ofPopMatrix();
        
        if(video.getIsMovieDone()){
            ofSetHexColor(0xFF0000);
            ofDrawBitmapString("end of movie", 110, 360);
        }

    
    }
    
    ofSetColor(54);
     ofDrawBitmapString("Heading: ", 8, 10);
     ofDrawBitmapString(ofToString(coreLocation->getTrueHeading()), 80,10);
     ofDrawBitmapString("Heading Accuracy: ", 8, 30);
     ofDrawBitmapString(ofToString(coreLocation->getHeadingAccuracy()), 200,30);
     ofDrawBitmapString("Position Accuracy: ", 8, 50);
     ofDrawBitmapString(ofToString(coreLocation->getLocationAccuracy()), 200,50);
    
    
    
}



void ofApp::gotMessage(ofMessage &msg){

    cout<<"got message "<<msg.message<<endl;
    
    vector< string > result=ofSplitString(msg.message, "_");
    cout<<result[0]<<endl;
    
    if(msg.message=="Show Keyboard"){
        cout<<"shift me"<<endl;
        keyboardShift=-280;
        for(int i=0; i<quests.size(); i++)
        {
            ofPoint p=quests[i].getInitScreenPosition();
            quests[i].moveToScreenPosition(ofPoint(p.x,p.y+keyboardShift));
        }
}

    
    if(msg.message=="Hide Keyboard"){
        cout<<"shift me back"<<endl;
        keyboardShift=0;
        
        for(int i=0; i<quests.size(); i++)
        {
            ofPoint p=quests[i].getInitScreenPosition();
            quests[i].moveToScreenPosition(ofPoint(p.x,p.y+keyboardShift));
        }
        
    }
    
    
     if(result[0]=="Solved"){
         actualPointofInterest=ofToInt(result[1])+1;

         compass.setPointOfInterest(pointsOfInterest[actualPointofInterest]);
         
         ofxXmlSettings settings;
         settings.loadFile(ofxiPhoneGetDocumentsDirectory()+"settings.xml");
         settings.setValue("settings:actualPointOfInterest",actualPointofInterest);
         settings.saveFile(ofxiPhoneGetDocumentsDirectory()+"settings.xml"); //puts settings.xml file in the bin/data folder
         

         
     }
    
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
    
    ofxXmlSettings settings;
    settings.loadFile(ofxiPhoneGetDocumentsDirectory()+"settings.xml");
    cout<<settings.getValue("settings:actualPointOfInterest", 0)<<endl;
    settings.setValue("settings:actualPointOfInterest",0);
    settings.saveFile(ofxiPhoneGetDocumentsDirectory()+"settings.xml"); //puts settings.xml file in the bin/data folder
    actualPointofInterest=0;

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

