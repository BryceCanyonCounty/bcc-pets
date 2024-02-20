-- --------------------------------------------------------

--
-- Table structure for table `pets`
--

CREATE TABLE `pets` (
  `id` int(11) NOT NULL,
  `petid` int(11) NOT NULL,
  `identifier` varchar(40) NOT NULL,
  `charidentifier` int(11) NOT NULL DEFAULT 0,
  `dog` varchar(255) NOT NULL,
  `skin` int(11) NOT NULL DEFAULT 0,
  `xp` int(11) NOT NULL DEFAULT 0,
  `transfered` int(11) NOT NULL DEFAULT 0,
  `called` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `pets`
--
ALTER TABLE `pets`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD KEY `petid` (`petid`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `pets`
--
ALTER TABLE `pets`
  MODIFY `petid` int(11) NOT NULL AUTO_INCREMENT;
COMMIT;
