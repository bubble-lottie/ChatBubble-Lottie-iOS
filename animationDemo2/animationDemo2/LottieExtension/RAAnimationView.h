//
//  RAAnimationView.h
//  animationDemo
//
//  Created by iOSzhang Inc on 20/9/14.
//  Copyright © 2020 iOSzhang Inc. All rights reserved.
//

#import "Lottie.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RAAnimationView : LOTAnimationView

- (instancetype)initWithContentsOfURL:(NSURL *)url canvasSize:(CGSize)canvasSize;

@end

NS_ASSUME_NONNULL_END
