//
//  RAAnimationView.m
//  animationDemo
//
//  Created by iOSzhang Inc on 20/9/14.
//  Copyright © 2020 iOSzhang Inc. All rights reserved.
//

#import "RAAnimationView.h"
#import "RAComposition.h"

@implementation RAAnimationView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (instancetype)initWithContentsOfURL:(NSURL *)url canvasSize:(CGSize)canvasSize {
    self = [self initWithFrame:CGRectZero];
    if (self) {
        //从缓存中获取
        NSString *cacheKey = [NSString stringWithFormat:@"%@-%.02f-%.02f", url.absoluteString, canvasSize.width, canvasSize.height];
        
        LOTComposition *laScene = [[LOTAnimationCache sharedCache] animationForKey:cacheKey];
        if (laScene) {
            laScene.cacheKey = cacheKey;
            [self performSelector:@selector(_initializeAnimationContainer)];
            [self _setupWithSceneModel:laScene];
        } else {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
                NSData *animationData = [NSData dataWithContentsOfURL:url];
                if (!animationData) {
                    return;
                }
                NSError *error;
                NSMutableDictionary *animationJSON = [NSJSONSerialization JSONObjectWithData:animationData options:NSJSONReadingMutableContainers error:&error];
                if (error || !animationJSON) {
                    return;
                }
                
//                animationJSON = [self _reloadAnimationJSON:animationJSON.mutableCopy canvasSize:canvasSize];
                
                RAComposition *laScene = [[RAComposition alloc] initWithJSON:animationJSON withAssetBundle:[NSBundle mainBundle] canvasSize:canvasSize];

                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    [[LOTAnimationCache sharedCache] addAnimation:laScene forKey:cacheKey];
                    laScene.cacheKey = cacheKey;
                    [self performSelector:@selector(_initializeAnimationContainer)];
                    [self _setupWithSceneModel:laScene];
                });
            });
        }
    }
    return self;
}

@end
