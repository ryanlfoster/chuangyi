//
//  RootViewController.m
//  magzine2
//
//  Created by hongquan on 1/24/13.
//  Copyright (c) 2013 hongquan. All rights reserved.
//

#import "RootViewController.h"
#import "DataViewController.h"
#import "CoverViewController.h"
#import "Publisher.h"

@interface RootViewController ()
@property (strong, nonatomic) UIPopoverController *popover;
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UISlider *slider;

@end

@implementation RootViewController

@synthesize modelController = _modelController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self performSegueWithIdentifier:@"CoverSegue" sender:nil];
    self.scrollView.bouncesZoom = YES;
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self.modelController;
    self.pageViewController.view.frame = self.scrollView.bounds;
    DataViewController *currentViewController;
    if (self.pageViewController.viewControllers.count) {
        currentViewController = self.pageViewController.viewControllers[0];
    }else{
        currentViewController = [self.modelController viewControllerAtIndex:0 storyboard:self.storyboard];
    }
    NSArray *viewControllers = @[currentViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:NULL];
    [self addChildViewController:self.pageViewController];
    [self.scrollView addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    self.view.gestureRecognizers = self.pageViewController.gestureRecognizers;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    [self.view addGestureRecognizer:tap];
    self.slider = [[UISlider alloc]initWithFrame:self.navigationController.toolbar.bounds];
    [self.slider addTarget:self action:@selector(touchDown) forControlEvents:UIControlEventTouchDown];
    [self.slider addTarget:self action:@selector(touchUpInside) forControlEvents:UIControlEventTouchUpInside];
    [self.slider addTarget:self action:@selector(touchUpOutside) forControlEvents:UIControlEventTouchUpOutside];
    [self.slider addTarget:self action:@selector(valueChanged) forControlEvents:UIControlEventValueChanged];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:self.slider];
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    self.toolbarItems = @[left,item,right];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.toolbar.hidden = YES;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    self.navigationController.toolbar.barStyle = UIBarStyleBlackTranslucent;
}

- (void)viewDidAppear:(BOOL)animated
{
    self.scrollView.contentSize = self.view.bounds.size;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"CoverSegue"]) {
        CoverViewController *cvc = segue.destinationViewController;
        cvc.cover = self.modelController.coverImage;
    }
}

- (void)touchDown
{
    NSLog(@"touch down");
}

- (void)touchUpInside
{
    NSLog(@"touch up inside");
}

- (void)touchUpOutside
{
    NSLog(@"touch up outside");
}

- (void)valueChanged
{
    NSLog(@"value changed %f",self.slider.value);
    DataViewController *currentViewController = self.pageViewController.viewControllers[0];
    NSUInteger indexOfCurrentViewController = [self.modelController indexOfViewController:currentViewController];
    if (UIDeviceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])) {
        NSInteger index = self.slider.value * (self.modelController.count.integerValue - 1);
        DataViewController *dvc = [self.modelController viewControllerAtIndex:index storyboard:self.storyboard];
        if (index < indexOfCurrentViewController) {
            [self.pageViewController setViewControllers:@[dvc] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:NULL];
        }
        if (index > indexOfCurrentViewController) {
            [self.pageViewController setViewControllers:@[dvc] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];
        }
    }else{
        NSInteger index = self.slider.value * (self.modelController.count.integerValue / 2 - 1);
        NSInteger left = 2 * index;
        NSInteger right = 2 * index + 1;
        DataViewController *ldvc = [self.modelController viewControllerAtIndex:left storyboard:self.storyboard];
        DataViewController *rdvc = [self.modelController viewControllerAtIndex:right storyboard:self.storyboard];
        if (left < indexOfCurrentViewController) {
            [self.pageViewController setViewControllers:@[ldvc,rdvc] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:NULL];
        }
        if (left > indexOfCurrentViewController) {
            [self.pageViewController setViewControllers:@[ldvc,rdvc] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];
        }
    }

}

- (void)tap
{
    NSLog(@"tap");
    self.navigationController.navigationBar.hidden = ! self.navigationController.navigationBar.hidden;
    self.navigationController.toolbar.hidden = ! self.navigationController.toolbar.hidden;
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    self.scrollView.zoomScale = 1.0;
    NSLog(@"%@",[NSValue valueWithCGRect:self.view.bounds]);
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    self.pageViewController.view.frame = self.scrollView.bounds;    
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    self.slider.frame = self.navigationController.toolbar.bounds;
    self.scrollView.contentSize = self.scrollView.bounds.size;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.pageViewController.view;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (ModelController *)modelController
{
     // Return the model controller object, creating it if necessary.
     // In more complex implementations, the model controller may be passed to the view controller.
    if (!_modelController) {
        _modelController = [[ModelController alloc] init];
    }
    return _modelController;
}

#pragma mark - UIPageViewController delegate methods

/*
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    
}
 */

- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.toolbar.hidden = YES;
    DataViewController *currentViewController;
    if (self.pageViewController.viewControllers.count) {
        currentViewController = self.pageViewController.viewControllers[0];
    }else{
        currentViewController = [self.modelController viewControllerAtIndex:0 storyboard:self.storyboard];
    }
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        NSLog(@"Portrait");
        NSArray *viewControllers = @[currentViewController];
        [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];
        self.pageViewController.doubleSided = NO;
        return UIPageViewControllerSpineLocationMin;
    }else{
        NSLog(@"Landscape");
        NSArray *viewControllers = nil;
        NSUInteger indexOfCurrentViewController = [self.modelController indexOfViewController:currentViewController];
        if (indexOfCurrentViewController == 0 || indexOfCurrentViewController % 2 == 0) {
            UIViewController *nextViewController = [self.modelController pageViewController:self.pageViewController viewControllerAfterViewController:currentViewController];
            viewControllers = @[currentViewController, nextViewController];
        } else {
            UIViewController *previousViewController = [self.modelController pageViewController:self.pageViewController viewControllerBeforeViewController:currentViewController];
            viewControllers = @[previousViewController, currentViewController];
        }
        [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];
        return UIPageViewControllerSpineLocationMid;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
    }
    return YES;
}


- (IBAction)subscribe:(id)sender {
    [[Publisher sharedPublisher]subscribe];
}

@end
