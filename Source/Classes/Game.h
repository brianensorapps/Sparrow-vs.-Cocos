//
//  Game.h
//  Sparrow vs. Cocos
//
//  Created by Brian Ensor on 9/11/11.
//  Copyright 2011 Brian Ensor Apps. All rights reserved.
//

#import "SPMovieClip.h"
#import "SPSprite.h"
#import "Map.h"
#import "Bird.h"

@interface Game : SPSprite {
    Map *map;
    Bird *bird;
    Bird *birdShadow;
    BOOL turning;
    BOOL turnDirection;
    SPSprite *world;
    BOOL invertedControls;
    SPJuggler *gameJuggler;
    SPJuggler *movieJuggler;
}

- (id)initWithMap:(Map *)newMap;
- (void)setInvertedControls:(BOOL)inverted;

@end
