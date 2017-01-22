//
//  XXTEncrypt.m
//

#import "XXTEncrypt.h"
#import "CommonCrypto/CommonDigest.h"
#include <CommonCrypto/CommonCryptor.h>
#import "DES3Util.h"
#import "GTMBase64.h"
 

@interface XXTEncrypt ()

@end

int MAXCOUNT = 999999;
//static NSString *SecretKey = @"Rr7KnLAG";//陕西
//static NSString *SecretKey = @"GSXXT72CH";
//static NSString *SecretKey = @"SNXXT72CH"; //甘肃测试
//static NSString *SecretKey = @"GXXXT72CH";   //广西测试
//static NSString *SecretKey = @"V7WoY0yU";//广西正式

//static Byte iv[] = {1,2,3,4,5,6,7,8};
//static NSString *gIv = @"01234567"  ;

@implementation XXTEncrypt
+(NSString *) XXTmd5: (NSString *) inputString
{
       @try {
        const char *cStr = [inputString UTF8String];
        unsigned char result[CC_MD5_DIGEST_LENGTH];
        CC_MD5(cStr, strlen(cStr), result);
        
        return   [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                 result[0], result[1], result[2], result[3],
                 result[4], result[5], result[6], result[7],
                 result[8], result[9], result[10], result[11],
                 result[12], result[13], result[14], result[15]
                 ] uppercaseString];
           


    }
    @catch (NSException *exception) {
        NSLog(@"XXTmd5 exception:%@",exception);
    }
  
  
}

+(NSString *) XXTmd5_base64: (NSString *) inputString
{
    @try {
        inputString= [[NSString alloc] initWithFormat:@"%@%@",inputString,gkey];
        const char *cStr = [inputString UTF8String];
        unsigned char digest[CC_MD5_DIGEST_LENGTH];
        CC_MD5( cStr, strlen(cStr), digest );
        
        NSData * base64 = [[NSData alloc]initWithBytes:digest length:CC_MD5_DIGEST_LENGTH];
        base64 = [GTMBase64 encodeData:base64];
        
        NSString * output = [[NSString alloc] initWithData:base64 encoding:NSUTF8StringEncoding];
//        output = [output lowercaseString];
        return output;
    }
    @catch (NSException *exception) {
        NSLog(@"XXTmd5 exception:%@",exception);
    }
    
    
}






+(NSString *) extendDES: (NSString *) Token
{
    NSString *extend = @"";
    
    NSDate* date = [NSDate date];
    NSDateFormatter * formatter	=   [[NSDateFormatter alloc] init];
    [formatter	setDateFormat:@"yyyyMMddHHmmss"];
    NSString *loctime = [formatter stringFromDate:date];
    int value = arc4random() % MAXCOUNT;
    extend = [NSString stringWithFormat:@"%@,%@,%d",Token,loctime,value];
    NSLog(@"加密前：%@",extend);
    NSString *s = [DES3Util encrypt:extend];
    NSLog(@"加密后：%@",s);
    return s;
    
//    NSData *btsData = [extend dataUsingEncoding:NSUTF8StringEncoding];
//    int len = btsData.length;
//    int n = (8 - len % 8);
//    if (n > 0 && n != 8) {
//        for (int i = 0; i < n; i++)
//            extend = [[NSString alloc] initWithFormat:@"%@ ",extend];
//    }
//    NSString *s = [DES3Util encrypt:extend];
//    NSLog(@"加密后：%@",s);
//    return s;
}

+(NSString *) encodeDES: (NSString *) Token
{
    NSString *extend = Token;
    NSData *btsData = [extend dataUsingEncoding:NSUTF8StringEncoding];
    int len = btsData.length;
    int n = (8 - len % 8);
    if (n > 0 && n != 8) {
        for (int i = 0; i < n; i++)
            extend = [[NSString alloc] initWithFormat:@"%@ ",extend];
    }
    NSString *s = [DES3Util encrypt:extend];

    return s;
}

+(NSString *) decryptDES: (NSString *) Token
{
    NSString *extend = Token;
    NSData *btsData = [extend dataUsingEncoding:NSUTF8StringEncoding];
    int len = btsData.length;
    int n = (8 - len % 8);
    if (n > 0 && n != 8) {
        for (int i = 0; i < n; i++)
            extend = [[NSString alloc] initWithFormat:@"%@ ",extend];
    }
    NSLog(@"extend:%@",extend);
    NSString *s = [DES3Util decrypt:extend];
    
    return s;
}
+(NSString *)getUDID
{
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
    
}

@end

