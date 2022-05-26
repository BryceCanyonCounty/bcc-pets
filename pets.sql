
CREATE TABLE IF NOT EXISTS `pets` (
  `identifier` varchar(40) NOT NULL,
  `charidentifier` int(11) NOT NULL DEFAULT 0,
  `dog` varchar(255) NOT NULL,
  `skin` int(11) NOT NULL DEFAULT 0,
  UNIQUE KEY `identifier` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
