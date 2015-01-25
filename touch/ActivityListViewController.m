//
//  ActivityListViewController.m
//  touch
//
//  Created by xinglunxu on 1/24/15.
//  Copyright (c) 2015 cs48. All rights reserved.
//

//#import "ActivityListViewController.h"
//#import "AppDelegate.h"
//#import <SDWebImage/UIImageView+WebCache.h>
//#import "AppDelegate.h"
//#import "EGORefreshTableHeaderView.h"
//#import "CustomActionSheet.h"
//#import "CommonDefine.h"
//#import "UserHeadImageView.h"
//
//
//@interface ActivityListViewController () <UITableViewDataSource,UITableViewDelegate,EGORefreshTableDelegate>
//
//
//@property (strong, nonatomic) IBOutlet UIView *customView;
//@property (strong, nonatomic) CustomActionSheet *actionSheet;
//
//@property (strong, nonatomic) UITableView *activityTableView;
//@property (strong, nonatomic) NSMutableArray *dataSource;
//@property (strong, nonatomic) NSMutableArray *heightArray;
//@property (assign, nonatomic) int currentPage;
//@property (assign, nonatomic) BOOL isInit;
//
//@property (nonatomic, strong) EGORefreshTableHeaderView *headerView;
//@property (nonatomic) BOOL reloadingData;
//@end
//
//@implementation ActivityListViewController
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view from its nib.
//    self.activityTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 64 - 49) style:UITableViewStylePlain];
//    self.activityTableView.delegate = self;
//    self.activityTableView.dataSource = self;
//    self.activityTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [self.view addSubview:self.activityTableView];
//    
//    if (!self.headerView) {
//        EGORefreshTableHeaderView *head = [[EGORefreshTableHeaderView alloc]initWithFrame:CGRectMake(0, 0 - self.activityTableView.bounds.size.height, self.activityTableView.frame.size.width, self.activityTableView.bounds.size.height)];
//        head.delegate = self;
//        [self.activityTableView addSubview:head];
//        self.headerView = head;
//    }
//    [self.headerView refreshLastUpdatedDate];
//    
//    [self.headerView forceToRefresh:self.activityTableView];
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//
//- (void)viewWillAppear:(BOOL)animated
//{
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshData) name:UIActivityCircleNeedRefreshDataNotification object:nil];
//    [(AppDelegate *)[[UIApplication sharedApplication] delegate] showTabBar];
//    self.navigationController.navigationBarHidden = NO;
//    if(!self.isInit)
//    {
//        self.currentPage = 1;
//        [self requestDataWithPage:self.currentPage];
//    }
//}
//
//- (void)requestDataWithPage:(int)page
//{
//    [[JCNewsFeedManager sharedManager] getNewsFeedsInBackgroundwithParameters:@{@"page":[NSNumber numberWithInt:page],@"count":@10,@"userId":[JCUser currentUser].recordID} WithBlock:^(NSArray *array, NSError *error) {
//        if (array.count > 0) {
//            self.dataSource = [array mutableCopy];
//            self.heightArray = [NSMutableArray arrayWithCapacity:self.dataSource.count];
//            [self calculateAndStoreCellHeight];
//            self.isInit = YES;
//        }
//        [self doneReloadTableViewDataSource];
//    }];
//}
//
//- (void)viewDidDisappear:(BOOL)animated
//{
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIActivityCircleNeedRefreshDataNotification object:nil];
//}
//
////刷新数据源
//- (void)refreshData
//{
//    [self requestDataWithPage:self.currentPage];
//}
//
//
////所有点击用户头像的事件
//- (void)userHeadViewTap:(UITapGestureRecognizer *)tap
//{
//    UserHeadImageView *imageView = (UserHeadImageView *)tap.view;
//    NSString *userId = imageView.userId;
//    PersonalHomepageViewController *personHomeVC = [[PersonalHomepageViewController alloc] init];
//    personHomeVC.hidesBottomBarWhenPushed = YES;
//    personHomeVC.userId = userId;
//    [[AppDelegate delegate] hideTabBar];
//    [self.navigationController pushViewController:personHomeVC animated:YES];
//}
//
////点赞 按钮点击事件
//- (void)likeAction:(UIButton *)button
//{
//    JCNewsFeed *newsFeed = self.dataSource[button.tag];
//    if (button.selected) {
//        //已经赞过了，准备取消赞
//        [button setImage:[UIImage imageNamed:@"activity_btn_praise_normal.png"] forState:UIControlStateNormal];
//        button.selected = NO;
//        [[JCNewsFeedManager sharedManager]unlikeNewsFeed:newsFeed.newsId ByUser:[JCUser currentUser] InBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//            NSLog(succeeded ? @"取消成功" : @"取消失败");
//            if (succeeded) {
//                [self requestDataWithPage:self.currentPage];
//            }
//        }];
//    }
//    else
//    {
//        //还未赞过，准备点赞
//        [button setImage:[UIImage imageNamed:@"activity_btn_praise_selected.png"] forState:UIControlStateNormal];
//        button.selected = YES;
//        [[JCNewsFeedManager sharedManager] likeNewsFeed:newsFeed.newsId ByUser:[JCUser currentUser] InBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//            NSLog(succeeded ? @"点赞成功" : @"点赞失败");
//            if (succeeded) {
//                [self requestDataWithPage:self.currentPage];
//            }
//        }];
//    }
//}
//
////显示更多赞按钮 点击事件
//- (void)otherLikeClicked:(UIButton *)button
//{
//    JCNewsFeed *newsFeed = self.dataSource[button.tag];
//    PraiseListViewController *praiseList = [[PraiseListViewController alloc] init];
//    praiseList.praiseArray = newsFeed.likeUsers;
//    [self.navigationController pushViewController:praiseList animated:YES];
//}
//
////评论按钮 点击事件
//- (void)commentAction:(UIButton *)button
//{
//    JCNewsFeed *newsFeed = self.dataSource[button.tag];
//    CommentListViewController *commentList = [[CommentListViewController alloc] init];
//    commentList.commentArray = newsFeed.comments;
//    commentList.commentType = CommentTypeNewsFeed;
//    commentList.postId = newsFeed.newsId;
//    [self.navigationController pushViewController:commentList animated:YES];
//}
//
////更多操作按钮 点击事件
//- (void)moreButtonAction:(UIButton *)button
//{
//    if (!_actionSheet) {
//        _actionSheet = [[CustomActionSheet alloc]initWithCustomView:_customView];
//        [_actionSheet show];
//    }
//    else
//    {
//        [_actionSheet show];
//    }
//}
//
////actionSheet中取消按钮的点击事件
//
//- (IBAction)actionSheetCancel:(id)sender {
//    [_actionSheet hide];
//}
//- (IBAction)actionSheetReport:(id)sender {
//}
//
//- (IBAction)actionSheetShare:(id)sender {
//}
//- (IBAction)actionSheetCollect:(id)sender {
//}
//
////活动圈中发表的图片手势响应事件
//- (void)tapImage:(UITapGestureRecognizer *)tap
//{
//    UIImageView *imageView = (UIImageView *)[tap view];
//    
//    int sourceIndex = imageView.tag/1000;
//    int imageIndex = imageView.tag%1000;
//    
//    NSArray *imageArray = [NSArray arrayWithArray:[(JCNewsFeed *)self.dataSource[sourceIndex]photos]];
//    
//    NSInteger count = imageArray.count;
//    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
//    for (int i = 0; i < count; i++) {
//        // 替换为中等尺寸图片
//        NSString *url = SAFEPARAMETER(imageArray[i][@"file_url"]);
//        Photo *photo = [[Photo alloc] init];
//        photo.url = [NSURL URLWithString:url]; // 图片路径
//        photo.srcImageView = imageView; // 来源于哪个UIImageView
//        [photos addObject:photo];
//    }
//    // 2.显示相册
//    PhotoBrowser *browser = [[PhotoBrowser alloc] init];
//    browser.currentPhotoIndex = imageIndex;
//    browser.photos = photos;
//    [browser show];
//}
//
//
////根据EventType 返回标题
//- (NSString *)getTitleWithEventType:(NSInteger)eventType
//{
//    NSString *title;
//    switch (eventType) {
//        case 0:
//        {
//            title = @"发表了图片";
//        }
//            break;
//        case 1:
//        {
//            title = @"发表了状态";
//        }
//            break;
//        case 2:
//        {
//            title = @"发表了图片";
//        }
//            break;
//        case 3:
//        {
//            title = @"参加了活动";
//        }
//            break;
//        case 4:
//        {
//            title = @"分享了活动";
//        }
//            break;
//        case 5:
//        {
//            title = @"发布了活动";
//        }
//            break;
//        default:
//            break;
//    }
//    return title;
//}
//
//- (void)calculateAndStoreCellHeight
//{
//    for (int i = 0; i < self.dataSource.count; i++) {
//        JCNewsFeed *newsFeed = self.dataSource[i];
//        CGFloat height = [self calculateCellHeight:newsFeed];
//        [self.heightArray addObject:[NSNumber numberWithFloat:height]];
//    }
//}
//
//
////根据字符串  计算视图的高度
//- (CGFloat)calculateViewHeight:(NSString *)text withViewWidth:(CGFloat)width withFont:(UIFont *)font
//{
//    CGSize size;
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
//    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
//    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
//    size = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
//    return ceil(size.height);
//}
//
//- (CGFloat)calculateCellHeight:(JCNewsFeed *)newsFeed
//{
//    CGFloat height = 5.0;//cell 边框距离上边缘高度
//    height = height + 5 + 40 + 5; //头像以及 title time 高度 间隙10
//    
//    if (newsFeed.eventType == 0 || newsFeed.eventType == 2) {
//        //发表图片
//        NSArray *images = [NSArray arrayWithArray:newsFeed.photos];
//        if (images.count == 1) {
//            height = height + 150 + 5; //如果只有一张图片 则切换为大图
//        }
//        else if (images.count == 2)
//        {
//            height = height + 75 + 5; //2张图放一行，小图
//        }
//        else
//        {
//            height = height + 75*2 + 5 + 5; //大于2 张图 放2行 行间距 10 小图
//        }
//    }
//    else if (newsFeed.eventType == 3 || newsFeed.eventType == 4 || newsFeed.eventType == 5)
//    {
//        //发表活动
//        height = height + 75 + 10; //间距 10
//    }
//    
//    //对发布内容的描述
//    NSString *content = newsFeed.content;
//    if (![content isEqualToString:@""]) {
//        height = height + [self calculateViewHeight:content withViewWidth:SCREENWIDTH - 6 - 20 - 45 withFont:[UIFont systemFontOfSize:13]] + 5;
//    }
//    
//    //活动标签以及地理位置
//    height = height + 20 + 5;
//    
//    //点赞
//    NSArray *like = [NSArray arrayWithArray:newsFeed.likeUsers];
//    if (like.count > 0) {
//        height = height + 25 + 5;
//    }
//    
//    
//    //评论
//    NSArray *comment = [NSArray arrayWithArray:newsFeed.comments];
//    if (comment.count > 0 && comment.count <= 6) {
//        for (int i = 0; i < comment.count; i++) {
//            NSDictionary *dic = [NSDictionary dictionaryWithDictionary:comment[i]];
//            NSString *string = [NSString stringWithFormat:@"%@:%@",dic[@"send_from"][@"name"],dic[@"content"]];
//            CGFloat labelHeight = [self calculateViewHeight:string withViewWidth:SCREENWIDTH - 6 - 45 - 5 withFont:[UIFont systemFontOfSize:13]];
//            height = height + (labelHeight > 20 ? labelHeight : 20);
//        }
//        height = height + 5;
//    }
//    else if (comment.count > 0 && comment.count > 6)
//    {
//        for (int i = 0; i < 6; i++) {
//            NSDictionary *dic = [NSDictionary dictionaryWithDictionary:comment[i]];
//            NSString *string = [NSString stringWithFormat:@"%@:%@",dic[@"send_from"][@"name"],dic[@"content"]];
//            CGFloat labelHeight = [self calculateViewHeight:string withViewWidth:SCREENWIDTH - 6 - 45 - 5 withFont:[UIFont systemFontOfSize:13]];
//            height = height + (labelHeight > 20 ? labelHeight : 20);
//        }
//        height = height + 20 + 5;
//    }
//    
//    //like comment  按钮
//    height = height + 25 + 5;
//    
//    height = height + 5; //cell边框 距离下边缘高度
//    
//    return height;
//}
//
//- (NSString *)timeText:(NSDate *)date {
//    NSTimeInterval duration = [[NSDate date] timeIntervalSinceDate:date];
//    if (duration < 60) {
//        return NSLocalizedString(@"time just now", @"刚刚");
//    } else if (duration < 3600) {
//        NSString *format = NSLocalizedString(@"time minute ago", @"分钟前");
//        return [NSString stringWithFormat:format, (long)(duration / 60)];
//    } else if (duration < 86400) {
//        NSString *format = NSLocalizedString(@"time hour ago", @"小时前");
//        return [NSString stringWithFormat:format, (long)(duration / 3600)];
//    } else {
//        NSDateFormatter *format = [[NSDateFormatter alloc] init];
//        [format setDateFormat:NSLocalizedString(@"time format without year", @"日期format")];
//        return [format stringFromDate:date];
//    }
//}
//
//
//#pragma mark - UITableViewDataSource & UITableViewDelegate
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return self.dataSource.count;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return [self.heightArray[indexPath.row] floatValue];
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSString *cellIdentifier = @"cellIdentifier";
//    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//    }
//    else
//    {
//        for (UIView * view in cell.contentView.subviews) {
//            [view removeFromSuperview];
//        }
//    }
//    
//    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(3, 5, SCREENWIDTH - 6, [self.heightArray[indexPath.row] floatValue] - 10)];
//    containerView.backgroundColor = [UIColor whiteColor];
//    containerView.layer.borderWidth = 0.5;
//    containerView.layer.borderColor = RGBACOLOR(208, 208, 208, 1).CGColor;
//    [cell.contentView addSubview:containerView];
//    
//    CGFloat height = 5.0;
//    CGFloat containerWidth = SCREENWIDTH - 6;
//    
//    JCNewsFeed *newsFeed = self.dataSource[indexPath.row];
//    UserHeadImageView *headImageView = [[UserHeadImageView alloc] initWithFrame:CGRectMake(5, height, 40, 40)];
//    headImageView.layer.borderWidth = 1.0f;
//    headImageView.layer.borderColor = [UIColor whiteColor].CGColor;
//    headImageView.layer.masksToBounds = YES;
//    headImageView.layer.cornerRadius = headImageView.frame.size.width / 2;
//    headImageView.userInteractionEnabled = YES;
//    JCUser *user = newsFeed.creator;
//    headImageView.userId = user.recordID;
//    [user getSmallUserAvatarWithUserID:user.recordID andWidth:40 andHeight:40 andBlock:^(UIImage *image, NSError *error) {
//        headImageView.image = image;
//    }];
//    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userHeadViewTap:)];
//    tap.numberOfTapsRequired = 1;
//    tap.numberOfTouchesRequired = 1;
//    [headImageView addGestureRecognizer:tap];
//    [containerView addSubview:headImageView];
//    
//    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, height + 10, containerWidth - 50 - 5 - 100, 20)];
//    titleLabel.text = [NSString stringWithFormat:@"%@%@",user.name,[self getTitleWithEventType:newsFeed.eventType]];
//    titleLabel.font = [UIFont fontWithName:DEFAULT_FONT_LIGHT size:13];
//    [containerView addSubview:titleLabel];
//    
//    UIImageView *timeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(containerWidth - 5 - 12 - 3 - 60, height + 14, 12, 12)];
//    timeImageView.image = [UIImage imageNamed:@"activity_icon_time.png"];
//    [containerView addSubview:timeImageView];
//    
//    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(containerWidth - 5 - 60, height + 10, 60, 20)];
//    timeLabel.textAlignment = NSTextAlignmentCenter;
//    timeLabel.text = [self timeText:newsFeed.createTime];
//    timeLabel.font = [UIFont fontWithName:DEFAULT_FONT_LIGHT size:13];
//    [containerView addSubview:timeLabel];
//    
//    height = height + 40 + 5; // title time Label 高度
//    
//    //图片 或者 是图片加活动描述
//    NSArray *imagesArray = [NSArray arrayWithArray:newsFeed.photos];
//    if (newsFeed.eventType == 0 || newsFeed.eventType == 2)
//    {
//        //发布图片
//        if (imagesArray.count == 1) {
//            //单张图片
//            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(45, height, 150, 150)];
//            [imageView sd_setImageWithURL:[NSURL URLWithString:imagesArray[0][@"thumbnail_url"]] placeholderImage:[UIImage imageNamed:@"activity_pic.png"]];
//            [containerView addSubview:imageView];
//            imageView.userInteractionEnabled = YES;
//            imageView.tag = 1000*indexPath.row + 0;
//            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
//            tap.numberOfTapsRequired = 1;
//            tap.numberOfTouchesRequired = 1;
//            [imageView addGestureRecognizer:tap];
//            height = height + 150 + 5; //单张图 高度
//        }
//        else
//        {
//            NSInteger maxCount = imagesArray.count > 4 ? 4 : imagesArray.count;
//            int row = 0, col = 0;
//            for (int i = 0; i < maxCount; i++) {
//                if (col == 2) {
//                    col = 0;
//                    row = row + 1;
//                }
//                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(45 + col*80, height + 80*row, 75, 75)];
//                [imageView sd_setImageWithURL:[NSURL URLWithString:imagesArray[i][@"thumbnail_url"]] placeholderImage:[UIImage imageNamed:@"activity_pic.png"]];
//                [containerView addSubview:imageView];
//                imageView.userInteractionEnabled = YES;
//                imageView.tag = 1000*indexPath.row + i;
//                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
//                tap.numberOfTapsRequired = 1;
//                tap.numberOfTouchesRequired = 1;
//                [imageView addGestureRecognizer:tap];
//                
//                col ++;
//            }
//            
//            height = height + (maxCount >2 ? 80*2 : 80);
//        }
//    }
//    else if (newsFeed.eventType == 3 || newsFeed.eventType == 4 || newsFeed.eventType == 5)
//    {
//        //发布活动
//        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:newsFeed.eventDic];
//        
//        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(45, height, 75, 75)];
//        [imageView sd_setImageWithURL:[NSURL URLWithString:dic[@"background_image"][@"thumb_image"]] placeholderImage:[UIImage imageNamed:@"activity_pic.png"]];
//        [containerView addSubview:imageView];
//        
//        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, height, containerWidth - 5 - 120, 75)];
//        contentLabel.numberOfLines = 0;
//        contentLabel.backgroundColor = [UIColor colorWithRed:207/255.0f green:207/255.0f blue:207/255.0f alpha:1.0f];
//        contentLabel.layer.borderColor = [UIColor colorWithRed:191/255.0f green:191/255.0f blue:191/255.0f alpha:1.0f].CGColor;
//        contentLabel.layer.borderWidth = 0.5;
//        contentLabel.font = [UIFont fontWithName:DEFAULT_FONT_LIGHT size:13];
//        contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
//        contentLabel.text = dic[@"desc"];
//        [containerView addSubview:contentLabel];
//        
//        height = height + 85;
//    }
//    
//    //对发布内容的描述
//    NSString *content = newsFeed.content;
//    if (![content isEqualToString:@""]) {
//        
//        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, height, containerWidth - 45 - 20, [self calculateViewHeight:content withViewWidth:containerWidth - 45 - 20 withFont:[UIFont systemFontOfSize:13]])];
//        contentLabel.numberOfLines = 0;
//        contentLabel.font = [UIFont systemFontOfSize:13];
//        contentLabel.text = content;
//        [containerView addSubview:contentLabel];
//        
//        height = height + [self calculateViewHeight:content withViewWidth:SCREENWIDTH - 6 - 20 - 45 withFont:[UIFont systemFontOfSize:13]] + 5;
//        
//        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(45, height, SCREENWIDTH - 45 - 20, 0.5)];
//        line.backgroundColor = RGBACOLOR(151, 151, 151, 100);
//        [containerView addSubview:line];
//    }
//    
//    //地理标签
//    UIImageView *tagImageView = [[UIImageView alloc] initWithFrame:CGRectMake(19, height + 2, 13, 15)];
//    tagImageView.image = [UIImage imageNamed:@"activity_icon_tag.png"];
//    [containerView addSubview:tagImageView];
//    
//    UILabel *tagLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, height, containerWidth - 5 - 45, 20)];
//    tagLabel.text = [NSString stringWithFormat:@"%@",@"用户发状态时所在的位置"];
//    tagLabel.font = [UIFont systemFontOfSize:13];
//    tagLabel.textColor = RGBACOLOR(136, 157, 181, 1);
//    [containerView addSubview:tagLabel];
//    
//    height = height + 20 + 5;
//    
//    
//    //展示点赞的人
//    NSArray *like = [NSArray arrayWithArray:newsFeed.likeUsers];
//    if (like.count > 0) {
//        //赞标签
//        UIImageView *likeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(19, height + 6, 13, 12)];
//        likeImageView.image = [UIImage imageNamed:@"activity_btn_praise_selected.png"];
//        [containerView addSubview:likeImageView];
//        
//        NSInteger count = like.count > 7 ? 7 : like.count;
//        for (int i = 0; i < count; i++) {
//            UserHeadImageView *praiseHeadView = [[UserHeadImageView alloc] initWithFrame:CGRectMake(45 + 30*i, height, 25, 25)];
//            praiseHeadView.layer.masksToBounds = YES;
//            praiseHeadView.layer.cornerRadius = 12.5;
//            praiseHeadView.layer.borderColor = [UIColor whiteColor].CGColor;
//            praiseHeadView.layer.borderWidth = 1;
//            praiseHeadView.userInteractionEnabled = YES;
//            praiseHeadView.userId = like[i][@"userId"];
//            [praiseHeadView sd_setImageWithURL:[NSURL URLWithString:like[i][@"thumb_image_url"]]];
//            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userHeadViewTap:)];
//            tap.numberOfTapsRequired = 1;
//            tap.numberOfTouchesRequired = 1;
//            [praiseHeadView addGestureRecognizer:tap];
//            [containerView addSubview:praiseHeadView];
//        }
//        
//        if (like.count > 7) {
//            UIButton *otherLike = [[UIButton alloc] initWithFrame:CGRectMake(45 + 30 * 7, height , containerWidth - 5 - 45 - 30 * 7, 25)];
//            [otherLike setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
//            [otherLike setTitleColor:RGBACOLOR(136, 157, 181, 1) forState:UIControlStateNormal];
//            [otherLike setTitle:[NSString stringWithFormat:@"and %d other like",(int)like.count - 7] forState:UIControlStateNormal];
//            [otherLike.titleLabel setFont:[UIFont fontWithName:DEFAULT_FONT_LIGHT size:13]];
//            [otherLike addTarget:self action:@selector(otherLikeClicked:) forControlEvents:UIControlEventTouchUpInside];
//            otherLike.tag = indexPath.row;
//            [containerView addSubview:otherLike];
//        }
//        
//        height = height + 25 + 5;
//    }
//    
//    //评论
//    NSArray *comment = [NSArray arrayWithArray:newsFeed.comments];
//    if (comment.count > 0) {
//        //评论的标签
//        UIImageView *commentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(19, height + 6, 13, 12)];
//        commentImageView.image = [UIImage imageNamed:@"activity_icon_comment.png"];
//        [containerView addSubview:commentImageView];
//        
//        NSInteger count = comment.count > 6 ? 6 : comment.count;
//        for (int i = 0; i < count; i++) {
//            NSDictionary *tempDic = comment[i];
//            NSString *name = tempDic[@"send_from"][@"name"];
//            NSString *content = tempDic[@"content"];
//            
//            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@:%@",name,content]];
//            [str addAttribute:NSForegroundColorAttributeName value:RGBACOLOR(136, 157, 181, 1) range:NSMakeRange(0,name.length + 1)];
//            UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, height, containerWidth - 45 - 5, [self calculateViewHeight:[NSString stringWithFormat:@"%@:%@",name,content] withViewWidth:containerWidth - 45 - 5 withFont:[UIFont systemFontOfSize:13]])];
//            commentLabel.attributedText = str;
//            commentLabel.font = [UIFont systemFontOfSize:13];
//            commentLabel.numberOfLines = 0;
//            commentLabel.lineBreakMode = NSLineBreakByWordWrapping;
//            [containerView addSubview:commentLabel];
//            
//            height = height + [self calculateViewHeight:[NSString stringWithFormat:@"%@:%@",name,content] withViewWidth:containerWidth - 45 - 5 withFont:[UIFont systemFontOfSize:13]];
//        }
//        if (comment.count > 6) {
//            UIButton *viewMoreBtn = [[UIButton alloc] initWithFrame:CGRectMake(45, height, containerWidth - 45 - 5, 20)];
//            [viewMoreBtn setTitleColor:RGBACOLOR(136, 157, 181, 1) forState:UIControlStateNormal];
//            [viewMoreBtn setTitle:[NSString stringWithFormat:@"and %d other comments",(int)comment.count - 6] forState:UIControlStateNormal];
//            [viewMoreBtn.titleLabel setFont:[UIFont fontWithName:DEFAULT_FONT_LIGHT size:13]];
//            [viewMoreBtn addTarget:self action:@selector(commentAction:) forControlEvents:UIControlEventTouchUpInside];
//            viewMoreBtn.tag = indexPath.row;
//            [containerView addSubview:viewMoreBtn];
//            
//            height = height + 20;
//        }
//        
//        height = height + 5;
//        
//    }
//    
//    // 点赞按钮  评论按钮  更多 按钮
//    UIButton *likeBtn = [[UIButton alloc] initWithFrame:CGRectMake(45, height, 95, 25)];
//    likeBtn.backgroundColor = RGBACOLOR(238, 238, 238, 1);
//    if (newsFeed.hasBeenPraised) {
//        [likeBtn setImage:[UIImage imageNamed:@"activity_btn_praise_selected.png"] forState:UIControlStateNormal];
//        likeBtn.selected = YES;
//    }
//    else
//    {
//        [likeBtn setImage:[UIImage imageNamed:@"activity_btn_praise_normal.png"] forState:UIControlStateNormal];
//        likeBtn.selected = NO;
//    }
//    [likeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -25, 0, 0)];
//    [likeBtn setTitleColor:RGBACOLOR(146, 146, 146, 1) forState:UIControlStateNormal];
//    [likeBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
//    [likeBtn setTitle:@"点赞" forState:UIControlStateNormal];
//    likeBtn.tag = indexPath.row;
//    [likeBtn addTarget:self action:@selector(likeAction:) forControlEvents:UIControlEventTouchUpInside];
//    [containerView addSubview:likeBtn];
//    
//    
//    UIButton *commentBtn = [[UIButton alloc] initWithFrame:CGRectMake(150, height, 95, 25)];
//    commentBtn.backgroundColor = RGBACOLOR(238, 238, 238, 1);
//    [commentBtn setImage:[UIImage imageNamed:@"activity_btn_comment.png"] forState:UIControlStateNormal];
//    [commentBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -25, 0, 0)];
//    [commentBtn setTitleColor:RGBACOLOR(146, 146, 146, 1) forState:UIControlStateNormal];
//    [commentBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
//    [commentBtn setTitle:@"评论" forState:UIControlStateNormal];
//    commentBtn.tag = indexPath.row;
//    [commentBtn addTarget:self action:@selector(commentAction:) forControlEvents:UIControlEventTouchUpInside];
//    [containerView addSubview:commentBtn];
//    
//    
//    UIButton *moreButton = [[UIButton alloc] initWithFrame:CGRectMake(containerWidth - 5 - 40, height, 40, 25)];
//    [moreButton setImage:[UIImage imageNamed:@"activity_btn_more.png"] forState:UIControlStateNormal];
//    moreButton.tag = indexPath.row;
//    [moreButton addTarget:self action:@selector(moreButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    [containerView addSubview:moreButton];
//    
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    return cell;
//}
//
//#pragma mark - UIScrollViewDelegate
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    [_headerView egoRefreshScrollViewDidScroll:scrollView];
//}
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//    [_headerView egoRefreshScrollViewDidEndDragging:scrollView];
//}
//
//#pragma mark -- EGORefreshTableViewDelegate
//
//- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos
//{
//    [self reloadTableViewDataSource];
//}
//
//- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView *)view
//{
//    return _reloadingData;
//}
//
//- (NSDate *)egoRefreshTableDataSourceLastUpdated:(UIView *)view
//{
//    return [NSDate date];
//}
//
//
//- (void)reloadTableViewDataSource
//{
//    _reloadingData = YES;
//    _currentPage = 1;
//    [self requestDataWithPage:_currentPage];
//}
//
//- (void)doneReloadTableViewDataSource
//{
//    _reloadingData = NO;
//    [_headerView egoRefreshScrollViewDataSourceDidFinishedLoading:_activityTableView];
//    [_activityTableView reloadData];
//}
//
//
//
///*
// #pragma mark - Navigation
// 
// // In a storyboard-based application, you will often want to do a little preparation before navigation
// - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
// // Get the new view controller using [segue destinationViewController].
// // Pass the selected object to the new view controller.
// }
// */
//
//@end
