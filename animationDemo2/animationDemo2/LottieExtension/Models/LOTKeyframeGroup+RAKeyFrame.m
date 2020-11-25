//
//  LOTKeyframeGroup+RAKeyFrame.m
//  animationDemo2
//
//  Created by iOSzhang Inc on 20/9/15.
//  Copyright © 2020 iOSzhang Inc. All rights reserved.
//

#import "LOTKeyframeGroup+RAKeyFrame.h"
#import "RAKeyframe.h"

@implementation LOTKeyframeGroup (RAKeyFrame)

- (instancetype)initWithData:(id)data calculationType:(NSInteger)caType orignSize:(CGSize)orignSize canvasSize:(CGSize)canvasSize {
    self = [super init];
    if (self) {
        if ([data isKindOfClass:[NSDictionary class]] &&
            [(NSDictionary *)data valueForKey:@"k"]) {
            [self buildKeyframesFromData:[(NSDictionary *)data valueForKey:@"k"] calculationType:caType orignSize:orignSize canvasSize:canvasSize layerSize:CGSizeZero];
        } else {
            [self buildKeyframesFromData:data calculationType:caType orignSize:orignSize canvasSize:canvasSize layerSize:CGSizeZero];
        }
    }
    return self;
}

- (instancetype)initWithData:(id)data calculationType:(NSInteger)caType orignSize:(CGSize)orignSize canvasSize:(CGSize)canvasSize layerSize:(CGSize)layerSize {
    self = [super init];
    if (self) {
        if ([data isKindOfClass:[NSDictionary class]] &&
            [(NSDictionary *)data valueForKey:@"k"]) {
            [self buildKeyframesFromData:[(NSDictionary *)data valueForKey:@"k"] calculationType:caType orignSize:orignSize canvasSize:canvasSize layerSize:layerSize];
        } else {
            [self buildKeyframesFromData:data calculationType:caType orignSize:orignSize canvasSize:canvasSize layerSize:layerSize];
        }
    }
    return self;
}

- (void)buildKeyframesFromData:(id)data calculationType:(NSInteger)caType orignSize:(CGSize)orignSize canvasSize:(CGSize)canvasSize layerSize:(CGSize)layerSize {
    if ([data isKindOfClass:[NSArray class]] &&
        [[(NSArray *)data firstObject] isKindOfClass:[NSDictionary class]] &&
        [(NSArray *)data firstObject][@"t"]) {
        // Array of Keyframes
        NSArray *keyframes =  (NSArray *)data;
        NSMutableArray *keys = [NSMutableArray array];
        NSDictionary *previousFrame = nil;
        for (NSDictionary *keyframe in keyframes) {
            NSMutableDictionary *currentFrame = [NSMutableDictionary dictionary];
            if (keyframe[@"t"]) {
                // Set time
                currentFrame[@"t"] = keyframe[@"t"];
            }
            if (keyframe[@"s"]) {
                // Set Value for Keyframe
                currentFrame[@"s"] = keyframe[@"s"];
            } else if (previousFrame[@"e"]) {
                // Set Value for Keyframe
                currentFrame[@"s"] = previousFrame[@"e"];
            }
            if (keyframe[@"o"]) {
                // Set out tangent
                currentFrame[@"o"] = keyframe[@"o"];
            }
            if (previousFrame[@"i"]) {
                currentFrame[@"i"] = previousFrame[@"i"];
            }
            if (keyframe[@"to"]) {
                // Set out tangent
                currentFrame[@"to"] = keyframe[@"to"];
            }
            if (previousFrame[@"ti"]) {
                currentFrame[@"ti"] = previousFrame[@"ti"];
            }
            if (keyframe[@"h"]) {
                currentFrame[@"h"] = keyframe[@"h"];
            }
            RAKeyframe *key = [[RAKeyframe alloc] initWithKeyframe:currentFrame calculationType:caType orignSize:orignSize canvasSize:canvasSize layerSize:layerSize];
            [keys addObject:key];
            previousFrame = keyframe;
        }
        
        [self setValue:keys forKey:@"keyframes"];
//        _keyframes = keys;
    } else {
        RAKeyframe *key = [[RAKeyframe alloc] initWithValue:data calculationType:caType orignSize:orignSize canvasSize:canvasSize layerSize:layerSize];
        [self setValue:@[key] forKey:@"keyframes"];
//        _keyframes = @[key];
    }
}


@end
