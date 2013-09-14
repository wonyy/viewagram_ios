//
//  CUtils.h
//  Viewagram
//
//  Created by Tan Hui on 06/28/13.
//  Copyright 2013 Viewagram. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CUtils : NSObject {

}

+ (NSString *)getDeviceID;

+ (NSString *)getFilePath:(NSString *)fileName;
+ (BOOL)isFileInDocumentDirectory:(NSString *)fileName;
+ (void)copyFileToDocumentDirectory:(NSString *)fileName;
+ (NSString *)getDocumentDirectory;
+ (NSString *)generateFileName: (BOOL) bMovie;

+ (void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message;

// Time and Date
+ (NSString *)convertToLocalTime:(NSString *)GMTtime;
+ (NSString *)getCurrentTime;
+ (NSInteger) getAge:(NSString *)dateOfBirth;

// image
+ (UIImage *)resizeImage:(UIImage *)image toSize:(CGSize)size;

// iPhone 5
+ (BOOL) isIphone5;

+ (void) makeRoundedText: (UITextField *) textField;
+ (BOOL) IsEmptyString : (NSString *) str;



@end
