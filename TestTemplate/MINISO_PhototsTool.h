//
//  MINISO_PhototsTool.h
//  MINISOBSA
//
//  Created by miniso_lj on 2019/6/13.
//  Copyright © 2019 Ebenchen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define MINISOWeakSelf __weak typeof(self) weakSelf = self;

typedef void(^SaveImageBlock)(BOOL isSaveSuccess);

NS_ASSUME_NONNULL_BEGIN

@interface MINISO_PhototsTool : NSObject

/**
 *  初始化方法
 *
 *  @param folderName 操作的目录文件
 *
 *  @return 操作对象
 */
- (instancetype)initWithFolderName:(NSString *)folderName;

/**
 *  保存图片到系统相册
 *
 *  @param imagePath  保存的图片路径
 */
- (void)saveImagePath:(NSString *)imagePath;


/**
 保存图片到系统相册

 @param image 图片
 @param imageName 图片名称
 */
- (void)saveImage:(UIImage *)image imageName:(NSString *)imageName;


/**
 同步本地plist和相册中的图片（有时候相册中的图片被删除了，这时候本地plist就也要被删除）
 */
- (void)synLocalPlistAndPhoto;

/**
 相册是否保存该图片

 @param imgUrl 图片路径
 @return 是否保存
 */
- (BOOL)isSavedImageUrl:(NSString *)imgUrl;

/**
 保存图片到系统相册

 @param image 图片
 @param imgUrl 图片路径
 */
- (void)saveImage:(UIImage *)image imageUrl:(NSString *)imgUrl saveImageBlock:(SaveImageBlock)saveImageBlock;

/**
 *  保存视频到系统相册
 *
 *  @param videoPath  保存的视频路径
 */
- (void)saveVideoPath:(NSString *)videoPath;

/**
 *  删除系统相册中的文件
 *
 *  @param filePath   文件的路径
 */
- (void)deleteFile:(NSString *)filePath;

@end

NS_ASSUME_NONNULL_END
