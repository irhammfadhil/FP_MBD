--prosedur login
DELIMITER $$

USE `vkvxweok_mbd_05111640000085`$$

DROP PROCEDURE IF EXISTS `sp_login`$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_login`(
	p_username VARCHAR(20), 
	p_password VARCHAR(32))
BEGIN
	IF EXISTS(SELECT 1 FROM db_account 
		WHERE `acc_username`=p_username AND `acc_password`= MD5(p_password)) THEN
		SELECT 0, "Login sukses";
	ELSE
		SELECT -1, "Maaf Username / Password tidak dikenal";		
	END IF;
    END$$

DELIMITER ;
-- prosedur buat akun
DELIMITER $$

USE `vkvxweok_mbd_05111640000085`$$

DROP PROCEDURE IF EXISTS `sp_register`$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_register`(
	p_username VARCHAR(20),
	p_password VARCHAR(32),
	p_email VARCHAR(50)
    )
BEGIN
IF NOT EXISTS (SELECT 1 FROM db_account WHERE acc_username=p_username ) THEN
	INSERT INTO db_account (acc_username, acc_password, acc_email, acc_lifepoint, acc_money)  
		VALUES (p_username, MD5(p_password), p_email, 300, 100);
	SELECT 0, 'Pendaftaran sukses';
	ELSE SELECT -1, 'Gagal, username sudah terdaftar!';
	END IF;
    END$$

DELIMITER ;
--prosedur beli senjata
DELIMITER $$

USE `vkvxweok_mbd_05111640000085`$$

DROP PROCEDURE IF EXISTS `sp_buyweapon`$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_buyweapon`(
	p_username VARCHAR(20),
	p_weapon VARCHAR(25))
	
BEGIN
	IF ((SELECT acc_money FROM db_account WHERE acc_username=p_username) >= (SELECT wp_cost FROM db_weapon WHERE wp_name=p_weapon)) THEN
		UPDATE db_account SET acc_money=acc_money - (SELECT wp_cost FROM db_weapon WHERE wp_name=p_weapon) WHERE acc_username=p_username;
		IF NOT EXISTS(SELECT pe_wp_number FROM db_profile WHERE pe_username=p_username AND pe_wp_number=(SELECT wp_number FROM db_weapon WHERE wp_name=p_weapon)) THEN
				INSERT INTO db_profile (pe_username, pe_wp_number, pe_quantity) VALUES (p_username, (SELECT wp_number FROM db_weapon WHERE wp_name=p_weapon), (SELECT wp_quantity FROM db_weapon WHERE wp_name=p_weapon));
				SELECT 0, "Pembelian senjata berhasil";				
			ELSE
				UPDATE db_profile SET pe_quantity=pe_quantity + (SELECT wp_quantity FROM db_weapon WHERE wp_name=p_weapon) WHERE pe_username = p_username;
				SELECT -1, "Update pembelian senjata berhasil";		
		END IF;
	ELSE
		SELECT -1, "Uang tidak mencukupi untuk pembelian senjata";		
	END IF;
    END$$
DELIMITER ;
