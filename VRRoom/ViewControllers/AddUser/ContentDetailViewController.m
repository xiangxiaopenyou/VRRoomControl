//
//  ContentDetailViewController.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/10/17.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "ContentDetailViewController.h"
#import "XJContentWebViewController.h"
#import "DetailContentCell.h"
//#import "AudioPlayerView.h"
#import "XLBlockAlertView.h"

#import "ContentModel.h"
//#import "ContentsMediaModel.h"

#import <UIImageView+WebCache.h>
#import <UIImage-Helpers.h>

//#import <UtoVRPlayer/UtoVRPlayer.h>
//#import <SDCycleScrollView.h>

@interface ContentDetailViewController ()</*UVPlayerDelegate,*/UITableViewDelegate, UITableViewDataSource/*, SDCycleScrollViewDelegate*/>
@property (weak, nonatomic) IBOutlet UIView *viewOfPlayer;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UIButton *collectButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraintOfPlayer;
@property (nonatomic) NSInteger isAdded;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectButtonHeight;

//@property (strong, nonatomic) UVPlayer *vrPlayer;
//@property (strong, nonatomic) UVPlayerItem  *vrPlayerItem;
//@property (strong, nonatomic) AudioPlayerView *audioPlayerView;
//@property (strong, nonatomic) SDCycleScrollView *cyclePicturesView;
//@property (strong, nonatomic) UIButton *startButton;
//@property (assign, nonatomic) CGFloat width;
//@property (strong, nonatomic) ContentsMediaModel *mediaModel;

@end

@implementation ContentDetailViewController

#pragma mark - UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    _width = SCREEN_WIDTH;

//    if ([self.contentModel.type integerValue] == 1) {
//        [self.navigationController setNavigationBarHidden:YES];
//        [self.viewOfPlayer addSubview:self.vrPlayer.playerView];
//        self.vrPlayer.gyroscopeEnabled = YES;
//        self.vrPlayer.duralScreenEnabled = YES;
//        [self.viewOfPlayer addSubview:self.startButton];
//        [_startButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.center.equalTo(self.viewOfPlayer);
//            make.width.height.mas_offset(51);
//        }];
//        self.startButton.hidden = YES;
//    } else if ([self.contentModel.type integerValue] == 2) {
//        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
//        _audioPlayerView = [[NSBundle mainBundle] loadNibNamed:@"AudioPlayerview" owner:nil options:nil][0];
//        [self.viewOfPlayer addSubview:_audioPlayerView];
//        [_audioPlayerView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.leading.trailing.top.bottom.equalTo(self.viewOfPlayer);
//        }];
//    } else {
//        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
//        [self.viewOfPlayer addSubview:self.cyclePicturesView];
//        [self.cyclePicturesView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.leading.trailing.top.bottom.equalTo(self.viewOfPlayer);
//        }];
//    }
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStyleDone target:self action:@selector(closeAction)]];
    XLShowHUDWithMessage(nil, self.view);
    [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:self.contentModel.coverPic] placeholderImage:[UIImage imageNamed:@"default_image"]];
    [self.collectButton setBackgroundImage:[UIImage imageWithColor:NAVIGATIONBAR_COLOR] forState:UIControlStateSelected];
    [self.collectButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:0.9 alpha:1]] forState:UIControlStateNormal];
    [self refreshBottomButtonState];
    _isAdded = self.contentModel.isAdded.integerValue;
    [self fetchDetails:self.contentModel.id];
}
//- (void)viewDidLayoutSubviews {
//    [super viewDidLayoutSubviews];
//    if ([self.contentModel.type integerValue] == 1) {
//        [self.vrPlayer.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.leading.trailing.top.bottom.equalTo(self.viewOfPlayer);
//        }];
//    }
    
