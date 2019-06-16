//
//  MINISO_PhototsTool.m
//  MINISOBSA
//
//  Created by miniso_lj on 2019/6/13.
//  Copyright © 2019 Ebenchen. All rights reserved.
//

#import "MINISO_PhototsTool.h"
#import <Photos/Photos.h>

@interface MINISO_PhototsTool ()

@property (nonatomic, copy) NSString *plistName;
@property (nonatomic, copy) NSString *folderName;

@end

@implementation MINISO_PhototsTool

/*
为了满足保存视频/图片到系统相册指定路径，并随时准备删除的变态需求，首先得弄清<Photos/Photos.h>库，保存一般都好说，但是想删除系统相册中的某个图片或者视频，第一印象就根据保存的文件名来进行删除，可是使用过该api之后，发现存在系统相册之后的名字根本就不是你原来存的那个名字，fileName也没有对外提供给你使用，但是它提供了localIdentifier字段，用来唯一标识系统相册中的元素，那么事情就好办了，我们在进行保存图片或者视频的时候，将其localIdentifier缓存到一个plist文件中，然后每次删除的时候，通过对应的文件名找到相应的localIdentifier就可以进行删除了
 */

- (instancetype)initWithFolderName:(NSString *)folderName {
    self = [self init];
    if (self) {
        self.plistName = @"MINISOBSA";
        self.folderName = folderName;
    }
    return self;
}

- (void)saveImagePath:(NSString *)imagePath{
    NSURL *url = [NSURL fileURLWithPath:imagePath];
    
    //标识保存到系统相册中的标识
    __block NSString *localIdentifier;
    
    MINISOWeakSelf;
    //首先获取相册的集合
    PHFetchResult *collectonResuts = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    //对获取到集合进行遍历
    [collectonResuts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        PHAssetCollection *assetCollection = obj;
        //Camera Roll是我们写入照片的相册
        if ([assetCollection.localizedTitle isEqualToString:weakSelf.folderName])  {
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                //请求创建一个Asset
                PHAssetChangeRequest *assetRequest = [PHAssetChangeRequest creationRequestForAssetFromImageAtFileURL:url];
                //请求编辑相册
                PHAssetCollectionChangeRequest *collectonRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
                //为Asset创建一个占位符，放到相册编辑请求中
                PHObjectPlaceholder *placeHolder = [assetRequest placeholderForCreatedAsset];
                //相册中添加照片
                [collectonRequest addAssets:@[placeHolder]];
                
                localIdentifier = placeHolder.localIdentifier;
            } completionHandler:^(BOOL success, NSError *error) {
                if (success) {
                    NSLog(@"保存图片成功!");
                    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[self readFromPlist]];
                    [dict setObject:localIdentifier forKey:[self showFileNameFromPath:imagePath]];
                    [self writeDicToPlist:dict];
                } else {
                    NSLog(@"保存图片失败:%@", error);
                }
            }];
        }
    }];
}

- (void)saveImage:(UIImage *)image imageName:(NSString *)imageName {
    //标识保存到系统相册中的标识
    __block NSString *localIdentifier;
    
    MINISOWeakSelf;
    //首先获取相册的集合
    PHFetchResult *collectonResuts = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    //对获取到集合进行遍历
    [collectonResuts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        PHAssetCollection *assetCollection = obj;
        //Camera Roll是我们写入照片的相册
        if ([assetCollection.localizedTitle isEqualToString:weakSelf.folderName])  {
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                //请求创建一个Asset
                PHAssetChangeRequest *assetRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
                //请求编辑相册
                PHAssetCollectionChangeRequest *collectonRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
                //为Asset创建一个占位符，放到相册编辑请求中
                PHObjectPlaceholder *placeHolder = [assetRequest placeholderForCreatedAsset];
                //相册中添加照片
                [collectonRequest addAssets:@[placeHolder]];
                
                localIdentifier = placeHolder.localIdentifier;
            } completionHandler:^(BOOL success, NSError *error) {
                if (success) {
                    NSLog(@"保存图片成功!");
                    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[self readFromPlist]];
                    [dict setObject:localIdentifier forKey:imageName];
                    [self writeDicToPlist:dict];
                } else {
                    NSLog(@"保存图片失败:%@", error);
                }
            }];
        }
    }];
}

