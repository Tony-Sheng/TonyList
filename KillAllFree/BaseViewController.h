//
//  BaseViewController.h
//  KillAllFree
//
//  Created by JackWong on 15/9/23.
//  Copyright (c) 2015年 JackWong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
/**
 *  自定义导航 Item
 *
 *  @param title     Item title
 *  @param imageName Item 背景
 *  @param frame      Item frame
 *  @param aSelector  点击调用的方法
 *  @param isLeft    在导航左边或右边放
 */
- (void)addBarButtonItemWithTitle:(NSString *)title
                        imageName:(NSString *)imageName
                            frame:(CGRect)frame
                        aSelector:(SEL)aSelector
                           isLeft:(BOOL)isLeft;
@end
