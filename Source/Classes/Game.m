//
//  Game.m
//  Sparrow vs. Cocos
//
//  Created by Brian Ensor on 9/11/11.
//  Copyright 2011 Brian Ensor Apps. All rights reserved.
//

#import "Game.h"
#import "Screen.h"

@implementation Game

- (id)initWithMap:(Map *)newMap {
    if ((self = [super init])) {
        gameJuggler = [[SPJuggler alloc] init];        
        bird = [[Bird alloc] init];
        
        bird.x = ([Screen sharedScreen].width-bird.width)/2;
        bird.y = [Screen sharedScreen].height-bird.height-20;
        
        birdShadow = [[Bird alloc] init];
        birdShadow.pivotX = birdShadow.width;
        birdShadow.pivotY = birdShadow.height;
        birdShadow.x = bird.x;
        birdShadow.y = bird.y;
        birdShadow.scaleX = 0.5;
        birdShadow.scaleY = 0.5;
        [birdShadow makeShadow];
        
        SPQuad *background = [SPQuad quadWithWidth:480 height:320];
        background.color = 0x000000;
        background.name = @"background";
        [self addChild:background];
        map = newMap;
        map.x = -map.width/2;
        map.y = -map.height/2;
        
        world = [SPSprite sprite];
        world.x = bird.x+bird.width/2;
        world.y = bird.y+bird.height/2;
        [self addChild:world];
        
        [world addChild:map];
        
        [self addChild:[map miniMap]];
        
        [self addChild:birdShadow];
        [self addChild:bird];
        
        [self addEventListener:@selector(onEnterFrame:) atObject:self forType:SP_EVENT_TYPE_ENTER_FRAME];
        [self addEventListener:@selector(onTouch:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
    }
    return self;
}

- (void)onTouch:(SPTouchEvent *)event {
    SPTouch *touch = [event.touches anyObject];
    SPPoint *touchLocation = [touch locationInSpace:[self childByName:@"background"]];
    if (touch.phase == SPTouchPhaseBegan) {
        if (touchLocation.x < 240) {
            turnDirection = 0;
            if (invertedControls) {
                [bird turnRight];
                [birdShadow turnRight];
            } else {
            [bird turnLeft];
            [birdShadow turnLeft];
            }
        }
        else if (touchLocation.x > 240) {
            turnDirection = 1;
            if (invertedControls) {
                [bird turnLeft];
                [birdShadow turnLeft];
            } else {
                [bird turnRight];
                [birdShadow turnRight];
            }
        }
        turning = YES;
    }
    else if (touch.phase == SPTouchPhaseEnded) {
        turning = NO;
        [bird goStraight];
        [birdShadow goStraight];
    }
}

- (void)onEnterFrame:(SPEnterFrameEvent *)event {
    [gameJuggler advanceTime:event.passedTime];
    [bird advanceTime:event.passedTime];
    [birdShadow advanceTime:event.passedTime];
    world.pivotX += -sin(world.rotation)*(100*event.passedTime);
    world.pivotY += -cos(world.rotation)*(100*event.passedTime);
    SPRectangle *birdBounds = [bird boundsInSpace:map];
    SPPoint *birdPosition = [SPPoint pointWithX:birdBounds.x+birdBounds.width/2 y:birdBounds.y+birdBounds.height/2];
    [birdShadow moveShadowX:birdPosition.x/8];
    [birdShadow moveShadowY:birdPosition.y/8];

    NSString *collisionName = [map objectCollidingWithBird:bird];
    if ([collisionName isEqualToString:@"tree"]) {
        [self setInvertedControls:YES];
        [gameJuggler removeAllObjects];
        [[gameJuggler delayInvocationAtTarget:self byTime:5] setInvertedControls:NO];
    }
    if (turning) {
        switch (turnDirection) {
            case 0:
                if (!invertedControls) {
                    world.rotation += SP_D2R(50)*event.passedTime;
                }
                else {
                    world.rotation -= SP_D2R(50)*event.passedTime;
                }
                break;
            case 1:
                if (!invertedControls) {
                    world.rotation -= SP_D2R(50)*event.passedTime;
                }
                else {
                    world.rotation += SP_D2R(50)*event.passedTime;
                }
                break;
            default:
                break;
        }
    }
}

- (void)setInvertedControls:(BOOL)inverted {
    if (inverted) {
        [bird dizzyBird];
        //bird.color = 0xFF0000;
    }
    else {
        [bird undizzyBird];
        //bird.color = 0x0000FF;
    }
    invertedControls = inverted;
}

- (void)dealloc {
    [gameJuggler release];
    [super dealloc];
}

@end
