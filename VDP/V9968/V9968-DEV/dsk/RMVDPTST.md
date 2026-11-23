# VDPTEST — teste de estresse da conclusão de comandos do VDP (comando do MSX-DOS)

Este programa de testes de carga foi criado para ser executado em um V9968 real
(VDP instalado no próprio equipamento, portas 98h–9Bh). Ele envia comandos
suscetíveis a falhas, incluindo casos de limite, com timeouts para o polling de
CE (e também TR nos comandos de transferência), a fim de detectar padrões que não
terminam.

## Como usar

Execute `VDPTEST` no prompt do MSX-DOS 2.

- A tela muda para Graphic 4 (`SCREEN 5`) e uma barra de progresso aparece na parte inferior.
- Os testes são executados em duas passagens: passagem A com a tela ligada e passagem B com a tela desligada.
- Ao terminar, o programa volta ao modo de texto e exibe os resultados:
  - Todos os testes concluídos com sucesso: `SUCCESS OF ALL`
  - Caso tenham ocorrido timeouts: `TIMEOUTS: n`
  - Ao terminar, o programa restaura a fonte, a tabela de nomes e a tabela de cores
    do início da execução (no modo SCREEN 1), além dos registradores do VDP.
    Os registradores R#0–R#7 são restaurados com os valores salvos pelo console;
    R#8/R#9 são restaurados com os valores padrão do modo de texto (08h/00h).
    Os valores de R#8 em diante obtidos de RGnSAV não são usados, pois às vezes
    podem ser antigos em computadores reais.
- Os detalhes também são gravados em `VDPTEST.LOG`, no diretório atual.
  (A linha FAIL registra a passagem, o número do caso, o comando, todos os
  parâmetros e o valor final de S#2.)

O tempo estimado é de alguns minutos (em caso de timeout, até cerca de 10 segundos
adicionais por ocorrência).

## Conteúdo dos testes (71 casos + 3 casos especiais)

- HMMV / HMMM / YMMM: tela inteira, operação entre páginas, sobreposição,
  alinhamento exato das bordas etc.
- LMMV: todas as operações lógicas (IMP/AND/OR/XOR/NOT, com e sem T),
  tela inteira e um único ponto.
- LMMM: vários tipos de operações lógicas e sobreposição.
- LMMC / HMMC / LMCM: transferências pela CPU, inclusive cruzando limites.
- LINE / PSET / POINT / SRCH: acertos e varreduras sem correspondência em
  ambas as direções até atingir a borda.
- Casos especiais: #201: disparar novamente um comando em execução;
  #202: retomada após uma interrupção STOP;
  #203: executar 2000 vezes seguidas HMMM 8×8 + LMMV-TAND 8×8,
  alternando as posições.

## Resultados da validação (2026-11-04, 3 ambientes)

- **openMSX (modelo V9958 puro)**: somente o caso #59 apresentou FAIL nas duas
  passagens; todos os demais casos, incluindo os especiais, passaram.
- **turboR real (V9958 verdadeiro)**: somente o caso #59 apresentou FAIL nas
  duas passagens; todos os demais passaram (correspondência completa com o modelo).
- **SX-2 + cartucho V9968 real**: os casos #58 e #59 apresentaram FAIL nas duas
  passagens; todos os demais passaram.

- **#59 (LMCM, SX=100 com NX=200, cruzando a borda direita):** até o V9958 real
  realiza o recorte na borda direita linha por linha e conclui a operação com
  156 pontos × 100 linhas = 15.600 pontos. Portanto, a suposição deste teste de
  esperar 20.000 pontos, conforme o manual, estava incorreta. O FAIL do caso #59
  deve ser interpretado como confirmação do mesmo comportamento de recorte do
  chip real (o modelo openMSX e o RTL do V9968 também correspondem ao chip real).
- **#58 (LMCM 1×1 em (255,1023)):** este caso passa no chip real e, portanto,
  representa uma diferença no RTL do V9968. No RTL, LMCM com NX=1 e NY=1
  transfere 0 pontos; essa correção está sendo acompanhada separadamente.

## Arquivos

- `VDPTEST.COM` — arquivo executável (para MSX-DOS 2)
- `VDPTEST.ASM` — código-fonte no formato zma. `cases.inc` contém a tabela de
  casos; o conjunto completo dos arquivos-fonte está no diretório de investigação
  `v9968ds4/vdptest/`.
