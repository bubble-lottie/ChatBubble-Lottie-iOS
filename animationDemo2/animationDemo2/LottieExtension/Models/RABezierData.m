//
//  RABezierData.m
//  animationDemo2
//
//  Created by iOSzhang Inc on 20/9/17.
//  Copyright © 2020 iOSzhang Inc. All rights reserved.
//

#import "RABezierData.h"
#import "CGGeometry+LOTAdditions.h"

@implementation RABezierData{
    CGPoint *_vertices;
    CGPoint *_inTangents;
    CGPoint *_outTangents;
}

@synthesize count = _count;
@synthesize closed = _closed;

- (instancetype)initWithData:(NSDictionary *)bezierData orignSize:(CGSize)orignSize canvasSize:(CGSize)canvasSize {
    self = [super init];
    if (self) {
        [self initializeData:bezierData orignSize:orignSize canvasSize:canvasSize];
    }
    return self;
}

- (void)dealloc {
    free(_vertices);
    free(_inTangents);
    free(_outTangents);
}

- (CGPoint)vertexAtIndex:(NSInteger)index {
    NSAssert((index < _count &&
              index >= 0),
             @"Lottie: Index out of bounds");
    return _vertices[index];
}

- (CGPoint)inTangentAtIndex:(NSInteger)index {
    NSAssert((index < _count &&
              index >= 0),
             @"Lottie: Index out of bounds");
    return _inTangents[index];
}

- (CGPoint)outTangentAtIndex:(NSInteger)index {
    NSAssert((index < _count &&
              index >= 0),
             @"Lottie: Index out of bounds");
    return _outTangents[index];
}

- (void)initializeData:(NSDictionary *)bezierData orignSize:(CGSize)orignSize canvasSize:(CGSize)canvasSize {
    
    NSArray *pointsArray = bezierData[@"v"];
    NSArray *inTangents = bezierData[@"i"];
    NSArray *outTangents = bezierData[@"o"];
    
    if (bezierData[@"pty"]) {
        _transformationMode = bezierData[@"pty"];
    } else {
        _transformationMode = @0;
    }
    
    if (pointsArray.count == 0) {
        NSLog(@"%s: Warning: shape has no vertices", __PRETTY_FUNCTION__);
        return ;
    }
    
    NSAssert((pointsArray.count == inTangents.count &&
              pointsArray.count == outTangents.count),
             @"Lottie: Incorrect number of points and tangents");
    _count = pointsArray.count;
    _vertices = (CGPoint *)malloc(sizeof(CGPoint) * pointsArray.count);
    _inTangents = (CGPoint *)malloc(sizeof(CGPoint) * pointsArray.count);
    _outTangents = (CGPoint *)malloc(sizeof(CGPoint) * pointsArray.count);
    if (bezierData[@"c"]) {
        _closed = [bezierData[@"c"] boolValue];
    }
    
    CGFloat diffX = canvasSize.width-orignSize.width;
    CGFloat diffY = canvasSize.height-orignSize.height;
    CGFloat XRatio = canvasSize.width/orignSize.width;
    CGFloat YRatio = canvasSize.height/orignSize.height;
    if (_transformationMode.integerValue != 0) {
        
    }
    for (int i = 0; i < pointsArray.count; i ++) {
        CGPoint vertex = [self _vertexAtIndex:i inArray:pointsArray];
        CGPoint outTex = [self _vertexAtIndex:i inArray:outTangents];
        CGPoint inTex = [self _vertexAtIndex:i inArray:inTangents];
        
        NSInteger xPty = _transformationMode.integerValue&0x00f;
        NSInteger yPty = (_transformationMode.integerValue&0x0f0) >> 4;
        NSInteger zPty = (_transformationMode.integerValue&0xf00) >> 8;
        
        CGFloat finishX = [self resaultValueForType:xPty value:vertex.x diff:diffX ratio:XRatio];
        CGFloat finishY = [self resaultValueForType:yPty value:vertex.y diff:diffY ratio:YRatio];
        
        CGFloat inX = inTex.x;
        CGFloat inY = inTex.y;
        CGFloat outX = outTex.x;
        CGFloat outY = outTex.y;
        if (xPty == 3) {
            inX = inX*XRatio;
            outX = outX*XRatio;
        }
        if (yPty == 3) {
            inY = inY*YRatio;
            outY = outY*YRatio;
        }
        
        vertex = CGPointMake(finishX, finishY);
        outTex = CGPointMake(outX, outY);
        inTex = CGPointMake(inX, inY);
       
        CGPoint outTan = LOT_PointAddedToPoint(vertex, outTex);
        CGPoint inTan = LOT_PointAddedToPoint(vertex, inTex);
        // BW BUG Straight Lines - Test Later
        // Bake fix for lines here
        _vertices[i] = vertex;
        _inTangents[i] = inTan;
        _outTangents[i] = outTan;
    }
}

- (CGPoint)_vertexAtIndex:(NSInteger)idx inArray:(NSArray *)points {
    NSAssert((idx < points.count),
             @"Lottie: Vertex Point out of bounds");
    
    NSArray *pointArray = points[idx];
    
    NSAssert((pointArray.count >= 2 &&
              [pointArray.firstObject isKindOfClass:[NSNumber class]]),
             @"Lottie: Point Data Malformed");
    
    return CGPointMake([(NSNumber *)pointArray[0] floatValue], [(NSNumber *)pointArray[1] floatValue]);
}

- (CGFloat)resaultValueForType:(NSInteger)type value:(CGFloat)value diff:(CGFloat)diff ratio:(CGFloat)ratio {
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
//        case 6:{
//            //图片比例s的修改，
//            value = value+diff*100/imageSize;
//        }
//            break;
    }
    return value;
}

@end
