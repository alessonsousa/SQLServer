SELECT distinct
	   SALUNO.RA
	   
FROM 
		FLAN (NOLOCK) 
			INNER JOIN SLAN (NOLOCK) 
			        ON SLAN.CODCOLIGADA = FLAN.CODCOLIGADA
				   AND SLAN.IDLAN       = FLAN.IDLAN
			INNER JOIN SPARCELA (NOLOCK) 
			        ON SPARCELA.CODCOLIGADA = SLAN.CODCOLIGADA
			       AND SPARCELA.IDPARCELA   = SLAN.IDPARCELA
			INNER JOIN SALUNO (NOLOCK) 
			        ON SALUNO.CODCOLIGADA = SPARCELA.CODCOLIGADA
				   AND SALUNO.RA          = SPARCELA.RA
			INNER JOIN PPESSOA (NOLOCK) 
			        ON PPESSOA.CODIGO = SALUNO.CODPESSOA
			INNER JOIN SCONTRATO (NOLOCK)
			        ON SCONTRATO.CODCOLIGADA = SPARCELA.CODCOLIGADA
			       AND SCONTRATO.RA          = SPARCELA.RA
			       AND SCONTRATO.IDPERLET    = SPARCELA.IDPERLET
			       AND SCONTRATO.CODCONTRATO = SPARCELA.CODCONTRATO
			INNER JOIN SHABILITACAOFILIAL (NOLOCK)
			        ON SHABILITACAOFILIAL.CODCOLIGADA         = SCONTRATO.CODCOLIGADA
			       AND SHABILITACAOFILIAL.IDHABILITACAOFILIAL = SCONTRATO.IDHABILITACAOFILIAL
			INNER JOIN SMATRICPL (NOLOCK) 
			        ON SMATRICPL.CODCOLIGADA         = SCONTRATO.CODCOLIGADA
			       AND SMATRICPL.RA                  = SCONTRATO.RA
			       AND SMATRICPL.IDPERLET            = SCONTRATO.IDPERLET
			       AND SMATRICPL.IDHABILITACAOFILIAL = SCONTRATO.IDHABILITACAOFILIAL
            INNER JOIN SSTATUS (NOLOCK)
                    ON SSTATUS.CODCOLIGADA = SMATRICPL.CODCOLIGADA
                   AND SSTATUS.CODSTATUS   = SMATRICPL.CODSTATUS				  
			full outer join SBOLSAALUNO (NOLOCK) ON
					SBOLSAALUNO.RA = SMATRICPL.RA
					AND SBOLSAALUNO.IDPERLET = SMATRICPL.IDPERLET

		WHERE FLAN.PERLETIVO = '2021.2'
		 AND  FLAN.CODAPLICACAO = 'S'
		 AND  SPARCELA.TIPOPARCELA = 'P'
		  AND FLAN.PARCELA = 2
		  AND flan.VALORORIGINAL = 0
		  AND SCONTRATO.TIPOCONTRATO = 'P' 
		  AND SBOLSAALUNO.CODBOLSA IS NULL