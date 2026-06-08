****



##### 笔记原则

- 任何笔记内容都要有 ’**主线**‘ 来串联
  - 因果链条 / 状态流 



##### 技术相关Prompt

- 初次询问技术：
  - $xx技术{例如饭型擦除} 究竟要理解何程度？ 每次都是一大篇‘课文’，类似应试教育知识点不说人话，明明两三段能说清非要搞好几页背景介绍/相关技术概述/相关技术背景/xx角度 + 要么就是火星文一样的‘蓄意编造



##### 业务理解格式

- 优先用Markdown缩进 而非动不动用XMind 表示流程：完全透彻之前不要用XMind，用markdown的【精准抽象类】缩进即可，就类似于下面内容中的【流程】：

  - ```
    ##### 短信场景下的SpringEvent应用案例
    - Cause：
      - 短信发送/验证都是在system内，因此用单体的SpringEvent
    - 流程：
      - H5会员登录接口 --> service --feign--> system.sendMq：1生成验证码存sms_code表，2调用 --> sendSingleSms：1校验模板/渠道，2存log，3调用 --> smsProducer.sendSmsSendMessage（applicationContext.publishEvent()发SpringEvent（此处是生产者）） --> 
        	消费者（system）：SmsSendConsumer.onMessage()(← @EventListener + @Async)  -->  doSendSms调用三方SMS API
      - 最终， 手机收到短信，然后，登陆时用户填入短信验证码，传入登录接口，然后会查sms表核对是否匹配...
    
      - 
    
    
    ```

    









用户正在参与一个涉及“IS业务类型与产品类型关系变更”的中后台系统功能重构项目，任务内容包括读取和理解账单中心/报障系统等多个页面的老旧代码（屎山），梳理前后端数据结构和映射逻辑，更新本地字典表并补全中英文国际化，涉及复杂的 queryMsgList、queryGraph 等重复调用的巨大方法和数据流。用户已持续输出日报和笔记，有完整的流程分析和改造记录。.
