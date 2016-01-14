//
//  ShareView.m
//  HiWeekend
//
//  Created by scjy on 16/1/14.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "ShareView.h"
#import "AppDelegate.h"
#import "WeiboSDK.h"
#import "WXApi.h"

@interface ShareView ()<WBHttpRequestDelegate>
@property (nonatomic, strong) UIView *shareView;
@property (nonatomic, strong) UIView *blackView;
@end
@implementation ShareView
- (instancetype)init{
    self = [super init];
    if (self) {
        [self configView];
    }
    return self;
}

- (void)configView{
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    self.blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    self.blackView.backgroundColor = [UIColor blackColor];
    self.blackView.alpha = 0.0;
    [window addSubview:self.blackView];
    self.shareView = [[UIView alloc] initWithFrame:CGRectMake(0, kHeight, kWidth, 200)];
    self.shareView.backgroundColor = [UIColor whiteColor];
    [window addSubview:self.shareView];
    
    //微博
    UIButton *weiboBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    weiboBtn.frame = CGRectMake(40, 15, 80, 120);
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20, 60, 60)];
    image.image = [UIImage imageNamed:@"share_weibi"];
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 80, 80, 20)];
    label1.text = @"分享到微博";
    label1.font = [UIFont systemFontOfSize:12];
    
    [weiboBtn addSubview:image];
    [weiboBtn addSubview:label1];
    [weiboBtn addTarget:self action:@selector(weiboShare) forControlEvents:UIControlEventTouchUpInside];
    [self.shareView addSubview:weiboBtn];
    //朋友
    UIButton *friendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    friendBtn.frame = CGRectMake(140, 15, 80, 120);
    UIImageView *image1 = [[UIImageView alloc]initWithFrame:CGRectMake(120, 20, 60, 60)];
    image1.image = [UIImage imageNamed:@"share_weixin"];
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(120, 80, 80, 20)];
    label2.text = @"分享给好友";
    [weiboBtn addSubview:image1];
    [weiboBtn addSubview:label2];
    label2.font = [UIFont systemFontOfSize:12];
    
    [friendBtn addTarget:self action:@selector(weixinShare) forControlEvents:UIControlEventTouchUpInside];
    [self.shareView addSubview:friendBtn];
    
    
    //朋友圈
    UIButton *circleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    circleBtn.frame = CGRectMake(240, 15, 80, 120);
    UIImageView *image2 = [[UIImageView alloc]initWithFrame:CGRectMake(220, 20, 60, 60)];
    image2.image = [UIImage imageNamed:@"circle"];
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(220, 80, 80, 20)];
    label3.text = @"分享到朋友圈";
    label3.font = [UIFont systemFontOfSize:12];
    [weiboBtn addSubview:image2];
    [weiboBtn addSubview:label3];
    
    [circleBtn addTarget:self action:@selector(friendShare) forControlEvents:UIControlEventTouchUpInside];
    [self.shareView addSubview:circleBtn];
    
    //取消按钮
    UIButton *removeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    removeBtn.frame = CGRectMake(70, 130, kWidth - 140, 40);
    removeBtn.backgroundColor = kColor;
    [removeBtn setTitle:@"取消" forState:UIControlStateNormal];
    [removeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [removeBtn addTarget:self action:@selector(returnMine) forControlEvents:UIControlEventTouchUpInside];
    [self.shareView addSubview:removeBtn];
    [UIView animateWithDuration:1.0 animations:^{
        self.blackView.alpha = 0.8;
        self.shareView.frame = CGRectMake(0, kHeight - 200, kWidth, 200);
        
    }];
    AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    [WeiboSDK logOutWithToken:myDelegate.wbtoken delegate:self withTag:@"user1"];

    
}
- (void)returnMine{
    [self.blackView removeFromSuperview];
    [self.shareView removeFromSuperview];
}
- (void)weiboShare{
    [self returnMine];
    AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = kRedirectURL;
    request.scope = @"all";
    request.userInfo = @{@"SSO_From":@"MineViewController", @"Other_Info_1": [NSNumber numberWithInt:123], @"Other_Info_2": @[@"obj1", @"obj2"], @"Other_Info_3":@{@"key1":@"obj1",@"key2":@"obj2"}};
    WBSendMessageToWeiboRequest *request1 = [WBSendMessageToWeiboRequest requestWithMessage:[self messageToShare]authInfo:request access_token:myDelegate.wbtoken];
    request1.userInfo = @{@"ShareMessageFrom":@"MineViewController", @"Other_Info_1": [NSNumber numberWithInt:123], @"Other_Info_2": @[@"obj1", @"obj2"], @"Other_Info_3":@{@"key1":@"obj1",@"key2":@"obj2"}};
    [WeiboSDK sendRequest:request1];
    //    WBProvideMessageForWeiboResponse *reponse = [WBProvideMessageForWeiboResponse responseWithMessage:[self messageToShare]];
    //    [WeiboSDK sendResponse:reponse];
}
- (WBMessageObject *)messageToShare{
    WBMessageObject *message = [WBMessageObject message];
    WBImageObject *image = [WBImageObject object];
    image.imageData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"007" ofType:@".jpg"]];
    message.imageObject = image;

//    WBWebpageObject *web = [WBWebpageObject object];
//    web.objectID = @"identifier1";
//    web.title = NSLocalizedString(@"Hi,周末", nil);
//    web.description = [NSString stringWithFormat:NSLocalizedString(@"这里有各种好玩的，快来玩吧", nil), [[NSDate date] timeIntervalSince1970]];
//    web.thumbnailData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"circle" ofType:@".png"]];
//    web.webpageUrl = @"http://open.weibo.com/";
//    message.mediaObject = web;
    return message;
}

- (void)friendShare{
    [self returnMine];
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"哈哈哈哈";
    [message setThumbImage:[UIImage imageNamed:@"ac_location_normal"]];
    WXWebpageObject *web = [WXWebpageObject object];
    web.webpageUrl = @"http://open.weibo.com/apps/3331706835/info/basic";
    message.mediaObject = web;
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.message = message;
    req.bText = NO;
    req.scene = WXSceneTimeline;
    [WXApi sendReq:req];
}
- (void)weixinShare{
    [self returnMine];
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:[UIImage imageNamed:@"007.jpg"]];
    WXImageObject *imageObject = [WXImageObject object];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"007" ofType:@".jpg"];
    imageObject.imageData = [NSData dataWithContentsOfFile:filePath];
    message.mediaObject = imageObject;
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.message = message;
    req.bText = NO;
    req.scene = WXSceneSession;
    [WXApi sendReq:req];
}







@end
