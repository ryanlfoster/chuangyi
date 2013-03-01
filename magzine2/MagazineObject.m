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

- (NSURL *)zipURL
{
    return [NSURL URLWithString:@"magazine.zip" relativeToURL:self.issue.contentURL];
}

- (NSURL *)folderURL
{
    return [NSURL URLWithString:@"magazine" relativeToURL:self.issue.contentURL];
}

- (void)download
{
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
    // get asset
    self.progress = 1.f*totalBytesWritten/expectedTotalBytes;
    self.cell.progressView.progress = self.progress;
    NSLog(@"%f",self.progress);
}

-(void)connection:(NSURLConnection *)connection didWriteData:(long long)bytesWritten totalBytesWritten:(long long)totalBytesWritten expectedTotalBytes:(long long)expectedTotalBytes {
    [self updateProgressOfConnection:connection withTotalBytesWritten:totalBytesWritten expectedTotalBytes:expectedTotalBytes];
}

-(void)connectionDidResumeDownloading:(NSURLConnection *)connection totalBytesWritten:(long long)totalBytesWritten expectedTotalBytes:(long long)expectedTotalBytes {
    NSLog(@"Resume downloading %f",1.f*totalBytesWritten/expectedTotalBytes);
    [self updateProgressOfConnection:connection withTotalBytesWritten:totalBytesWritten expectedTotalBytes:expectedTotalBytes];
}

-(void)connectionDidFinishDownloading:(NSURLConnection *)connection destinationURL:(NSURL *)destinationURL {
    NSError *moveError=nil;
    if ([[NSFileManager defaultManager] moveItemAtURL:destinationURL toURL:self.zipURL error:&moveError]) {
        ZipArchive* zip = [[ZipArchive alloc] init];
        if( [zip UnzipOpenFile:self.zipURL.path] ) {
            BOOL ret = [zip UnzipFileTo:self.folderURL.path overWrite:YES];
            if( NO==ret ) {
                NSLog(@"unzip error");
            }
            [zip UnzipCloseFile];
        }
    }else{
        NSLog(@"move error %@",moveError);
    }
    // update the Newsstand icon
    UIImage *img = [UIImage imageWithData:[NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:self.cover] returningResponse:nil error:nil]];
    if(img) {
        [[UIApplication sharedApplication] setNewsstandIconImage:img];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    }
}


@end
