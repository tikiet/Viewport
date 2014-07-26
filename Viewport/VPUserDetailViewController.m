#import "VPUserDetailViewController.h"
#import "VPInfo.h"
#import "VPConnectionDataDepot.h"
#import "VPUserDetailPhotoView.h"
#import "TKImageLoader.h"
#import "VPFeed.h"
#import "NS(Attributed)String+Geometrics.h"

@interface VPUserDetailViewController ()
{
    NSMutableArray *recents;
}
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
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    NSNib *nib = [[NSNib alloc]initWithNibNamed:@"VPUserDetailPhotoView" bundle:nil];
    [self.tableView registerNib:nib forIdentifier:@"photo"];
}

-(void)show
{
    
}

-(void)prepare
{
    NSURLRequest *detailRequest =[NSURLRequest requestWithURL:[VPInfo retrieveUserDetailUrlWithUserId:[@(self.user.userId) stringValue]]];
    NSURLConnection *detailConn =
    [[NSURLConnection alloc] initWithRequest:detailRequest
                                    delegate:[[VPConnectionDataDepot alloc]
                                              initWithSuccessBlock:^(NSData *data){
                                                  [self updateUserDetail:data];
                                              } failBlock:^(NSError *error){
                                                  NSLog(@"error:%@", error);
                                              }]];
    
    [detailConn start];
    
    NSURLRequest *recentsRequest = [NSURLRequest requestWithURL:[VPInfo retrieveUserRecentsUrlWithUserId:[@(self.user.userId) stringValue]]];
    NSURLConnection *recentsConn =
    [[NSURLConnection alloc] initWithRequest:recentsRequest
                                    delegate:[[VPConnectionDataDepot alloc]
                                              initWithSuccessBlock:^(NSData*data) {
                                                  [self updateUserRecents:data];
                                              } failBlock:^(NSError *error) {
                                                  NSLog(@"error:%@", error);
                                              }]];
    [recentsConn start];
}

-(void)updateUserDetail:(NSData*)data
{
    NSDictionary *raw = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    self.user = [[VPUser alloc] initWithDictionary:[raw objectForKey:@"data"]];
    
    self.followers.stringValue = [@(self.user.followerCount) stringValue];
    self.following.stringValue = [@(self.user.followingCount) stringValue];
    self.posts.stringValue = [@(self.user.postCount) stringValue];
    self.userName.stringValue = self.user.fullName;
    self.bio.stringValue = self.user.bio;
    
    float height = [self.user.bio heightForWidth:400 font:[NSFont fontWithName:@"Lucida Grande" size:13]];
    NSView *bio = self.bio;
    [self.bio addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[bio(%f)]", height]
                                                                   options:0
                                                                   metrics:nil
                                                                      views:NSDictionaryOfVariableBindings(bio)]];
    TKImageLoader *loader = [[TKImageLoader alloc] initWithURL:[NSURL URLWithString:self.user.profilePicture]
                                                     imageView:self.profile];
    [loader start];
}

-(void)updateUserRecents:(NSData*)data
{
    NSDictionary *raw = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSArray *recentsArray = [raw objectForKey:@"data"];
    
    recents = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in recentsArray) {
        VPFeed *feed = [[VPFeed alloc] initWithDictionray:dic];
        [recents addObject:feed];
    }
    
    [self.tableView reloadData];
}

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    if (recents)
        return (int)ceil(recents.count/3.0);
    return 0;
}

-(NSView*) tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    VPUserDetailPhotoView *photoView = [self.tableView makeViewWithIdentifier:@"photo" owner:self];
    long index = row * 3 + [tableColumn.identifier intValue];
    if (index >= recents.count){
        return nil;
    }
    
    VPFeed *feed = recents[index];
    TKImageLoader *loader = [[TKImageLoader alloc] initWithURL:[NSURL URLWithString: feed.images.lowResolution.url]
                             imageView:photoView.imageView];
    [loader start];
    
    return photoView;
}

-(BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row
{
    return NO;
}
@end
