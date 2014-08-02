#import "TKNavigationController.h"

@interface TKNavigationController ()
{
    NSMutableArray *retainedViewControllers;
    NSView *innermostSubview;
}
@end

@implementation TKNavigationController

@synthesize viewControllers = _viewControllers;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)awakeFromNib
{
    retainedViewControllers = [[NSMutableArray alloc]init];
    _viewControllers = [[NSMutableArray alloc]init];
    innermostSubview = self.view;
}

-(void)addViewController:(NSViewController *)viewController retain:(BOOL)retain
{
    if(retain){
        [retainedViewControllers addObject:viewController];
    }
    
    [self.viewControllers addObject:viewController];
    
    CATransition *transition = [CATransition animation];
    
    if (!retain) {
        [transition setType:kCATransitionPush];
        [transition setSubtype:kCATransitionFromRight];
    } else {
        [transition setType:kCATransitionFade];
    }
    
    [innermostSubview setAnimations:[NSDictionary dictionaryWithObject:transition forKey:@"subviews"]];
    innermostSubview.wantsLayer = YES;
    [[innermostSubview animator] addSubview:viewController.view];
    
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
    
    innermostSubview = view;
}

-(void)removeFromViewChain:(NSView*)view
{
    NSArray *subviews = view.subviews;
    NSView *superview = view.superview;
    
    [view removeFromSuperview];
    for (NSView *view in subviews) {
        [superview addSubview:view];
    }
}

-(void)moveToTop:(NSViewController *)viewController
{
    [self removeFromViewChain:viewController.view];
    
    NSMutableArray *viewControllersToDelete = [[NSMutableArray alloc] init];
    NSMutableArray *viewsToDelete = [[NSMutableArray alloc]init];
    for (NSViewController *controller in self.viewControllers) {
        if (![retainedViewControllers containsObject:controller]) {
            [viewControllersToDelete addObject:controller];
            [viewsToDelete addObject:controller.view];
        }
    }
    
    for (NSView *view in viewsToDelete) {
        [self removeFromViewChain:view];
    }
    
    [self.viewControllers removeObjectsInArray:viewControllersToDelete];
}

-(void)pop
{
    if (![retainedViewControllers containsObject: [self.viewControllers lastObject]]) {
        [self.viewControllers removeLastObject];
        
        CATransition *transition = [CATransition animation];
        [transition setType:kCATransitionPush];
        [transition setSubtype:kCATransitionFromLeft];
        
        NSView *superView = [innermostSubview superview];
        
        [superView setAnimations:[NSDictionary dictionaryWithObject:transition forKey:@"subviews"]];
        [[innermostSubview animator] removeFromSuperview];
        
        innermostSubview = superView;
    }
}

@end
