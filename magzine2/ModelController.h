//
//  ModelController.h
//  magzine2
//
//  Created by hongquan on 1/24/13.
//  Copyright (c) 2013 hongquan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MagazineObject.h"

@class DataViewController;

@interface ModelController : NSObject <UIPageViewControllerDataSource>
@property (nonatomic, strong) NSNumber *count;
- (UIImage *)coverImage;
- (DataViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;
- (NSUInteger)indexOfViewController:(DataViewController *)viewController;
- (id)initWithMagazine:(MagazineObject *)magazine;
@end
