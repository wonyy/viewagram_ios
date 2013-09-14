//
//  DataKeeper.h
//  Lovitivity
//
//  Created by Wony Shin on 10/19/12.
//  Copyright 2012 Lovitivity. All rights reserved.
//  

#import "SingletonClass.h"

@interface DataKeeper : SingletonClass {
    
    NSString    *m_strLastErrorMessage;
    
    NSMutableDictionary *m_dictLocalImageCaches;
}


@property (nonatomic, retain) NSString    *m_strLastErrorMessage;
@property (nonatomic, retain) NSMutableDictionary *m_dictLocalImageCaches;

@property (nonatomic) BOOL m_bFacebookLink;
@property (nonatomic) BOOL m_bTwitterLink;

@property (nonatomic) BOOL m_bImageFilter;
@property (nonatomic) BOOL m_bVideoFilter;


- (UIImage *)getImage: (NSString *) strURL;
- (UIImage *)getLocalImage: (NSString *) strURL;

- (BOOL)saveDataToFile;
- (BOOL)loadDataFromFile;
- (NSString*)dataFilePath;

- (void) CreateThreadDownloadImages;
- (void) DownloadImages;

@end
