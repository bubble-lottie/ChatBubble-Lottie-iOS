//
//  RAKeyframe.h
//  animationDemo2
//
//  Created by iOSzhang Inc on 20/9/17.
//  Copyright © 2020 iOSzhang Inc. All rights reserved.
//

#import "LOTKeyframe.h"

NS_ASSUME_NONNULL_BEGIN

@interface RAKeyframe : LOTKeyframe

- (instancetype)initWithKeyframe:(NSDictionary *)keyframe calculationType:(NSInteger)caType orignSize:(CGSize)orignSize canvasSize:(CGSize)canvasSize layerSize:(CGSize)layerSize;
- (instancetype)initWithValue:(id)value calculationType:(NSInteger)caType orignSize:(CGSize)orignSize canvasSize:(CGSize)canvasSize layerSize:(CGSize)layerSize;

@end

NS_ASSUME_NONNULL_END
