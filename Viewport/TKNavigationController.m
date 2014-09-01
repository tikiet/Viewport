#import "TKNavigationController.h"

@interface TKNavigationController ()
{
    NSMutableArray *retainedViewControllers;
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
    NSLog(@"awakeFromNib");
    retainedViewControllers = [[NSMutableArray alloc]init];
    _viewControllers = [[NSMutableArray alloc]init];
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

-(void)moveToTop:(NSViewController *)viewController
{
    NSMutableArray *subviews = [NSMutableArray arrayWithArray:self.view.subviews];
    [subviews removeObject:viewController.view];
    [subviews addObject:viewController.view];
    
    NSMutableArray *viewControllersToDelete = [[NSMutableArray alloc]init];
    NSMutableArray *viewsToDelete = [[NSMutableArray alloc]init];
    for (NSViewController *controller in self.viewControllers) {
        if (![retainedViewControllers containsObject:controller]) {
            [viewControllersToDelete addObject:controller];
            [viewsToDelete addObject:controller.view];
        }
    }
    
    [subviews removeObjectsInArray:viewsToDelete];
    [self.viewControllers removeObjectsInArray:viewControllersToDelete];
    
    self.view.subviews = subviews;
}

-(void)pop
{
    if (![retainedViewControllers containsObject: [self.viewControllers lastObject]]) {
        if ([[self.viewControllers lastObject] respondsToSelector:@selector(willDisappear)]) {
            [[self.viewControllers lastObject] performSelector:@selector(willDisappear) withObject:nil withObject:nil];
        }
        
        [self.viewControllers removeLastObject];
        
        CATransition *transition = [CATransition animation];
        [transition setType:kCATransitionPush];
        [transition setSubtype:kCATransitionFromLeft];
        
        NSView *lastView = [self.view.subviews lastObject];
        
        [self.view setAnimations:[NSDictionary dictionaryWithObject:transition forKey:@"subviews"]];
        [[lastView animator] removeFromSuperview];
    }
}

@end
