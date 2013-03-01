//
//  DataViewController.h
//  magzine2
//
//  Created by hongquan on 1/24/13.
//  Copyright (c) 2013 hongquan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MagazineObject.h"

@interface DataViewController : UIViewController
@property (strong, nonatomic) MagazineObject *magazine;
@property (strong, nonatomic) id dataObject;
@end
