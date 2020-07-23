//
//  ViewController.m
//  YXZChatFramework
//
//  Created by 颜学宙 on 2020/7/22.
//  Copyright © 2020 颜学宙. All rights reserved.
//

#import "ViewController.h"
#import "YxzChatListTableView.h"
#define MAXCOUNT 15
@interface ViewController ()
{
    NSArray<NSString *> *_conmentAry;
      NSArray<NSString *> *_nameAry;
}
@property(nonatomic,strong)YxzChatListTableView *listTableView;
@property (nonatomic) dispatch_source_t timer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor blackColor];
    
    _listTableView=[[YxzChatListTableView alloc]initWithFrame:CGRectMake(0, 100, MsgTableViewWidth, MsgTableViewHeight)];
    _listTableView.reloadType=YxzReloadLiveMsgRoom_Time;
    [self.view addSubview:self.listTableView];
    
    _conmentAry = @[@"如果我是DJ你会爱我吗🏷💋❤️💘💇 哟哟哟~~~",
                    @"好喜欢主播，主播唱歌太好听了🎤🎤🎤🎤",  @"تیتینینینی这是阿拉伯文，阿拉伯文从右到左排版，我们强制把它从按照正常排版显示~~",
                    @"哟哟~~切克闹！煎饼果子来一套~~😻✊❤️🙇",
                    @"哟哟！！你看那面又大又宽，你看那碗又大又圆！哟哟~~~😁😁😁😁😁😁",
                    @"蔡徐坤是NBA打球最帅的woman~~😏😏😏😏😏😏，不服来辩~~",
                    @"吴亦凡是rap界最有内涵的woman😏😏😏😏😏😏，不服来辩~~~"];
    
    _nameAry = @[@"蔡徐坤", @"吴亦凡", @"吴京", @"成龙", @"郭敬明"];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self start];
}
// 开始模拟发送消息
- (void)start {
    if (_timer == nil) {
        __weak typeof(self) weakSelf = self;
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 2.0*NSEC_PER_SEC/MAXCOUNT, 0);
        dispatch_source_set_event_handler(_timer, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf creatTestIMMsg:YxzMsgType_gift_text];
            });
        });
        dispatch_resume(_timer);
    }
}
// 随机生成不同类型消息
- (void)creatTestIMMsg:(YxzMsgType)subType {
    YXZMessageModel *msgModel = [YXZMessageModel new];
    if (subType == 0) {
        msgModel.msgType = arc4random() % 7;
    } else {
        msgModel.msgType = subType;
    }
    if (subType==YxzMsgType_Announcement) {
        msgModel.content=@"2020年10月10日将升级";
    }else if(subType==YxzMsgType_barrage){
        msgModel.content=_conmentAry[arc4random() % _conmentAry.count];
    }else if(subType==YxzMsgType_Other){
        msgModel.atUser = [YxzUserModel new];
        msgModel.atUser.nickName = @"这是一个被@的用户";
        msgModel.atUser.userID = @"10086";
        msgModel.atUser.gender = arc4random() % 1;
        msgModel.atUser.level = arc4random() % 100;
        msgModel.content=_conmentAry[arc4random() % _conmentAry.count];
    }else if (subType==YxzMsgType_Subscription){
//        msgModel.content=@"关注了主播";
    }else if(subType==YxzMsgType_gift_text){
        msgModel.quantity = @"1";
        msgModel.giftModel = [YxzGiftModel new];
        msgModel.giftModel.giftID = [NSString stringWithFormat:@"giftID_%u", arc4random() % 10];
        msgModel.giftModel.thumbnailUrl = @"https://showme-livecdn.9yiwums.com/gift/gift/20190225/b9a2dc3f1bef436598dfa470eada6a60.png";
        msgModel.giftModel.name = @"烟花🎆";
    }
    
    msgModel.msgID = [NSString stringWithFormat:@"msgID_%u", arc4random() % 10000];
    
    YxzUserModel *user = [YxzUserModel new];
    user.nickName = _nameAry[arc4random() % _nameAry.count];
    user.userID = [NSString stringWithFormat:@"userID_%ld", msgModel.msgType];
    user.level = arc4random() % 100;
    user.gender = arc4random() % 1;
    
    msgModel.user = user;
    
    
    // 生成富文本模型
    [msgModel initMsgAttribute];
    
    
    [self.listTableView addNewMsg:msgModel];
}

@end
