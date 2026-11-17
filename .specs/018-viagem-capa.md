# Capa da viagem

- Slug: `viagem-capa`
- Status: `em execução`
- Data: 2026-11-16
- Última atualização: 2026-11-17
- Responsável: produto
- Repositório: `mayahtrip-app`
- Docs relacionados: `.docs/BUSINESS/16-viagem-capa-e-abas.md`, `.docs/BUSINESS/BUSINESS.md`, `.docs/DESIGN.md`, `.docs/prototype`
- Specs relacionadas: `carteira`
- ADRs relacionados: nenhum

## 1. Contexto

Fato: o protótipo em `.docs/prototype` (16 nov 2026, frame 390×844) e `16-viagem-capa-e-abas.md` já descrevem esta feature. O app Flutter em `mayahtrip-app` ainda não tem essa tela.

Quem sente: quem for usar o app e quem for comparar a tela com o protótipo. Sem esta fatia, o comportamento existe só no HTML.

Premissa, não fato: os dados continuam mocados, iguais aos do protótipo. Não há API nesta fila.

## 2. Necessidade de negócio

O app público precisa desta tela idêntica ao protótipo antes de qualquer outra entrega da mesma área. O sucesso é a pessoa cumprir o fluxo abaixo e a inspeção no frame 390×844 não achar diferença de layout, espaçamento, alinhamento ou animação.

## 3. Objetivo e resultado observável

Capa, pílulas, informações essenciais e o segmentado das cinco abas. O conteúdo de cada aba é a spec daquela aba.

## 4. Usuários e permissões

| Persona/papel | O que pode fazer | Restrições |
| --- | --- | --- |
| Jean Lucas, sessão mocada | Cumprir o fluxo desta fatia como no protótipo | Dados fixos do protótipo |
| Convidado | Só o que `modo-convidado` libera | Fora desta spec, exceto na própria spec `modo-convidado` |
| Dono, Viajante supremo, Viajante experiente, Assistente júnior | O que `16-viagem-capa-e-abas.md` e BUSINESS.md §4.3 permitem nesta tela | Papel que a tela não menciona não ganha permissão nova |

## 5. Escopo

### 5.1 Dentro do escopo

- Capa, pílulas, informações essenciais e o segmentado das cinco abas. O conteúdo de cada aba é a spec daquela aba.
- Flutter em `mayahtrip-app`, com os dados mocados do protótipo.
- Reutilizar tokens, fontes e movimento definidos na spec `abertura`, sem redefini-los.

### 5.2 Fora de escopo

- As outras fatias: `abertura`, `sign-in`, `sign-up`, `confirm-account`, `forgot-password`, `reset-password`, `inicio`, `notificacoes`, `busca`, `pagina-do-lugar`, `explorar`, `comentarios-curtidas`, `inserir-no-roteiro`, `avaliar-parada`, `acoes-rapidas`, `nova-viagem`, `carteira`, `roteiro-lista`, `roteiro-mapa`, `detalhe-da-parada`, `adicionar-parada`, `gastos`, `novo-gasto`, `mala`, `lista-de-compras`, `documentos-links`, `compartilhar-viagem`, `maya`, `perfil`, `minhas-publicacoes`, `minhas-midias`, `mencoes`, `seguidores`, `perfil-publico`, `privacidade-bloqueios`, `onde-ja-estive`, `aparencia`, `editar-perfil`, `idioma-moeda`, `modo-convidado`.
- API real, painel, site de planos e cobrança em loja.
- Item marcado `A DEFINIR` que o protótipo não desenha. Não inventar a regra.
- O painel lateral do HTML do protótipo.

## 6. Comportamento esperado

Recorte: Capa, pílulas, informações essenciais e o segmentado das cinco abas. O conteúdo de cada aba é a spec daquela aba.

O texto abaixo é a regra desta fatia. Medida, tempo e cor citados são critério visual. Menção a uma tela de outra spec é só navegação: o destino pertence à spec daquele slug.

