//
//  SceneContentCell.h
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/4/18.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ContentModel;

typedef void (^oprationClock)(BOOL selected);

@interface SceneContentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *clickNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *operationButton;
@property (copy, nonatomic) oprationClock block;

- (void)setupContents:(ContentModel *)model viewType:(NSInteger)type;

@end
