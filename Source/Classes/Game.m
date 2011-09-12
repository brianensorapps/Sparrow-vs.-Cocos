//
//  Game.m
//  Sparrow vs. Cocos
//
//  Created by Brian Ensor on 9/11/11.
//  Copyright 2011 Brian Ensor Apps. All rights reserved.
//

#import "Game.h"

@implementation Game

- (id)initWithMap:(Map *)newMap {
    if ((self = [super init])) {
        bird = [SPQuad quadWithWidth:50 height:70];
        bird.x = ([UIScreen mainScreen].bounds.size.height-bird.width)/2;
        bird.y = [UIScreen mainScreen].bounds.size.width-bird.height-20;
        bird.color = 0x0000ff;
        NSLog(@"x:%f y:%f", map.pivotX, map.pivotY);
        
        SPQuad *background = [SPQuad quadWithWidth:480 height:320];
        background.color = 0x000000;
        background.name = @"background";
        [self addChild:background];
        map = newMap;
        map.pivotX = self.width/2;
        map.pivotY = (self.height+bird.y+bird.height)/2;
        map.x = map.pivotX;
        map.y = map.pivotY;
        
        [self addChild:map];
        [self addChild:bird];
        
        [self addEventListener:@selector(onEnterFrame:) atObject:self forType:SP_EVENT_TYPE_ENTER_FRAME];
        [self addEventListener:@selector(onTouch:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
        NSLog(@"game initialized");
    }
    return self;
}

- (void)onTouch:(SPTouchEvent *)event {
    SPTouch *touch = [event.touches anyObject];
    SPPoint *touchLocation = [touch locationInSpace:[self childByName:@"background"]];
    if (touch.phase == SPTouchPhaseBegan) {
        if (touchLocation.x < 240) {
            turnDirection = 0;
        }
        else if (touchLocation.x > 240) {
            turnDirection = 1;
        }
        turning = YES;
    }
    else if (touch.phase == SPTouchPhaseEnded) {
        turning = NO;
    }
}

- (void)onEnterFrame:(SPEnterFrameEvent *)event {
    map.pivotX += -sin(map.rotation)*(30*event.passedTime);
    map.pivotY += -cos(map.rotation)*(30*event.passedTime);
    
    if (turning) {
        switch (turnDirection) {
            case 0:
                map.rotation += SP_D2R(50)*event.passedTime;
                break;
            case 1:
                map.rotation -= SP_D2R(50)*event.passedTime;
                break;
            default:
                break;
        }
    }
}

@end
