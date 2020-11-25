//
//  RAKeyframe.m
//  animationDemo2
//
//  Created by iOSzhang Inc on 20/9/17.
//  Copyright © 2020 iOSzhang Inc. All rights reserved.
//

#import "RAKeyframe.h"
#import "RABezierData.h"

@implementation RAKeyframe

@synthesize keyframeTime = _keyframeTime;
@synthesize isHold = _isHold;
@synthesize inTangent = _inTangent;
@synthesize outTangent = _outTangent;
@synthesize spatialInTangent = _spatialInTangent;
@synthesize spatialOutTangent = _spatialOutTangent;

@synthesize floatValue = _floatValue;
@synthesize pointValue = _pointValue;
@synthesize sizeValue = _sizeValue;
@synthesize colorValue = _colorValue;
@synthesize pathData = _pathData;
@synthesize arrayValue = _arrayValue;

- (instancetype)initWithKeyframe:(NSDictionary *)keyframe calculationType:(NSInteger)caType orignSize:(CGSize)orignSize canvasSize:(CGSize)canvasSize layerSize:(CGSize)layerSize {
    self = [super init];
    if (self) {
        _keyframeTime = keyframe[@"t"];
        _inTangent = CGPointZero;
        _outTangent = CGPointZero;
        _spatialInTangent = CGPointZero;
        _spatialOutTangent = CGPointZero;
        NSDictionary *timingOutTangent = keyframe[@"o"];
        NSDictionary *timingInTangent = keyframe[@"i"];
        if (timingInTangent) {
            _inTangent = [self _pointFromValueDict:timingInTangent];
        }
        if (timingOutTangent) {
            _outTangent = [self _pointFromValueDict:timingOutTangent];
        }
        if ([keyframe[@"h"] boolValue]) {
            _isHold = YES;
        }
        if (keyframe[@"to"]) {
            NSArray *to = keyframe[@"to"];
            _spatialOutTangent = [self _pointFromValueArray:to];
        }
        if (keyframe[@"ti"]) {
            NSArray *ti = keyframe[@"ti"];
            _spatialInTangent =  [self _pointFromValueArray:ti];
        }
        id data = keyframe[@"s"];
        if (data) {
            [self setupOutputWithData:data calculationType:caType orignSize:orignSize canvasSize:canvasSize layerSize:layerSize];
        }
    }
    return self;
}

- (instancetype)initWithValue:(id)value calculationType:(NSInteger)caType orignSize:(CGSize)orignSize canvasSize:(CGSize)canvasSize layerSize:(CGSize)layerSize {
    self = [super init];
    if (self) {
        _keyframeTime = @0;
        _isHold = YES;
        [self setupOutputWithData:value calculationType:caType orignSize:orignSize canvasSize:canvasSize layerSize:layerSize];
    }
    return self;
}

- (void)setupOutputWithData:(id)data calculationType:(NSInteger)caType orignSize:(CGSize)orignSize canvasSize:(CGSize)canvasSize layerSize:(CGSize)layerSize {
    NSInteger xPty = caType&0x00f;
    NSInteger yPty = (caType&0x0f0) >> 4;
    NSInteger zPty = (caType&0xf00) >> 8;
    
    if ([data isKindOfClass:[NSNumber class]]) {
        _floatValue = [(NSNumber *)data floatValue];
        CGFloat minDeffince = [self minDeffince:canvasSize.width-orignSize.width value:canvasSize.height-orignSize.height];
        CGFloat minRatio = MIN(canvasSize.width/orignSize.width, canvasSize.height/orignSize.height);
        NSLog(@"minDeffince:%lf", minDeffince);
        
        _floatValue = [self resaultValueForType:xPty value:_floatValue diff:minDeffince ratio:minRatio imageOrignSize:layerSize.width];
    }
    if ([data isKindOfClass:[NSArray class]] &&
        [[(NSArray *)data firstObject] isKindOfClass:[NSNumber class]]) {
        NSArray *numberArray = (NSArray *)data;
        if (numberArray.count > 0) {
            CGFloat minDeffince = [self minDeffince:canvasSize.width-orignSize.width value:canvasSize.height-orignSize.height];
            CGFloat minRatio = MIN(canvasSize.width/orignSize.width, canvasSize.height/orignSize.height);
            _floatValue = [self resaultValueForType:xPty value:[(NSNumber *)numberArray[0] floatValue] diff:minDeffince ratio:minRatio imageOrignSize:layerSize.width];
        }
        if (numberArray.count > 1) {
            CGFloat Xdiff = canvasSize.width-orignSize.width;
            CGFloat Ydiff = canvasSize.height-orignSize.height;
            CGFloat XRatio = canvasSize.width/orignSize.width;
            CGFloat YRatio = canvasSize.height/orignSize.height;
            
            CGFloat finishX = (_floatValue = [self resaultValueForType:xPty value:[(NSNumber *)numberArray[0] floatValue] diff:Xdiff ratio:XRatio imageOrignSize:layerSize.width]);
            CGFloat finishY = (_floatValue = [self resaultValueForType:yPty value:[(NSNumber *)numberArray[1] floatValue] diff:Ydiff ratio:YRatio imageOrignSize:layerSize.height]);
            
            _pointValue = CGPointMake(finishX, finishY);
            
            _sizeValue = CGSizeMake(_pointValue.x, _pointValue.y);
        }
        if (numberArray.count > 3) {
            _colorValue = [self _colorValueFromArray:numberArray];
        }
        _arrayValue = numberArray;
    } else if ([data isKindOfClass:[NSArray class]] &&
               [[(NSArray *)data firstObject] isKindOfClass:[NSDictionary class]]) {
        _pathData = [[RABezierData alloc] initWithData:[(NSArray *)data firstObject] orignSize:orignSize canvasSize:canvasSize];
    } else if ([data isKindOfClass:[NSDictionary class]]) {
        _pathData = [[RABezierData alloc] initWithData:data orignSize:orignSize canvasSize:canvasSize];
    }
}

