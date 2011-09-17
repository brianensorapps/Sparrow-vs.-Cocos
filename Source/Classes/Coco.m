//
//  Coco.m
//  Sparrow vs. Cocos
//
//  Created by Arend Hintze on 17.09.11.
//  Copyright 2011 KGI. All rights reserved.
//

#import "Coco.h"


@implementation Coco

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(id) initWithTarget:(SPPoint*)newTarget{
    self = [super init];
    if (self) {
        animationJuggler=[[SPJuggler alloc] init];
        M = [[SPMovieClip alloc] initWithFrame:[SPTexture textureWithContentsOfFile:@"Sparrow000.png"] fps:20.0];
        [M play];
        [animationJuggler addObject:M];
        [self addEventListener:@selector(onEnterFrame:) atObject:self forType:SP_EVENT_TYPE_ENTER_FRAME];
    }    
    return self;
}

- (void)onEnterFrame:(SPEnterFrameEvent *)event {
    float passedTime=event.passedTime;
    [animationJuggler advanceTime:passedTime];
}

-(void) setNewTarget:(SPPoint*)newTarget{ target=newTarget;}

- (void)dealloc
{
    [super dealloc];
}

@end
