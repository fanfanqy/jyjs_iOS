//
//  SinglePaperVC.m
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/3/4.
//  Copyright © 2016年 WangQi. All rights reserved.
//

#import "SinglePaperVC.h"
#import "BelowToolbar.h"
#import "UIImage+ChangeSize.h"

@interface SinglePaperVC ()
@property (nonatomic , strong) UIImageView *wallpaper;
@property (nonatomic , strong) BelowToolbar *belowToolbar;
@end

@implementation SinglePaperVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.image = [[UIImage alloc]init];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatImageView];
    [self creatSubviews];
    
}

- (void)creatSubviews
{

    // 分享按钮
    
    UIImage *image = [UIImage imageNamed:@"share_black.png"];
    image = [image scaleToSize:image size:CGSizeMake(27, 36)];
   UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(shareAction)];
    
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
    // 收藏,预览,下载
    self.belowToolbar = [[BelowToolbar alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 104, self.view.frame.size.width, 40)];
    [self.view addSubview:self.belowToolbar];
    self.belowToolbar.delegate = self;
    
}

- (void)backAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)shareAction
{
    NSLog(@"分享给好友");
}
- (void)collectionAction:(UIButton *)button //收藏
{
    button.selected = !button.selected;
    NSLog(@"收藏");
}
- (void)previewAction // 预览
{
    NSLog(@"预览");
}
- (void)downloadAction // 下载
{
    NSLog(@"下载");
    UIImageWriteToSavedPhotosAlbum(self.image, nil, nil, nil);
}
- (void)creatImageView
{
    self.wallpaper = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64)];
    [self.view addSubview:self.wallpaper];
    self.wallpaper.image = self.image;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageviewTapAction:)];
    [self.wallpaper addGestureRecognizer:tap];
    self.wallpaper.userInteractionEnabled = YES;
}
// 点击当前图片,隐藏/显示 工具按钮
- (void)imageviewTapAction:(UITapGestureRecognizer *)tap
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end