## Capa (300 px)
- Foto do destino (ou cor sólida); degradê de baixo `rgba(12,10,28,.9)` até transparente em 65%.
- Topo (52 px, 16 px laterais): voltar (vidro) · **Compartilhar** (vidro) → `26` · **Editar** (vidro) → edição da viagem `A DEFINIR`.
- Base (20 px): kicker lima “{datas} · N dias”; nome editorial **56 px** (44 px se o nome tiver mais de 9 caracteres), branco.
- À direita do nome: avatares dos participantes (32 px, borda `#15122E`) + bolinha “+” (branco 20%) → `26-compartilhar-viagem-e-papeis.md`.
- **Pílulas de informações essenciais** (28 px, raio 14, branco 16% + desfoque, 12 px/700), na ordem: 💰 moeda (símbolo), 🕘 fuso relativo à sua localização (“+1h”, “0h”), ☁️ clima (faixa °C), 🔌 tomada (tipo) + seta. Toque → folha **Informações essenciais**:
  - Linhas com ícone 40 px (raio 13, `#EBE8FF`), rótulo 12 px e valor 13 px/700: Moeda, Fuso (“1 h a mais que Lisboa (sua localização)”), Clima (“8 – 17 °C em março”), Tomada (“Tipos F e L · 230 V”).
  - Caixa da Maya (fundo `#F1FFD1`): “Tem dúvida sobre visto, chip ou câmbio? Pergunte à Maya”.

## Abas
Segmentado (5 itens): **Roteiro · Gastos · Mala · Compras · Docs**. A aba escolhida é lembrada por viagem.

| Aba | Documento |
| --- | --- |
| Roteiro | `17-roteiro-lista.md`, `18-roteiro-mapa-e-otimizacao.md` |
| Gastos | `21-gastos.md` |
| Mala | `23-mala.md` |
| Compras | `24-lista-de-compras.md` |
| Docs | `25-documentos-e-links.md` |

## Regras por papel
| Papel | Abas visíveis |
| --- | --- |
| Dono / Viajante supremo | Todas |
| Viajante experiente | Todas, **exceto Docs** |
| Assistente júnior | Roteiro, Mala e Compras (somente leitura); **sem Gastos e sem Docs** |

Como as abas ocultas aparecem (somem ou bloqueadas com cadeado): `A DEFINIR`.

## Rascunho
Kicker mostra “Datas a definir · N dias”; dias se chamam “Dia 1…N”. Selo de status não aparece na capa.

## A DEFINIR
- Tela de edição da viagem (nome, capa, datas, destinos, orçamento).
- Excluir/arquivar viagem e sair de viagem compartilhada.

Estados desta fatia:

- Vazio: o que `16-viagem-capa-e-abas.md` descreve como vazio. Se o arquivo não descreve vazio, a tela não inventa empty state.
- Erro: só a mensagem que o arquivo escreve. Mensagem marcada `A DEFINIR` não é criada.
- Permissão: papéis de BUSINESS.md §4.3 quando a tela cita papel.
- Limite: o número que o arquivo fixa (tentativas, caracteres, dias, itens). O que está `A DEFINIR` não vira limite.

## 7. Critérios de aceite

- [x] **AC-1** — Dado uma viagem com data, quando a capa abre, então a foto tem 300 px, o kicker traz datas e dias e o nome editorial tem 56 px, ou 44 px se o nome passa de 9 caracteres; verificado por `test/ui/features/viagem_capa/viagem_capa_view_model_test.dart` (regra do tamanho) e `viagem_capa_view_test.dart` (kicker/nome na tela).
- [x] **AC-2** — Dado as pílulas, quando a pessoa toca uma, então a folha Informações essenciais mostra moeda, fuso relativo, clima e tomada; verificado por `viagem_capa_view_test.dart`. Dados minerados de `ess[]` do protótipo para as 5 viagens mocadas.
- [x] **AC-3** — Dado a viagem aberta, quando a pessoa troca de aba e sai, então a aba escolhida volta a aparecer nessa viagem; verificado por `viagem_capa_view_model_test.dart` (memória por `viagem.id`, em processo — não persistida em disco, D-8 abaixo).
- [x] **AC-4** — Dado um rascunho, quando a capa abre, então o kicker diz "Datas a definir · N dias" e não há selo de status; verificado pelos mesmos testes (viagem "Japão").
- [x] **AC-5** — Dado Viajante experiente, quando a capa abre, então a aba Docs não aparece; dado Assistente júnior, então Gastos e Docs não aparecem; verificado por `viagem_capa_view_model_test.dart`/`viagem_capa_view_test.dart`.
- [x] **AC-6** — Dado o frame 390×844 e os dados mocados do protótipo, quando esta tela está visível, então alinhamento, espaçamento, tipografia e cor coincidem com `.docs/prototype` e com `16-viagem-capa-e-abas.md`; verificado por teste de widget em viewport 390 px. Inspeção visual lado a lado via app real não concluída nesta sessão.
- [ ] **AC-7** — Dado reduzir movimento ativo no aparelho, quando esta tela anima, então as durações caem para cerca de 0 ms; **pendente**, mesmo gap das specs anteriores.

