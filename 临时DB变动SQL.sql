

#注销需求相关数据库变动

更新表结构
ALTER TABLE member MODIFY COLUMN is_log_off TINYINT NOT NULL default 0 comment '注销标记01';

#更新存量数据(小程序和H5都得执行)
update member set is_log_off=0 where deleted=0;
update member set is_log_off=1 where deleted=1;


#成员测试数据
INSERT INTO member (id,member_no,balance,nickname,deleted, tenant_id,phone,parent_id) VALUES
	 (101,'xq test no1',100,'xq测试成员1',0,1,'13100250121',NULL),
	 (1011,'xq test no11',200,'xq测试成员11',0,1,'13100250122','101'),
	 (1012,'xq test no12',300,'xq测试成员12',0,1,'13100250123','101'),
	 (10111,'xq test no111',400,'xq测试成员111',0,1,'13100250124','1011'),
	 (10112,'xq test no112',500,'xq测试成员112',0,1,'13100250125','1011')
;


#关系测试数据
INSERT INTO member_relationship (id,child_member_id,parent_member_id,status,confirm_type,
  bind_time,cooling_end_time,create_time,update_time,deleted,tenant_id) 
VALUES
	 (1101,1011,101,2,1,'2026-04-01 00:00:00','2026-04-16 00:00:00','2026-04-01 00:00:00','2026-04-01 00:00:00',0,1),
	 (1201,1012,101,2,1,'2026-04-01 00:00:00','2026-04-16 00:00:00','2026-04-01 00:00:00','2026-04-01 00:00:00',0,1),
	 (111011,10111,1011,2,1,'2026-04-01 00:00:00','2026-04-16 00:00:00','2026-04-01 00:00:00','2026-04-01 00:00:00',0,1),
	 (112011,10112,1011,2,1,'2026-04-01 00:00:00','2026-04-16 00:00:00','2026-04-01 00:00:00','2026-04-01 00:00:00',0,1)
;



################# 暂存 待删 #######################
#菜单权限
INSERT INTO system_menu (name,permission,`type`,sort,parent_id,`path`,icon,component,component_name,
  status,visible,keep_alive,always_show,creator,create_time,updater,update_time,deleted) 
  VALUES
	 ('会员注销','league:member:merge',3,0,0,'','#',NULL,NULL,0,1,1,1,'','2026-05-14 17:45:15',
   '','2026-05-14 17:45:15',0);

#给超级管理员角色（role_id=1）分配这个测试权限
INSERT INTO system_role_menu (role_id, menu_id, creator)
  VALUES (1, 5047？？, '1');