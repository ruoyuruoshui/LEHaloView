//
//  LEHaloView.m
//  LEHaloView
//
//  Created by 陈记权 on 8/4/16.
//  Copyright © 2016 LeEco. All rights reserved.
//

#import "LEHaloView.h"

#import "LEHaloView.h"

@interface LEHaloView ()

@property (nonatomic, assign) BOOL animating;
@property (nonatomic, strong) CAShapeLayer *haloLayer;
@property (nonatomic, strong) CAShapeLayer *centerLayer;
@property (nonatomic, strong) CAReplicatorLayer *replicatorLayer;

@end

@implementation LEHaloView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self _setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _setup];
    }
    return self;
}

- (void)_setup
{
    self.haloLayer = [CAShapeLayer layer];
    
    _haloLayer.frame = CGRectMake(0, 0, 20, 20);
    _haloLayer.position = CGPointMake(CGRectGetWidth(self.bounds) / 2.0f, CGRectGetHeight(self.bounds) / 2.0f);
    
    UIBezierPath *pulsePath = [UIBezierPath bezierPathWithOvalInRect:_haloLayer.bounds];
    _haloLayer.path = pulsePath.CGPath;
    _haloLayer.fillColor = [UIColor redColor].CGColor;
    
    self.centerLayer = [CAShapeLayer layer];
    _centerLayer.frame = CGRectMake(0, 0, 20, 20);
    _centerLayer.position = CGPointMake(CGRectGetWidth(self.bounds) / 2.0f, CGRectGetHeight(self.bounds) / 2.0f);
    _centerLayer.path = pulsePath.CGPath;
    _centerLayer.fillColor = [UIColor redColor].CGColor;
    [self.layer addSublayer:_centerLayer];
    
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    replicatorLayer.frame = _haloLayer.bounds;
    replicatorLayer.instanceCount = 3;
    replicatorLayer.instanceDelay = 1;
    
    [replicatorLayer addSublayer:_haloLayer];
    self.replicatorLayer = replicatorLayer;
    [self.layer insertSublayer:self.replicatorLayer below:_centerLayer];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _haloLayer.position = CGPointMake(CGRectGetWidth(self.bounds) / 2.0f, CGRectGetHeight(self.bounds) / 2.0f);
    _centerLayer.position = _haloLayer.position;
}

- (void)_setupAnimationGroup
{
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[[self _scaleAnimation], [self _opacityAnimation]];
    animationGroup.duration = 3;
    animationGroup.autoreverses = NO;
    animationGroup.repeatCount = CGFLOAT_MAX;
    [self.haloLayer addAnimation:animationGroup forKey:@"pulseAnimation"];
}

- (CABasicAnimation *)_scaleAnimation
{
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.xy"];
    scaleAnimation.fromValue = @1.0f;
    scaleAnimation.toValue = @10.0;
    scaleAnimation.duration = 3;
    
    return scaleAnimation;
}

- (CAKeyframeAnimation *)_opacityAnimation
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    animation.duration = 3;
    animation.values = @[@0.45, @0.45, @0];
    animation.keyTimes = @[@0, @0.2, @1];
    animation.removedOnCompletion = NO;
    
    return animation;
}

- (BOOL)isAnimating
{
    return _animating;
}

- (void)startHalo
{
    if (self.animating) {
        return;
    }
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self _setupAnimationGroup];
    });
    
    _haloLayer.speed = 1.0f;
    _haloLayer.timeOffset = 0.0f;
    _haloLayer.beginTime = 0.0f;
    self.animating = YES;
}

- (void)stopHalo
{
    CFTimeInterval pausedTime = [self.layer convertTime:CACurrentMediaTime() toLayer:nil];
    _haloLayer.speed = 0.0f;
    _haloLayer.timeOffset = pausedTime;
    self.animating = NO;
}

@end
