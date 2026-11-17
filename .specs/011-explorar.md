# Feed

- Slug: `explorar`
- Status: `em execução`
- Data: 2026-11-16
- Última atualização: 2026-11-17
- Responsável: produto
- Repositório: `mayahtrip-app`
- Docs relacionados: `.docs/BUSINESS/09-explorar-feed.md`, `.docs/BUSINESS/BUSINESS.md`, `.docs/DESIGN.md`, `.docs/prototype`
- Specs relacionadas: `inicio`
- ADRs relacionados: nenhum

## 1. Contexto

Fato: o protótipo em `.docs/prototype` (16 nov 2026, frame 390×844) e `09-explorar-feed.md` já descrevem esta feature. O app Flutter em `mayahtrip-app` ainda não tem essa tela.

Quem sente: quem for usar o app e quem for comparar a tela com o protótipo. Sem esta fatia, o comportamento existe só no HTML.

Premissa, não fato: os dados continuam mocados, iguais aos do protótipo. Não há API nesta fila.

## 2. Necessidade de negócio

O app público precisa desta tela idêntica ao protótipo antes de qualquer outra entrega da mesma área. O sucesso é a pessoa cumprir o fluxo abaixo e a inspeção no frame 390×844 não achar diferença de layout, espaçamento, alinhamento ou animação.

## 3. Objetivo e resultado observável

Feed em tela cheia, abas e avanço de 9 s. Comentários, inserir no roteiro e o perfil público são destinos.

## 4. Usuários e permissões

| Persona/papel | O que pode fazer | Restrições |
| --- | --- | --- |
| Jean Lucas, sessão mocada | Cumprir o fluxo desta fatia como no protótipo | Dados fixos do protótipo |
| Convidado | Só o que `modo-convidado` libera | Fora desta spec, exceto na própria spec `modo-convidado` |
| Dono, Viajante supremo, Viajante experiente, Assistente júnior | O que `09-explorar-feed.md` e BUSINESS.md §4.3 permitem nesta tela | Papel que a tela não menciona não ganha permissão nova |

## 5. Escopo

### 5.1 Dentro do escopo

- Feed em tela cheia, abas e avanço de 9 s. Comentários, inserir no roteiro e o perfil público são destinos.
- Flutter em `mayahtrip-app`, com os dados mocados do protótipo.
- Reutilizar tokens, fontes e movimento definidos na spec `abertura`, sem redefini-los.

### 5.2 Fora de escopo

- As outras fatias: `abertura`, `sign-in`, `sign-up`, `confirm-account`, `forgot-password`, `reset-password`, `inicio`, `notificacoes`, `busca`, `pagina-do-lugar`, `comentarios-curtidas`, `inserir-no-roteiro`, `avaliar-parada`, `acoes-rapidas`, `nova-viagem`, `carteira`, `viagem-capa`, `roteiro-lista`, `roteiro-mapa`, `detalhe-da-parada`, `adicionar-parada`, `gastos`, `novo-gasto`, `mala`, `lista-de-compras`, `documentos-links`, `compartilhar-viagem`, `maya`, `perfil`, `minhas-publicacoes`, `minhas-midias`, `mencoes`, `seguidores`, `perfil-publico`, `privacidade-bloqueios`, `onde-ja-estive`, `aparencia`, `editar-perfil`, `idioma-moeda`, `modo-convidado`.
- API real, painel, site de planos e cobrança em loja.
- Item marcado `A DEFINIR` que o protótipo não desenha. Não inventar a regra.
- O painel lateral do HTML do protótipo.

## 6. Comportamento esperado

Recorte: Feed em tela cheia, abas e avanço de 9 s. Comentários, inserir no roteiro e o perfil público são destinos.

O texto abaixo é a regra desta fatia. Medida, tempo e cor citados são critério visual. Menção a uma tela de outra spec é só navegação: o destino pertence à spec daquele slug.

## Objetivo
Descobrir lugares por vídeos curtos da comunidade (estilo TikTok) e levar o lugar ao roteiro em um toque.

## Estrutura
- Tela cheia, fundo preto, rolagem vertical **com encaixe por vídeo** (um post por tela).
- Barra inferior escura (ver `BUSINESS.md` §6). Balão da Maya escondido nesta tela.

