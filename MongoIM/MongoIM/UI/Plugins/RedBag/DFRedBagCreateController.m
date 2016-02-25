//
//  DFRedBagCreateController.m
//  MongoIM
//
//  Created by Allen Zhong on 16/2/6.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#import "DFRedBagCreateController.h"
#import "DFRedBagMessageContent.h"

@interface DFRedBagCreateController()

@property (strong, nonatomic) UITextView *amountTextView;
@property (strong, nonatomic) UITextView *titleTextView;

@property (strong, nonatomic) UIButton *createButton;

@end

@implementation DFRedBagCreateController


- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}



-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"发红包";

    _amountTextView = [[UITextView alloc] initWithFrame:CGRectMake(20, 100, 200, 30)];
    _amountTextView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    _amountTextView.layer.borderWidth = 1;
    _amountTextView.text= @"100";
    [self.view addSubview:_amountTextView];
    
    _titleTextView = [[UITextView alloc] initWithFrame:CGRectMake(20, 160, 200, 30)];
    _titleTextView.layer.borderColor = [UIColor redColor].CGColor;
    _titleTextView.layer.borderWidth = 1;
    _titleTextView.text = @"恭喜发财 大吉大利";
    [self.view addSubview:_titleTextView];
    
    
    _createButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 220, 200, 30)];
    _createButton.backgroundColor = [UIColor redColor];
    [_createButton setTitle:@"发红包" forState:UIControlStateNormal];
    [_createButton addTarget:self action:@selector(create) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_createButton];
    
    
}


-(UIBarButtonItem *)leftBarButtonItem
{
    return [UIBarButtonItem text:@"关闭" selector:@selector(dismiss) target:self];
}

-(void) dismiss
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void) create
{
    DFRedBagMessageContent *content = [[DFRedBagMessageContent alloc] init];
    content.title = _titleTextView.text;
    
    [self.plugin send:content type:MessageContentTypeRedBag];
    [self dismiss];
}
            
@end
