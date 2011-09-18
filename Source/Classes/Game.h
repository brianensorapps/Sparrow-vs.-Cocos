//
//  Game.h
//  Sparrow vs. Cocos
//
//  Created by Brian Ensor on 9/11/11.
//  Copyright 2011 Brian Ensor Apps. All rights reserved.
//

#import "SPSprite.h"
#import "Map.h"
#import "Bird.h"
#import "Coco.h"
#import "Frog.h"

@interface Game : SPSprite {
    Map *map;
    Bird *bird;
    Bird *birdShadow;
    BOOL turning;
    BOOL turnDirection;
    SPSprite *world;
    BOOL invertedControls;
    SPJuggler *gameJuggler;
}

- (id)initWithMap:(Map *)newMap;
- (void)setInvertedControls:(BOOL)inverted;

@end
