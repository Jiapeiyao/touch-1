//
//  ActivityListViewController.m
//  touch
//
//  Created by xinglunxu on 1/24/15.
//  Copyright (c) 2015 cs48. All rights reserved.
//

#import "ActivityListViewController.h"
#import "AppDelegate.h"
#import "AppDelegate.h"
#import "CustomActionSheet.h"
#import "CommonDefine.h"
#import "UserHeadImageView.h"
#import "newsFeed.h"
#import "newsFeedManager.h"
#import "NewStatusViewController.h"
#import "EventManager.h"


@interface ActivityListViewController () <UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *customView;
@property (strong, nonatomic) CustomActionSheet *actionSheet;

@property (strong, nonatomic) UITableView *activityTableView;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) NSMutableArray *heightArray;
@property (assign, nonatomic) int currentPage;
@property (assign, nonatomic) BOOL isInit;
@property (nonatomic) BOOL reloadingData;
@end

@implementation ActivityListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.activityTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 64 - 49) style:UITableViewStylePlain];
    self.activityTableView.delegate = self;
    self.activityTableView.dataSource = self;
    self.activityTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.activityTableView];
    
    [self refreshData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshData) name:UIActivityCircleNeedRefreshDataNotification object:nil];
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] showTabBar];
    self.navigationController.navigationBarHidden = NO;
    if(!self.isInit)
    {
        self.currentPage = 1;
        [self requestDataWithPage:self.currentPage];
    }
}

- (void)requestDataWithPage:(int)page
{
    self.dataSource = [[newsFeedManager sharedManager] getNewsFeedsInBackground];
    self.heightArray = [NSMutableArray arrayWithCapacity:self.dataSource.count];
    [self calculateAndStoreCellHeight];
    self.isInit = YES;
    [_activityTableView reloadData];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIActivityCircleNeedRefreshDataNotification object:nil];
}

//refresh data
- (void)refreshData
{
    [self requestDataWithPage:self.currentPage];
}


//Button action
- (void)moreButtonAction:(UIButton *)button
{
    if (!_actionSheet) {
        _actionSheet = [[CustomActionSheet alloc]initWithCustomView:_customView];
        [_actionSheet show];
    }
    else
    {
        [_actionSheet show];
    }
}

//actionSheet cancel event

- (IBAction)actionSheetCancel:(id)sender {
    [_actionSheet hide];
}
- (IBAction)actionSheetReport:(id)sender {
}

- (IBAction)actionSheetShare:(id)sender {
}
- (IBAction)actionSheetCollect:(id)sender {
}

//go back to title according to eventype
- (NSString *)getTitleWithEventType:(NSInteger)eventType
{
    NSString *title;
    switch (eventType) {
        case 0:
        {
            title = @"created the event";
        }
            break;
        case 1:
        {
            title = @"posted a status";
        }
            break;
        case 2:
        {
            title = @"joined the event";
        }
            break;
        default:
            break;
    }
    return title;
}

- (void)calculateAndStoreCellHeight
{
    for (int i = 0; i < self.dataSource.count; i++) {
        newsFeed *newsFeed = self.dataSource[i];
        CGFloat height = [self calculateCellHeight:newsFeed];
        [self.heightArray addObject:[NSNumber numberWithFloat:height]];
    }
}


//calculate the cell hight
- (CGFloat)calculateViewHeight:(NSString *)text withViewWidth:(CGFloat)width withFont:(UIFont *)font
{
    CGSize size;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    size = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    return ceil(size.height);
}