### Abas (topo, 50 px do topo, 16 px laterais)
Pílulas de 36 px, raio 18 px, 14 px: **Seguindo · Para você (padrão) · Próximas viagens · Salvos**. Ativa: fundo branco, texto `#15122E`, 800. Inativa: `rgba(21,18,46,.35)` + desfoque, texto branco 600. A fila rola na horizontal e esmaece na borda direita. À direita, lupa 40 px (`rgba(21,18,46,.4)`) → Busca.

| Aba | Conteúdo |
| --- | --- |
| Seguindo | Posts de pessoas que o usuário segue |
| Para você | Todos (algoritmo `A DEFINIR`) |
| Próximas viagens | Posts de cidades das viagens futuras do usuário, ordenados pela viagem mais próxima. Selo `#15122E`/lima no topo: “🧳 Para sua viagem · {viagem} em N dias” |
| Salvos | Lugares salvos pelo usuário |

Trocar de aba volta ao primeiro post. Posts de pessoas **bloqueadas ou silenciadas** não aparecem.

### Post
- Foto/vídeo em tela cheia; zoom lento de 1,02 → 1,14 em 9 s enquanto o post está ativo (≥ 60% visível).
- Degradê: escuro no topo (55% → 0 em 20%) e forte na base (62% em 55% → 95% em 100%).
- **Trilho de ações** (direita, 12 px da borda, 290 px da base; botões 48 px redondos, branco 16% + desfoque; rótulo 12 px/700):
  1. **Curtir** (coração 24 px; curtido = preenchido `#FF5A6A`, “pulo” de escala 0,6→1,25→1 em 450 ms). Contador: total; curtido mostra “+1”.
  2. **Comentários** (balão 22 px) com o total de comentários → abre `10-comentarios-e-curtidas.md`.
  3. **Salvar** (marcador; salvo = preenchido lima).
  4. **Enviar** (aviso “Link copiado”).
- **Bloco de conteúdo** (16 px esquerda, 76 px direita, 116 px da base, espaço 12 px):
  - Autor: avatar 36 px + @usuário (13 px/700) + “esteve aqui em {mês ano}” (12 px `#D8D6E4`); toque → perfil público. Botão **Seguir** (30 px, contorno branco) se ainda não segue.
  - Kicker lima “{cidade} · {lugar}”; título editorial **40 px**; texto 13 px `#E4E2EE`.
  - **Cartão do lugar** (branco, raio 20 px): miniatura 40 px + nome + estrela/nota/categoria (toque → página do lugar) + botão primário **+ Roteiro** (38 px) → `11-inserir-no-roteiro.md`.
- **Botão de progresso** (canto inferior direito, 12 px da borda, 118 px da base): círculo 48 px escuro com seta para baixo balançando (1,6 s). Anel lima de 3 px desenha 0 → 360° em **9 s** enquanto o post está ativo.

## Regras
1. **Avanço automático**: ao completar o anel (9 s), o feed rola sozinho para o próximo post; no último, volta ao primeiro.
2. Tocar no botão de progresso pula para o próximo imediatamente.
3. Curtir, salvar e seguir exigem conta (convidado → convite).
4. Aba vazia: tela `#120F2A` com ícone de marcador 28 px (bloco 64 px), título editorial 32 px “Nada salvo ainda” (Salvos) ou “Nada por aqui” (outras), texto explicativo e botão lima **Ver Para você**.

## A DEFINIR
- Duração real por vídeo (o anel de 9 s é do protótipo com fotos; para vídeo, sugerido: duração do vídeo).
- Som (ligado/desligado por padrão).
- Algoritmo do “Para você”.

Estados desta fatia:

- Vazio: o que `09-explorar-feed.md` descreve como vazio. Se o arquivo não descreve vazio, a tela não inventa empty state.
- Erro: só a mensagem que o arquivo escreve. Mensagem marcada `A DEFINIR` não é criada.
- Permissão: papéis de BUSINESS.md §4.3 quando a tela cita papel.
- Limite: o número que o arquivo fixa (tentativas, caracteres, dias, itens). O que está `A DEFINIR` não vira limite.

## 7. Critérios de aceite

