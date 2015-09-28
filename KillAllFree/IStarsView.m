//
//  IStarsView.m
//  KillAllFree
//
//  Created by JackWong on 15/9/23.
//  Copyright (c) 2015年 JackWong. All rights reserved.
//

#import "IStarsView.h"

@implementation IStarsView {
    
    UIImageView *_foregroundView;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self customeViews];
    }
    return self;
}

- (void)customeViews {
    
    UIImageView *backGroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 65, 23)];
    backGroundView.image = [UIImage imageNamed:@"StarsBackground"];
    [self addSubview:backGroundView];
    
    _foregroundView = [[UIImageView alloc] initWithFrame:CGRectZero];
    
    
    _foregroundView.contentMode = UIViewContentModeLeft;
    
    
    _foregroundView.image = [UIImage imageNamed:@"StarsForeground"];
    _foregroundView.clipsToBounds = YES;
    [self addSubview:_foregroundView];
    
}

- (void)setLevel:(double)level {
    _foregroundView.frame = CGRectMake(0, 0, 65*(level/5.0), 23);
}

@end
