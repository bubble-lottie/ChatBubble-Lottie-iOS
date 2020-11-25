//
//  RAComposition.h
//  animationDemo2
//
//  Created by iOSzhang Inc on 20/9/15.
//  Copyright © 2020 iOSzhang Inc. All rights reserved.
//

#import "LOTComposition.h"

NS_ASSUME_NONNULL_BEGIN

@interface RAComposition : LOTComposition

@property (nonatomic, readonly) CGRect originCompBounds;

- (instancetype _Nonnull)initWithJSON:(NSMutableDictionary * _Nullable)jsonDictionary withAssetBundle:(NSBundle * _Nullable)bundle canvasSize:(CGSize)canvasSize;

@end

NS_ASSUME_NONNULL_END
