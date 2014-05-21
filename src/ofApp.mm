#include "ofApp.h"

//--------------------------------------------------------------
void ofApp::setup(){
    
    ofSetCircleResolution(200);
    
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
    
       //quests[1].setSecretArray(s1);
    
    
    backgroundImage.loadImage("decoder.png");
    //backgroundImage.resize(200, 200);

    
    
    setupQuests();
   

    
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
    
    ofPoint p =*new ofPoint(0,0);
    pointsOfInterest.push_back(p);
    
    p.set(0,0);
    pointsOfInterest.push_back(p);
    
    p.set(47.564544,7.595019);
    pointsOfInterest.push_back(p);
    
    p.set(47.562447,7.593579);
    pointsOfInterest.push_back(p);
    
    p.set(47.566123,7.59059);
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

    //intervall=ofRandom(0.35,0.5);
    
    //RESET
    intervallMin=3;
    intervallMax=4;

    timer=ofGetElapsedTimef();
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
    ofSetColor(255);
    backgroundImage.draw(0,0);
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
    
    
    if(bIsReset){
    
        ofPushMatrix();
        ofTranslate(ofGetScreenWidth()/2, ofGetScreenHeight()/2);
        ofRect(-25,-25,50,50);
        ofPopMatrix();
    
    }

    
    
    //ofSetColor(54);
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

void ofApp::setupQuests(){
    
    numberOfQuests=5;
    
    vector<string> s0;
    string s="Café Salon";
    s0.push_back(s);
    s="Cafe Salon";
    s0.push_back(s);
    s="Cafe Saloon";
    s0.push_back(s);
    s="Saloon";
    s0.push_back(s);
    s="Kaffee Salon";
    s0.push_back(s);
    s="Kaffe Salon";
    s0.push_back(s);
    s="Kaffe Saloon";
    s0.push_back(s);
    s="Kaffee Saloon";
    s0.push_back(s);
    s="Café Saloon";
    s0.push_back(s);
    
    
    vector<string> s1;
    s="Schatz";
    s1.push_back(s);
    
    
    vector<string> s2;
    s="Schliessfach";
    s2.push_back(s);
    s="Schliesfach";
    s2.push_back(s);
    s="Postfach";
    s2.push_back(s);
    s="Safe";
    s2.push_back(s);
    s="Tresor";
    s2.push_back(s);
    s="Schliessbox";
    s2.push_back(s);
    s="Box";
    s2.push_back(s);
    
    
    
    vector<string> s3;
    s="Platte";
    s3.push_back(s);
    
    vector<string> s4;
    s="Love";
    s4.push_back(s);
    
    
    /*  for(int i=0; i<numberOfQuests; i++)
     {
     Quest q =*new Quest();
     q.setup();
     q.setId(i);
     q.setWidth(ofGetWidth());
     float h=100;
     q.setHeight(h);
     q.setScreenPosition(ofPoint(0,(h*i)+500));
     // q.setSecret("S");
     q.setSecretArray(s1);
     quests.push_back(q);
     }*/
    
    float h=80;
    int myid=0;
    int offset=610;
    
    Quest q =*new Quest();
    q.setup();
    q.setId(myid);
    q.setWidth(ofGetWidth());
    q.setHeight(h);
    q.setScreenPosition(ofPoint(0,(h*myid)+offset));
    // q.setSecret("S");
    q.setSecretArray(s0);
    quests.push_back(q);
    
    myid=1;
    q =*new Quest();
    q.setup();
    q.setId(myid);
    q.setWidth(ofGetWidth());
    q.setHeight(h);
    q.setScreenPosition(ofPoint(0,(h*myid)+offset));
    // q.setSecret("S");
    q.setSecretArray(s1);
    quests.push_back(q);
    
    myid=2;
    q =*new Quest();
    q.setup();
    q.setId(myid);
    q.setWidth(ofGetWidth());
    q.setHeight(h);
    q.setScreenPosition(ofPoint(0,(h*myid)+offset));
    // q.setSecret("S");
    q.setSecretArray(s2);
    quests.push_back(q);
    
    myid=3;
    q =*new Quest();
    q.setup();
    q.setId(myid);
    q.setWidth(ofGetWidth());
    q.setHeight(h);
    q.setScreenPosition(ofPoint(0,(h*myid)+offset));
    // q.setSecret("S");
    q.setSecretArray(s3);
    quests.push_back(q);
    
    myid=4;
    q =*new Quest();
    q.setup();
    q.setId(myid);
    q.setWidth(ofGetWidth());
    q.setHeight(h);
    q.setScreenPosition(ofPoint(0,(h*myid)+offset));
    // q.setSecret("S");
    q.setSecretArray(s4);
    quests.push_back(q);
    
    
    
    
    
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
    
    cout<<touch.id<<endl;

    
    float now = ofGetElapsedTimef();
    
    if (now-timer>intervallMin&&now-timer<intervallMax){
        reset();
        bIsReset=true;
    }
    if(touch.id==2){
        cout<<"timer to now"<<endl;
        cout<<"now "<<now<<" delta "<<now-timer<<endl;
        timer=now;
    }


}

//--------------------------------------------------------------
void ofApp::reset(){
    
    cout<<"---------- Reset ------------" <<endl;
    
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
    bIsReset=false;

}


