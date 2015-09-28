//
//  AppModel.m
//  KillAllFree
//
//  Created by JackWong on 15/9/23.
//  Copyright (c) 2015年 JackWong. All rights reserved.
//

#import "AppModel.h"

@implementation ApplicationModel

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"description": @"appDescription"}];
}
@end

@implementation AppModel

@end
