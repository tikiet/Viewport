#import "VPUserDetailViewController.h"
#import "VPInfo.h"
#import "VPConnectionDataDepot.h"
#import "TKImageLoader.h"

@interface VPUserDetailViewController ()

@end

@implementation VPUserDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil
                           bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(void)awakeFromNib
{
    CALayer *layer = [CALayer layer];
    layer.backgroundColor = CGColorCreateGenericRGB(1, 1, 1, 1);
    self.view.wantsLayer = YES;
    self.view.layer = layer;
}

-(void)show
{
    
}

-(void)prepare
{
    NSURLRequest *request =
    [NSURLRequest requestWithURL:
     [VPInfo retrieveUserDetailUrlWithUserId:
      [@(self.user.userId) stringValue]]];
    
    NSURLConnection *con =
    [[NSURLConnection alloc] initWithRequest:request
                                    delegate:[[VPConnectionDataDepot alloc]
                                              initWithSuccessBlock:^(NSData *data){
                                                  [self updateData:data];
                                              } failBlock:^(NSError *error){
                                                  NSLog(@"error:%@", error);
                                              }]
                            startImmediately:NO];
    
    [con start];
    
}

-(void)updateData:(NSData*)data
{
    NSDictionary *raw = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    self.user = [[VPUser alloc] initWithDictionary:[raw objectForKey:@"data"]];
    
    self.followers.stringValue = [@(self.user.followerCount) stringValue];
    self.following.stringValue = [@(self.user.followingCount) stringValue];
    self.posts.stringValue = [@(self.user.postCount) stringValue];
    self.bio.stringValue = self.user.bio;
    self.userName.stringValue = self.user.name;
    
    TKImageLoader *loader = [[TKImageLoader alloc] initWithURL:[NSURL URLWithString:self.user.profilePicture]
                                                     imageView:self.profile];
    [loader start];
}
@end
