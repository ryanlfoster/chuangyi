//
//  MagazineObject.h
//  magzine2
//
//  Created by hongquan on 1/29/13.
//  Copyright (c) 2013 hongquan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NewsstandKit/NewsstandKit.h>
#import "MagazineCell.h"

@class MagazineCell;

@interface MagazineObject : NSObject <NSURLConnectionDownloadDelegate>

- (id)initWithDictionary:(NSDictionary *)dict andURL:(NSURL *)URL;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSURL *cover;
@property (nonatomic, strong) NSURL *content;
@property (nonatomic, strong) NKIssue *issue;
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, readwrite) float progress;
@property (nonatomic, weak) MagazineCell *cell;
@property (nonatomic, readwrite) BOOL busy;
- (void)download;
- (void)trash;
@end
