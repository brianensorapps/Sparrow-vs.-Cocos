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
        
        bird = [SPQuad quadWithWidth:70 height:70];
        bird.x = ([Screen sharedScreen].width-bird.width)/2;
        bird.y = [Screen sharedScreen].height-bird.height-20;
        bird.color = 0x0000ff;
        
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
        [self addChild:bird];
        
        SPSprite *positionIndicator = [SPSprite sprite];
        SPQuad *representationBackground = [SPQuad quadWithWidth:88 height:88 color:0x000000];
        [positionIndicator addChild:representationBackground];
        SPQuad *mapRepresentation = [SPQuad quadWithWidth:84 height:84];
        mapRepresentation.x = 2;
        mapRepresentation.y = 2;
        [positionIndicator addChild:mapRepresentation];
        positionQuad = [SPQuad quadWithWidth:4 height:4 color:0xFF0000];
        positionQuad.x = 2;
        positionQuad.y = 2;
        [positionIndicator addChild:positionQuad];
        positionIndicator.x = [Screen sharedScreen].width-positionIndicator.width-10;
        positionIndicator.y = [Screen sharedScreen].height-positionIndicator.height-10;
        [self addChild:positionIndicator];
        
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
<<<<<<< HEAD
    [gameJuggler advanceTime:event.passedTime];
    world.pivotX += -sin(world.rotation)*(100*event.passedTime);
    world.pivotY += -cos(world.rotation)*(100*event.passedTime);
    SPRectangle *birdBounds = [bird boundsInSpace:map];
    SPPoint *birdPosition = [SPPoint pointWithX:birdBounds.x+birdBounds.width/2 y:birdBounds.y+birdBounds.height/2];
    float newX = birdPosition.x/40+2;
    float newY = birdPosition.y/40+2;
    if (newX > 2 && newX < 82) {
        positionQuad.x = birdPosition.x/40+2;
    }
    if (newY > 2 && newY < 82) {
        positionQuad.y = birdPosition.y/40+2;
    }
    NSString *collisionName = [map objectCollidingWithBird:bird];
    if ([collisionName isEqualToString:@"tree"]) {
        [self setInvertedControls:YES];
        [gameJuggler removeAllObjects];
        [[gameJuggler delayInvocationAtTarget:self byTime:5] setInvertedControls:NO];
    }
=======
    map.pivotX += -sin(map.rotation)*(100*event.passedTime);
    map.pivotY += -cos(map.rotation)*(100*event.passedTime);
    
>>>>>>> I played around with speed, no essential change
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
        bird.color = 0xFF0000;
    }
    else {
        bird.color = 0x0000FF;
    }
    invertedControls = inverted;
}

- (void)dealloc {
    [gameJuggler release];
    [super dealloc];
}

@end
