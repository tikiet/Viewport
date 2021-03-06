#import "VPUserDetailViewController.h"
#import "VPInfo.h"
#import "VPConnectionDataDepot.h"
#import "VPUserDetailPhotoView.h"
#import "TKImageLoader.h"
#import "VPFeed.h"
#import "NS(Attributed)String+Geometrics.h"
#import "VPRelationship.h"

@interface VPUserDetailViewController ()
{
    NSArray *recents;
    BOOL triggeredBottom;
    BOOL hasMore;
    NSString *nextMaxId;
    VPRelationship *relationship;
}
@end

@implementation VPUserDetailViewController

-(void)awakeFromNib
{
    CALayer *layer = [CALayer layer];
    layer.backgroundColor = CGColorCreateGenericRGB(1, 1, 1, 1);
    self.view.wantsLayer = YES;
    self.view.layer = layer;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    triggeredBottom = NO;
    hasMore = YES;
    
    NSNib *nib = [[NSNib alloc]initWithNibNamed:@"VPUserDetailPhotoView" bundle:nil];
    [self.tableView registerNib:nib forIdentifier:@"photo"];
    id clipView = [[self.tableView enclosingScrollView] contentView];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(boundsChangeNotificationHandler:)
                                                 name:NSViewBoundsDidChangeNotification
                                               object:clipView];
}

- (void)boundsChangeNotificationHandler:(NSNotification *)aNotification
{
    if ([aNotification object] == [[self.tableView enclosingScrollView] contentView]){
        if ( NSMaxY([self.tableView enclosingScrollView].documentVisibleRect) >=
            NSHeight([[self.tableView enclosingScrollView].documentView bounds]) ){
            if (!triggeredBottom) {
                triggeredBottom = YES;
                [self startRequest];
            }
        }
    }
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
    
    NSURLRequest *relationshipRequest = [NSURLRequest requestWithURL:[VPInfo retrieveUserRelationshipWithUserId:[@(self.user.userId) stringValue]]];
    NSURLConnection *relationshipConn =
    [[NSURLConnection alloc] initWithRequest:relationshipRequest delegate:[[VPConnectionDataDepot alloc] initWithSuccessBlock:^(NSData*data) {
        [self updateRelationship:data];
    }failBlock:^(NSError *error) {
        NSLog(@"error:%@", error);
    }]];
    [relationshipConn start];
    
    [self startRequest];
}

-(void)updateRelationship:(NSData*) data
{
    NSDictionary *raw = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSDictionary *meta = [raw objectForKey:@"meta"];
    NSLog(@"raw:%@", raw);
    NSLog(@"meta:%@", meta);
    int code =  [[meta objectForKey:@"code"] intValue];
    if (code != 200) {
        [self reportError:meta];
        return;
    }
    
    relationship = [[VPRelationship alloc] initWithDictionary:[raw objectForKey:@"data"]];
    NSLog(@"relationship.out = %d", relationship.outgoingStatus);
    NSLog(@"relationship.in = %d", relationship.incomingStatus);
    
    if (relationship.incomingStatus == requested_by) {
        self.relationshipButton.title = @"Confirm request";
    } else if (relationship.incomingStatus == blocked_by_you) {
        self.relationshipButton.title = @"Blocked";
    } else if (relationship.outgoingStatus == requested) {
        self.relationshipButton.title = @"Request sent";
    } else if (relationship.outgoingStatus == follows) {
        self.relationshipButton.title = @"Following";
    } else if (relationship.outgoingStatus == none) {
        self.relationshipButton.title = @"Follow";
    }
}

