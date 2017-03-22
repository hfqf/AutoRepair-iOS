//
//  LocalImageHelper.m
//  JZH_Test
//
//  Created by Points on 13-10-24.
//  Copyright (c) 2013年 Points. All rights reserved.
//

#define MAX_LENGTH_PIC  100

#import "LocalImageHelper.h"
#include <sys/param.h>
#include <sys/mount.h>

@implementation LocalImageHelper

//创建存放图片和音频的文件夹
+ (void)createUploadFileInDocument
{
    NSString *path = [NSString stringWithFormat:@"%@/uploadFile/%@/", [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"],[LoginUserUtil userId] ];
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:path isDirectory:&isDir];
    
    if ( !(isDir == YES && existed == YES) )
    {
       if([fileManager createDirectoryAtPath:[NSString stringWithFormat:@"%@picture",path] withIntermediateDirectories:YES attributes:nil error:nil])
       {
           SpeLog(@"%@创建成功",[NSString stringWithFormat:@"%@picture",path] );
       }
        if([fileManager createDirectoryAtPath:[NSString stringWithFormat:@"%@audio",path] withIntermediateDirectories:YES attributes:nil error:nil])
        {
            SpeLog(@"%@创建成功",[NSString stringWithFormat:@"%@audio",path] );
        }
    }
}


+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
    
}

//保存大图
+ (BOOL)saveOriginalImage:(NSString *)cutedPath withImage:(UIImage *)image error:(NSError *)error

{
    NSData * picData  = UIImageJPEGRepresentation(image, 0.001);
    [picData writeToFile:cutedPath atomically:YES];
    return error == nil;
}


+ (NSString *)saveImage:(UIImage *)tempImage
{
  //  UIImage * newImage = nil;
    //当宽高有个大于MAX_LENGTH_PIC就要进行剪切
//    if(tempImage.size.height > MAX_LENGTH_PIC || tempImage.size.width > MAX_LENGTH_PIC)
//    {
//        CGSize currentSize = CGSizeZero;
//        if(tempImage.size.height > tempImage.size.width)
//        {
//            currentSize = CGSizeMake(tempImage.size.width*MAX_LENGTH_PIC/tempImage.size.height , MAX_LENGTH_PIC);
//        }
//        else
//        {
//            currentSize = CGSizeMake(MAX_LENGTH_PIC , tempImage.size.height*MAX_LENGTH_PIC/tempImage.size.width);
//        }
//        
//        newImage = [self imageWithImageSimple:tempImage scaledToSize:currentSize];
//    }
//    else
//    {
//        newImage = tempImage;
//    }
   // NSData * picData  = UIImageJPEGRepresentation(tempImage, 1);
   // NSString* fullPathToFile = [NSString stringWithFormat:@"%@/%@",[self getStoredFilePath:YES],[self getPicNameFromCurrentTime]];
    
    NSString *fileName = [self getPicNameFromCurrentTime];
    NSString *maxPicPath = [NSString stringWithFormat:@"%@/%@",[self getStoredFilePath:YES],fileName];
    
    NSError *error = nil;
    SpeLog(@"homePath==%@",NSHomeDirectory());
    if([self saveOriginalImage:maxPicPath withImage:tempImage error:error])
    {
        SpeLog(@"大图写入:%@",maxPicPath);
        return maxPicPath;
    }
    else
    {
        SpeLog(@"error:%@",error);
        return nil;
    }
    
//    if([picData writeToFile:fullPathToFile atomically:NO])
//    {
//        return fullPathToFile;
//        SpeLog(@"小图写入:%@",fullPathToFile);
//    }
//    else
//    {
//        return nil;
//    }
}

//按路径保存音频文件
+ (BOOL)saveAudioFileWithFileData:(NSData *)data withPath:(NSString *)filePath;
{
    return [data writeToFile:filePath atomically:NO];
}

//参数决定是图片还是音频
+ (float)lengthOfSavedPictureFileData:(BOOL)isPic
{
    NSString *path = [self getStoredFilePath:isPic];
    return [self folderSizeAtPath:path];
}

//某个总文件夹的所有文件大小 KB
+ (float ) folderSizeAtPath:(NSString*) folderPath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath])
        return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil)
    {
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        
        #if TARGET_IPHONE_SIMULATOR
        if([fileAbsolutePath rangeOfString:@".DS_Store"].length > 0)//模拟器含有的隐藏文件
        {
            continue;
        }
        #endif
        
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0);
}



