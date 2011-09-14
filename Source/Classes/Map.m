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
            NSDictionary *size = [map objectForKey:@"size"];
            
            int baseTextureSize = [[map objectForKey:@"baseTextureSize"] intValue];
            int minSize = [Screen sharedScreen].width/baseTextureSize;
            int maxSize = 1024/baseTextureSize;
            int width = [[size objectForKey:@"width"] intValue];
            int height = [[size objectForKey:@"height"] intValue];
            if (width < minSize || height < minSize) {
                NSLog(@"WARNING: minimum map height and width of %d, resetting to minimum", minSize);
            }
            if (width > maxSize || height > maxSize) {
                NSLog(@"WARNING: maximum map height and width of %d, resetting to maximum", maxSize);
            }
            int area = width*height;
            
            SPTexture *baseTexture = [SPTexture textureWithContentsOfFile:[map objectForKey:@"baseTexture"]];
            int row = 0;
            int column = 0;
            for (int i = 0; i<area; i++) {
                SPImage *baseImage = [SPImage imageWithTexture:baseTexture];
                baseImage.x = column*baseTextureSize;
                baseImage.y = row*baseTextureSize;
                baseImage.color = 0xCD853F;
                [self addChild:baseImage];
                if (column+1 == width) {
                    row++;
                    column = 0;
                } else {
                    column++;
                }
            }
            int treeMapWidth=width/4;
            int treeMapHeight=height/4;
            if([[map objectForKey:@"mapType"] isEqualToString:@"grown"]){
                NSLog(@"grown layout");
                NSMutableArray *M=[[NSMutableArray alloc] init];
                int x,y,i,nx,ny,c;
                //create empty map with size
                for(x=0;x<treeMapWidth;x++){
                    [M addObject:[[NSMutableArray alloc] init]];
                    for(y=0;y<treeMapHeight;y++){
                        if((x==0)||(x==treeMapWidth-1)||(y==0)||(y==treeMapHeight-1))
                            [[M objectAtIndex:x] addObject:@"1"];
                        else
                            [[M objectAtIndex:x] addObject:@"0"];
                    }
                }
                // add a seed
                [[M objectAtIndex:treeMapWidth/2]  replaceObjectAtIndex:treeMapHeight/2 withObject:@"1"];
                //now grow single trees around seed
                i=0;
                do{
                    i++;
                    x=1+(rand()%(treeMapWidth-2));
                    y=1+(rand()%(treeMapHeight-2));
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
                }while(i<width*height*10);
                //take all those threes out that connect lines
                for(x=1;x<treeMapWidth-2;x++)
                    for(y=1;y<treeMapHeight-2;y++)
                        if([[[M objectAtIndex:x] objectAtIndex:y] isEqualToString:@"1"]){
                            c=0;
                            for(nx=x-1;nx<x+2;nx++)
                                for(ny=y-1;ny<y+2;ny++)
                                    if((nx!=x)&&(ny!=y))
                                        if([[[M objectAtIndex:nx] objectAtIndex:ny] isEqualToString:@"1"])
                                            c++;
                            if(c>3)
                                [[M objectAtIndex:x] replaceObjectAtIndex:y withObject:@"0"];
                        }
                treeBounds = [[NSMutableArray alloc] init];
                SPTexture *treeTexture = [SPTexture textureWithContentsOfFile:[map objectForKey:@"treeTexture"]];
                for(x=0;x<treeMapHeight;x++)
                     for(y=0;y<treeMapWidth;y++)
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

- (void)dealloc {
    [treeBounds release];
    [super dealloc];
}

@end
