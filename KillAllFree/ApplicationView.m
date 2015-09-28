//
//  ApplicationView.m
//  KillAllFree
//
//  Created by JackWong on 15/9/24.
//  Copyright (c) 2015年 JackWong. All rights reserved.
//

#import "ApplicationView.h"
#import "IStarsView.h"
#import "UIView+Common.h"
#import <SDWebImage/UIImageView+WebCache.h>
@implementation ApplicationView {
    UIImageView *_appIconimageView;
    UILabel *_titleLabel;
    IStarsView *_iStartView;
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self customViews];
    }
    return self;
}
- (void)customViews {
    _appIconimageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 50, 50)];
    [self addSubview:_appIconimageView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(maxX(_appIconimageView)+ 5, minY(_appIconimageView), width(self.frame)- maxX(_appIconimageView) - 5*2, 20)];
    [self addSubview:_titleLabel];
    
    _iStartView = [[IStarsView alloc] initWithFrame:CGRectMake(minX(_titleLabel), maxY(_titleLabel) + 25, 65, 23)];
    [self addSubview:_iStartView];
    
}
- (void)setAppModel:(SubAppModel *)appModel {
    _appModel = appModel;
    [self reloadView];
}
- (void)reloadView {
    _titleLabel.text = _appModel.name;
    [_appIconimageView sd_setImageWithURL:[NSURL URLWithString:_appModel.iconUrl] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    [_iStartView setLevel:[_appModel.starOverall doubleValue]];
}

- (void)resetPostion {
    _appIconimageView.frame =  CGRectMake(5, 5, 50, 50);
    _titleLabel.frame = CGRectMake(maxX(_appIconimageView)+ 5, minY(_appIconimageView), width(self.frame)- maxX(_appIconimageView) - 5*2, 20);
    _iStartView.frame = CGRectMake(minX(_titleLabel), maxY(_titleLabel) + 15, 65, 23);
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
