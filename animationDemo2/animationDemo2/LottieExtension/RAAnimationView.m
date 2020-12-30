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
//            [self performSelector:@selector(_setupWithSceneModel:) withObject:laScene];
//            [self _initializeAnimationContainer];
//            [self _setupWithSceneModel:laScene];
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
//                    [self performSelector:@selector(_setupWithSceneModel:) withObject:laScene];
//                    [self _initializeAnimationContainer];
//                    [self _setupWithSceneModel:laScene];
                });
            });
        }
    }
    return self;
}

- (void)setAnimationWithContentsOfURL:(NSURL *)url cavasSize:(CGSize)canvasSize {
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

//- (NSDictionary *)_reloadAnimationJSON:(NSMutableDictionary *)animationJSON canvasSize:(CGSize)canvasSize {
//    LOTComposition *orScene = [[LOTComposition alloc] initWithJSON:animationJSON withAssetBundle:[NSBundle mainBundle]];
//    //计算画布差值
//    CGFloat differenceW = canvasSize.width-orScene.compBounds.size.width;
//    CGFloat differenceH = canvasSize.height-orScene.compBounds.size.height;
//    //调整画布大小
//    [animationJSON setValue:@(canvasSize.width) forKey:@"w"];
//    [animationJSON setValue:@(canvasSize.height) forKey:@"h"];
//
//    NSArray *layers = [animationJSON valueForKey:@"layers"];
//
//    for (NSMutableDictionary *layerDic in layers) {
//        NSNumber *pty = layerDic[@"pty"];
//        switch (pty.intValue) {
//            case 0:{
//            }
//                break;
//            case 24:{
//                //修改位置
//                NSMutableDictionary *ks = layerDic[@"ks"];
//                NSMutableDictionary *ks_p = ks[@"p"];
//                id ks_p_k = ks_p[@"k"];
//                if ([ks_p_k isKindOfClass:[NSArray class]]) {
//                    NSMutableArray *ks_p_k_array = (NSMutableArray *)ks_p_k;
//                    [ks_p_k_array replaceObjectAtIndex:0 withObject:@(canvasSize.width/2)];
//                    [ks_p_k_array replaceObjectAtIndex:1 withObject:@(canvasSize.height/2)];
//                }
//
//                //修改图形
//                NSMutableArray *shapes = layerDic[@"shapes"];
//                for (NSMutableDictionary *shapeDic in shapes) {
//                    NSNumber *shapePty = shapeDic[@"pty"];
//                    NSString *type = shapeDic[@"ty"];
//                    if ([type isEqualToString:@"gr"]) {
//                        //组合类型
//                    }
//                    switch (shapePty.intValue) {
//                        case 1:{
//                            NSMutableArray *it = shapeDic[@"it"];
//                            for (NSMutableDictionary *itDic in it) {
//                            }
//                        }
//                            break;
//                        case 3:{
//                        }
//                            break;
//                        case 20:{
//                        }
//                            break;
//                        case 24:{
//
//                        }
//                            break;
//                    }
//                }
//            }
//                break;
//        }
//    }
//
////    NSArray *markers = [animationJSON valueForKey:@"markers"];
//
//    return animationJSON;
//}

@end
