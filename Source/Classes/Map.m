//
//  Map.m
//  Sparrow vs. Cocos
//
//  Created by Brian Ensor on 9/11/11.
//  Copyright 2011 Brian Ensor Apps. All rights reserved.
//

#import "Map.h"
#import "Screen.h"

@implementation Map

- (id)initWithLevel:(int)level {
    if ((self = [super init])) {
        NSString *levelPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"level_%d", level] ofType:@"plist"];
        if ([[NSFileManager defaultManager] fileExistsAtPath:levelPath]) {
            NSDictionary *map = [NSDictionary dictionaryWithContentsOfFile:levelPath];
            int size = [[map objectForKey:@"size"] intValue];
            int baseTextureSize = [[map objectForKey:@"baseTextureSize"] intValue];
            int minSize = [Screen sharedScreen].width/baseTextureSize;
            int maxSize = 1024/baseTextureSize;
            if (size < minSize) {
                NSLog(@"WARNING: minimum map size of %d, resetting to minimum", minSize);
            }
            if (size > maxSize) {
                NSLog(@"WARNING: maximum map size of %d, resetting to maximum", maxSize);
            }
            int area = size*size;
            
            SPTexture *baseTexture = [SPTexture textureWithContentsOfFile:[map objectForKey:@"baseTexture"]];
            int row = 0;
            int column = 0;
            for (int i = 0; i<area; i++) {
                SPImage *baseImage = [SPImage imageWithTexture:baseTexture];
                baseImage.x = column*baseTextureSize;
                baseImage.y = row*baseTextureSize;
                baseImage.color = 0xCD853F;
                [self addChild:baseImage];
                if (column+1 == size) {
                    row++;
                    column = 0;
                } else {
                    column++;
                }
            }
            int treeMapSize = size/4;
            if([[map objectForKey:@"mapType"] isEqualToString:@"grown"]){
                NSLog(@"grown layout");
                NSMutableArray *M=[[NSMutableArray alloc] init];
                int x,y,i,nx,ny,c;
                //create empty map with size
                for(x=0;x<treeMapSize;x++){
                    [M addObject:[[NSMutableArray alloc] init]];
                    for(y=0;y<treeMapSize;y++){
                        if((x==0)||(x==treeMapSize-1)||(y==0)||(y==treeMapSize-1))
                            [[M objectAtIndex:x] addObject:@"1"];
                        else
                            [[M objectAtIndex:x] addObject:@"0"];
                    }
                }
                // add a seed
                [[M objectAtIndex:treeMapSize/2]  replaceObjectAtIndex:treeMapSize/2 withObject:@"1"];
                //now grow single trees around seed
                i=0;
                do{
                    i++;
                    x = [SPUtils randomIntBetweenMin:1 andMax:treeMapSize-2];
                    y = [SPUtils randomIntBetweenMin:1 andMax:treeMapSize-2];
                    if([[[M objectAtIndex:x] objectAtIndex:y] isEqualToString:@"0"]){
                        c=0;
                        for(nx=x-1;nx<x+2;nx++)
                            for(ny=y-1;ny<y+2;ny++)
                                if((nx!=x)&&(ny!=y))
                                    if([[[M objectAtIndex:nx] objectAtIndex:ny] isEqualToString:@"1"])
                                        c++;
                        if(c==1){
                            [[M objectAtIndex:x] replaceObjectAtIndex:y withObject:@"1"];
                            i=0;
                        }
                    }
                }while(i<area*10);
                //take all those threes out that connect lines
                for(x=1;x<treeMapSize-2;x++)
                    for(y=1;y<treeMapSize-2;y++)
                        if([[[M objectAtIndex:x] objectAtIndex:y] isEqualToString:@"1"]){
                            c=0;
                            for(nx=x-1;nx<x+2;nx++)
                                for(ny=y-1;ny<y+2;ny++)
                                    if((nx!=x)&&(ny!=y))
                                        if([[[M objectAtIndex:nx] objectAtIndex:ny] isEqualToString:@"1"])
                                            c++;
                            if(c>2)
                                [[M objectAtIndex:x] replaceObjectAtIndex:y withObject:@"0"];
                        }
                treeBounds = [[NSMutableArray alloc] init];
                SPTexture *treeTexture = [SPTexture textureWithContentsOfFile:[map objectForKey:@"treeTexture"]];
                for(x=0;x<treeMapSize;x++)
                     for(y=0;y<treeMapSize;y++)
                         if([[[M objectAtIndex:x] objectAtIndex:y] isEqualToString:@"1"])
                         {
                             SPImage *treeImage = [SPImage imageWithTexture:treeTexture];
                             treeImage.x = x*baseTextureSize*4;
                             treeImage.y = y*baseTextureSize*4;
                             [self addChild:treeImage];
                             SPRectangle *bounds = treeImage.bounds;
                             bounds.width -= 10;
                             bounds.height -= 10;
                             bounds.x += 5;
                             bounds.y += 5;
                             [treeBounds addObject:bounds];
                         }
            }
            [self compile];
        }
        else {
            NSLog(@"WARNING: level_%d does not exist", level);
            return nil;
        }
    }
    return self;
}

+ (Map *)mapWithLevel:(int)level {
    return [[[Map alloc] initWithLevel:level] autorelease];
}

- (NSString *)objectCollidingWithBird:(SPDisplayObject *)bird {
    SPRectangle *birdRect = [bird boundsInSpace:self];
    for (SPRectangle *treeRect in treeBounds) {
        float treeRadius = treeRect.width/2;
        SPPoint *treeCenter = [SPPoint pointWithX:treeRect.x+treeRect.width/2 y:treeRect.y+treeRect.height/2];
        SPPoint *birdCenter = [SPPoint pointWithX:birdRect.x+birdRect.width/2 y:birdRect.y+birdRect.height/2];
        if ([SPPoint distanceFromPoint:birdCenter toPoint:treeCenter] < treeRadius+25) {
            return @"tree";
        }
    }
    return nil;
}

-(SPCompiledSprite*) miniMap{
    //loops over treeBounds and creates a miniMap/compiled sprite so that 
    //one can see where the trees are
    SPCompiledSprite *S=[[SPCompiledSprite alloc] init];
    for(SPRectangle *R in treeBounds){
        SPQuad *Q=[SPQuad quadWithWidth:2 height:2];
        Q.color=0x00FF00;
        Q.alpha=0.5;
        Q.x=R.x/(64);
        Q.y=R.y/(64);
        [S addChild:Q];
    }
    [S compile];
    return S;
}


- (void)dealloc {
    [treeBounds release];
    [super dealloc];
}

@end
