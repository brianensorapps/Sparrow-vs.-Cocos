//
//  Screen.m
//  Sparrow vs. Cocos
//
//  Created by Brian Ensor on 9/11/11.
//  Copyright 2011 Brian Ensor Apps. All rights reserved.
//

#import "Screen.h"

@implementation Screen

@synthesize height = mHeight;
@synthesize width = mWidth;
@synthesize showsFPS;

+ (Screen *)sharedScreen {
    static Screen *sharedScreen;
    @synchronized(self) {
        if (!sharedScreen) {
            sharedScreen = [[Screen alloc] init];
        }
    }
    return sharedScreen;
}

- (void)onEnterFrame:(SPEnterFrameEvent *)event {
    if (self.showsFPS) {
        frameRateCount++;
        timeCount += event.passedTime;
        if (timeCount >= 1.0f) {
            frameRateText.text = [NSString stringWithFormat:@"FPS: %d", frameRateCount];
            frameRateCount = 0;
            timeCount -= 1.0f;
        }
        if (frameRateText.visible && [self childIndex:frameRateText] != self.numChildren-1) [self addChild:frameRateText];
    }
}

- (void)setShowsFPS:(BOOL)visible {
    frameRateText.visible = visible;
    showsFPS = visible;
}

- (id)init {
    if ((self = [super init])) {
        frameRateText = [SPTextField textFieldWithWidth:100 height:20 text:@"FPS: 60" fontName:@"Helvetica" fontSize:20 color:0xFFFFFF];
        frameRateText.touchable = NO;
        frameRateText.hAlign = SPHAlignLeft;
        frameRateText.vAlign = SPVAlignBottom;
        frameRateText.x = 10;
        frameRateText.y = self.height-frameRateText.height-10;
        [self addChild:frameRateText];
        self.showsFPS = NO;
        [self addEventListener:@selector(onEnterFrame:) atObject:self forType:SP_EVENT_TYPE_ENTER_FRAME];
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    return self;
}

- (void)orientationChanged:(NSNotification *)notification {
    UIDeviceOrientation orientation = [(UIDevice *)notification.object orientation];
    if (orientation != [self orientation]) {
        switch (orientation) {
            case UIDeviceOrientationLandscapeLeft:
                self.rotation = SP_D2R(90);
                self.x = [SPStage mainStage].width;
                self.y = 0;
                [UIApplication sharedApplication].statusBarOrientation = UIInterfaceOrientationLandscapeRight;
                break;
            case UIDeviceOrientationLandscapeRight:
                self.rotation = SP_D2R(-90);
                self.x = 0;
                self.y = [SPStage mainStage].height;
                [UIApplication sharedApplication].statusBarOrientation = UIInterfaceOrientationLandscapeLeft;
                break;
            default:
                break;
        }
    }
}

- (UIInterfaceOrientation)orientation {
    return [UIApplication sharedApplication].statusBarOrientation;
}

- (float)width {
    return [SPStage mainStage].height;
}

- (float)height {
    return [SPStage mainStage].width;
}

@end
