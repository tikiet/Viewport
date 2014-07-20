#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>

@interface TKNavigationController : NSViewController

@property NSMutableArray *viewControllers;

-(void)addViewController:(NSViewController*) viewController;
-(void)moveToTop:(NSViewController*) viewController;

@end