- (void)saveImage:(UIImage *)image imageUrl:(NSString *)imgUrl saveImageBlock:(nonnull SaveImageBlock)saveImageBlock{
    //标识保存到系统相册中的标识
    __block NSString *localIdentifier;
    
    MINISOWeakSelf;
    //首先获取相册的集合
    PHFetchResult *collectonResuts = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    //对获取到集合进行遍历
    [collectonResuts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        PHAssetCollection *assetCollection = obj;
        //Camera Roll是我们写入照片的相册
        if ([assetCollection.localizedTitle isEqualToString:weakSelf.folderName])  {
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                //请求创建一个Asset
                PHAssetChangeRequest *assetRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
                //请求编辑相册
                PHAssetCollectionChangeRequest *collectonRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
                //为Asset创建一个占位符，放到相册编辑请求中
                PHObjectPlaceholder *placeHolder = [assetRequest placeholderForCreatedAsset];
                //相册中添加照片
                [collectonRequest addAssets:@[placeHolder]];
                
                localIdentifier = placeHolder.localIdentifier;
            } completionHandler:^(BOOL success, NSError *error) {
                if (success) {
                    saveImageBlock(YES);
                    NSLog(@"保存图片成功!");
                    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[self readFromPlist]];
                    [dict setObject:localIdentifier forKey:[self showFileNameFromPath:imgUrl]];
                    [weakSelf writeDicToPlist:dict];
                } else {
                    saveImageBlock(NO);
                    NSLog(@"保存图片失败:%@", error);
                }
            }];
        }
    }];
}

- (BOOL)isSavedImageUrl:(NSString *)imgUrl {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[self readFromPlist]];
    NSString *key = [self showFileNameFromPath:imgUrl];
    if ([dict.allKeys containsObject:key]) {
        return YES;
    }
    return NO;
}

- (void)saveVideoPath:(NSString *)videoPath {
    NSURL *url = [NSURL fileURLWithPath:videoPath];
    
    //标识保存到系统相册中的标识
    __block NSString *localIdentifier;
    
    MINISOWeakSelf;
    //首先获取相册的集合
    PHFetchResult *collectonResuts = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    //对获取到集合进行遍历
    [collectonResuts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        PHAssetCollection *assetCollection = obj;
        //folderName是我们写入照片的相册
        if ([assetCollection.localizedTitle isEqualToString:weakSelf.folderName])  {
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                //请求创建一个Asset
                PHAssetChangeRequest *assetRequest = [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:url];
                //请求编辑相册
                PHAssetCollectionChangeRequest *collectonRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
                //为Asset创建一个占位符，放到相册编辑请求中
                PHObjectPlaceholder *placeHolder = [assetRequest placeholderForCreatedAsset];
                //相册中添加视频
                [collectonRequest addAssets:@[placeHolder]];
                
                localIdentifier = placeHolder.localIdentifier;
            } completionHandler:^(BOOL success, NSError *error) {
                if (success) {
                    NSLog(@"保存视频成功!");
                    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[self readFromPlist]];
                    [dict setObject:localIdentifier forKey:[self showFileNameFromPath:videoPath]];
                    [self writeDicToPlist:dict];
                } else {
                    NSLog(@"保存视频失败:%@", error);
                }
            }];
        }
    }];
}

- (void)deleteFile:(NSString *)filePath {
    if ([self isExistFolder:_folderName]) {
        //获取需要删除文件的localIdentifier
        NSDictionary *dict = [self readFromPlist];
        NSString *localIdentifier = [dict valueForKey:[self showFileNameFromPath:filePath]];
        
        MINISOWeakSelf;
        PHFetchResult *collectonResuts = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
        [collectonResuts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            PHAssetCollection *assetCollection = obj;
            if ([assetCollection.localizedTitle isEqualToString:weakSelf.folderName])  {
                PHFetchResult *assetResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:[PHFetchOptions new]];
                [assetResult enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    PHAsset *asset = obj;
                    if ([localIdentifier isEqualToString:asset.localIdentifier]) {
                        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                            [PHAssetChangeRequest deleteAssets:@[obj]];
                        } completionHandler:^(BOOL success, NSError *error) {
                            if (success) {
                                NSLog(@"删除成功!");
                                NSMutableDictionary *updateDic = [NSMutableDictionary dictionaryWithDictionary:dict];
                                [updateDic removeObjectForKey:[self showFileNameFromPath:filePath]];
                                [self writeDicToPlist:updateDic];
                            } else {
                                NSLog(@"删除失败:%@", error);
                            }
                        }];
                    }
                }];
            }
        }];
    }
}

