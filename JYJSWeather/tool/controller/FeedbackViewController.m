//
//  FeedbackViewController.m
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/5/20.
//  Copyright © 2016年 WangQi. All rights reserved.
//

#import "FeedbackViewController.h"
#import "ASNetworking.h"

static const CGFloat gap = 10;
static const CGFloat buttonHeight = 30;

@interface FeedbackViewController ()
{
    
}
@property (nonatomic , strong) UIView * buttonBackgroundView;
@property (nonatomic , strong) NSArray *butArray;
@property (nonatomic , strong) UITextView *textView;
@property (nonatomic , strong) UIButton * submit;



@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"意见反馈";
    [self.view setBackgroundColor:UIColorFromRGB(0xF4F4F4)];
    [self creatView];
    [self addSwipe];
}
- (void)creatView
{
    self.buttonBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(gap, gap + 64, self.view.frame.size.width - gap * 2, buttonHeight + gap * 2)];
    [self.view addSubview:self.buttonBackgroundView];
    
    UIButton * weather = [[UIButton alloc]initWithFrame:CGRectMake(0, gap, 150, buttonHeight)];
    [self.buttonBackgroundView addSubview:weather];
    [weather setTitle:@"天气信息不准确" forState:UIControlStateNormal];
    [weather setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [weather setBackgroundColor:[UIColor whiteColor]];
    [weather addTarget:self action:@selector(selectedType:) forControlEvents:UIControlEventTouchUpInside];
    weather.layer.cornerRadius = gap;
    [weather setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    
    
    UIButton * location = [[UIButton alloc]initWithFrame:CGRectMake(weather.frame.size.width + gap, gap, 100, buttonHeight)];
    [self.buttonBackgroundView addSubview:location];
    [location setTitle:@"定位不准确" forState:UIControlStateNormal];
    [location setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [location setBackgroundColor:[UIColor whiteColor]];
    [location addTarget:self action:@selector(selectedType:) forControlEvents:UIControlEventTouchUpInside];
    location.layer.cornerRadius = gap;
    [location setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];

    
    UIButton * otherbut = [[UIButton alloc]initWithFrame:CGRectMake(location.frame.origin.x + location.frame.size.width + gap, gap, buttonHeight * 2, buttonHeight)];
    [self.buttonBackgroundView addSubview:otherbut];
    [otherbut setTitle:@"其他" forState:UIControlStateNormal];
    [otherbut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [otherbut setBackgroundColor:[UIColor whiteColor]];
    [otherbut addTarget:self action:@selector(selectedType:) forControlEvents:UIControlEventTouchUpInside];
    otherbut.layer.cornerRadius = gap;
    [otherbut setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];

    
    self.textView = [[UITextView alloc]initWithFrame:CGRectMake(gap, self.buttonBackgroundView.frame.origin.y + self.buttonBackgroundView.frame.size.height, self.view.frame.size.width - 2 * gap, 200)];
    [self.view addSubview:self.textView];
    self.textView.layer.cornerRadius = gap;
    self.textView.font = [UIFont systemFontOfSize:17];
    
    
    self.submit = [[UIButton alloc]initWithFrame:CGRectMake((self.view.frame.size.width-40) / 2, self.textView.frame.origin.y + self.textView.frame.size.height + gap, buttonHeight * 2, buttonHeight)];
    [self.view addSubview:self.submit];
    [self.submit setTitle:@"提交" forState:UIControlStateNormal];
    self.submit.backgroundColor = [UIColor lightGrayColor];
    self.submit.layer.cornerRadius = gap;
    [self.submit addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
    keyboardDoneButtonView.barStyle = UIBarStyleDefault;
    keyboardDoneButtonView.translucent = YES;
    keyboardDoneButtonView.tintColor = nil;
    [keyboardDoneButtonView sizeToFit];
    // toolbar上的2个按钮
    UIBarButtonItem *SpaceButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                               target:nil  action:nil]; // 让完成按钮显示在右侧
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                                   style:UIBarButtonItemStyleDone target:self
                                                                  action:@selector(pickerDoneClicked)];
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:SpaceButton, doneButton, nil]];
    self.textView.inputAccessoryView = keyboardDoneButtonView;
    
    
  

}
- (void)submitAction:(UIButton *)button
{
    NSDictionary * dic = @{@"Token":Token ,
                           @"Category":@"1",
                           @"Contents":@"test"};
    [ASNetworking ASNetURLconnectionWith:FeedbackUrl type:@"POST" Parmaters:dic FinishBlock:^(NSData *data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSUTF8StringEncoding error:nil];
            NSNumber * number = [dic objectForKey:@"d"];
            if ([number integerValue] == 1 ) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"提交反馈成功!" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    [self.navigationController popViewControllerAnimated:NO];
                }];
                
                [alert addAction:action];
                [self presentViewController:alert animated:YES completion:^{
                    
                }];
                
            } else {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"提交反馈失败,请重新提交!" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    
                }];
                
                [alert addAction:action];
                [self presentViewController:alert animated:YES completion:^{
                    
                }];

                
            }
        });
        
    }];
    
}
-(void)pickerDoneClicked
{
    [self.textView resignFirstResponder];
}
- (void)addSwipe
{
    //添加轻扫手势
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
    //设置轻扫的方向
    swipeGesture.direction = UISwipeGestureRecognizerDirectionDown; //默认向右
    [self.view addGestureRecognizer:swipeGesture];
}
- (void)swipeGesture:(UISwipeGestureRecognizer *)swipeGesture
{
    [self.textView resignFirstResponder];
}
- (void)selectedType:(UIButton *)button
{
    for (UIButton *but  in self.buttonBackgroundView.subviews) {
        but.selected = NO;
        but.backgroundColor = [UIColor whiteColor];
    }
    button.backgroundColor = self.submit.backgroundColor;
    button.selected = YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