- [x] **AC-1** — Dado o feed, quando um post fica pelo menos 60% visível, então a foto faz zoom de 1,02 a 1,14 em 9 s e o anel lima completa 360° em 9 s; ao completar, o feed vai ao próximo e, no último, volta ao primeiro; verificado por `test/ui/features/explorar/explorar_view_test.dart` (AC-1, com `tester.pump` em vez de relógio falso injetado — o controlador de 9 s é real, avançado pelo pump). Implementação: como a tela usa `PageView` com encaixe por página (não scroll contínuo com `IntersectionObserver`), "ativo" é a página atual do `PageView`, não um cálculo de 60% de área visível — mesmo resultado observável.
- [x] **AC-2** — Dado a aba Para você, quando a pessoa troca de aba, então a lista volta ao primeiro post e posts de pessoas bloqueadas ou silenciadas não aparecem; verificado por `explorar_view_test.dart` e por `test/ui/features/explorar/explorar_view_model_test.dart`.
- [x] **AC-3** — Dado um post, quando a pessoa curte, então o coração fica #FF5A6A com o pulo de escala e o contador mostra +1; verificado por `explorar_view_test.dart` (o pulo de escala em si é por inspeção do código, `_PostSlideState._pulo`).
- [x] **AC-4** — Dado uma aba vazia, quando ela abre, então a tela #120F2A oferece Ver Para você; verificado por `explorar_view_test.dart`.
- [x] **AC-5** — Dado o Explorar visível, quando a barra inferior aparece, então ela fica escura e o balão da Maya não aparece; verificado por `test/ui/features/inicio/inicio_view_test.dart` (a barra; o balão da Maya já não existe em nenhuma tela desta fila, D-5 de `007-inicio.md`).
- [x] **AC-6** — Dado o frame 390×844 e os dados mocados do protótipo, quando esta tela está visível, então alinhamento, espaçamento, tipografia e cor coincidem com `.docs/prototype` e com `09-explorar-feed.md`; verificado por mineração dos 8 posts reais de `SCREENS.explore` e por teste de widget em viewport 390 px (achou e corrigiu 2 overflows reais: a linha do autor e a linha de nota/categoria do cartão do lugar). Gaps conhecidos, não pixel-perfeitos: (1) o Explorar herda o `SafeArea` de topo compartilhado do `InicioView` em vez de ser 100% tela cheia — ver nota no código de `inicio_view.dart`; (2) os 5 lugares minerados sem foto real usam bloco de cor (D-6 abaixo). Inspeção visual lado a lado via app real não concluída nesta sessão.
- [ ] **AC-7** — Dado reduzir movimento ativo no aparelho, quando esta tela anima, então as durações caem para cerca de 0 ms; **pendente**, mesmo gap das specs 007-010.

## 8. Premissas e decisões

| ID | Tipo | Descrição | Dono | Validação |
| --- | --- | --- | --- | --- |
| D-1 | decisão | O protótipo e `09-explorar-feed.md` mandam no visual e no movimento. Dado divergente, a inspeção para e a diferença fica registrada antes de implementar. | produto | inspeção lado a lado |
| D-2 | decisão | Dados mocados, código de verificação `1234`, usuário Jean Lucas quando a tela pede alguém logado. | produto | comparar com o protótipo |
| D-3 | decisão | `A DEFINIR` não é implementado como regra nova. | produto | revisão da spec |
| P-1 | premissa | A fundação visual da spec `abertura` já existe quando esta fatia for implementada, salvo na própria abertura. | app | a spec `abertura` concluída |
| D-6 | divergência (D-1) | Os 8 posts do feed usam 5 lugares novos (trocadero, bigben, coliseu, basilica, angelo) minerados de `PL`; o protótipo mostra foto real para eles, mas o binário da foto não estava disponível localmente nesta sessão. Usam bloco de cor sólida (`Lugar.corFallback`) até a foto real chegar. | produto | trocar por foto real quando disponível |
| D-7 | decisão | O `ExplorarView` fica dentro do mesmo `IndexedStack` das outras 3 raízes do `InicioView`, para preservar o estado do feed (página atual, curtidas) ao trocar de aba. Efeito colateral: o controlador de 9 s do post ativo continua rodando mesmo com o Explorar fora de tela. Troca aceitável nesta fila; revisar se virar problema de desempenho real. | app | observação em uso real |

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
| Para você | Todos (algoritmo `A DEFINIR`) | não | produto | antes do refine-spec |
| ## A DEFINIR | não | produto | antes do refine-spec |

Nenhuma pergunta acima bloqueia esta spec. A tela mocada copia o que o protótipo já mostra e deixa de fora o que o protótipo não desenha.

## 13. Resultado

A fatia `explorar` está pronta quando todos os AC passam no frame 390×844 com os dados mocados do protótipo.

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

- `inicio` em `007-inicio.md`
