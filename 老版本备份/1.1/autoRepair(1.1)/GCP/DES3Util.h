//
//  DES3Util.h
//

#import <Foundation/Foundation.h>

#define gkey			@"njxtqgjyptfromlianchuang"
#define gIv             @"01234567"
@interface DES3Util : NSObject {
    
}

// 加密方法
+ (NSString*)encrypt:(NSString*)plainText;

// 解密方法
+ (NSString*)decrypt:(NSString*)encryptText;

@end

