//
//  Coco.h
//  Sparrow vs. Cocos
//
//  Created by Arend Hintze on 17.09.11.
//  Copyright 2011 KGI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Map.h"

@interface Coco : SPDisplayObjectContainer {
@private
    SPMovieClip *M;
    SPJuggler *animationJuggler;
    SPPoint *target,*currentMapPosition;
    NSMutableArray *waypointStack;
    float angle;
    float speed;
}

-(id) initWithPosition:(SPPoint*)startPosition targetPosition:(SPPoint*)targetPosition inMap:(Map*)map;
-(void) setNewTarget:(SPPoint*)newTarget inMap:(Map*)map;
@end
