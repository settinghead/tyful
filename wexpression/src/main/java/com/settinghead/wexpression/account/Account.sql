CREATE  TABLE `wexpression`.`Account` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `username` VARCHAR(255) NOT NULL UNIQUE,
  `password` VARCHAR(255) NOT NULL,
  `firstName` VARCHAR(255) NOT NULL ,
  `lastName` VARCHAR(255) NOT NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;
