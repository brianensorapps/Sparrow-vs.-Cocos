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
        
        birdJuggler = [[SPJuggler alloc] init];
        SPTexture *tSparrow000 = [SPTexture textureWithContentsOfFile:@"Sparrow000.png"];
        SPTexture *tSparrow001 = [SPTexture textureWithContentsOfFile:@"Sparrow001.png"];
        SPTexture *tSparrow002 = [SPTexture textureWithContentsOfFile:@"Sparrow002.png"];
        SPTexture *tSparrow003 = [SPTexture textureWithContentsOfFile:@"Sparrow003.png"];
        SPTexture *tSparrow004 = [SPTexture textureWithContentsOfFile:@"Sparrow004.png"];
        SPTexture *tSparrow005 = [SPTexture textureWithContentsOfFile:@"Sparrow005.png"];
        bird = [SPMovieClip movieWithFrame:tSparrow000 fps:12];
        [bird addFrame:tSparrow001];
        [bird addFrame:tSparrow002];
        [bird addFrame:tSparrow003];
        [bird addFrame:tSparrow004];
        [bird addFrame:tSparrow005];
        bird.loop = YES;
        
        [birdJuggler addObject:bird];
        
        birdShadow = [SPMovieClip movieWithFrame:tSparrow000 fps:12];
        [birdShadow addFrame:tSparrow001];
        [birdShadow addFrame:tSparrow002];
        [birdShadow addFrame:tSparrow003];
        [birdShadow addFrame:tSparrow004];
        [birdShadow addFrame:tSparrow005];
        birdShadow.loop = YES;
        birdShadow.scaleX = 0.5;
        birdShadow.scaleY = 0.5;
        birdShadow.pivotY = birdShadow.height;
        //birdShadow.pivotX = birdShadow.width/2;
        birdShadow.color = 0x000000;
        birdShadow.alpha = 0.5;
        
        [birdJuggler addObject:birdShadow];

        
        birdShadow.x = bird.width/2-birdShadow.width/2;
        birdShadow.y = bird.y;
        
        [self addChild:birdShadow];
        [self addChild:bird];    

    } return self;
}
-(void)advanceTime:(double)seconds
{
    [birdJuggler advanceTime:seconds];
    
}
-(void)moveBirdShadowX:(float)shadowX
{
    birdShadow.x = shadowX;
}
-(void)moveBirdShadowY:(float)shadowY
{
    birdShadow.y = shadowY;
}
-(void)dizzyBird
{
    SPTween *dizzy = [SPTween tweenWithTarget:bird time:0.3];
    [dizzy animateProperty:@"alpha" targetValue:0.3];
    dizzy.loop = SPLoopTypeReverse;
    [birdJuggler addObject:dizzy];
}
-(void)undizzyBird
{
    [birdJuggler removeTweensWithTarget:bird];
    bird.alpha = 1;
}
@end
