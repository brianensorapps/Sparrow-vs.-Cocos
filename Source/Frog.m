//
//  Coco.m
//  Sparrow vs. Cocos
//
//  Created by Arend Hintze on 17.09.11.
//  Copyright 2011 KGI. All rights reserved.
//

#import "Frog.h"


@implementation Frog

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(id) initWithPosition:(SPPoint*)startPosition inMap:(Map*)map{
    //this constructor expects a start position in tile map coordinates not in absolute coordinates
    self = [super init];
    if (self) {
        animationJuggler=[[SPJuggler alloc] init];
        //This is the preiminary graphic...
        M = [[SPMovieClip alloc] initWithFrame:[SPTexture textureWithContentsOfFile:@"frog000.png"] fps:8.0];
        [M addFrame:[SPTexture textureWithContentsOfFile:@"frog001.png"]];
        [M addFrame:[SPTexture textureWithContentsOfFile:@"frog002.png"]];
        [M addFrame:[SPTexture textureWithContentsOfFile:@"frog003.png"]];
        [M setLoop:NO];
        //[M play];
        [animationJuggler addObject:M];
        [self addChild:M];
        self.pivotX=M.width/2.0;
        self.pivotY=M.height/2.0;
        collisions=map.collisionMap;
        currentPosition=startPosition;
        self.x=currentPosition.x*32-(map.width/2);
        self.y=currentPosition.y*32-(map.height/2);
        direction=0;
        [self addEventListener:@selector(onEnterFrame:) atObject:self forType:SP_EVENT_TYPE_ENTER_FRAME];
        [self makeJump:NULL];
    }    
    return self;
}

- (void)onEnterFrame:(SPEnterFrameEvent *)event {
    float passedTime=event.passedTime;
    [animationJuggler advanceTime:passedTime];
}

-(void) makeJump:(SPEvent*)event{
    int xm[4]={0,1,0,-1};
    int ym[4]={-1,0,1,0};
    
    if([[[collisions objectAtIndex:(int)currentPosition.x+xm[direction]] objectAtIndex:(int)currentPosition.y+ym[direction]] intValue]==1){
        if(rand()&1){
            SPTween *T=[SPTween tweenWithTarget:self time:0.5];
            [T animateProperty:@"rotation" targetValue:self.rotation-SP_D2R(90)];
            [animationJuggler addObject:T];
            direction=(direction-1)&3;
            [T addEventListener:@selector(makeJump:) atObject:self forType:SP_EVENT_TYPE_TWEEN_COMPLETED];
            [M setCurrentFrame:0];
            [M play];
        }
        else{
            SPTween *T=[SPTween tweenWithTarget:self time:0.5];
            [T animateProperty:@"rotation" targetValue:self.rotation+SP_D2R(90)];
            [animationJuggler addObject:T];
            direction=(direction-1)&3;
            [T addEventListener:@selector(makeJump:) atObject:self forType:SP_EVENT_TYPE_TWEEN_COMPLETED];            
            [M setCurrentFrame:0];
            [M play];
        }
    }
    else{
        SPTween *T=[SPTween tweenWithTarget:self time:0.5];
        [T animateProperty:@"x" targetValue:self.x+(32*xm[direction])];
        [T animateProperty:@"y" targetValue:self.y+(32*ym[direction])];
        [animationJuggler addObject:T];
        currentPosition.x+=xm[direction];
        currentPosition.y+=ym[direction];
        [T addEventListener:@selector(makeJump:) atObject:self forType:SP_EVENT_TYPE_TWEEN_COMPLETED];            
        [M setCurrentFrame:0];
        [M play];
    }

}
- (void)dealloc
{
    [super dealloc];
}

@end
