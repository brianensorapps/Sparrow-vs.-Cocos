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

+ (Screen *)sharedScreen {
    static Screen *sharedScreen;
    @synchronized(self) {
        if (!sharedScreen) {
            sharedScreen = [[Screen alloc] init];
        }
    }
    return sharedScreen;
}

- (id)init {
    if ((self = [super init])) {
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
