//
//  AppViewCell.m
//  KillAllFree
//
//  Created by JackWong on 15/9/23.
//  Copyright (c) 2015年 JackWong. All rights reserved.
//

#import "AppViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIView+Common.h"
#import "IStarsView.h"
@implementation AppViewCell {
    UIImageView *_appIconImageView;
    UILabel *_titleLabel;
    UILabel *_restTimeLabel;
    UILabel *_priceLabel;
    UILabel *_categoryLabel;
    UILabel *_lineLabel;
    UILabel *_shareLabel;
    IStarsView *_iStartsView;
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self customViews];
    }
    return self;
}

- (void)customViews {
    
    _appIconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_appIconImageView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_titleLabel];
    
    _restTimeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_restTimeLabel];
    
    _categoryLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_categoryLabel];
    
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_priceLabel];
    
    _lineLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_lineLabel];
    
    _shareLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_shareLabel];
    
    _iStartsView = [[IStarsView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_iStartsView];
}
- (void)setApplicationModel:(ApplicationModel *)applicationModel {
    _applicationModel = applicationModel;
    [self reloadCell];
}
- (void)reloadCell {

    [_appIconImageView sd_setImageWithURL:[NSURL URLWithString:_applicationModel.iconUrl] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    
    }];
    
//    SDImageCache *imageCache = [SDImageCache sharedImageCache];
//    if ([imageCache diskImageExistsWithKey:_applicationModel.iconUrl]) {
//        [_appIconImageView setImage:[imageCache imageFromDiskCacheForKey:_applicationModel.iconUrl]];
//    } else {
//        [_appIconImageView sd_setImageWithURL:[NSURL URLWithString:_applicationModel.iconUrl] placeholderImage:nil];
//    }
    _titleLabel.text = _applicationModel.name;
    _priceLabel.text = _applicationModel.lastPrice;
    
    _shareLabel.text = [NSString stringWithFormat:@"分享:%@ 收藏:%@ 下载:%@",_applicationModel.shares, _applicationModel.favorites, _applicationModel.downloads];
    [_iStartsView setLevel:[_applicationModel.starCurrent doubleValue]];
    
}
- (void)awakeFromNib {
    // Initialization code
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat leftMargin = 15;
    CGFloat topMargin = 10;
    _appIconImageView.frame = CGRectMake(leftMargin, topMargin, 70, 70);
    _titleLabel.frame = CGRectMake(maxX(_appIconImageView) + 10, minY(_appIconImageView) - 5, width(self.frame) - 130, 25);
    _shareLabel.frame = CGRectMake(leftMargin, maxY(_appIconImageView) + 5, width(self.frame) - 2*leftMargin, 20);
    _priceLabel.frame = CGRectMake(maxX(_shareLabel) - 100, maxY(_titleLabel), 50, 20);
    _categoryLabel.frame = CGRectMake(minX(_priceLabel), maxY(_priceLabel), width(_priceLabel.frame), height(_priceLabel.frame));
    _iStartsView.frame = CGRectMake(maxX(_appIconImageView) + 10 , 60, 65, 23);
    
 
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