//}
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    if ([self.contentModel.type integerValue] == 3) {
//        [self.cyclePicturesView adjustWhenControllerViewWillAppera];
//    }
//}
//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//}
//- (void)viewDidDisappear:(BOOL)animated {
//    [super viewDidDisappear:animated];
//    if (self.vrPlayer) {
//        [self.vrPlayer prepareToRelease];
//        self.vrPlayer = nil;
//    } if (self.audioPlayerView) {
//        [self.audioPlayerView removeFromSuperview];
//        self.audioPlayerView = nil;
//    }
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//视频播放屏幕旋转处理
//- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
//    BOOL isLandscape = size.width == _width;
//    CGFloat height;
//    if (isLandscape) {
//        height = 225.0;
//        self.collectButtonHeight.constant = 45.f;
//    } else {
//        height = SCREEN_WIDTH;
//        self.collectButtonHeight.constant = 0;
//    }
//    CGFloat duration = [coordinator transitionDuration];
//    self.heightConstraintOfPlayer.constant = height;
//    [UIView animateWithDuration:duration animations:^{
//        [self.view layoutIfNeeded];
//    }];
//}
//设置底部按钮
- (void)refreshBottomButtonState {
    if (self.viewType == 1) {
        [self.collectButton setTitle:@"收藏" forState:UIControlStateNormal];
        [self.collectButton setTitle:@"已收藏" forState:UIControlStateSelected];
        self.collectButton.selected = [self.contentModel.isCollected integerValue] == 0 ? NO : YES;
    } else {
        [self.collectButton setTitle:@"选择" forState:UIControlStateNormal];
        [self.collectButton setTitle:@"已选择" forState:UIControlStateSelected];
        self.collectButton.selected = [self.contentModel.isAdded integerValue] == 0 ? NO : YES;
    }
}

#pragma mark - Requests
- (void)fetchDetails:(NSString *)contentId {
    [ContentModel fetchContentDetail:contentId handler:^(id object, NSString *msg) {
        if (object) {
            XLDismissHUD(self.view, NO, YES, nil);
            self.contentModel = object;
            self.contentModel.isAdded = @(_isAdded);
            GJCFAsyncMainQueue(^{
//                if (self.contentModel.ext) {
//                    self.mediaModel = [ContentsMediaModel yy_modelWithDictionary:self.contentModel.ext];
//                    [self loadPlayer];
//                }
                [self refreshBottomButtonState];
                [self.tableView reloadData];
            });
        } else {
            XLDismissHUD(self.view, YES, NO, msg);
        }
    }];
}

#pragma mark - IBAction & Selector
- (void)closeAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)collectAction:(id)sender {
    if (self.viewType == 1) {
        if (self.contentModel.isCollected.integerValue == 0) {
            self.contentModel.isCollected = @(1);
            [ContentModel collectContent:self.contentModel.id handler:nil];
            XLDismissHUD(self.view, YES, YES, @"收藏成功");
        } else {
            self.contentModel.isCollected = @(0);
            [ContentModel cancelCollectContent:self.contentModel.id handler:nil];
            XLDismissHUD(self.view, YES, YES, @"取消收藏成功");
        }
    } else {
        self.contentModel.isAdded = self.contentModel.isAdded.integerValue == 0 ? @(1) : @(0);
    }
    [self refreshBottomButtonState];
    if (self.collectBlock) {
        self.collectBlock(self.contentModel);
    }
}
- (void)linkAction {
    XJContentWebViewController *webController = [[XJContentWebViewController alloc] init];
    webController.urlString = self.contentModel.contentDescription;
    [self.navigationController pushViewController:webController animated:YES];
}
//- (void)startPlay {
//    if (XLNetworkState != 5) {
//        [[[XLBlockAlertView alloc] initWithTitle:@"提示" message:NSLocalizedString(@"player.wifiNotReachability", nil) block:^(NSInteger buttonIndex) {
//            if (buttonIndex == 1) {
//                [self videoPlay];
//            }
//        } cancelButtonTitle:NSLocalizedString(@"cancel", nil) otherButtonTitles:NSLocalizedString(@"player.continuePlay", nil), nil] show];
//    } else {
//        [self videoPlay];
//    }
//    
//}
//- (void)videoPlay {
//    if (self.vrPlayer.currentItem) {
//        [self.vrPlayer play];
//    } else {
//        if (_vrPlayerItem) {
//            [self.vrPlayer appendItem:_vrPlayerItem];
//        } else {
//            XLShowThenDismissHUD(NO, XJVideoCanNotPlay, self.view);
//        }
//    }
//    self.startButton.hidden = YES;
//}

