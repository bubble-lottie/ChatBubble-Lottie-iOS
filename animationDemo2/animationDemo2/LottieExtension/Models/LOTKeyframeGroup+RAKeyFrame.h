//
//  LOTKeyframeGroup+RAKeyFrame.h
//  animationDemo2
//
//  Created by iOSzhang Inc on 20/9/15.
//  Copyright © 2020 iOSzhang Inc. All rights reserved.
//

#import "LOTKeyframe.h"

NS_ASSUME_NONNULL_BEGIN

@interface LOTKeyframeGroup (RAKeyFrame)

- (instancetype)initWithData:(id)data calculationType:(NSInteger)caType orignSize:(CGSize)orignSize canvasSize:(CGSize)canvasSize;

- (instancetype)initWithData:(id)data calculationType:(NSInteger)caType orignSize:(CGSize)orignSize canvasSize:(CGSize)canvasSize layerSize:(CGSize)layerSize;

@end

NS_ASSUME_NONNULL_END