//具体到某个文件的大小
+ (long long) fileSizeAtPath:(NSString*) filePath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath])
    {
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}


+ (NSString *) freeDiskSpaceInGB
{
    struct statfs buf;
    long long totalSpace = -1;
    if(statfs("/var", &buf) >= 0)
    {
        totalSpace = (long long)(buf.f_bsize * buf.f_bfree);
    }
    NSString * returnStr = nil;
    if(1024*1024> totalSpace >= 1024)
    {
        returnStr = [NSString stringWithFormat:@"%qi K" ,totalSpace/1024/1024/1024];
    }
    else if (1204*1214*1024> totalSpace >=1024*1024)
    {
        returnStr = [NSString stringWithFormat:@"%qi M" ,totalSpace/1024/1024/1024];
        
    }
    else if (totalSpace >=1204*1214*1024)
    {
        returnStr = [NSString stringWithFormat:@"%qi G" ,totalSpace/1024/1024/1024];
    }
    return returnStr;
}

+ (NSString *)MSpaceOfByte:(long long)byte
{
    long  long totalSpace = byte;
    NSString * returnStr = nil;
    if(1214*1024> totalSpace && totalSpace >= 1024)
    {
       return returnStr = [NSString stringWithFormat:@"%1.0f K" ,totalSpace*1.0/1024.0];
    }
    else if (1204*1214*1024> totalSpace && totalSpace>=1214*1024)
    {
       return  returnStr = [NSString stringWithFormat:@"%1.0f M" ,totalSpace*1.0/1024.0/1024.0];
    }
    else if (totalSpace >=1204*1214*1024)
    {
       return returnStr = [NSString stringWithFormat:@"%1.0f G" ,totalSpace*1.0/1024.0/1024.0/1024.0];
    }
    return  returnStr = [NSString stringWithFormat:@"%lld B" ,totalSpace];;
}


+ (NSString *)totalDiskSpaceInGB
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    struct statfs tStats;
    statfs([[paths lastObject] cString], &tStats);
    long long totalSpace = (float)(tStats.f_blocks * tStats.f_bsize);
    
    NSString * returnStr = nil;
    if(1024*1024> totalSpace >= 1024)
    {
        returnStr = [NSString stringWithFormat:@"%qi K" ,totalSpace/1024/1024/1024];
    }
    else if (1204*1214*1024> totalSpace >=1024*1024)
    {
        returnStr = [NSString stringWithFormat:@"%qi M" ,totalSpace/1024/1024/1024];

    }
    else if (totalSpace >=1204*1214*1024)
    {
        returnStr = [NSString stringWithFormat:@"%qi G" ,totalSpace/1024/1024/1024];
    }
    return returnStr;
}


