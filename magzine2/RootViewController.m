//
//  RootViewController.m
//  magzine2
//
//  Created by hongquan on 1/24/13.
//  Copyright (c) 2013 hongquan. All rights reserved.
//

#import "RootViewController.h"
#import "DataViewController.h"

@interface RootViewController ()
@property (strong, nonatomic) UIPopoverController *popover;
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UISlider *slider;

@end

@implementation RootViewController

@synthesize modelController = _modelController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.scrollView.bouncesZoom = NO;
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
    self.slider.minimumValue = 1;
    [self.slider addTarget:self action:@selector(touchDown) forControlEvents:UIControlEventTouchDown];
    [self.slider addTarget:self action:@selector(touchUpInside) forControlEvents:UIControlEventTouchUpInside];
    [self.slider addTarget:self action:@selector(touchUpOutside) forControlEvents:UIControlEventTouchUpOutside];
    [self.slider addTarget:self action:@selector(valueChanged) forControlEvents:UIControlEventValueChanged];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    self.navigationController.toolbar.barStyle = UIBarStyleBlackTranslucent;
}

- (void)viewDidAppear:(BOOL)animated
{
    self.scrollView.contentSize = self.view.bounds.size;
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
    NSLog(@"value changed");
}

- (void)tap
{
    NSLog(@"tap");
    self.navigationController.navigationBar.hidden = ! self.navigationController.navigationBar.hidden;
    self.navigationController.toolbar.alpha = ! self.navigationController.toolbar.alpha;
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    self.scrollView.zoomScale = 1.0;
    NSLog(@"%@",[NSValue valueWithCGRect:self.view.bounds]);
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration:(UIInterfaceOrientation)fromInterfaceOrientation
{
    self.pageViewController.view.frame = self.scrollView.bounds;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
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
    self.navigationController.toolbar.alpha = 0;
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

@end
