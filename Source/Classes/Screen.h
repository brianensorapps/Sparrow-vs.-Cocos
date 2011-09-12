//
//  Screen.h
//  Sparrow vs. Cocos
//
//  Created by Brian Ensor on 9/11/11.
//  Copyright 2011 Brian Ensor Apps. All rights reserved.
//

#import "SPSprite.h"

@interface Screen : SPSprite

+ (Screen *)sharedScreen;
- (UIInterfaceOrientation)orientation;

@end
