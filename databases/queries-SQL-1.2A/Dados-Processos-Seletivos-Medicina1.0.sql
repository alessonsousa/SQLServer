﻿
-- SELECT * FROM GLINKSREL WHERE MASTERTABLE = 'SPSAREAOFERTADA';

SELECT DISTINCT
	SPSPROCESSOSELETIVO.NOME AS 'PROCESSO SELETIVO',
	SPSUSUARIO.NOME AS 'NOME DO CANDITADO',
	SPSUSUARIO.EMAIL AS 'EMAIL DO CANDITADO',
	CASE
	    
		/*REMOVE NÚMEROS FIXOS DA CONSULTA*/
		WHEN 
				(LEN(TELEFONE2) = 8 AND SUBSTRING(TELEFONE2, 1, 1) BETWEEN 2 AND 5)
		OR (LEN(TELEFONE2) = 9 AND SUBSTRING(TELEFONE2, 2, 1) BETWEEN 2 AND 5)
		OR (LEN(TELEFONE2) = 10 AND SUBSTRING(TELEFONE2, 3, 1) BETWEEN 2 AND 5)
		OR (LEN(TELEFONE2) = 11 AND SUBSTRING(TELEFONE2, 4, 1) BETWEEN 2 AND 5) 
		THEN NULL
		
		/*ADICIONA 9 APÓS O DDD*/
		WHEN 
				LEN(REPLACE(REPLACE(REPLACE(REPLACE(TELEFONE2, '(', ''), ')', ''), ' ', ''), '-', '')) = 10
		OR LEN(TELEFONE2) = 10 
		THEN SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(TELEFONE2, '(', ''), ')', ''), ' ', ''), '-', ''), 1, 2) 
			 + '9' 
			 + SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(TELEFONE2, '(', ''), ')', ''), ' ', ''), '-', ''), 3, 8)
		
		/*PROVAVELMENTE JÁ TEM O 9 APÓS O DDD ENTÃO RETORNA O PRÓPRIO NÚMERO*/
		WHEN 
				LEN(REPLACE(REPLACE(REPLACE(REPLACE(TELEFONE2, '(', ''), ')', ''), ' ', ''), '-', '')) > 10 
		THEN SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(TELEFONE2, '(', ''), ')', ''), ' ', ''), '-', ''), 1, 11)
		
		/*REMOVE NÚMEROS SEM DDD*/
		WHEN LEN(REPLACE(REPLACE(REPLACE(REPLACE(TELEFONE2, '(', ''), ')', ''), ' ', ''), '-', '')) < 10
		OR LEN(TELEFONE2) < 10 
		THEN NULL		

	END AS 'TELEFONE',
	SPSAREAINTERESSE.NOME AS 'CURSO',

	CASE
	WHEN SPSINSCRICAOAREAOFERTADA.STATUS = 1 THEN 'PAGO'
	WHEN SPSINSCRICAOAREAOFERTADA.STATUS = 0 THEN 'PENDENTE DE PAGAMENTO'
	ELSE 'INSCRI��O CANCELADA'
END AS 'SITUA��O DE INSCRI��O'

FROM SPSINSCRICAOAREAOFERTADA
	INNER JOIN SPSUSUARIO (NOLOCK) ON	
		SPSINSCRICAOAREAOFERTADA.CODUSUARIOPS = SPSUSUARIO.CODUSUARIOPS
	INNER JOIN SPSAREAOFERTADA (NOLOCK) ON	
		SPSAREAOFERTADA.IDPS = SPSINSCRICAOAREAOFERTADA.IDPS
	INNER JOIN SPSOPCAOINSCRITO (NOLOCK) ON	
		SPSOPCAOINSCRITO.IDPS = SPSAREAOFERTADA.IDPS
	INNER JOIN SPSPROCESSOSELETIVO (NOLOCK) ON	
		SPSAREAOFERTADA.IDPS = SPSPROCESSOSELETIVO.IDPS
	INNER JOIN SPSAREAINTERESSE ON
		SPSAREAINTERESSE.IDAREAINTERESSE = SPSAREAOFERTADA.IDAREAINTERESSE

WHERE	
--ENEM - 225 / Tradicional - 229
SPSINSCRICAOAREAOFERTADA.IDPS IN (225, 229)
	--UNIFAP - 1 / FAP FORTALEZA - 2 / FAP ARARIPINA - 4
	AND SPSINSCRICAOAREAOFERTADA.IDCAMPUS = 4
	-- C�DIGO: INSCRI��O PAGO - 1 / INSCRI��O A PAGAR - 0 / INSCRI��O CANCELADA - 8
	AND SPSINSCRICAOAREAOFERTADA.STATUS IN (0, 1)
