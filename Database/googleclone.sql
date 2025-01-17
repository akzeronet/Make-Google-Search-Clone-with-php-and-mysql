-- phpMyAdmin SQL Dump
-- version 5.0.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 15, 2020 at 01:22 PM
-- Server version: 10.4.11-MariaDB
-- PHP Version: 7.4.2

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `googleclone`
--

-- --------------------------------------------------------

--
-- Table structure for table `images`
--

CREATE TABLE `images` (
  `id` int(11) NOT NULL,
  `siteId` int(11) NOT NULL,
  `siteUrl` varchar(512) NOT NULL,
  `imageUrl` varchar(512) NOT NULL,
  `alt` varchar(512) NOT NULL,
  `title` varchar(512) NOT NULL,
  `clicks` int(11) NOT NULL,
  `broken` tinyint(4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `images`
--

INSERT INTO `images` (`id`, `siteId`, `siteUrl`, `imageUrl`, `alt`, `title`, `clicks`, `broken`) VALUES
(1, 1, 'http://www.timeshighereducation.co.uk/world-university-rankings/2014/reputation-ranking/range/01-50', 'http://d311j2r2qvjkvi.cloudfront.net/getasset/55bc335a-7476-4473-8c1a-0aa4aba338ab/', 'Recruiter logo', '', 0, 0),
(2, 1, 'http://www.timeshighereducation.co.uk/world-university-rankings/2014/reputation-ranking/range/01-50', 'http://d311j2r2qvjkvi.cloudfront.net/getasset/9ae7796f-5841-44cd-9f13-61882b5319fd/', 'Recruiter logo', '', 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `sites`
--

CREATE TABLE `sites` (
  `id` int(11) NOT NULL,
  `url` varchar(512) NOT NULL,
  `title` varchar(512) NOT NULL,
  `description` varchar(512) NOT NULL,
  `keywords` varchar(512) NOT NULL,
  `clicks` int(11) NOT NULL,
  `videoClicks` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `sites`
--

INSERT INTO `sites` (`id`, `url`, `title`, `description`, `keywords`, `clicks`, `videoClicks`) VALUES
(1, 'http://www.timeshighereducation.co.uk/world-university-rankings/2014/reputation-ranking/range/01-50', 'World Reputation Rankings 2014 | Times Higher Education (THE)', 'The Times Higher Education World Reputation Rankings 2014 employ the world\'s largest invitation-only academic opinion survey to provide the definitive list of the top 100 most powerful global university brands. A spin-off of the annual Times Higher Education World University Rankings, the reputation league table is based on nothing more than subjective judgement - but it is', '', 0, 0),
(2, 'http://championtsd.com/', 'Rugby Karate Classes for all Ages | Champion Tang Soo Do', 'Champion Tang Soo Do Karate classes in Rugby are just what you need if you are looking to keep fit, make friends and learn self defense!', 'Champion Tang Soo Do, champion karate, rugby karate, rugby martial arts, rugby tang soo do, champion tsd, championtsd, karate all ages, warwickshire martial arts', 0, 0);

--
-- Table structure for table `videos`
--

CREATE TABLE `videos` (
  `id` int(11) NOT NULL,
  `siteId` int(11) NOT NULL,
  `videoUrl` varchar(512) NOT NULL,
  `thumbnailUrl` varchar(512) NOT NULL,
  `title` varchar(512) NOT NULL,
  `clicks` int(11) NOT NULL,
  `broken` tinyint(4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `videos`
--

INSERT INTO `videos` (`id`, `siteId`, `videoUrl`, `thumbnailUrl`, `title`, `clicks`, `broken`) VALUES
(1, 1, 'https://www.youtube.com/watch?v=VIDEO_ID_HERE', 'https://img.youtube.com/vi/VIDEO_ID_HERE/0.jpg', 'YouTube Video Title', 0, 0),
(2, 2, 'https://www.youtube.com/watch?v=ANOTHER_VIDEO_ID', 'https://img.youtube.com/vi/ANOTHER_VIDEO_ID/0.jpg', 'Another YouTube Video', 0, 0);

-- --------------------------------------------------------

--
-- Indexes for dumped tables
--

--
-- Indexes for table `images`
--
ALTER TABLE `images`
  ADD PRIMARY KEY (`id`),
  ADD KEY `siteId` (`siteId`);

--
-- Indexes for table `sites`
--
ALTER TABLE `sites`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `videos`
--
ALTER TABLE `videos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `siteId` (`siteId`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `images`
--
ALTER TABLE `images`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26856;

--
-- AUTO_INCREMENT for table `sites`
--
ALTER TABLE `sites`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4378;

--
-- AUTO_INCREMENT for table `videos`
--
ALTER TABLE `videos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `images`
--
ALTER TABLE `images`
  ADD CONSTRAINT `images_ibfk_1` FOREIGN KEY (`siteId`) REFERENCES `sites` (`id`);

--
-- Constraints for table `videos`
--
ALTER TABLE `videos`
  ADD CONSTRAINT `videos_ibfk_1` FOREIGN KEY (`siteId`) REFERENCES `sites` (`id`);

COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
