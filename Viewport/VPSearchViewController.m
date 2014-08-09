#import "VPSearchViewController.h"
#import "VPInfo.h"
#import "VPConnectionDataDepot.h"
#import "VPSearchUserResultView.h"
#import "VPUser.h"
#import "TKImageLoader.h"

@interface VPSearchViewController ()
{
    NSArray *users;
}
@end

@implementation VPSearchViewController

-(void)awakeFromNib
{
    NSNib *nib = [[NSNib alloc] initWithNibNamed:@"VPSearchUserResultView" bundle:nil];
    [self.tableView registerNib:nib forIdentifier:@"CELL"];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.extendedDelegate = self;
}

- (IBAction)enter:(id)sender {
    [self startSearch:((NSSearchField *)sender).stringValue];
}

- (void) startSearch:(NSString*)query
{
    NSURL *url = [VPInfo retrieveUserSearchUrlWithQueryParameter:query];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLConnection *con =
    [[NSURLConnection alloc] initWithRequest:request
                                    delegate:[[VPConnectionDataDepot alloc]
                                              initWithSuccessBlock:^(NSData *data){
                                                  [self updateData:data];
                                              } failBlock:^(NSError *error){
                                                  NSLog(@"error:%@", error);
                                              }]];
    [con start];
}

-(void)updateData:(NSData*)data
{
    NSDictionary *raw = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSArray *list = [raw objectForKey:@"data"];
    NSMutableArray *usersArray = [[NSMutableArray alloc] init];
    for (NSDictionary *user in list) {
        VPUser *u = [[VPUser alloc] initWithDictionary:user];
        [usersArray addObject:u];
    }
    
    users = usersArray;
    [self.tableView reloadData];
}

-(NSInteger) numberOfRowsInTableView:(NSTableView *)tableView
{
    if(users) {
        return users.count;
    } else {
        return 0;
    }
}

-(NSView*)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    VPSearchUserResultView *view = [self.tableView makeViewWithIdentifier:@"CELL" owner:self];
    VPUser *user = users[row];
    
    view.fullname.stringValue = user.fullName;
    view.nickname.stringValue = user.name;
    
    view.profilePicture.wantsLayer = YES;
    view.profilePicture.layer.cornerRadius = 5;
    TKImageLoader *loader = [[TKImageLoader alloc] initWithURL:[NSURL URLWithString:user.profilePicture]
                                                     imageView:view.profilePicture];
    [loader start];
    
    return view;
}

- (void)tableView:(NSTableView *)tableView didClickedRow:(NSInteger)row{
    if (self.delegate) {
        VPUser *user = users[row];
        [self.delegate modelDidSelect:user];
    }
}
@end
