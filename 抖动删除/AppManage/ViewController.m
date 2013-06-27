//
//  ViewController.m
//  AppManage
//
//  Created by chen on 13-5-29.
//  Copyright (c) 2013年 chen. All rights reserved.
//

#import "ViewController.h"

#import "AppButton.h"

#define WIDTH  65
#define HIGHT  105

#define TAGH  10

#define BTNWIDTH  WIDTH - TAGH
#define BTNHIGHT  HIGHT - TAGH

@interface ViewController ()
{
    BOOL m_bTransform;
    NSMutableArray *m_arData;
}

@end

@implementation ViewController

- (void)dealloc
{
    [m_arData release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createData];
	// Do any additional setup after loading the view, typically from a nib.
    int width = self.view.frame.size.width/4;
    for (int i = 0; i < [m_arData count]; i++)
    {
        int t = i/4;
        int d = fmod(i, 4);
        UIView *nView = [[[UIView alloc] initWithFrame:CGRectMake(width * d + 5, HIGHT * t +10, WIDTH, HIGHT)] autorelease];
        CAppButton *appBtn = [CAppButton BtnWithType:UIButtonTypeCustom];
        [appBtn setFrame:CGRectMake(TAGH, TAGH, BTNWIDTH, BTNHIGHT)];
        [appBtn setImage:[UIImage imageNamed:@"apphead.png"] forState:UIControlStateNormal];
        [appBtn setTitle:[m_arData objectAtIndex:i] forState:UIControlStateNormal];
        [appBtn addTarget:self action:@selector(btnClicked:event:) forControlEvents:UIControlEventTouchUpInside];
        appBtn.tag = i;
        [nView addSubview:appBtn];
        
        UIImageView *tagImgView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)] autorelease];
        [tagImgView setImage:[UIImage imageNamed:@"deleteTag.png"]];
        [tagImgView setHidden:YES];
        [nView addSubview:tagImgView];
        
        [self.view addSubview:nView];
        nView.userInteractionEnabled = NO;
    }
    
    UILongPressGestureRecognizer *lpgr = [[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(LongPressGestureRecognizer:)] autorelease];
    [self.view addGestureRecognizer:lpgr];
    
    UITapGestureRecognizer *tapGestureTel2 = [[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TwoPressGestureRecognizer:)]autorelease];
    [tapGestureTel2 setNumberOfTapsRequired:2];
    [tapGestureTel2 setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:tapGestureTel2];
}

- (void)createData
{
    m_arData = [[NSMutableArray alloc] initWithObjects:@"电话", @"短信", @"通讯录", @"浏览器", @"日历", @"时钟", @"计算器", @"地图", @"天气", @"图库", nil];
}

- (void)btnClicked:(id)sender event:(id)event
{
    UIButton *btn = (UIButton *)sender;
    [self deleteAppBtn:btn.tag];
}

- (void)deleteAppBtn:(int)index
{
    NSArray *views = self.view.subviews;
    __block CGRect newframe;
    for (int i = index; i < [m_arData count]; i++)
    {
        UIView *obj = [views objectAtIndex:i];
        __block CGRect nextframe = obj.frame;
        if (i == index)
        {
            [obj removeFromSuperview];
        }
        else
        {
            for (UIView *v in obj.subviews)
            {
                if ([v isMemberOfClass:[CAppButton class]])
                {
                    v.tag = i - 1;
                    break;
                }
            }
            [UIView animateWithDuration:0.6 animations:^
             {
                 obj.frame = newframe;
             } completion:^(BOOL finished)
             {
             }];
        }
        newframe = nextframe;
    }
    [m_arData removeObjectAtIndex:index];
}

- (void)LongPressGestureRecognizer:(UIGestureRecognizer *)gr
{
    if (gr.state == UIGestureRecognizerStateBegan)
    {
        if (m_bTransform)
            return;
        
        for (UIView *view in self.view.subviews)
        {
            view.userInteractionEnabled = YES;
            for (UIView *v in view.subviews)
            {
                if ([v isMemberOfClass:[UIImageView class]])
                    [v setHidden:NO];
            }
        }
        m_bTransform = YES;
        [self BeginWobble];
    }
}

-(void)TwoPressGestureRecognizer:(UIGestureRecognizer *)gr
{
    if(m_bTransform==NO)
        return;
    
    for (UIView *view in self.view.subviews)
    {
        view.userInteractionEnabled = NO;
        for (UIView *v in view.subviews)
        {
            if ([v isMemberOfClass:[UIImageView class]])
                [v setHidden:YES];
        }
    }
    m_bTransform = NO;
    [self EndWobble];
}

-(void)BeginWobble
{
    NSAutoreleasePool* pool=[NSAutoreleasePool new];
    for (UIView *view in self.view.subviews)
    {
        srand([[NSDate date] timeIntervalSince1970]);
        float rand=(float)random();
        CFTimeInterval t=rand*0.0000000001;
        [UIView animateWithDuration:0.1 delay:t options:0  animations:^
         {
             view.transform=CGAffineTransformMakeRotation(-0.05);
         }
                         completion:^(BOOL finished)
         {
             [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse|UIViewAnimationOptionAllowUserInteraction  animations:^
              {
                  view.transform=CGAffineTransformMakeRotation(0.05);
              } completion:^(BOOL finished) {}];
         }];
    }
    [pool release];
}

-(void)EndWobble
{
    NSAutoreleasePool* pool=[NSAutoreleasePool new];
    for (UIView *view in self.view.subviews)
    {
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState animations:^
         {
             view.transform=CGAffineTransformIdentity;
             for (UIView *v in view.subviews)
             {
                 if ([v isMemberOfClass:[UIImageView class]])
                     [v setHidden:YES];
             }
         } completion:^(BOOL finished) {}];
    }
    [pool release];
}

@end
