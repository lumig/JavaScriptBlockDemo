//
//  ViewController.m
//  jsTest
//
//  Created by fangpinhui on 16/4/14.
//  Copyright © 2016年 lee. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIWebViewDelegate>
@property (nonatomic)UIWebView *webView;
@property (nonatomic)JSContext *jsContext;
@property (nonnull,strong) UIButton *btn;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    self.webView.delegate = self;
    [self.view addSubview:_webView];
    NSString *str = [[NSBundle mainBundle] pathForResource:@"untitled3" ofType:@"html"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:str]]];
    
    //  在上面添加一个按钮，实现oc端控制h5实现弹alert方法框
    self.btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 400, 100, 40)];
    self.btn.backgroundColor = [UIColor redColor];
    [self.btn addTarget:self action:@selector(showAlert) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btn];
    
    
}
- (void)showAlert
{
    //要将script的alert()方法转化为string类型
    NSString *alertJs=@"alert('Hello Word')";
    [_jsContext evaluateScript:alertJs];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    _jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    _jsContext[@"callShare"] =^(id obj){
////这里通过block回调从而获得h5传来的json数据
        NSData *data = [(NSString *)obj dataUsingEncoding:NSUTF8StringEncoding ];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@" data   %@   ======  ShareUrl %@",obj,dict[@"shareUrl"]);
    };

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
