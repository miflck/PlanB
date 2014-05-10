//
//  quest.mm
//  PlanB
//
//  Created by Michael Flueckiger on 06.05.14.
//
//

#pragma once
#include "ofMain.h"
#include "ofxiPhone.h"
#include "ofxiPhoneExtras.h"




class Quest{
    
    
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
    
    
    ofPoint init_screenPos;
    ofPoint screenPos;
    ofPoint target_screenPos;

    
    ofColor myColor;
    ofColor solvedColor;
    ofColor failColor;
    
    
    float myWidth;
    float myHeight;
    
    void setId(int _id);
    int myId;
    void setWidth(float w);
    void setHeight (float h);
    
    float easing;
    void setScreenPosition(ofPoint _screenpos);
    ofPoint getActualScreenPosition();
    ofPoint getInitScreenPosition();

    void moveToScreenPosition(ofPoint _screenpos);
    
    string secret;
    void setSecret(string secret);
    bool checkSecret(string _try);
    void markAsSolved();
    void showFail();
    
    
    bool bIsSolved;
    bool getIsSolved();
    void setIsSolved(bool _isSolved);
    
    
    
    ofxiPhoneKeyboard * solutionfield;
    string textBefore;
    bool keyboardbefore;
    bool keyboardnow;
    
    
    
private:
    float intervall;
    float timer;
    bool blink;
    void changeBlink();
    
    
    
};