//
//  SubjectModel.h
//  KillAllFree
//
//  Created by JackWong on 15/9/24.
//  Copyright (c) 2015年 JackWong. All rights reserved.
//

#import "JSONModel.h"

@protocol SubAppModel
@end

@interface SubAppModel : JSONModel
@property (nonatomic, copy) NSString *applicationId;
@property (nonatomic, copy) NSString *downloads;
@property (nonatomic, copy) NSString *iconUrl;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *ratingOverall;
@property (nonatomic, copy) NSString *starOverall;
@end

@interface SubjectModel : JSONModel
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *desc_img;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, strong) NSMutableArray<SubAppModel> *applications;
@end