- (CGFloat)calculateCellHeight:(newsFeed *)newsFeed
{
    CGFloat height = 5.0;//cell distance to top edge
    height = height + 5 + 40 + 5; //avator and title time height gap 10

    if (newsFeed.eventType == 0 || newsFeed.eventType == 2){
        //create activity
        height = height + 75 + 10; //gap 10
    }
    
    //description to created event
    NSString *content = newsFeed.content;
    if (![content isEqualToString:@""]) {
        height = height + [self calculateViewHeight:content withViewWidth:SCREENWIDTH - 6 - 20 - 45 withFont:[UIFont systemFontOfSize:13]] + 5;
    }
    
    //activity tag and location
    height = height + 20 + 5;
    
    //thump up
    NSArray *like = [NSArray arrayWithArray:newsFeed.likeUsers];
    if (like.count > 0) {
        height = height + 25 + 5;
    }
    
    //comment
    NSArray *comment = [NSArray arrayWithArray:newsFeed.comments];
    if (comment.count > 0 && comment.count <= 6) {
        for (int i = 0; i < comment.count; i++) {
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary:comment[i]];
            NSString *string = [NSString stringWithFormat:@"%@:%@",dic[@"send_from"][@"name"],dic[@"content"]];
            CGFloat labelHeight = [self calculateViewHeight:string withViewWidth:SCREENWIDTH - 6 - 45 - 5 withFont:[UIFont systemFontOfSize:13]];
            height = height + (labelHeight > 20 ? labelHeight : 20);
        }
        height = height + 5;
    }
    else if (comment.count > 0 && comment.count > 6)
    {
        for (int i = 0; i < 6; i++) {
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary:comment[i]];
            NSString *string = [NSString stringWithFormat:@"%@:%@",dic[@"send_from"][@"name"],dic[@"content"]];
            CGFloat labelHeight = [self calculateViewHeight:string withViewWidth:SCREENWIDTH - 6 - 45 - 5 withFont:[UIFont systemFontOfSize:13]];
            height = height + (labelHeight > 20 ? labelHeight : 20);
        }
        height = height + 20 + 5;
    }
    
    //like comment button
    height = height + 25 + 5;
    
    height = height + 5; //cell边框 距离下边缘高度
    
    return height;
}

- (NSString *)timeText:(NSDate *)date {
    NSTimeInterval duration = [[NSDate date] timeIntervalSinceDate:date];
    if (duration < 60) {
        return NSLocalizedString(@"time just now", @"刚刚");
    } else if (duration < 3600) {
        NSString *format = NSLocalizedString(@"time minute ago", @"分钟前");
        return [NSString stringWithFormat:format, (long)(duration / 60)];
    } else if (duration < 86400) {
        NSString *format = NSLocalizedString(@"time hour ago", @"小时前");
        return [NSString stringWithFormat:format, (long)(duration / 3600)];
    } else {
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:NSLocalizedString(@"time format without year", @"日期format")];
        return [format stringFromDate:date];
    }
}


