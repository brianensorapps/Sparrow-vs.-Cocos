//
//  Map.h
//  Sparrow vs. Cocos
//
//  Created by Brian Ensor on 9/11/11.
//  Copyright 2011 Brian Ensor Apps. All rights reserved.
//

#import "SPCompiledSprite.h"

@interface Map : SPCompiledSprite {
    NSMutableArray *treeBounds;
    NSMutableArray *collisionMap;
}

- (id)initWithLevel:(int)level;
+ (Map *)mapWithLevel:(int)level;
- (NSString *)objectCollidingWithBird:(SPDisplayObject *)bird;
-(SPCompiledSprite*) miniMap;
@property (retain) NSMutableArray* collisionMap;

@end
