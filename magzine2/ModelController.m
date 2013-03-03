//
//  ModelController.m
//  magzine2
//
//  Created by hongquan on 1/24/13.
//  Copyright (c) 2013 hongquan. All rights reserved.
//

#import "ModelController.h"

#import "DataViewController.h"

/*
 A controller object that manages a simple model -- a collection of month names.
 
 The controller serves as the data source for the page view controller; it therefore implements pageViewController:viewControllerBeforeViewController: and pageViewController:viewControllerAfterViewController:.
 It also implements a custom method, viewControllerAtIndex: which is useful in the implementation of the data source methods, and in the initial configuration of the application.
 
 There is no need to actually create view controllers for each page in advance -- indeed doing so incurs unnecessary overhead. Given the data model, these methods create, configure, and return a new view controller on demand.
 */

@interface ModelController()
@property (strong, nonatomic) NSArray *pageData;
@property (strong, nonatomic) NSString *cover;
@property (strong, nonatomic) MagazineObject *magazine;
@end

@implementation ModelController

- (id)initWithMagazine:(MagazineObject *)magazine;
{
    self = [super init];
    if (self) {
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"index.json" relativeToURL:magazine.issue.contentURL]];
        NSDictionary *index = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",index);
        _count = [index objectForKey:@"count"];
        _cover = [index objectForKey:@"cover"];
        _pageData = [NSArray arrayWithArray:[index objectForKey:@"pages"]];
        _magazine = magazine;
    }
    return self;
}

- (UIImage *)coverImage;
{
    NSURL *URL = [NSURL URLWithString:self.cover relativeToURL:self.magazine.issue.contentURL];
    NSLog(@"%@",URL);
    UIImage *cover = [UIImage imageWithContentsOfFile:URL.path];
    return cover;
}

- (DataViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard
{   
    // Return the data view controller for the given index.
    if (([self.pageData count] == 0) || (index >= [self.pageData count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    DataViewController *dataViewController = [storyboard instantiateViewControllerWithIdentifier:@"DataViewController"];
    dataViewController.dataObject = self.pageData[index];
    dataViewController.magazine = self.magazine;
    return dataViewController;
}

- (NSUInteger)indexOfViewController:(DataViewController *)viewController
{   
     // Return the index of the given data view controller.
     // For simplicity, this implementation uses a static array of model objects and the view controller stores the model object; you can therefore use the model object to identify the index.
    return [self.pageData indexOfObject:viewController.dataObject];
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(DataViewController *)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(DataViewController *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pageData count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

@end
