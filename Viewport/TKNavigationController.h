#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>

@interface TKNavigationController : NSViewController

@property NSMutableArray *viewControllers;

-(void)addViewController:(NSViewController*) viewController retain:(BOOL)retain;
-(void)moveToTop:(NSViewController*) viewController;

@end
