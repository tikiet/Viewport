#import "TKNavigationController.h"

@interface TKNavigationController ()

@end

@implementation TKNavigationController

@synthesize viewControllers;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(void)addViewController:(NSViewController *)viewController
{
    [self.viewControllers addObject:viewControllers];
    CATransition *transition = [CATransition animation];
    [transition setType:kCATransitionPush];
    [transition setSubtype:kCATransitionFromRight];

    [self.view setAnimations:[NSDictionary dictionaryWithObject:transition forKey:@"subviews"]];
    self.view.wantsLayer = YES;
    [[self.view animator] addSubview:viewController.view];
    
    NSView *parent = self.view;
    NSView *view = viewController.view;
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSArray *constraint1 = [NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[view]-(0)-|"
                                                                   options:0
                                                                   metrics:nil
                                                                     views:NSDictionaryOfVariableBindings(view)];
    NSArray *constraint2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[view]-(0)-|"
                                                                   options:0
                                                                   metrics:nil
                                                                     views:NSDictionaryOfVariableBindings(view)];
    
    [parent addConstraints:constraint1];
    [parent addConstraints:constraint2];
    
}

@end
