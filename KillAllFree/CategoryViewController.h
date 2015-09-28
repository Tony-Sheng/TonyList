//
//  CategoryViewController.h
//  KillAllFree
//
//  Created by JackWong on 15/9/24.
//  Copyright (c) 2015年 JackWong. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^CategoryIdBlock)(NSString *categoryId);

@interface CategoryViewController : BaseViewController

@property (nonatomic, copy) CategoryIdBlock categoryIdBlock;

@end
