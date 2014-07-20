#import "VPFeedDetailViewController.h"

@interface VPFeedDetailViewController ()

@end

@implementation VPFeedDetailViewController

@synthesize feed;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(void)awakeFromNib
{
    NSNib *photo = [[NSNib alloc]initWithNibNamed:@"VPFeedDetailPhotoView" bundle:nil];
    [self.tableView registerNib:photo forIdentifier:@"photo"];
    
    NSNib *comment = [[NSNib alloc] initWithNibNamed:@"VPFeedDetailCommentView" bundle:nil];
    [self.tableView registerNib:comment forIdentifier:@"comment"];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

-(void)show
{
    [self.tableView reloadData];
}

-(CGFloat) tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    if (row == 0){
        return 430;
    } else {
        return 100;
    }
}

-(BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row
{
    return false;
}

-(NSView*)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    if (row == 0){
        VPFeedDetailPhotoView *photoView = [tableView makeViewWithIdentifier:@"photo" owner:self];
        return photoView;
    } else {
        VPFeedDetailCommentView *commentView = [tableView makeViewWithIdentifier:@"comment" owner:self];
        return commentView;
    }
}
@end