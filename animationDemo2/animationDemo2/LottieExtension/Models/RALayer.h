//
//  RALayer.h
//  animationDemo2
//
//  Created by iOSzhang Inc on 20/9/15.
//  Copyright © 2020 iOSzhang Inc. All rights reserved.
//

#import "LOTLayer.h"

NS_ASSUME_NONNULL_BEGIN

@interface RALayer : LOTLayer

@property (nonatomic, readonly) NSNumber *transformationMode;

- (instancetype)initWithJSON:(NSDictionary *)jsonDictionary
              withAssetGroup:(LOTAssetGroup *)assetGroup
               withFramerate:(NSNumber *)framerate
                   orignSize:(CGSize)orignSize
                  canvasSize:(CGSize)canvasSize;

@end

NS_ASSUME_NONNULL_END