+ (NSString *)getFinalPath:(NSString *)path With:(BOOL)isPic
{
    NSString *localPath = [NSString stringWithFormat:@"%@/uploadFile/%@/%@/%@", [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"],[LoginUserUtil userId],(isPic ?@"picture":@"audio"),path];
    return localPath ;
}


//获取存放路径
+ (NSString *)getStoredFilePath:(BOOL)isPic
{

    NSString *imageDir = [NSString stringWithFormat:@"%@/uploadFile%@/%@", [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"],[LoginUserUtil userId],(isPic ?@"picture":@"audio")];
    return imageDir;
}

//得到剪切过后的image
+ (UIImage *)getImageWithPath : (NSString *)filePath
{
    UIImage *tempImage = [UIImage imageWithContentsOfFile:filePath];
    UIImage *newImage = nil;
    //当宽高有个大于MAX_LENGTH_PIC就要进行剪切
    if(tempImage.size.height > MAX_LENGTH_PIC || tempImage.size.width > MAX_LENGTH_PIC)
    {
        CGSize currentSize = CGSizeZero;
        if(tempImage.size.height > tempImage.size.width)
        {
            currentSize = CGSizeMake(tempImage.size.width*MAX_LENGTH_PIC/tempImage.size.height , MAX_LENGTH_PIC);
        }
        else
        {
            currentSize = CGSizeMake(MAX_LENGTH_PIC , tempImage.size.height*MAX_LENGTH_PIC/tempImage.size.width);
        }
        
        newImage = [self imageWithImageSimple:tempImage scaledToSize:currentSize];
    }
    else
    {
        newImage = tempImage;
    }
    
    return newImage;
}

+ (NSString *)getPicNameFromCurrentTime
{
    NSDate *dateToDay = [NSDate date];//将获得当前时间
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss:SSS"];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [df setLocale:locale];
    NSString *strDate = [df stringFromDate:dateToDay];
    SpeLog(@"getPicNameFromCurrentTime==%@",strDate);
    return [NSString stringWithFormat:@"%@.jpg",strDate];
}

+ (NSString *)getAudioNameFromCurrentTime
{
    NSDate *dateToDay = [NSDate date];//将获得当前时间
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss:SSS"];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [df setLocale:locale];
    NSString *strDate = [df stringFromDate:dateToDay];
    SpeLog(@"getPicNameFromCurrentTime==%@",strDate);
    return [NSString stringWithFormat:@"%@",strDate];
}

//删除文件级内的文件
+ (void)clearSavedFile
{
    NSString * folderPath = [self getStoredFilePath:YES];
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath])
        return ;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    while ((fileName = [childFilesEnumerator nextObject]) != nil)
    {
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        if([fileAbsolutePath rangeOfString:@".DS_Store"].length > 0)//模拟器
        {
            continue;
        }
        [manager  removeItemAtPath:fileAbsolutePath error:nil];
    }
   
    
    
    NSString * audioPath = [self getStoredFilePath:NO];
    if (![manager fileExistsAtPath:audioPath])
        return ;
    childFilesEnumerator = [[manager subpathsAtPath:audioPath] objectEnumerator];
    while ((fileName = [childFilesEnumerator nextObject]) != nil)
    {
        NSString* fileAbsolutePath = [audioPath stringByAppendingPathComponent:fileName];
        if([fileAbsolutePath rangeOfString:@".DS_Store"].length > 0)//模拟器
        {
            continue;
        }
        [manager  removeItemAtPath:fileAbsolutePath error:nil];
    }
}

+ (BOOL)deleteCurrentFile:(NSString *)path
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:path])
    {
        return NO;
    }
    return  [manager  removeItemAtPath:path error:nil];
}



#pragma mark - UiimagePicker
+ (void)selectPhotoFromLibray:(UIViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate> * )pointer
{
    UIImagePickerController  *m_picker = [[UIImagePickerController alloc] init];
    m_picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    m_picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    m_picker.allowsEditing = YES;
    m_picker.delegate = pointer;
    [pointer presentViewController:m_picker animated:YES completion:NULL];

}

+ (void)selectPhotoFromCamera:(UIViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate> *)pointer
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该设备没有拍照功能" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
        return ;
    }
    UIImagePickerController  *m_picker = [[UIImagePickerController alloc] init];
    m_picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    m_picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    m_picker.allowsEditing = YES;
    m_picker.delegate = pointer;
    [pointer presentViewController:m_picker animated:YES completion:NULL];
}



#pragma mark -

//根据url获取这个音频文件得本地数据
+ (NSString *)getPathWithAudioUrl:(NSString *)url
{
    NSString *path = [NSString stringWithFormat:@"%@/%@.spx",[LocalImageHelper getStoredFilePath:NO],url];
    return path;
}

@end

@implementation UIImage(InternalMethod)

- (UIImage*)imageRotatedByDegrees:(CGFloat)degrees
{
    
    CGFloat width = CGImageGetWidth(self.CGImage);
    CGFloat height = CGImageGetHeight(self.CGImage);
    
	CGSize rotatedSize;
    
    rotatedSize.width = width;
    rotatedSize.height = height;
    
	UIGraphicsBeginImageContext(rotatedSize);
	CGContextRef bitmap = UIGraphicsGetCurrentContext();
	CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
	CGContextRotateCTM(bitmap, degrees * M_PI / 180);
	CGContextRotateCTM(bitmap, M_PI);
	CGContextScaleCTM(bitmap, -1.0, 1.0);
	CGContextDrawImage(bitmap, CGRectMake(-rotatedSize.width/2, -rotatedSize.height/2, rotatedSize.width, rotatedSize.height), self.CGImage);
	UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newImage;
}

@end
