//
//  Stage.m
//  Sparrow vs. Cocos
//

#import "Stage.h"
#import "Screen.h"
#import "Game.h"
#import "Map.h"

@implementation Stage

- (id)initWithWidth:(float)width height:(float)height
{
    if ((self = [super initWithWidth:width height:height]))
    {
        Screen *screen = [Screen sharedScreen];
        [self addChild:screen];
        
        Game *game = [[Game alloc] initWithMap:[Map mapWithLevel:1]];
        [screen addChild:game];
        [game release];
    }
    return self;
}
@end
