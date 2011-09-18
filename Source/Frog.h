//
//  Coco.h
//  Sparrow vs. Cocos
//
//  Created by Arend Hintze on 17.09.11.
//  Copyright 2011 KGI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Map.h"
#import "SPTween.h"

@interface Frog : SPDisplayObjectContainer {
@private
    SPMovieClip *M;
    SPJuggler *animationJuggler;
    SPPoint *currentPosition;
    NSMutableArray *collisions;
    int direction;
}

-(id) initWithPosition:(SPPoint*)startPosition inMap:(Map*)map;
-(void) makeJump:(SPEvent*)event;
@end
