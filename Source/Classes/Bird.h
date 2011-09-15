//
//  Bird.h
//  Sparrow vs. Cocos
//
//  Created by chriis on 9/15/11.
//  Copyright 2011 Sathi. All rights reserved.
//

#import "SPSprite.h"


@interface Bird : SPSprite {
    SPMovieClip *bird;
    SPMovieClip *birdShadow;
    SPJuggler *birdJuggler;
}
-(void)advanceTime:(double)seconds;
-(void)moveBirdShadowX:(float)shadowX;
-(void)moveBirdShadowY:(float)shadowY;
-(void)dizzyBird;
-(void)undizzyBird;
@end
