//
//  RABezierData.h
//  animationDemo2
//
//  Created by iOSzhang Inc on 20/9/17.
//  Copyright © 2020 iOSzhang Inc. All rights reserved.
//

#import "LOTBezierData.h"

NS_ASSUME_NONNULL_BEGIN

@interface RABezierData : LOTBezierData

@property (nonatomic, readonly) NSNumber *transformationMode;

- (instancetype)initWithData:(NSDictionary *)bezierData orignSize:(CGSize)orignSize canvasSize:(CGSize)canvasSize;

@end

NS_ASSUME_NONNULL_END