- (CGPoint)_pointFromValueArray:(NSArray *)values {
    CGPoint returnPoint = CGPointZero;
    if (values.count > 1) {
        returnPoint.x = [(NSNumber *)values[0] floatValue];
        returnPoint.y = [(NSNumber *)values[1] floatValue];
    }
    return returnPoint;
}

- (CGPoint)_pointFromValueDict:(NSDictionary *)values {
    NSNumber *xValue = @0, *yValue = @0;
    if ([values[@"x"] isKindOfClass:[NSNumber class]]) {
        xValue = values[@"x"];
    } else if ([values[@"x"] isKindOfClass:[NSArray class]]) {
        xValue = values[@"x"][0];
    }
    
    if ([values[@"y"] isKindOfClass:[NSNumber class]]) {
        yValue = values[@"y"];
    } else if ([values[@"y"] isKindOfClass:[NSArray class]]) {
        yValue = values[@"y"][0];
    }
    
    return CGPointMake([xValue floatValue], [yValue floatValue]);
}

- (UIColor *)_colorValueFromArray:(NSArray<NSNumber *>  *)colorArray {
    if (colorArray.count == 4) {
        BOOL shouldUse255 = NO;
        for (NSNumber *number in colorArray) {
            if (number.floatValue > 1) {
                shouldUse255 = YES;
            }
        }
        return [UIColor colorWithRed:colorArray[0].floatValue / (shouldUse255 ? 255.f : 1.f)
                               green:colorArray[1].floatValue / (shouldUse255 ? 255.f : 1.f)
                                blue:colorArray[2].floatValue / (shouldUse255 ? 255.f : 1.f)
                               alpha:colorArray[3].floatValue / (shouldUse255 ? 255.f : 1.f)];
    }
    return nil;
}

- (CGFloat)minDeffince:(CGFloat)value1 value:(CGFloat)value2 {
    if (fabs(value1)>fabs(value2)) {
        return value1;
    }
    return value2;
}

- (CGFloat)resaultValueForType:(NSInteger)type value:(CGFloat)value diff:(CGFloat)diff ratio:(CGFloat)ratio imageOrignSize:(CGFloat)imageSize {
    switch (type) {
        case 1:{
            //差值计算
            value = value+diff;
        }
            break;
        case 2:{
            //差值计算
            value = value-diff;
        }
            break;
        case 3:{
            //比率计算
            value = value*ratio;
        }
            break;
        case 4:{
            //差值计算
            value = value+diff/2;
        }
            break;
        case 5:{
            //差值计算
            value = value-diff/2;
        }
            break;
        case 6:{
            //图片比例s的修改，
            value = value+diff*100/imageSize;
        }
            break;
    }
    return value;
}

- (void)remapValueWithBlock:(CGFloat (^)(CGFloat inValue))remapBlock {
    _floatValue = remapBlock(_floatValue);
    _pointValue = CGPointMake(remapBlock(_pointValue.x), remapBlock(_pointValue.y));
    _sizeValue = CGSizeMake(remapBlock(_sizeValue.width), remapBlock(_sizeValue.height));
}

@end