#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"numberOfSectionSInTableView");
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"numberOfRowsInSection");
    NSLog(@"Value of count = %lu",(unsigned long)self.dataSource.count);
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.heightArray[indexPath.row] floatValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    else
    {
        for (UIView * view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
    }
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(3, 5, SCREENWIDTH - 6, [self.heightArray[indexPath.row] floatValue] - 10)];
    containerView.backgroundColor = [UIColor whiteColor];
    containerView.layer.borderWidth = 0.5;
    containerView.layer.borderColor = RGBACOLOR(208, 208, 208, 1).CGColor;
    [cell.contentView addSubview:containerView];
    
    CGFloat height = 5.0;
    CGFloat containerWidth = SCREENWIDTH - 6;
    
    newsFeed *newsFeed = self.dataSource[indexPath.row];
    UserHeadImageView *headImageView = [[UserHeadImageView alloc] initWithFrame:CGRectMake(5, height, 40, 40)];
    headImageView.layer.borderWidth = 1.0f;
    headImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    headImageView.layer.masksToBounds = YES;
    headImageView.layer.cornerRadius = headImageView.frame.size.width / 2;
    headImageView.userInteractionEnabled = YES;
    User *user = newsFeed.creator;
    headImageView.userId = user.recordID;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userHeadViewTap:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [headImageView addGestureRecognizer:tap];
    [containerView addSubview:headImageView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, height + 10, containerWidth - 50 - 5 - 100, 20)];
    titleLabel.text = [NSString stringWithFormat:@"%@ %@",user.username,[self getTitleWithEventType:newsFeed.eventType]];
    titleLabel.font = [UIFont fontWithName:DEFAULT_FONT_LIGHT size:13];
    [containerView addSubview:titleLabel];
    
    UIImageView *timeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(containerWidth - 5 - 12 - 3 - 60, height + 14, 12, 12)];
    timeImageView.image = [UIImage imageNamed:@"activity_icon_time.png"];
    [containerView addSubview:timeImageView];
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(containerWidth - 5 - 60, height + 10, 60, 20)];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.text = [self timeText:newsFeed.createTime];
    timeLabel.font = [UIFont fontWithName:DEFAULT_FONT_LIGHT size:13];
    [containerView addSubview:timeLabel];
    
    height = height + 40 + 5; // title time Label height
     if (newsFeed.eventType == 0 || newsFeed.eventType == 2)
    {
        //create activity
         UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, height, containerWidth, 75)];
        contentLabel.numberOfLines = 0;
        [self customizeBackground:newsFeed.subjecttype labelGiven:contentLabel];
        contentLabel.layer.borderColor = [UIColor colorWithRed:191/255.0f green:191/255.0f blue:191/255.0f alpha:1.0f].CGColor;
        contentLabel.layer.borderWidth = 0.5;
        contentLabel.font = [UIFont fontWithName:DEFAULT_FONT_LIGHT size:17];
        contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [contentLabel setTextAlignment:UITextAlignmentCenter];
        contentLabel.text = newsFeed.eventtitle;
        [containerView addSubview:contentLabel];
        
        height = height + 85;
    }
    
    //description to created activity
    NSString *content = newsFeed.content;
    if (![content isEqualToString:@""]) {
        
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, height, containerWidth - 45 - 20, [self calculateViewHeight:content withViewWidth:containerWidth - 45 - 20 withFont:[UIFont systemFontOfSize:13]])];
        contentLabel.numberOfLines = 0;
        contentLabel.font = [UIFont systemFontOfSize:13];
        contentLabel.text = content;
        [containerView addSubview:contentLabel];
        
        height = height + [self calculateViewHeight:content withViewWidth:SCREENWIDTH - 6 - 20 - 45 withFont:[UIFont systemFontOfSize:13]] + 5;
        
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(45, height, SCREENWIDTH - 45 - 20, 0.5)];
        line.backgroundColor = RGBACOLOR(151, 151, 151, 100);
        [containerView addSubview:line];
    }
    
    //location tage
    UIImageView *tagImageView = [[UIImageView alloc] initWithFrame:CGRectMake(19, height + 2, 13, 15)];
    tagImageView.image = [UIImage imageNamed:@"activity_icon_tag.png"];
//    [containerView addSubview:tagImageView];
    
    UILabel *tagLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, height, containerWidth - 5 - 45, 20)];
    tagLabel.text = [NSString stringWithFormat:@"%@",@"▽ Location"];
    tagLabel.font = [UIFont systemFontOfSize:13];
    tagLabel.textColor = RGBACOLOR(136, 157, 181, 1);