#pragma mark - Private Methods
//- (void)loadPlayer {
//    if ([self.contentModel.type integerValue] == 1) {
//        if (self.mediaModel.content) {
//            _vrPlayerItem = [[UVPlayerItem alloc] initWithPath:self.mediaModel.content type:UVPlayerItemTypeOnline];
//            self.startButton.hidden = NO;
//        }
//    } else if ([self.contentModel.type integerValue] == 2) {
//        if (self.mediaModel.content) {
//            [_audioPlayerView setupContents:self.mediaModel.content imageUrl:self.contentModel.coverPic];
//        }
//    } else {
//        if (self.mediaModel.content) {
//            NSArray *tempArray = [self.mediaModel.content componentsSeparatedByString:@","];
//            self.cyclePicturesView.imageURLStringsGroup = [tempArray copy];
//        }
//    }
//}
#pragma mark - UVPlayerDelegate
//- (void)player:(UVPlayer *)player playingStatusDidChanged:(NSDictionary *)dict {
//    float rate = [dict[@"rate"] floatValue];
//    BOOL avalibaleItem = [dict[@"avalibaleItem"] boolValue];
//    BOOL bufferFull = [dict[@"bufferFull"] boolValue];
//    if (rate == 1 || (!avalibaleItem && !bufferFull) ) {
//        self.startButton.hidden = YES;
//    } else {
//        self.startButton.hidden = NO;
//    }
//}
#pragma mark - UITableView DataSource Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //CGSize size = XLSizeOfText(self.contentModel.contentDescription, SCREEN_WIDTH - 30, XJSystemFont(14));
    return 180.f/* + size.height*/;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"DetailContent";
    DetailContentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.contentModel) {
        cell.collectionButton.hidden = self.viewType == 1 ? YES : NO;
        cell.contentTitleLabel.text = [NSString stringWithFormat:@"%@", self.contentModel.name];
        cell.contentTimeLabel.text = self.contentModel.createdAt ? [NSString stringWithFormat:@"%@", self.contentModel.createdAt] : nil;
        cell.clickNumberLabel.text = [NSString stringWithFormat:@"点击量：%@", @(self.contentModel.clicks.integerValue)];
        cell.priceLabel.text = [NSString stringWithFormat:@"￥%.2f", [self.contentModel.price floatValue]];
        NSString *diseaseString = @"";
        if (!XLIsNullObject(self.contentModel.disease)) {
            diseaseString = [NSString stringWithFormat:@"%@", self.contentModel.disease];
        }
        if (!XLIsNullObject(self.contentModel.therapy)) {
            if (XLIsNullObject(diseaseString)) {
                diseaseString = [NSString stringWithFormat:@"%@", self.contentModel.therapy];
            } else {
                diseaseString = [NSString stringWithFormat:@"%@-%@", diseaseString, self.contentModel.therapy];
            }
        }
        if (!XLIsNullObject(self.contentModel.typeName)) {
            if (XLIsNullObject(diseaseString)) {
                diseaseString = [NSString stringWithFormat:@"%@", self.contentModel.typeName];
            } else {
                diseaseString = [NSString stringWithFormat:@"%@-%@", diseaseString, self.contentModel.typeName];
            }
        }
        cell.diseaseLabel.text = diseaseString;
        cell.collectionButton.selected = [self.contentModel.isCollected integerValue] == 0 ? NO : YES;
        cell.durationLabel.text = [NSString stringWithFormat:@"%@分钟", self.contentModel.duration];
        //cell.descriptionLabel.text = [NSString stringWithFormat:@"%@", self.contentModel.contentDescription];
        [cell.linkButton addTarget:self action:@selector(linkAction) forControlEvents:UIControlEventTouchUpInside];
        GJCFWeakObject(cell) weakCell = cell;
        cell.collectBlock = ^(){
            if ([self.contentModel.isCollected integerValue] == 0) {
                self.contentModel.isCollected = @1;
                weakCell.collectionButton.selected = YES;
                [ContentModel collectContent:self.contentModel.id handler:nil];
                XLDismissHUD(self.view, YES, YES, @"收藏成功");
            } else {
                self.contentModel.isCollected = @0;
                weakCell.collectionButton.selected = NO;
                [ContentModel cancelCollectContent:self.contentModel.id handler:nil];
                XLDismissHUD(self.view, YES, YES, @"取消收藏成功");
            }
            if (self.collectBlock) {
                self.collectBlock(self.contentModel);
            }
        };
    }
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Getters
//- (UVPlayer *)vrPlayer {
//    if (!_vrPlayer) {
//        _vrPlayer = [[UVPlayer alloc] initWithConfiguration:nil];
//        _vrPlayer.delegate = self;
//        [_vrPlayer setPortraitBackButtonTarget:self selector:@selector(backAction:)];
//    }
//    return _vrPlayer;
//}
//播放视频按钮
//- (UIButton *)startButton {
//    if (!_startButton) {
//        _startButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_startButton setImage:[UIImage imageNamed:@"video_stop"] forState:UIControlStateNormal];
//        [_startButton addTarget:self action:@selector(startPlay) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _startButton;
//    
//}
//图片集轮播
//- (SDCycleScrollView *)cyclePicturesView {
//    if (!_cyclePicturesView) {
//        _cyclePicturesView = [[SDCycleScrollView alloc] init];
//        _cyclePicturesView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
//        _cyclePicturesView.autoScrollTimeInterval = 15.0;
//        _cyclePicturesView.contentMode = UIViewContentModeScaleAspectFill;
//        _cyclePicturesView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
//        _cyclePicturesView.placeholderImage = [UIImage imageNamed:@"default_image"];
//        _cyclePicturesView.clipsToBounds = YES;
//        _cyclePicturesView.delegate = self;
//    }
//    return _cyclePicturesView;
//}

@end
