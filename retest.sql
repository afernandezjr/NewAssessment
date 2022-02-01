DROP DATABASE retest;
CREATE DATABASE retest;
USE retest;
CREATE TABLE `applicationform` (
  `id` int(11) NOT NULL,
  `paddress` varchar(100) NOT NULL,
  `number` int(100) NOT NULL,
  `fooditem` varchar(100) NOT NULL,
  `quantity` int(50) NOT NULL,
  `price` int(50) NOT NULL,
  `total` varchar(50) NOT NULL,
  `userid` int(11) NOT NULL,
  `status` varchar(30) NOT NULL DEFAULT 'pending',
  `mname` varchar(50) NOT NULL,
  `payments` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
--
-- Dumping data for table `applicationform`
--

INSERT INTO `applicationform` (`id`, `paddress`, `number`, `fooditem`, `quantity`, `price`, `total`, `userid`, `status`, `mname`, `payments`) VALUES
(1, 'dsgferhgykuk', 0, 'Lechon', 0, 0, '6000', 26, 'approve', 'adsfasdasdf', 'Gcash'),
(14, 'dfdfdf', 435234535, 'sdfsdfdsf', 32, 343, '1232', 14, 'approve', 'mars', '0'),
(15, 'Toril City', 0, 'binagoongan', 0, 0, '300', 21, 'approve', 'Ags', 'Gcash');

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `id` int(11) NOT NULL,
  `pname` varchar(100) NOT NULL,
  `pprice` int(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`id`, `pname`, `pprice`) VALUES
(1, 'Binagoongan', 159),
(2, 'Bicol-Express', 180),
(3, 'Pakbet ala Cagayan', 140),
(4, 'Bulalo', 200);

-- --------------------------------------------------------

--
-- Table structure for table `transaction`
--

CREATE TABLE `transaction` (
  `id` int(11) NOT NULL,
  `transactionid` varchar(100) NOT NULL,
  `pid` varchar(100) NOT NULL,
  `uid` varchar(100) NOT NULL,
  `quantity` int(100) NOT NULL,
  `status` varchar(100) NOT NULL DEFAULT 'pending',
  `date` varchar(100) NOT NULL,
  `mop` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `transaction`
--

INSERT INTO `transaction` (`id`, `transactionid`, `pid`, `uid`, `quantity`, `status`, `date`, `mop`) VALUES
(1, '00919025-246e-47b2-b250-faa1e7b1c57b', '1', '26', 1, 'delivered', '2022-01-28', 'gcash'),
(2, '00919025-246e-47b2-b250-faa1e7b1c57b', '2', '26', 1, 'delivered', '2022-01-28', 'gcash'),
(3, '00919025-246e-47b2-b250-faa1e7b1c57b', '4', '26', 1, 'delivered', '2022-01-28', 'gcash'),
(4, 'f7171e9e-0a8b-446e-9f7d-dfbaa9858045', '1', '26', 10, 'pending', '2022-01-21', 'gcash'),
(5, 'f7171e9e-0a8b-446e-9f7d-dfbaa9858045', '3', '26', 5, 'pending', '2022-01-21', 'gcash'),
(6, '915e5ffc-60ea-47cb-a369-0c2a57bb42dc', '1', '26', 50, 'delivered', '2022-01-31', 'gcash'),
(7, '915e5ffc-60ea-47cb-a369-0c2a57bb42dc', '2', '26', 50, 'delivered', '2022-01-31', 'gcash');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(100) NOT NULL,
  `fname` varchar(100) NOT NULL,
  `lname` varchar(100) NOT NULL,
  `contactno` int(50) NOT NULL,
  `email` varchar(50) NOT NULL,
  `role` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `fname`, `lname`, `contactno`, `email`, `role`) VALUES
(1, 'admin', 'admin', 'angelo', 'fernandez', 2147483647, 'admin@admin', 'admin'),
(3, 'admin2', 'admin2', 'Joseph1', 'Joseph1', 92615, 'sdsd@ss.cc', 'admin'),
(4, 'test2', 'test2', 'Angelo Al', 'Fernandez', 2147483647, 'test123@gmail.com', 'guest'),
(21, 'chrissasakalam', 'chrissa', 'Chrissa Marie', 'Agujar', 1231243123, 'chrissa@gmail.com', 'guest'),
(25, 'maynard', 'maynard', 'maynard ', 'magallen', 324234234, 'maynard@gmail.com', 'guest'),
(26, 'andrew', 'andrew', 'Andrew', 'Manteza', 123123123, 'andrew@manteza', 'guest'),
(27, 'try', 'try', 'asdasd', 'asdasd', 1241234124, 'try@gmail.com', 'guest'),
(28, 'cedens', 'cedens', 'cedens', 'cedens', 2147483647, 'cedens@gmail.com', 'guest'),
(29, 'John', 'john', 'John', 'Fernandez', 2147483647, 'talo@gmail.com', 'guest');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `applicationform`
--
ALTER TABLE `applicationform`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `transaction`
--
ALTER TABLE `transaction`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `applicationform`
--
ALTER TABLE `applicationform`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `transaction`
--
ALTER TABLE `transaction`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;