//
//  Bird.m
//  Sparrow vs. Cocos
//
//  Created by chriis on 9/15/11.
//  Copyright 2011 Sathi. All rights reserved.
//

#import "Bird.h"
#import "Screen.h"


@implementation Bird

- (id)init
{
    if ((self = [super init])) {
        
        bird = [SPSprite sprite];
        birdJuggler = [[SPJuggler alloc] init];
        SPTexture *tBody000 = [SPTexture textureWithContentsOfFile:@"body000.png"];
        SPTexture *tBody001 = [SPTexture textureWithContentsOfFile:@"body001.png"];
        SPTexture *tTail = [SPTexture textureWithContentsOfFile:@"Tail.png"];
        SPTexture *tLwing000 = [SPTexture textureWithContentsOfFile:@"Lwing000.png"];
        SPTexture *tLwing001 = [SPTexture textureWithContentsOfFile:@"Lwing001.png"];
        SPTexture *tLwing002 = [SPTexture textureWithContentsOfFile:@"Lwing002.png"];
        SPTexture *tLwing003 = [SPTexture textureWithContentsOfFile:@"Lwing003.png"];
        SPTexture *tLwing004 = [SPTexture textureWithContentsOfFile:@"Lwing004.png"];
        SPTexture *tLwing005 = [SPTexture textureWithContentsOfFile:@"Lwing005.png"];
        SPTexture *tLwing006 = [SPTexture textureWithContentsOfFile:@"Lwing006.png"];
        SPTexture *tLwing007 = [SPTexture textureWithContentsOfFile:@"Lwing007.png"];
        SPTexture *tRwing000 = [SPTexture textureWithContentsOfFile:@"Rwing000.png"];
        SPTexture *tRwing001 = [SPTexture textureWithContentsOfFile:@"Rwing001.png"];
        SPTexture *tRwing002 = [SPTexture textureWithContentsOfFile:@"Rwing002.png"];
        SPTexture *tRwing003 = [SPTexture textureWithContentsOfFile:@"Rwing003.png"];
        SPTexture *tRwing004 = [SPTexture textureWithContentsOfFile:@"Rwing004.png"];
        SPTexture *tRwing005 = [SPTexture textureWithContentsOfFile:@"Rwing005.png"];
        SPTexture *tRwing006 = [SPTexture textureWithContentsOfFile:@"Rwing006.png"];
        SPTexture *tRwing007 = [SPTexture textureWithContentsOfFile:@"Rwing007.png"];
        
        
        LeftWing = [SPMovieClip movieWithFrame:tLwing000 fps:18];
        [LeftWing addFrame:tLwing001];
        [LeftWing addFrame:tLwing002];
        [LeftWing addFrame:tLwing003];
        [LeftWing addFrame:tLwing004];
        [LeftWing addFrame:tLwing005];
        [LeftWing addFrame:tLwing006];
        [LeftWing addFrame:tLwing007];
        LeftWing.loop = YES;
        
        RightWing = [SPMovieClip movieWithFrame:tRwing000 fps:18];
        [RightWing addFrame:tRwing001];
        [RightWing addFrame:tRwing002];
        [RightWing addFrame:tRwing003];
        [RightWing addFrame:tRwing004];
        [RightWing addFrame:tRwing005];
        [RightWing addFrame:tRwing006];
        [RightWing addFrame:tRwing007];
        RightWing.loop = YES;
        
        Body = [SPMovieClip movieWithFrame:tBody000 fps:8];
        [Body addFrame:tBody001];
        
        [birdJuggler addObject:LeftWing];
        [birdJuggler addObject:RightWing];
        [birdJuggler addObject:Body];
        
        Tail = [SPImage imageWithTexture:tTail];
        Tail.pivotX = Tail.width/2;
        Tail.pivotY = Tail.height - Tail.height*0.2;
        Tail.x = Tail.width/2;
        Tail.y = Tail.height - Tail.height*0.2;
        
        isDizzy = NO;
        
        [bird addChild:Tail];
        [bird addChild:Body];
        [bird addChild:LeftWing];
        [bird addChild:RightWing];
        [self addChild:bird];

    } return self;
}
-(void)advanceTime:(double)seconds
{
    [birdJuggler advanceTime:seconds];
    
}
-(void)turnLeft
{
    SPTween *tailLeft = [SPTween tweenWithTarget:Tail time:1];
    [tailLeft animateProperty:@"rotation" targetValue:PI/6];
    [birdJuggler addObject:tailLeft];
    LeftWing.loop = NO;
    [LeftWing pause];
    LeftWing.currentFrame = 3;
    RightWing.fps = 25;
    RightWing.loop = YES;
    [RightWing play];
}
-(void)turnRight
{
    SPTween *tailRight = [SPTween tweenWithTarget:Tail time:1];
    [tailRight animateProperty:@"rotation" targetValue:-PI/6];
    [birdJuggler addObject:tailRight];
    RightWing.loop = NO;
    [RightWing pause];
    RightWing.currentFrame = 3;
    LeftWing.fps = 25;
    LeftWing.loop = YES;
    [LeftWing play];
    
}
-(void)goStraight
{
    [birdJuggler removeTweensWithTarget:Tail];
    Tail.rotation = 0;
    RightWing.fps = 18;
    LeftWing.fps = 18;
    LeftWing.currentFrame = 0;
    RightWing.currentFrame = 0;
    LeftWing.loop = YES;
    RightWing.loop = YES;
    [LeftWing play];
    [RightWing play];
}
-(void)dizzyBird
{
    if (!isDizzy) {
    SPTween *dizzy = [SPTween tweenWithTarget:bird time:0.1];
    [dizzy animateProperty:@"alpha" targetValue:0.2];
    dizzy.loop = SPLoopTypeReverse;
    [birdJuggler addObject:dizzy];
    isDizzy = YES;
    }
}
-(void)undizzyBird
{
    [birdJuggler removeTweensWithTarget:bird];
    bird.alpha = 1;
    isDizzy = NO;
}
-(void)makeShadow
{
    LeftWing.color = 0x000000;
    RightWing.color = 0x000000;
    Body.color = 0x000000;
    Tail.color = 0x000000;
    bird.alpha = 0.2;
}
-(void)moveShadowX:(float)birdX
{
    bird.x = birdX;
}
-(void)moveShadowY:(float)birdY
{
    bird.y = birdY;
}
@end