- (BOOL)isExistFolder:(NSString *)folderName {
    //首先获取用户手动创建相册的集合
    PHFetchResult *collectonResuts = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    
    __block BOOL isExisted = NO;
    //对获取到集合进行遍历
    [collectonResuts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        PHAssetCollection *assetCollection = obj;
        //folderName是我们写入照片的相册
        if ([assetCollection.localizedTitle isEqualToString:folderName])  {
            isExisted = YES;
        }
    }];
    
    return isExisted;
}

- (void)createFolder:(NSString *)folderName {
    if (![self isExistFolder:folderName]) {
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            //添加HUD文件夹
            [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:folderName];
            
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                NSLog(@"创建相册文件夹成功!");
            } else {
                NSLog(@"创建相册文件夹失败:%@", error);
            }
        }];
    }
}

- (void)synLocalPlistAndPhoto {
    
    if ([self isExistFolder:_folderName]) {
        MINISOWeakSelf;
        PHFetchResult *collectonResuts = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
        [collectonResuts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            PHAssetCollection *assetCollection = obj;
            if ([assetCollection.localizedTitle isEqualToString:weakSelf.folderName])  {
                PHFetchResult *assetResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:[PHFetchOptions new]];
                NSMutableArray *identifiers = [NSMutableArray array];
                [assetResult enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    PHAsset *asset = obj;
                    [identifiers addObject:asset.localIdentifier];
                }];
                
                [weakSelf updateLocalPlistWithPhotoIdentifierArray:identifiers];
            }
        }];
    }
}

- (void)updateLocalPlistWithPhotoIdentifierArray:(NSMutableArray *)array {
    //如果本地plist中的identifier没有相册中的，就要删除
    NSDictionary *dict = [self readFromPlist];
    NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithDictionary:dict];
    for (NSString *key in muDic.allKeys) {
        if (![array containsObject:muDic[key]]) {
            [muDic removeObjectForKey:key];
        }
    }
    [self writeDicToPlist:muDic];
}

#pragma mark - setters和getters
- (void)setFolderName:(NSString *)folderName {
    if (!_folderName) {
        _folderName = folderName;
        [self createFolder:folderName];
    }
}

- (void)setPlistName:(NSString *)plistName {
    if (!_plistName) {
        _plistName = plistName;
        
        //创建plist文件，记录path和localIdentifier的对应关系
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        NSString *path = [paths objectAtIndex:0];
        NSString *filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", plistName]];
        NSLog(@"plist路径:%@", filePath);
        NSFileManager* fm = [NSFileManager defaultManager];
        if (![fm fileExistsAtPath:filePath]) {
            BOOL success = [fm createFileAtPath:filePath contents:nil attributes:nil];
            if (!success) {
                NSLog(@"创建plist文件失败!");
            } else {
                NSLog(@"创建plist文件成功!");
            }
        } else {
            NSLog(@"沙盒中已有该plist文件，无需创建!");
        }
    }
}

#pragma mark - 写入plist文件
- (void)writeDicToPlist:(NSDictionary *)dict {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", _plistName]];
    [dict writeToFile:filePath atomically:YES];
}

#pragma mark - 读取plist文件
- (NSDictionary *)readFromPlist {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", _plistName]];
    return [NSDictionary dictionaryWithContentsOfFile:filePath];
}

#pragma mark - 根据路径获取文件名
- (NSString *)showFileNameFromPath:(NSString *)path {
    return [NSString stringWithFormat:@"%@", [[path componentsSeparatedByString:@"/"] lastObject]];
}


@end
