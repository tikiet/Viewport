#import "VPFeedDetailViewController.h"
#import "TKImageLoader.h"
#import "VPFeedDetailPhotoView.h"
#import "VPFeedDetailCommentView.h"
#import "NSTextField+LayoutContraintTag.h"
#import "NS(Attributed)String+Geometrics.h"

@interface VPFeedDetailViewController ()

@end

@implementation VPFeedDetailViewController
{
    NSFont *defaultFont;
}

@synthesize feed;

-(void)prepare
{
    NSNib *photo = [[NSNib alloc]initWithNibNamed:@"VPFeedDetailPhotoView" bundle:nil];
    [self.tableView registerNib:photo forIdentifier:@"photo"];
    
    NSNib *comment = [[NSNib alloc] initWithNibNamed:@"VPFeedDetailCommentView" bundle:nil];
    [self.tableView registerNib:comment forIdentifier:@"comment"];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    defaultFont = [NSFont fontWithName:@"Lucida Grande" size:13];
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
        
        VPComment *comment = feed.comments.comments[row - 1];
        return 60.0 + [self resizeTextField:comment];
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
        commentView.userName.textColor = [NSColor colorWithCalibratedRed:0.19 green:0.36 blue:0.55 alpha:1];
        commentView.userName.stringValue = comment.user.name;
        commentView.imageView.wantsLayer = YES;
        CALayer *layer = [CALayer layer];
        layer.cornerRadius = 3;
        layer.masksToBounds = YES;
        commentView.imageView.layer = layer;
        
        NSTextField *textView = commentView.textView;
        textView.stringValue = comment.text;
        if (textView.tag) {
            [textView removeConstraints:textView.tag];
        }
        textView.tag =
        [NSLayoutConstraint constraintsWithVisualFormat:[NSString
                                                         stringWithFormat:@"V:[textView(%f)]",
                                                         ceil([self resizeTextField:comment])]
                                                options:0
                                                metrics:nil
                                                  views:NSDictionaryOfVariableBindings(textView)];
        [textView addConstraints:textView.tag];
        return commentView;
    }
}

-(CGFloat)resizeTextField:(VPComment *) comment
{
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithString: comment.text];
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithContainerSize:NSMakeSize(360, FLT_MAX)] ;
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc]init];
    
    [layoutManager addTextContainer:textContainer];
    [textStorage addLayoutManager:layoutManager];
    [textContainer setLineFragmentPadding:0.0];
    [layoutManager glyphRangeForTextContainer:textContainer];
    NSLog(@"height:%f, text:%@",[layoutManager usedRectForTextContainer:textContainer].size.height, comment.text);
    
    return [comment.text heightForWidth:360 font:defaultFont];
}

@end