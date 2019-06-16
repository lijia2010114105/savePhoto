//
//  MBProgressHUD+MINISOExtensions.m
//  MINISOApp
//
//  Created by Eben chen on 2018/7/11.
//  Copyright © 2018年 Ebenchen. All rights reserved.
//

#import "MBProgressHUD+MINISOExtensions.h"

#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

@implementation MBProgressHUD (MINISOExtensions)

#pragma mark 显示信息
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
    if (view == nil) {
        view = [UIApplication sharedApplication].keyWindow;
    }

    view.backgroundColor = RGBACOLOR(1, 1, 1, 0.5f);
    
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    [view bringSubviewToFront:hud];
    
    hud.detailsLabel.text = text;
    hud.detailsLabel.font = [UIFont systemFontOfSize:16];
    
    // 设置图片
    if (icon.length) {
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
    }

    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = RGBACOLOR(0, 0, 0, 0.8f);
    hud.detailsLabel.textColor = [UIColor whiteColor];
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 2秒之后再消失
    [hud hideAnimated:YES afterDelay:2];
}

#pragma mark 显示错误信息
+ (void)showError:(NSString *)error toView:(UIView *)view{
    [self show:error icon:@"error" view:view];
}

#pragma mark 显示成功信息
+ (void)showSuccess:(NSString *)success toView:(UIView *)view
{
    [self show:success icon:@"success" view:view];
}

#pragma mark 显示无图标提示信息
+ (void)showNoneIconMessage:(NSString *)message toView:(UIView *)view
{
    [self show:message icon:nil view:view];
}

#pragma mark 显示一些信息
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view {
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    [view bringSubviewToFront:hud];
    hud.detailsLabel.text = message;
    hud.detailsLabel.font = [UIFont systemFontOfSize:16];
    
//    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
//    hud.bezelView.backgroundColor = RGBACOLOR(0, 0, 0, 0.8f);
//    hud.detailsLabel.textColor = [UIColor whiteColor];
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
    hud.dimBackground = NO;
    return hud;
}

+ (void)showTipInfoNotIcon:(NSString *)tipInfo {
    [self showNoneIconMessage:tipInfo toView:nil];
}

+ (void)showSuccess:(NSString *)success
{
    [self showSuccess:success toView:nil];
}

+ (void)showSuccessBeforeHide:(NSString *)success {
    [self hideHUD];
    [self showSuccess:success];
}

+ (void)showError:(NSString *)error
{
    [self showError:error toView:nil];
}

+ (void)showErrorBeforeHide:(NSString *)error {
    [self hideHUD];
    [self showError:error];
}

+ (MBProgressHUD *)showMessage:(NSString *)message
{
    return [self showMessage:message toView:nil];
}

+ (MBProgressHUD *)showMessageBefore:(NSString *)message {
    [self hideHUD];
    return [self showMessage:message];
}

+ (void)hideHUDForView:(UIView *)view
{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    [self hideHUDForView:view animated:YES];
}

+ (void)hideHUD
{
    [self hideHUDForView:nil];
}

@end