- (IBAction)changeRelationship:(id)sender {
    NSString *action = nil;
    if (relationship) {
        if (relationship.incomingStatus == requested_by) {
            action = @"approve";
        } else if (relationship.incomingStatus == blocked_by_you) {
            action = @"unblock";
        } else if (relationship.outgoingStatus == requested) {
            action = nil;
        } else if (relationship.outgoingStatus == follows) {
            action = @"unfollow";
        } else if (relationship.outgoingStatus == none) {
            action = @"follow";
        }
    }
    
    if (action) {
        NSMutableURLRequest *relationshipRequest = [NSMutableURLRequest requestWithURL:[VPInfo retrieveUserRelationshipWithUserId:[@(self.user.userId) stringValue]]];
        relationshipRequest.HTTPMethod = @"POST";
        relationshipRequest.HTTPBody = [[NSString stringWithFormat:@"action=%@", action] dataUsingEncoding:NSUTF8StringEncoding];
        NSURLConnection *relationshipConn =
        [[NSURLConnection alloc] initWithRequest:relationshipRequest delegate:[[VPConnectionDataDepot alloc] initWithSuccessBlock:^(NSData*data) {
            [self updateRelationship:data];
        }failBlock:^(NSError *error) {
            NSLog(@"error:%@", error);
        }]];
        [relationshipConn start];
    }
}

-(void)updateUserDetail:(NSData*)data
{
    NSDictionary *raw = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSDictionary *meta = [raw objectForKey:@"meta"];
    NSLog(@"meta:%@", meta);
    int code =  [[meta objectForKey:@"code"] intValue];
    if (code != 200) {
        [self reportError:meta];
        return;
    }
    
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
    CALayer *layer = [CALayer layer];
    layer.cornerRadius = 3;
    layer.masksToBounds = YES;
    self.profile.wantsLayer = YES;
    self.profile.layer = layer;
    
    TKImageLoader *loader = [[TKImageLoader alloc] initWithURL:[NSURL URLWithString:self.user.profilePicture]
                                                     imageView:self.profile];
    [loader start];
}

-(void)startRequest
{
    NSURLRequest *recentsRequest = [NSURLRequest requestWithURL:[VPInfo retrieveUserRecentsUrlWithUserId:[@(self.user.userId) stringValue] nextMaxId:nextMaxId]];
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

-(void)reportError:(NSDictionary*)meta
{
    
}

-(void)updateUserRecents:(NSData*)data
{
    NSDictionary *raw = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSArray *rawFeeds = [raw objectForKey:@"data"];
    NSDictionary *meta = [raw objectForKey:@"meta"];
    NSLog(@"meta:%@", meta);
    int code =  [[meta objectForKey:@"code"] intValue];
    if (code != 200) {
        [self reportError:meta];
        [self.privateUserHint setHidden:NO];
        return;
    }
    
    
    NSMutableSet *feeds = [[NSMutableSet alloc] init];
    for (NSDictionary *dic in rawFeeds){
        [feeds addObject: [[VPFeed alloc] initWithDictionray:dic]];
    }
    
    [feeds addObjectsFromArray:recents];
    
    recents = [[feeds allObjects] sortedArrayUsingComparator:^NSComparisonResult(id a, id b){
        VPFeed *fa = (VPFeed*)a;
        VPFeed *fb = (VPFeed*)b;
        int r = fa.createdTime - fb.createdTime;
        if (r > 0){
            return NSOrderedAscending;
        } else if (r == 0){
            return NSOrderedSame;
        } else {
            return NSOrderedDescending;
        }
    }];
    
    triggeredBottom = NO;
    [self.tableView reloadData];
    
    NSDictionary *pagination = [raw objectForKey:@"pagination"];
    if (hasMore) {
        if (pagination && !([pagination isEqual: [NSNull null]])){
            NSString *maxId = [pagination objectForKey:@"next_max_id"];
            if (maxId && !([maxId isEqual:[NSNull null]])) {
                hasMore = YES;
                if (!nextMaxId || [maxId longLongValue] < [nextMaxId longLongValue]) {
                    nextMaxId = maxId;
                }
            } else {
                hasMore = NO;
            }
        } else {
            hasMore = NO;
        }
    }
}

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    if (recents) {
        return (int)ceil(recents.count/3.0);
    }
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
    photoView.imageView.target = self;
    photoView.imageView.action = @selector(viewPicDidSelect:);
    [loader start];
    
    return photoView;
}

-(IBAction) viewPicDidSelect:(id)sender
{
    if (self.modelDelegate){
        long col = [self.tableView columnForView:sender];
        long row = [self.tableView rowForView:sender];
        
        VPFeed *comment = recents[row * 3 + col];
        [self.modelDelegate modelDidSelect:comment];
    }
}

-(BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row
{
    return NO;
}
@end
