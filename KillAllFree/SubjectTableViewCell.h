//
//  SubjectTableViewCell.h
//  KillAllFree
//
//  Created by JackWong on 15/9/24.
//  Copyright (c) 2015年 JackWong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubjectModel.h"

@class SubjectTableViewCell;
@protocol TouchAppDelegate <NSObject>

- (void)touchAppForCell:(SubjectTableViewCell *)cell applicationId:(NSString *)applicationId;

@end

@interface SubjectTableViewCell : UITableViewCell
/**
 *  每个单元格对应的数据源
 */
@property (nonatomic, strong) SubjectModel *subjectModel;

@property (nonatomic, weak) id<TouchAppDelegate> delegate;

@end
