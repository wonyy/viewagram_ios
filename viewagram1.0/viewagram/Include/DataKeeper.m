//
//  DataKeeper.m
//  Lovitivity
//
//  Created by Wony Shin on 10/19/12.
//  Copyright 2012 Lovitivity. All rights reserved.
//

#import "DataKeeper.h"

#import <CommonCrypto/CommonDigest.h>

@implementation DataKeeper



@synthesize m_strLastErrorMessage;

@synthesize m_dictLocalImageCaches;

- (id)init
{
    self = [super init];
    if (self) {
        
        ////////////////////////////////////////////
        //// Initialize
        ////////////////////////////////////////////

        m_dictLocalImageCaches = [[NSMutableDictionary alloc] init];
        
        
        ////////////////////////////////////////////
    }
    
    return self;
}

- (void)dealloc
{
    if (m_strLastErrorMessage != nil) {
        [m_strLastErrorMessage release];
    }
    
    if (m_dictLocalImageCaches != nil) {
        [m_dictLocalImageCaches release];
    }
    
    [super dealloc];
}


#pragma mark - Image Caching

- (void)CreateThreadDownloadImages {
    [NSThread detachNewThreadSelector:@selector(DownloadImages) toTarget:self withObject:nil];
}

- (void) DownloadImages {
    NSAutoreleasePool *autoreleasePool = [[NSAutoreleasePool alloc] init];
    NSLog(@"Start Downloading....");
    
    [self saveDataToFile];
    [autoreleasePool release];
}


// This functions is to get Image from URL
// If the image isnt in local, download and save to local
// If the image is already in local, use it.

- (UIImage *)getImage: (NSString *) strURL {
    
    if (strURL == nil || [strURL isKindOfClass:[NSString class]] == NO || [strURL isEqualToString:@""]) {
        return nil;
    }
    
    // Get Local URL of image
    NSString *strLocalURL = [m_dictLocalImageCaches objectForKey:strURL];
    
    UIImage *image;
    
    // If image isnt in local, download and save it to local.
    if (strLocalURL == nil || [strLocalURL isEqualToString:@""]) {
        
        // Get image data from URL.
        NSData* imgData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString: 
                                                                 strURL]];
        
        // Generate local file name
        NSString *strFileName = [CUtils generateFileName: NO];
        
        NSString *tempPath = [NSString stringWithFormat:@"%@/%@",[CUtils getDocumentDirectory], strFileName];
        
        // Write Image data as a local file.
        if ([imgData length] != 0) {
            if ([imgData writeToFile:tempPath atomically:YES] == YES) {
                [m_dictLocalImageCaches setObject:tempPath forKey:strURL];
            }
            
            image = [UIImage imageWithData:imgData];
            
            if (!image)
                image = nil;
        } else {
            image = nil;
        }
        
        [imgData release];        
    } else {
        
    // NSLog(@"Local URL = %@", strLocalURL);
    // If image is already in local, use it.
       image = [UIImage imageWithContentsOfFile: strLocalURL];
    }
    
    return image;
}

- (UIImage *)getLocalImage: (NSString *) strURL {
    
    // Get Local URL of image
    NSString *strLocalURL = [m_dictLocalImageCaches objectForKey:strURL];
    
    UIImage *image;
    
    // If image isnt in local, download and save it to local.
    if (strLocalURL == nil || [strLocalURL isEqualToString:@""]) {
        return nil;
    } else {
        // If image is already in local, use it.
        image = [UIImage imageWithContentsOfFile: strLocalURL];
    }
    
    return image;
}


#pragma mark - Local Management

// All datas will be written in local file
// Image List, User Name, User Password, User setting information

- (BOOL)saveDataToFile
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    [dic setValue:m_dictLocalImageCaches forKey:@"images"];
    
    [dic setValue: [NSNumber numberWithBool: _m_bFacebookLink] forKey: @"FBLink"];
    [dic setValue: [NSNumber numberWithBool: _m_bTwitterLink] forKey: @"TwitterLink"];
    
    [dic setValue: [NSNumber numberWithBool: _m_bImageFilter] forKey: @"imagefilter"];
    [dic setValue: [NSNumber numberWithBool: _m_bVideoFilter] forKey: @"videofilter"];

  
    BOOL bSuccess = [dic writeToFile:[self dataFilePath] atomically:YES];
    
    if (bSuccess) {
       // NSLog(@"Write to file successfully. dic=%@", dic);
    } else {
        NSLog(@"Write to file failed");
    }
    
    [dic release];
    
    return bSuccess;
}

- (BOOL)loadDataFromFile
{
    NSString *filePath = [self dataFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:filePath];
        
    //    NSLog(@"LoadDatas!, Dic = %@", dic);
        
        NSDictionary *dict = [dic objectForKey:@"images"];
        
        if (dict != nil && [dict count] > 0) {
            [self setM_dictLocalImageCaches: [dic objectForKey:@"images"]];
        }
        
        NSNumber *numFB = [dic objectForKey:@"FBLink"];
        
        if (numFB != nil) {
            _m_bFacebookLink = [numFB boolValue];
        }
        
        NSNumber *numTwitter = [dic objectForKey:@"TwitterLink"];
        
        if (numTwitter != nil) {
            _m_bTwitterLink = [numTwitter boolValue];
        }
        
        NSNumber *numImageFilter = [dic objectForKey:@"imagefilter"];
        
        if (numImageFilter != nil) {
            _m_bImageFilter = [numImageFilter boolValue];
        } else {
            _m_bImageFilter = YES;
        }
        
        NSNumber *numVideoFilter = [dic objectForKey:@"videofilter"];
        
        if (numVideoFilter != nil) {
            _m_bVideoFilter = [numVideoFilter boolValue];
        } else {
            _m_bVideoFilter = YES;
        }

        
        [dic release];
        return YES;
    } else {
        _m_bVideoFilter = YES;
        _m_bImageFilter = YES;
        
    }
    
    // if file is not exist, set default value
    //[self setServerAddress:[NSString stringWithString:@"http://develop.sweneno.com/index.php/"]];
    
    return NO;
}

- (NSString*)dataFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"viewagram.plist"];
}

@end