## 8. Premissas e decisões

| ID | Tipo | Descrição | Dono | Validação |
| --- | --- | --- | --- | --- |
| D-1 | decisão | O protótipo e `16-viagem-capa-e-abas.md` mandam no visual e no movimento. Dado divergente, a inspeção para e a diferença fica registrada antes de implementar. | produto | inspeção lado a lado |
| D-2 | decisão | Dados mocados, código de verificação `1234`, usuário Jean Lucas quando a tela pede alguém logado. | produto | comparar com o protótipo |
| D-3 | decisão | `A DEFINIR` não é implementado como regra nova. | produto | revisão da spec |
| P-1 | premissa | A fundação visual da spec `abertura` já existe quando esta fatia for implementada, salvo na própria abertura. | app | a spec `abertura` concluída |
| D-8 | decisão | "A aba escolhida é lembrada por viagem" foi implementada como memória em processo (`Map` estático por `viagem.id`), não persistida em disco — não há backend nesta fila, e reabrir o app perde a memória. Comportamento visível dentro de uma mesma sessão é o pedido pela spec. | app | `ViagemCapaViewModel._memoria` |
| D-9 | decisão | Apenas a aba Roteiro tem conteúdo real (specs `017-roteiro-lista.md`/`018-roteiro-mapa.md`, desta mesma fila). Gastos, Mala, Compras e Docs abrem `DestinoPlaceholder` — são as specs `021`/`023`/`024`/`025`, fora desta fila. | produto | implementar quando essas specs chegarem |

## 9. Impactos

| Área | Impacto |
| --- | --- |
| Arquitetura/contratos | Tela Flutter em `mayahtrip-app`. Sem contrato de API nesta fatia. |
| Dados | Estado em memória, igual ao protótipo. Nada é gravado em servidor. |
| UI/UX e acessibilidade | Frame 390×844. Tipografia Plus Jakarta Sans e Instrument Serif. Reduzir movimento zera a duração. |
| Segurança | Sessão mocada. Sem senha real, sem segredo, sem PAN de cartão. |
| Observabilidade | Não se aplica: não há chamada de rede nesta fatia. |

## 10. Plano de testes

- Widget/unitário: cada AC com dado de entrada do protótipo.
- Integração: não se aplica enquanto os dados forem mocados.
- Manual no frame 390×844: abrir o protótipo por HTTP e comparar esta tela, inclusive o movimento.
- Casos de borda: vazio, erro escrito no doc, papel sem permissão e reduzir movimento.

## 11. Riscos e rollback

| Risco | Probabilidade | Impacto | Mitigação |
| --- | --- | --- | --- |
| A tela copia a vizinha e estoura o escopo | média | alto | AC e seção 5.2 nomeiam as outras specs |
| Medida do protótipo diverge do BUSINESS | baixa | alto | Parar e registrar, decisão D-1 |

- Rollback: remover a rota e os widgets desta fatia. As specs vizinhas continuam.
- Critério para abortar: um AC falha na inspeção lado a lado ou a implementação precisa inventar um `A DEFINIR`.

## 12. Perguntas em aberto

| Pergunta | Bloqueante? | Dono | Prazo |
| --- | --- | --- | --- |
| Topo (52 px, 16 px laterais): voltar (vidro) · **Compartilhar** (vidro) → `26` · **Editar** (vidro) → edição da viagem `A DEFINIR`. | não | produto | antes do refine-spec |
| Como as abas ocultas aparecem (somem ou bloqueadas com cadeado): `A DEFINIR`. | não | produto | antes do refine-spec |
| ## A DEFINIR | não | produto | antes do refine-spec |

Nenhuma pergunta acima bloqueia esta spec. A tela mocada copia o que o protótipo já mostra e deixa de fora o que o protótipo não desenha.

## 13. Resultado

A fatia `viagem-capa` está pronta quando todos os AC passam no frame 390×844 com os dados mocados do protótipo.

## 14. Definition of Ready

- [x] Problema, usuário e valor claros
- [x] Escopo e fora de escopo explícitos
- [x] Critérios de aceite mensuráveis (`AC-*`)
- [x] Premissas com dono e validação
- [x] Impactos mapeados
- [x] Plano de testes definido
- [x] Riscos e rollback definidos
- [x] Sem pergunta bloqueante em aberto
- [ ] Spec revisada com `refine-spec`
- [ ] Aprovada pelo responsável

Dependências para implementar, não para ler esta spec:

- `carteira` em `017-carteira.md`