//    [containerView addSubview:tagLabel];
    
    height = height + 20 + 5;
    
    
    //show people giving thumb up
    NSArray *like = [NSArray arrayWithArray:newsFeed.likeUsers];
    if (like.count > 0) {
        //thumb up tage
        UIImageView *likeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(19, height + 6, 13, 12)];
        likeImageView.image = [UIImage imageNamed:@"activity_btn_praise_selected.png"];
        [containerView addSubview:likeImageView];
        
        NSInteger count = like.count > 7 ? 7 : like.count;
        for (int i = 0; i < count; i++) {
            UserHeadImageView *praiseHeadView = [[UserHeadImageView alloc] initWithFrame:CGRectMake(45 + 30*i, height, 25, 25)];
            praiseHeadView.layer.masksToBounds = YES;
            praiseHeadView.layer.cornerRadius = 12.5;
            praiseHeadView.layer.borderColor = [UIColor whiteColor].CGColor;
            praiseHeadView.layer.borderWidth = 1;
            praiseHeadView.userInteractionEnabled = YES;
            praiseHeadView.userId = like[i][@"userId"];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userHeadViewTap:)];
            tap.numberOfTapsRequired = 1;
            tap.numberOfTouchesRequired = 1;
            [praiseHeadView addGestureRecognizer:tap];
            [containerView addSubview:praiseHeadView];
        }
        
        if (like.count > 7) {
            UIButton *otherLike = [[UIButton alloc] initWithFrame:CGRectMake(45 + 30 * 7, height , containerWidth - 5 - 45 - 30 * 7, 25)];
            [otherLike setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
            [otherLike setTitleColor:RGBACOLOR(136, 157, 181, 1) forState:UIControlStateNormal];
            [otherLike setTitle:[NSString stringWithFormat:@"and %d other like",(int)like.count - 7] forState:UIControlStateNormal];
            [otherLike.titleLabel setFont:[UIFont fontWithName:DEFAULT_FONT_LIGHT size:13]];
            [otherLike addTarget:self action:@selector(otherLikeClicked:) forControlEvents:UIControlEventTouchUpInside];
            otherLike.tag = indexPath.row;
            [containerView addSubview:otherLike];
        }
        
        height = height + 25 + 5;
    }
    
    //comment
    NSArray *comment = [NSArray arrayWithArray:newsFeed.comments];
    if (comment.count > 0) {
        //comment tag
        UIImageView *commentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(19, height + 6, 13, 12)];
        commentImageView.image = [UIImage imageNamed:@"activity_icon_comment.png"];
        [containerView addSubview:commentImageView];
        
        NSInteger count = comment.count > 6 ? 6 : comment.count;
        for (int i = 0; i < count; i++) {
            NSDictionary *tempDic = comment[i];
            NSString *name = tempDic[@"send_from"][@"name"];
            NSString *content = tempDic[@"content"];
            
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@:%@",name,content]];
            [str addAttribute:NSForegroundColorAttributeName value:RGBACOLOR(136, 157, 181, 1) range:NSMakeRange(0,name.length + 1)];
            UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, height, containerWidth - 45 - 5, [self calculateViewHeight:[NSString stringWithFormat:@"%@:%@",name,content] withViewWidth:containerWidth - 45 - 5 withFont:[UIFont systemFontOfSize:13]])];
            commentLabel.attributedText = str;
            commentLabel.font = [UIFont systemFontOfSize:13];
            commentLabel.numberOfLines = 0;
            commentLabel.lineBreakMode = NSLineBreakByWordWrapping;
            [containerView addSubview:commentLabel];
            
            height = height + [self calculateViewHeight:[NSString stringWithFormat:@"%@:%@",name,content] withViewWidth:containerWidth - 45 - 5 withFont:[UIFont systemFontOfSize:13]];
        }
        if (comment.count > 6) {
            UIButton *viewMoreBtn = [[UIButton alloc] initWithFrame:CGRectMake(45, height, containerWidth - 45 - 5, 20)];
            [viewMoreBtn setTitleColor:RGBACOLOR(136, 157, 181, 1) forState:UIControlStateNormal];
            [viewMoreBtn setTitle:[NSString stringWithFormat:@"and %d other comments",(int)comment.count - 6] forState:UIControlStateNormal];
            [viewMoreBtn.titleLabel setFont:[UIFont fontWithName:DEFAULT_FONT_LIGHT size:13]];
            [viewMoreBtn addTarget:self action:@selector(commentAction:) forControlEvents:UIControlEventTouchUpInside];
            viewMoreBtn.tag = indexPath.row;
            [containerView addSubview:viewMoreBtn];
            
            height = height + 20;
        }
        
        height = height + 5;
        
    }
    
    // thumb up button comment button  more button
    UIButton *likeBtn = [[UIButton alloc] initWithFrame:CGRectMake(45, height, 95, 25)];
    likeBtn.backgroundColor = RGBACOLOR(238, 238, 238, 1);
    NSLog(@"%@ %hhd ", newsFeed.newsId, newsFeed.hasBeenPraised);
    if (newsFeed.hasBeenPraised) {
        likeBtn.backgroundColor = RGBACOLOR(123, 238, 238, 1);
        likeBtn.selected = YES;
    }
    else
    {
        likeBtn.selected = NO;
    }
    [likeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -25, 0, 0)];
    [likeBtn setTitleColor:RGBACOLOR(146, 146, 146, 1) forState:UIControlStateNormal];
    [likeBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    NSString* s;
    if(newsFeed.likeUserCount)
    {
        s = [NSString stringWithFormat:@"Interested(%ld)",(long)newsFeed.likeUserCount];
    }
    else{s = @"Interested";}
    [likeBtn setTitle:s forState:UIControlStateNormal];
    likeBtn.tag = indexPath.row;
    [likeBtn addTarget:self action:@selector(likeAction:) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:likeBtn];
    
    
    UIButton *commentBtn = [[UIButton alloc] initWithFrame:CGRectMake(150, height, 95, 25)];
    commentBtn.backgroundColor = RGBACOLOR(238, 238, 238, 1);
    [commentBtn setImage:[UIImage imageNamed:@"activity_btn_comment.png"] forState:UIControlStateNormal];
    [commentBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -25, 0, 0)];
    [commentBtn setTitleColor:RGBACOLOR(146, 146, 146, 1) forState:UIControlStateNormal];
    [commentBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [commentBtn setTitle:@"Comment" forState:UIControlStateNormal];
    commentBtn.tag = indexPath.row;
    [commentBtn addTarget:self action:@selector(commentAction:) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:commentBtn];
    
    
    UIButton *moreButton = [[UIButton alloc] initWithFrame:CGRectMake(containerWidth - 5 - 40, height, 40, 25)];
    [moreButton setImage:[UIImage imageNamed:@"activity_btn_more.png"] forState:UIControlStateNormal];
    moreButton.tag = indexPath.row;
    [moreButton addTarget:self action:@selector(moreButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:moreButton];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSLog(@"cellForRowAtIndex");
    return cell;
}

-(void)likeAction:(UIButton*) button
{
    newsFeed* nf = self.dataSource[button.tag];
    if (button.selected) {
        button.backgroundColor = RGBACOLOR(238, 238, 238, 1);
        button.selected = NO;
        [self removeLikeUserToNewsFeed:nf.eventType nid:nf.newsId];
}
    else{
        button.backgroundColor = RGBACOLOR(123, 238, 238, 1);
        button.selected = YES;
        [self addLikeUserToNewsFeed:nf.eventType nid:nf.newsId];
    }
}

-(void)removeLikeUserToNewsFeed:(NSInteger) i  nid:(NSString*) nfid
{
    if( i ==1 )
    {
        [[newsFeedManager sharedManager]unlikeNewsFeed:nfid ByUser:[User currentUser] InBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            NSLog(succeeded ? @"Cancel Succeed" : @"Cancel Fail");
            if (succeeded) {
                [self requestDataWithPage:self.currentPage];
            }
        }];
    }
    
    else
    {
        [[EventManager sharedManager]unlikeNewsFeed:nfid ByUser:[User currentUser] InBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            NSLog(succeeded ? @"Cancel Succeed" : @"Cancel Fail");
            if (succeeded) {
                [self requestDataWithPage:self.currentPage];
            }
        }];
    }
}

