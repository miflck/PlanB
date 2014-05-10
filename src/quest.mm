//
//  quest.cpp
//  PlanB
//
//  Created by Michael Flueckiger on 06.05.14.
//
//

#include "quest.h"
//--------------------------------------------------------------
void Quest::setup(){
    bIsSolved=false;
    easing=0.1;
   
    ofRegisterTouchEvents(this); // this will enable our circle class to listen to the mouse events.

    solutionfield = new ofxiPhoneKeyboard(500,250,200,25);
	solutionfield->setVisible(true);
	solutionfield->setBgColor(255, 255, 255,150);
	solutionfield->setFontColor(0,0,0,255);
	solutionfield->setFontSize(18);
    solutionfield->updateOrientation();
    
    solvedColor =ofColor(0,255,0,100);
    failColor=ofColor(255,0,0);
    myColor=ofColor(0,0,255,50);
    
    
    //intervall=ofRandom(0.35,0.5);
    intervall=0.5;
    timer=ofGetElapsedTimef();
    blink=true;
}

//--------------------------------------------------------------
void Quest::update(){
    
    //BLinking
    float now = ofGetElapsedTimef();
    if (now-timer>intervall){
        changeBlink();
        timer=now;
    }
    
     keyboardnow=solutionfield->isKeyboardShowing();

    if(keyboardbefore!=keyboardnow){
        cout<<keyboardbefore<<" "<<keyboardnow<<endl;

        if(keyboardnow){
            ofSendMessage("Show Keyboard");
        }else{
            ofSendMessage("Hide Keyboard");
        }
 
    }
    

    keyboardbefore=keyboardnow;
    
    
    float targetX = target_screenPos.x;
    float dx = targetX - screenPos.x;
    if(abs(dx) > 1) {
        screenPos.x += dx * easing;
    }
    
    float targetY = target_screenPos.y;
    float dy = targetY - screenPos.y;
    if(abs(dy) > 1) {
        screenPos.y += dy * easing;
    }
    
    
    if(!bIsSolved){
        if(solutionfield->getText()!="" && solutionfield->getText()!=textBefore){
            bIsSolved=checkSecret(solutionfield->getText());
            textBefore=solutionfield->getText();
            if(bIsSolved){
                markAsSolved();
            }else{
                showFail();
            }
        
        }
    }
}

//--------------------------------------------------------------
void Quest::draw(){

//    int padding=50;
    int yOffset=0;
    
    
    ofPushMatrix();
 
    solutionfield->setPosition(screenPos.x+myWidth/2,screenPos.y+myHeight/2);
    ofTranslate(screenPos.x, screenPos.y-yOffset);
    ofFill();
    ofSetColor(myColor);
    ofSetLineWidth(1);
    ofRect(0,0,myWidth,myHeight);
    
   ofNoFill();
    ofSetColor(255, 255, 255);
    ofSetLineWidth(1);
    ofRect(0,0,myWidth,myHeight);
    
    
    if(!bIsSolved){
        ofSetColor(255,0,0);
    }
    else{
        ofSetColor(0,255,0);
    }
    ofFill();
    ofSetLineWidth(1);
    if(!bIsSolved && blink)ofRect(20,20,50,50);
    if(bIsSolved)ofRect(20,20,50,50);
    
    ofPopMatrix();
    
    
}


bool Quest::getIsSolved(){
    return bIsSolved;
}


//--------------------------------------------------------------
void Quest::touchDown(ofTouchEventArgs & touch){
    cout<<touch.id<<endl;
}

//--------------------------------------------------------------
void Quest::touchMoved(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------
void Quest::touchUp(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------
void Quest::touchDoubleTap(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------
void Quest::touchCancelled(ofTouchEventArgs & touch){
    
}


//--------------------------------------------------------------

void Quest::setSecret(string _secret){
    secret=_secret;
    
}


bool Quest::checkSecret(string _try){
    bool solved=false;
    if(_try==secret){
        solved=true;
    }
    return solved;
}




void Quest::setIsSolved(bool _isSolved){
    bIsSolved=_isSolved;
    if(bIsSolved)markAsSolved();
}



void Quest::markAsSolved(){
    myColor=solvedColor;
    solutionfield->setVisible(false);
    ofSendMessage("Solved_"+ofToString(myId));
}

void Quest::showFail(){
    myColor=failColor;

}


void Quest::changeBlink(){
    blink=!blink;
}


//--------------------------------------------------------------
void Quest::setScreenPosition(ofPoint _sceenPosition){
    screenPos.set(_sceenPosition);
    init_screenPos.set(screenPos);
    target_screenPos.set(screenPos);
    solutionfield->setPosition(screenPos.x+myWidth/2,screenPos.y+myHeight/2);
}

ofPoint Quest::getActualScreenPosition(){
    return screenPos;
}


ofPoint Quest::getInitScreenPosition(){
    return init_screenPos;
}





//--------------------------------------------------------------
void Quest::moveToScreenPosition(ofPoint _sceenPosition){
    target_screenPos.set(_sceenPosition);
}


//--------------------------------------------------------------
void Quest::setId(int _id){
    myId=_id;
}

//--------------------------------------------------------------
void Quest::setHeight(float h){
    myHeight=h;

}

//--------------------------------------------------------------
void Quest::setWidth(float w){
    myWidth=w;
}

//--------------------------------------------------------------
void Quest::exit(){
    
}

