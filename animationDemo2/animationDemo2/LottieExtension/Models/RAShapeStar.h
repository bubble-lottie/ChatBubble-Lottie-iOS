//
//  RAShapeStar.h
//  animationDemo2
//
//  Created by iOSzhang Inc on 20/9/17.
//  Copyright © 2020 iOSzhang Inc. All rights reserved.
//

#import "LOTShapeStar.h"

NS_ASSUME_NONNULL_BEGIN

@interface RAShapeStar : LOTShapeStar

@property (nonatomic, readonly) NSNumber *transformationMode;

- (instancetype)initWithJSON:(NSDictionary *)jsonDictionary orignSize:(CGSize)orignSize canvasSize:(CGSize)canvasSize;

@end

NS_ASSUME_NONNULL_END
