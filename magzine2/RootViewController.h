//
//  RootViewController.h
//  magzine2
//
//  Created by hongquan on 1/24/13.
//  Copyright (c) 2013 hongquan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelController.h"

@interface RootViewController : UIViewController <UIPageViewControllerDelegate, UIScrollViewDelegate>
@property (strong, nonatomic) ModelController *modelController;

@end
