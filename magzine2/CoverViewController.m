//
//  CoverViewController.m
//  magzine2
//
//  Created by XIA YINCHU on 3/2/13.
//  Copyright (c) 2013 hongquan. All rights reserved.
//

#import "CoverViewController.h"

@interface CoverViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation CoverViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.imageView.image = self.cover;
    [[UIApplication sharedApplication]setNewsstandIconImage:self.cover];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)tap:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidUnload {
    [self setImageView:nil];
    [super viewDidUnload];
}

@end
