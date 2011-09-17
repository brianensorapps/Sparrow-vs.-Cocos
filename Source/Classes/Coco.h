//
//  Coco.h
//  Sparrow vs. Cocos
//
//  Created by Arend Hintze on 17.09.11.
//  Copyright 2011 KGI. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Coco : SPDisplayObjectContainer {
@private
    SPMovieClip *M;
    SPJuggler *animationJuggler;
    SPPoint *target;
    float angle;
    float speed;
}

-(id) initWithTarget:(SPPoint*)newTarget;
-(void) setNewTarget:(SPPoint*)newTarget;

@end
