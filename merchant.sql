CREATE TABLE merchant (
    id INT AUTO_INCREMENT PRIMARY KEY,
    identifier VARCHAR(255) NOT NULL,
    charid INT NOT NULL,
    deliveries_completed INT NOT NULL DEFAULT 0,
    merchant_xp INT NOT NULL DEFAULT 0,
    merchant_lvl INT NOT NULL DEFAULT 0
);