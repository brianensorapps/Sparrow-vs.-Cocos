//
//  Game.h
//  Sparrow vs. Cocos
//
//  Created by Brian Ensor on 9/11/11.
//  Copyright 2011 Brian Ensor Apps. All rights reserved.
//

#import "SPSprite.h"
#import "Map.h"

@interface Game : SPSprite {
    Map *map;
    BOOL turning;
    BOOL turnDirection;
    SPQuad *bird;
    SPQuad *positionQuad;
}

- (id)initWithMap:(Map *)newMap;

@end
