# 19 — Denúncias

## Objetivo
Analisar o que um viajante denunciou e devolver o resultado para ele.

## Origem
Denúncia feita no app (`BUSINESS/30`): spam ou golpe, conteúdo enganoso sobre um lugar, assédio ou discurso de ódio, conteúdo impróprio, perfil falso, outro motivo.

O alvo é um perfil, uma avaliação ou um comentário.

## Fila
Filtros: aberta, em análise, procedente, improcedente.

Cada item mostra denunciante, alvo, motivo, data e status.

## Ações
- Assumir (passa a em análise).
- Marcar procedente.
- Marcar improcedente.
- Se procedente, escolher um ou os dois efeitos: remover o conteúdo (`20`) e desativar a conta do alvo (`04`).

## Regras
- Ao fechar, o denunciante recebe notificação no app e no push, com o resultado. O texto diz se a denúncia foi aceita ou não. Não revela dado interno da análise.
- O denunciado não recebe aviso de que foi denunciado. Se a conta for desativada, ele só deixa de entrar.
- Bloqueio entre duas pessoas continua sendo ação delas. O administrador não bloqueia uma pessoa “em nome” da outra.
- Prazo máximo de análise: `A DEFINIR`.
