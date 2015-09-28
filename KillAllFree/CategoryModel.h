//
//  CategoryModel.h
//  KillAllFree
//
//  Created by JackWong on 15/9/24.
//  Copyright (c) 2015年 JackWong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoryModel : NSObject
@property (nonatomic, copy) NSString *categoryCname;
@property (nonatomic, copy) NSString *categoryCount;
@property (nonatomic, copy) NSString *categoryId;
@property (nonatomic, copy) NSString *categoryName;
@property (nonatomic, copy) NSString *down;
@property (nonatomic, copy) NSString *free;
@property (nonatomic, copy) NSString *limited;
@property (nonatomic, copy) NSString *same;
@property (nonatomic, copy) NSString *up;
@property (nonatomic, copy) NSString *picUrl;
@end
