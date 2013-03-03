//
//  MagazineObject.m
//  magzine2
//
//  Created by hongquan on 1/29/13.
//  Copyright (c) 2013 hongquan. All rights reserved.
//

#import "MagazineObject.h"
#import "ZipArchive.h"

@implementation MagazineObject

- (void)leftButton:(id)sender
{
    NSLog(@"left");
}

- (id)initWithDictionary:(NSDictionary *)dict andURL:(NSURL *)URL
{
    self = [super init];
    if (self) {
        NSString *name = [dict objectForKey:@"Name"];
        NSString *title = [dict objectForKey:@"Title"];
        NSNumber *date = [dict objectForKey:@"Date"];
        NSString *cover = [dict objectForKey:@"Cover"];
        NSString *content = [dict objectForKey:@"Content"];
        self.name = name;
        self.title = title;
        self.date = [NSDate dateWithTimeIntervalSince1970:date.integerValue];
        self.cover = [NSURL URLWithString:cover relativeToURL:URL];
        self.content = [NSURL URLWithString:content relativeToURL:URL];
    }
    return self;
}

- (NKIssue *)issue
{
    NKLibrary *library = [NKLibrary sharedLibrary];
    NKIssue *issue = [library issueWithName:self.name];
    if (issue) {
        return issue;
    }else{
        return [library addIssueWithName:self.name date:self.date];
    }
}

- (void)download
{
    self.cell.progressView.hidden = NO;
    NSURLRequest *request = [NSURLRequest requestWithURL:self.content];
    NKAssetDownload *download = [self.issue addAssetWithRequest:request];
    [download downloadWithDelegate:self];
}

- (void)trash
{
    NKLibrary *library = [NKLibrary sharedLibrary];
    [library removeIssue:self.issue];
}

#pragma mark - NSURLConnectionDownloadDelegate

-(void)updateProgressOfConnection:(NSURLConnection *)connection withTotalBytesWritten:(long long)totalBytesWritten expectedTotalBytes:(long long)expectedTotalBytes {
    self.progress = 1.f*totalBytesWritten/expectedTotalBytes;
    self.cell.progressView.progress = self.progress;
    NSLog(@"%f",self.progress);
}

-(void)connection:(NSURLConnection *)connection didWriteData:(long long)bytesWritten totalBytesWritten:(long long)totalBytesWritten expectedTotalBytes:(long long)expectedTotalBytes {
    [self updateProgressOfConnection:connection withTotalBytesWritten:totalBytesWritten expectedTotalBytes:expectedTotalBytes];
}

-(void)connectionDidResumeDownloading:(NSURLConnection *)connection totalBytesWritten:(long long)totalBytesWritten expectedTotalBytes:(long long)expectedTotalBytes {
    [self updateProgressOfConnection:connection withTotalBytesWritten:totalBytesWritten expectedTotalBytes:expectedTotalBytes];
}

-(void)connectionDidFinishDownloading:(NSURLConnection *)connection destinationURL:(NSURL *)destinationURL {
    UILocalNotification *notification = [[UILocalNotification alloc]init];
    notification.soundName = UILocalNotificationDefaultSoundName;
    notification.alertAction = @"创诣";
    notification.alertBody = self.title;
    notification.applicationIconBadgeNumber = 1;
    UIApplication *app = [UIApplication sharedApplication];
    [app presentLocalNotificationNow:notification];
    ZipArchive *zip = [[ZipArchive alloc] init];
    dispatch_queue_t queue = dispatch_queue_create("cn.m9m10.chuangyi", 0);
    self.cell.indicator.hidden = NO;
    self.cell.progressView.hidden = YES;
    [self.cell.indicator startAnimating];
    dispatch_async(queue, ^{
        self.busy = YES;
        [zip UnzipOpenFile:destinationURL.path];
        [zip UnzipFileTo:self.issue.contentURL.path overWrite:YES];
        [zip UnzipCloseFile];
        self.busy = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.cell.indicator stopAnimating];
        });
    });
}

@end
