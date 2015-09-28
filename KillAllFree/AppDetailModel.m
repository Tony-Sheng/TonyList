//
//  AppDetailModel.m
//  KillAllFree
//
//  Created by JackWong on 15/9/25.
//  Copyright (c) 2015年 JackWong. All rights reserved.
//

#import "AppDetailModel.h"

@implementation PhotoModel



@end

@implementation AppDetailModel

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"description":@"appDescription"}];
}
@end