-(void)addLikeUserToNewsFeed:(NSInteger) i  nid:(NSString*) nfid
{
    if( i ==1 )
    {
        [[newsFeedManager sharedManager]likeNewsFeed:nfid ByUser:[User currentUser] InBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            NSLog(succeeded ? @"Cancel Succeed" : @"Cancel Fail");
            if (succeeded) {
                [self requestDataWithPage:self.currentPage];
            }
        }];
    }
    
    else
    {
        [[EventManager sharedManager]likeNewsFeed:nfid ByUser:[User currentUser] InBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            NSLog(succeeded ? @"Cancel Succeed" : @"Cancel Fail");
            if (succeeded) {
                [self requestDataWithPage:self.currentPage];
            }
        }];
    }
}

-(void)customizeBackground: (NSInteger) i labelGiven: (UILabel*) label
{
    switch(i)
    {
        case 0:
            label.backgroundColor = [UIColor colorWithRed:207/255.0f green:207/255.0f blue:100/255.0f alpha:1.0f];
        break;
            
        case 1:
            label.backgroundColor = [UIColor colorWithRed:100/255.0f green:207/255.0f blue:207/255.0f alpha:1.0f];
        break;
        
        case 2:
            label.backgroundColor = [UIColor colorWithRed:207/255.0f green:207/255.0f blue:100/255.0f alpha:1.0f];
            break;
        
        case 3:
            label.backgroundColor = [UIColor colorWithRed:50/255.0f green:207/255.0f blue:100/255.0f alpha:1.0f];
            break;
        
        default:
            label.backgroundColor = [UIColor colorWithRed:207/255.0f green:207/255.0f blue:207/255.0f alpha:1.0f];
            break;
    }
}


#pragma mark - UIScrollViewDelegate


@end
