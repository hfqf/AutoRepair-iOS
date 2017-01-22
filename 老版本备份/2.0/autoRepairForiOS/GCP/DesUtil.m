//
//  DesUtil.m
//

#import "DesUtil.h"
#import <CommonCrypto/CommonCryptor.h>
#import "ConverUtil.h"
#import "GTMBase64.h"

@implementation DesUtil


static Byte iv[] = {1,2,3,4,5,6,7,8};
/*
 DES加密
 */
+(NSString *) encryptUseDES:(NSString *)clearText key:(NSString *)key
{
    NSString *ciphertext = @"";
    
    NSData *textData = [clearText dataUsingEncoding:NSUTF8StringEncoding];
//  NSLog(@"textData:%@",textData);
    Byte *data = (Byte *)[textData bytes];
 

    NSUInteger dataLength = [clearText length];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                          kCCOptionECBMode,
                                          [key UTF8String], kCCKeySizeDES,
                                          iv,
                                          data	, dataLength,
                                          buffer, 1024,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
//        NSLog(@"DES加密成功");
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
//        NSLog(@"data:%@",data);
//        Byte* bb = (Byte*)[data bytes];
//        NSLog(@"DES数据length %d",data.length);
//        ciphertext = [ConverUtil parseByteArray2HexString:bb length:(data.length)];
        ciphertext = [[NSString alloc] initWithData:[GTMBase64 encodeData:data] encoding:NSUTF8StringEncoding];
    }else{
        NSLog(@"DES加密失败");
    }
    return ciphertext;
}

/**
 DES解密
 */
+(NSString *) decryptUseDES:(NSString *)plainText key:(NSString *)key
{
//    plainText = [ConverUtil parseHexToByteArray:plainText ];
    NSString *cleartext = nil;
    NSData *textData = [ConverUtil parseHexToByteArray:plainText];
//    NSLog(@"textData:%@",textData);
    NSUInteger dataLength = [textData length];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;
    
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmDES,
                                          kCCOptionECBMode,
                                          [key UTF8String], kCCKeySizeDES,
                                          iv,
                                          [textData bytes]	, dataLength,
//                                          textData ,dataLength,
                                          buffer, 1024,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
//        NSLog(@"DES解密成功");
        
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        
//        NSLog(@"data:%@",data);
        cleartext = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        Byte* bb = (Byte*)[data bytes];
//        NSLog(@"DES数据length %d",data.length);
//        cleartext = [ConverUtil parseByteArray2HexString:bb length:(data.length)];
    }else{
        NSLog(@"DES解密失败");
    }
    return cleartext;
}



@end
