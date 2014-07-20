#import "VPFeedDetailViewController.h"
#import "TKImageLoader.h"
#import "VPFeedDetailPhotoView.h"
#import "VPFeedDetailCommentView.h"

@interface VPFeedDetailViewController ()

@end

@implementation VPFeedDetailViewController

@synthesize feed;

-(void)prepare
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
        return 430.0;
    } else {
        return 60.0;
    }
}

-(NSInteger) numberOfRowsInTableView:(NSTableView *)tableView
{
    return feed.comments.comments.count + 1;
}

-(BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row
{
    return false;
}

-(NSView *) tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    if (row == 0){
        VPFeedDetailPhotoView *photoView = [tableView makeViewWithIdentifier:@"photo" owner:self];
        TKImageLoader *loader = [[TKImageLoader alloc] initWithURL:[NSURL URLWithString:feed.images.standardResolution.url]
                                                         imageView:photoView.imageView];
        [loader start];
        return photoView;
    } else {
        VPFeedDetailCommentView *commentView = [tableView makeViewWithIdentifier:@"comment" owner:self];
        VPComment *comment = feed.comments.comments[row - 1];
        
        TKImageLoader *loader = [[TKImageLoader alloc] initWithURL:[NSURL URLWithString: comment.user.profilePicture]
                                                         imageView:commentView.imageView];
        [loader start];
        commentView.textView.stringValue = comment.text;
        return commentView;
    }
}
@end