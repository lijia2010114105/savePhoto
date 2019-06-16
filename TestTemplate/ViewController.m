//
//  ViewController.m
//  TestTemplate
//
//  Created by miniso_lj on 2019/6/4.
//  Copyright © 2019 miniso_lj. All rights reserved.
//

#import "ViewController.h"
#import "MINISO_PhototsTool.h"
#import "MINISO_PhototsTool.h"
#import <Photos/Photos.h>
#import "MBProgressHUD+MINISOExtensions.h"

@interface ViewController ()
{
    UIImage *img;
}
@property (nonatomic, strong) MINISO_PhototsTool *photoTool;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self photoAuthorization];
    
    img = [UIImage imageNamed:@"water"];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
    [self.view addSubview:imgView];
    imgView.image = img;
    imgView.backgroundColor = [UIColor yellowColor];
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(100, 350, 100, 50);
    [self.view addSubview:saveBtn];
    [saveBtn setTitle:@"保存图片" forState:UIControlStateNormal];
    saveBtn.backgroundColor = [UIColor yellowColor];
    [saveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(savePhoto) forControlEvents:UIControlEventTouchUpInside];
}

- (void)savePhoto {
    
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusDenied) {
        [self authPhotoAlert];
    } else {
        
        if (!_photoTool) {
            [self createPhotoTool];
        }
        
        NSString *url = @"water";
        
        //先判断相册是否有该图片，有了话就不用在保存到相册了
        if (![_photoTool isSavedImageUrl:url]) {
            [_photoTool saveImage:img imageUrl:url saveImageBlock:^(BOOL isSaveSuccess) {
                if (isSaveSuccess) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [MBProgressHUD showTipInfoNotIcon:@"保存成功!"];
                    });
                } else {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [MBProgressHUD showTipInfoNotIcon:@"保存失败!"];
                    });
                }
            }];
        } else {
            [MBProgressHUD showTipInfoNotIcon:@"该图片已保存!"];
        }
    }
}

- (void)authPhotoAlert {
    MINISOWeakSelf;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"尚未授权" message:@"请先到授权界面授权允许访问相册！" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf authPhoto];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)authPhoto {
    NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if([[UIApplication sharedApplication] canOpenURL:url]) {
        NSURL*url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:url];
    }
}

//相册功能授权
- (void)photoAuthorization {
    //授权成功后在初始化相册文件夹,否则也不能创建成功
    MINISOWeakSelf;
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                [weakSelf createPhotoTool];
            }
        }];
    } else if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized) {
        [self createPhotoTool];
    }
}

- (void)createPhotoTool {
    self.photoTool = [[MINISO_PhototsTool alloc] initWithFolderName:@"test"];
    [self.photoTool synLocalPlistAndPhoto];
}

@end
