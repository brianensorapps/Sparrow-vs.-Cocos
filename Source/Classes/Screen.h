//
//  Screen.h
//  Sparrow vs. Cocos
//
//  Created by Brian Ensor on 9/11/11.
//  Copyright 2011 Brian Ensor Apps. All rights reserved.
//

#import "SPSprite.h"

@interface Screen : SPSprite {
    float mHeight;
    float mWidth;
}

+ (Screen *)sharedScreen;
- (UIInterfaceOrientation)orientation;

@property (nonatomic, readonly) float height;
@property (nonatomic, readonly) float width;

@end
