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
            int width = MAX([[size objectForKey:@"width"] intValue], minSize);
            int height = MAX([[size objectForKey:@"height"] intValue], minSize);
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
            
            SPTexture *treeTexture = [SPTexture textureWithContentsOfFile:[map objectForKey:@"treeTexture"]];
            for (int i = 0; i<100; i++) {
                SPImage *treeImage = [SPImage imageWithTexture:treeTexture];
                treeImage.x = [SPUtils randomIntBetweenMin:0 andMax:width*baseTextureSize-treeImage.width];
                treeImage.y = [SPUtils randomIntBetweenMin:0 andMax:height*baseTextureSize-treeImage.height];
                [self addChild:treeImage];
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

@end
