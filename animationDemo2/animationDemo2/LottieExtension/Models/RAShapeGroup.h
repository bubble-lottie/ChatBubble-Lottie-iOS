//
//  RAShapeGroup.h
//  animationDemo2
//
//  Created by iOSzhang Inc on 20/9/17.
//  Copyright © 2020 iOSzhang Inc. All rights reserved.
//

#import "LOTShapeGroup.h"

NS_ASSUME_NONNULL_BEGIN

@interface RAShapeGroup : LOTShapeGroup

+ (id)shapeItemWithJSON:(NSDictionary *)itemJSON orignSize:(CGSize)orignSize canvasSize:(CGSize)canvasSize;

@end

NS_ASSUME_NONNULL_END
