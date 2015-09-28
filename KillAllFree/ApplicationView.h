//
//  ApplicationView.h
//  KillAllFree
//
//  Created by JackWong on 15/9/24.
//  Copyright (c) 2015年 JackWong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubjectModel.h"
@interface ApplicationView : UIView
@property (nonatomic, strong) SubAppModel *appModel;
- (void)resetPostion;
@end
