-- phpMyAdmin SQL Dump
-- version 2.11.4
-- http://www.phpmyadmin.net
--
-- Хост: localhost
-- Время создания: Янв 20 2009 г., 18:33
-- Версия сервера: 5.1.22
-- Версия PHP: 5.2.5

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";

--
-- База данных: `spm`
--
 CREATE DATABASE `spm` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `spm`;

-- --------------------------------------------------------

--
-- Структура таблицы `BotActivity`
--

DROP TABLE IF EXISTS `BotActivity`;
CREATE TABLE IF NOT EXISTS `BotActivity` (
  `ActivityId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `DateTime` datetime NOT NULL,
  `BotId` varchar(32) NOT NULL,
  `BotVer` varchar(32) NOT NULL,
  `ActivityType` int(11) NOT NULL,
  `AdditionalId` int(11) DEFAULT NULL,
  `IP` varchar(16) NOT NULL,
  PRIMARY KEY (`ActivityId`),
  KEY `ActivityType` (`ActivityType`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=19779441 ;

--
-- Дамп данных таблицы `BotActivity`
--


-- --------------------------------------------------------

--
-- Структура таблицы `BotConfig`
--

DROP TABLE IF EXISTS `BotConfig`;
CREATE TABLE IF NOT EXISTS `BotConfig` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Ver` int(11) NOT NULL,
  `BotId` varchar(32) COLLATE cp1251_general_cs NOT NULL,
  `Command` varchar(255) CHARACTER SET latin1 NOT NULL,
  PRIMARY KEY (`Id`),
  KEY `Ver` (`Ver`)
) ENGINE=MyISAM  DEFAULT CHARSET=cp1251 COLLATE=cp1251_general_cs AUTO_INCREMENT=49 ;


-- --------------------------------------------------------

--
-- Структура таблицы `Bots`
--

DROP TABLE IF EXISTS `Bots`;
CREATE TABLE IF NOT EXISTS `Bots` (
  `BotsId` int(11) NOT NULL AUTO_INCREMENT,
  `Ver` varchar(4) CHARACTER SET latin1 NOT NULL COMMENT 'Bot version',
  PRIMARY KEY (`BotsId`),
  KEY `Ver` (`Ver`)
) ENGINE=MyISAM  DEFAULT CHARSET=cp1251 COLLATE=cp1251_general_cs AUTO_INCREMENT=26 ;

--
-- Дамп данных таблицы `Bots`
--


-- --------------------------------------------------------

--
-- Структура таблицы `Config`
--

DROP TABLE IF EXISTS `Config`;
CREATE TABLE IF NOT EXISTS `Config` (
  `Name` varchar(20) NOT NULL,
  `Value` varchar(20) NOT NULL,
  PRIMARY KEY (`Name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Дамп данных таблицы `Config`
--

INSERT INTO `Config` (`Name`, `Value`) VALUES
('LastBotId', '1');

-- --------------------------------------------------------

--
-- Структура таблицы `lists`
--

DROP TABLE IF EXISTS `lists`;
CREATE TABLE IF NOT EXISTS `lists` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `file` varchar(128) DEFAULT NULL,
  `count` int(10) DEFAULT NULL,
  UNIQUE KEY `id` (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=86 ;

--
-- Дамп данных таблицы `lists`
--

INSERT INTO `lists` (`id`, `file`, `count`) VALUES
(77, 'screemer_ua@hotmail.com.txt', 10);
-- --------------------------------------------------------

--
-- Структура таблицы `macro`
--

DROP TABLE IF EXISTS `macro`;
CREATE TABLE IF NOT EXISTS `macro` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `name` varchar(128) DEFAULT NULL,
  `type` varchar(128) DEFAULT NULL,
  `file` text,
  `count` int(10) DEFAULT NULL,
  `value` int(10) DEFAULT NULL,
  UNIQUE KEY `id` (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=13 ;

--
-- Дамп данных таблицы `macro`
--

INSERT INTO `macro` (`id`, `name`, `type`, `file`, `count`, `value`) VALUES
(8, 'A', 'd', 'A.txt', 26, NULL),
(9, 'PHHH', 'd', 'PHHH.txt', 50, NULL),
(10, 'FIRST_NAMES', 'd', 'FIRST_NAMES.txt', 2000, NULL),
(11, 'LAST_NAMES', 'd', 'LAST_NAMES.txt', 2000, NULL),
(12, 'SUB_VIAGRA', 'd', 'SUB_VIAGRA.txt', 780, NULL);

-- --------------------------------------------------------

--
-- Структура таблицы `robo`
--

DROP TABLE IF EXISTS `robo`;
CREATE TABLE IF NOT EXISTS `robo` (
  `id` varchar(50) DEFAULT NULL,
  `ip` varchar(20) DEFAULT NULL,
  `tick` int(16) DEFAULT NULL,
  `time` int(16) DEFAULT NULL,
  `smtp` varchar(10) DEFAULT NULL,
  `ver` varchar(10) DEFAULT NULL,
  `bl` int(16) DEFAULT NULL,
  UNIQUE KEY `id` (`id`),
  KEY `ip` (`ip`),
  KEY `tick` (`tick`),
  KEY `time` (`time`),
  KEY `smtp` (`smtp`),
  KEY `ver` (`ver`),
  KEY `bl` (`bl`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Дамп данных таблицы `robo`
--



-- --------------------------------------------------------

--
-- Структура таблицы `tasks`
--

DROP TABLE IF EXISTS `tasks`;
CREATE TABLE IF NOT EXISTS `tasks` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `name` varchar(128) DEFAULT NULL,
  `fmail` text,
  `header` varchar(128) DEFAULT NULL,
  `body` text,
  `list` text,
  `list_size` int(10) DEFAULT NULL,
  `lpr1` int(10) DEFAULT NULL,
  `lpr2` int(10) DEFAULT NULL,
  `status` varchar(10) DEFAULT NULL,
  `subjects` text,
  `links_server` varchar(100) NOT NULL DEFAULT '127.0.0.1',
  `links` text,
  `from_name` varchar(128) DEFAULT NULL,
  `ver` varchar(100) NOT NULL,
  `style` int(11) NOT NULL DEFAULT '0',
  UNIQUE KEY `id` (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=201 ;


