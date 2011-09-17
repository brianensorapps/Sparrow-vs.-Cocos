//
//  Bird.h
//  Sparrow vs. Cocos
//
//  Created by chriis on 9/15/11.
//  Copyright 2011 Sathi. All rights reserved.
//

#import "SPSprite.h"


@interface Bird : SPSprite {
    SPSprite *bird;
    SPMovieClip *LeftWing;
    SPMovieClip *RightWing;
    SPMovieClip *Body;
    SPImage *Tail;
    SPJuggler *birdJuggler;
    BOOL isDizzy;
}
-(void)advanceTime:(double)seconds;
-(void)dizzyBird;
-(void)undizzyBird;
-(void)turnLeft;
-(void)turnRight;
-(void)goStraight;
-(void)makeShadow;
-(void)moveShadowX:(float)birdX;
-(void)moveShadowY:(float)birdY;
@end
