SELECT DISTINCT
	SALUNO.RA						[MATRICULA], 
	PPESSOA.NOME					[ALUNO],
	PPESSOA.EMAIL,
	PPESSOA.TELEFONE2,
	SCURSO.NOME						[CURSO], 
	SMODALIDADECURSO.DESCRICAO		[MODALIDADE CURSO],
	SHISTDISCPENDENTES.CODDISC		[C�DIGO DISCIPLINA], 
	SHISTDISCPENDENTES.DISCIPLINA	[DISCIPLINA],
	SHISTDISCPENDENTES.CODPERIODO	[PERIODO]
FROM SHABILITACAOALUNO (NOLOCK)
	INNER JOIN SHISTDISCPENDENTES (NOLOCK) ON
			SHISTDISCPENDENTES.CODCOLIGADA = SHABILITACAOALUNO.CODCOLIGADA
		AND SHISTDISCPENDENTES.IDHABILITACAOFILIAL = SHABILITACAOALUNO.IDHABILITACAOFILIAL
		AND SHISTDISCPENDENTES.RA = SHABILITACAOALUNO.RA
	INNER JOIN SALUNO (NOLOCK) ON
			SALUNO.CODCOLIGADA = SHABILITACAOALUNO.CODCOLIGADA
		AND SALUNO.RA = SHABILITACAOALUNO.RA
	INNER JOIN PPESSOA (NOLOCK) ON
			PPESSOA.CODIGO = SALUNO.CODPESSOA
	INNER JOIN SHABILITACAOFILIAL (NOLOCK) ON
			SHABILITACAOFILIAL.CODCOLIGADA = SHABILITACAOALUNO.CODCOLIGADA
		AND SHABILITACAOFILIAL.IDHABILITACAOFILIAL = SHABILITACAOALUNO.IDHABILITACAOFILIAL
	INNER JOIN SCURSO (NOLOCK) ON
			SCURSO.CODCOLIGADA = SHABILITACAOFILIAL.CODCOLIGADA
		AND SCURSO.CODCURSO = SHABILITACAOFILIAL.CODCURSO
	INNER JOIN SMATRICPL ON
			SMATRICPL.RA = SHABILITACAOALUNO.RA
		AND SMATRICPL.IDHABILITACAOFILIAL = SHABILITACAOALUNO.IDHABILITACAOFILIAL
	INNER JOIN SMODALIDADECURSO (NOLOCK) ON
			SMODALIDADECURSO.CODCOLIGADA = SCURSO.CODCOLIGADA
		AND SMODALIDADECURSO.CODMODALIDADECURSO = SCURSO.CODMODALIDADECURSO
WHERE
		SHABILITACAOALUNO.CODSTATUS = 19 /*STATUS NO CURSO CURSANDO*/
	AND (SHISTDISCPENDENTES.CODSTATUS <> 19 OR SHISTDISCPENDENTES.CODSTATUS IS NULL) /*STATUS CURSANDO NA DISCIPLINA*/
	AND SMATRICPL.CODSTATUS IN (12, 101, 111)
	AND SMODALIDADECURSO.CODMODALIDADECURSO = 3
	AND SMATRICPL.IDPERLET = 167

ORDER BY
	--SCURSO.NOME, PPESSOA.NOME, SHISTDISCPENDENTES.CODPERIODO, SHISTDISCPENDENTES.DISCIPLINA
	PPESSOA.NOME