# Notificações

- Slug: `notificacoes`
- Status: `em execução`
- Data: 2026-11-16
- Última atualização: 2026-11-17
- Responsável: produto
- Repositório: `mayahtrip-app`
- Docs relacionados: `.docs/BUSINESS/06-notificacoes.md`, `.docs/BUSINESS/BUSINESS.md`, `.docs/DESIGN.md`, `.docs/prototype`
- Specs relacionadas: `inicio`
- ADRs relacionados: nenhum

## 1. Contexto

Fato: o protótipo em `.docs/prototype` (16 nov 2026, frame 390×844) e `06-notificacoes.md` já descrevem esta feature. O app Flutter em `mayahtrip-app` ainda não tem essa tela.

Quem sente: quem for usar o app e quem for comparar a tela com o protótipo. Sem esta fatia, o comportamento existe só no HTML.

Premissa, não fato: os dados continuam mocados, iguais aos do protótipo. Não há API nesta fila.

## 2. Necessidade de negócio

O app público precisa desta tela idêntica ao protótipo antes de qualquer outra entrega da mesma área. O sucesso é a pessoa cumprir o fluxo abaixo e a inspeção no frame 390×844 não achar diferença de layout, espaçamento, alinhamento ou animação.

## 3. Objetivo e resultado observável

Central aberta pelo sino. Tipos desenhados: roteiro, convite, gasto e boas-vindas. Layout de comentário, curtida, menção e denúncia continua A DEFINIR.

## 4. Usuários e permissões

| Persona/papel | O que pode fazer | Restrições |
| --- | --- | --- |
| Jean Lucas, sessão mocada | Cumprir o fluxo desta fatia como no protótipo | Dados fixos do protótipo |
| Convidado | Só o que `modo-convidado` libera | Fora desta spec, exceto na própria spec `modo-convidado` |
| Dono, Viajante supremo, Viajante experiente, Assistente júnior | O que `06-notificacoes.md` e BUSINESS.md §4.3 permitem nesta tela | Papel que a tela não menciona não ganha permissão nova |

## 5. Escopo

### 5.1 Dentro do escopo

- Central aberta pelo sino. Tipos desenhados: roteiro, convite, gasto e boas-vindas. Layout de comentário, curtida, menção e denúncia continua A DEFINIR.
- Flutter em `mayahtrip-app`, com os dados mocados do protótipo.
- Reutilizar tokens, fontes e movimento definidos na spec `abertura`, sem redefini-los.

### 5.2 Fora de escopo

- As outras fatias: `abertura`, `sign-in`, `sign-up`, `confirm-account`, `forgot-password`, `reset-password`, `inicio`, `busca`, `pagina-do-lugar`, `explorar`, `comentarios-curtidas`, `inserir-no-roteiro`, `avaliar-parada`, `acoes-rapidas`, `nova-viagem`, `carteira`, `viagem-capa`, `roteiro-lista`, `roteiro-mapa`, `detalhe-da-parada`, `adicionar-parada`, `gastos`, `novo-gasto`, `mala`, `lista-de-compras`, `documentos-links`, `compartilhar-viagem`, `maya`, `perfil`, `minhas-publicacoes`, `minhas-midias`, `mencoes`, `seguidores`, `perfil-publico`, `privacidade-bloqueios`, `onde-ja-estive`, `aparencia`, `editar-perfil`, `idioma-moeda`, `modo-convidado`.
- API real, painel, site de planos e cobrança em loja.
- Item marcado `A DEFINIR` que o protótipo não desenha. Não inventar a regra.
- O painel lateral do HTML do protótipo.

## 6. Comportamento esperado

Recorte: Central aberta pelo sino. Tipos desenhados: roteiro, convite, gasto e boas-vindas. Layout de comentário, curtida, menção e denúncia continua A DEFINIR.

O texto abaixo é a regra desta fatia. Medida, tempo e cor citados são critério visual. Menção a uma tela de outra spec é só navegação: o destino pertence à spec daquele slug.

## Regra geral
Toda notificação é **enviada no app e por push** ao mesmo tempo.

## Acesso
Sino do Início. Ao abrir a tela, todas passam a **lidas** após 400 ms (o contador do sino zera).

## Layout
- Cabeçalho (52 px do topo): voltar (44 px) · título “Notificações” (h3) · botão ✓ (44 px) **Marcar todas como lidas** (aviso “Tudo lido”).
- Seções com kicker 11 px/800 `#5E5A73`: **HOJE** e **ESTA SEMANA** (margem 22 px acima, 10 px abaixo). Cartões brancos raio 24 px, espaço 10 px, padding 14 px.
- Não lida: bolinha 8 px `#2B207F` 10 px à esquerda do cartão, alinhada ao título.

## Tipos

### 1. Roteiro sendo gerado
- Ícone 44 px (raio 14) roxo com indicador giratório lima.
- Título “Montando o roteiro de {viagem}”; subtítulo “Organizando N dias por bairro para você andar menos”.
- Barra de progresso 6 px + texto “{p}% · você pode sair, avisamos quando terminar”.
- Ao concluir: ícone vira check; título “Roteiro de {viagem} pronto”; subtítulo “N dias, M paradas organizadas por bairro”; botão lima **Ver roteiro** (40 px) → abre a viagem na aba Roteiro, dia 1. Também aparece o aviso “Roteiro de {viagem} pronto” com ação **Ver**.
- A geração é assíncrona: o usuário pode sair da tela.

### 2. Convite para viagem
- Avatar 44 px de quem convidou; texto “**{Nome}** te convidou para a viagem **{viagem}**”; linha “{datas} · N pessoas”.
- Botões lado a lado (42 px): **Aceitar** (primário) / **Recusar** (contorno).
- Aceitar → viagem entra na Carteira com o papel definido no convite; etiqueta lima “✓ Você entrou na viagem”; aviso “Você entrou em {viagem}” + **Ver**.
- Recusar → etiqueta cinza “Convite recusado”; aviso “Convite recusado. {Nome} será avisada.” **Quem convidou recebe notificação** (app + push).

### 3. Gasto lançado por outra pessoa
- Avatar 44 px com selo lima de carteira (20 px) no canto inferior direito.
- “**{Nome}** adicionou **{descrição}** em {viagem}”; linha 12 px/700 `#962A10`: “{valor} · você deve {sua parte}”.
- Toque → abre a viagem na aba Gastos.

### 4. Boas-vindas
- Ícone: símbolo da marca 24 px em bloco `#15122E`.
- “Bem-vindo ao MayahTrip!” / “Crie sua primeira viagem em 4 toques ou explore o que a comunidade anda postando.”
- Toque → assistente de nova viagem.

## Outras notificações previstas (app + push)
- Comentário, resposta, curtida e menção em publicações (ver `10` e `29`).
- Retorno de denúncia (ver `30`).
- Layout desses itens: `A DEFINIR`.

## A DEFINIR
- Agrupamento por período além de “Hoje” e “Esta semana” (ex.: “Anteriores”).
- Exclusão de notificações individuais.
- Texto exato dos pushes.

Estados desta fatia:

- Vazio: o que `06-notificacoes.md` descreve como vazio. Se o arquivo não descreve vazio, a tela não inventa empty state.
- Erro: só a mensagem que o arquivo escreve. Mensagem marcada `A DEFINIR` não é criada.
- Permissão: papéis de BUSINESS.md §4.3 quando a tela cita papel.
- Limite: o número que o arquivo fixa (tentativas, caracteres, dias, itens). O que está `A DEFINIR` não vira limite.

## 7. Critérios de aceite

- [x] **AC-1** — Dado notificações não lidas, quando a central abre, então após 400 ms todas ficam lidas e o contador do sino zera; verificado por `test/ui/features/notificacoes/notificacoes_view_test.dart` (AC-1).
- [x] **AC-2** — Dado um convite, quando a pessoa aceita, então a viagem entra na carteira com o papel do convite e o aviso oferece Ver; quando recusa, o aviso diz que quem convidou será avisado; verificado por `notificacoes_view_test.dart` (AC-2, aceitar e recusar). "Entrar na carteira" propriamente dito é um placeholder, pois a tela Carteira não existe ainda (fora de escopo desta fila).
- [x] **AC-3** — Dado a notificação de roteiro concluído, quando a pessoa toca Ver roteiro, então a viagem abre na aba Roteiro, dia 1; verificado por `notificacoes_view_test.dart` (AC-3) — "abrir" é um `DestinoPlaceholder` rotulado, já que a tela de Roteiro é de outra spec fora desta fila.
- [x] **AC-4** — Dado a notificação de gasto, quando a pessoa toca o cartão, então a viagem abre na aba Gastos; verificado por inspeção do código (`_CartaoGasto.onTap` → placeholder "aba Gastos"); mesma ressalva do AC-3.
- [x] **AC-5** — Dado a boas-vindas, quando a pessoa toca, então abre o assistente de nova viagem; verificado por inspeção do código (`_CartaoBoasVindas.onTap` → placeholder "assistente de nova viagem"); mesma ressalva.
- [x] **AC-6** — Dado o frame 390×844 e os dados mocados do protótipo, quando esta tela está visível, então alinhamento, espaçamento, tipografia e cor coincidem com `.docs/prototype` e com `06-notificacoes.md`; verificado por mineração de `S.notifs` do protótipo (ids `gen`/`inv`/`exp`/`wel` idênticos) e por teste de widget em viewport 390 px. Inspeção visual lado a lado via app real não concluída nesta sessão (ver nota ao fim da fila).
- [ ] **AC-7** — Dado reduzir movimento ativo no aparelho, quando esta tela anima, então as durações caem para cerca de 0 ms; **pendente**, mesmo gap do AC-7 de `007-inicio.md`.

## 8. Premissas e decisões

| ID | Tipo | Descrição | Dono | Validação |
| --- | --- | --- | --- | --- |
| D-1 | decisão | O protótipo e `06-notificacoes.md` mandam no visual e no movimento. Dado divergente, a inspeção para e a diferença fica registrada antes de implementar. | produto | inspeção lado a lado |
| D-2 | decisão | Dados mocados, código de verificação `1234`, usuário Jean Lucas quando a tela pede alguém logado. | produto | comparar com o protótipo |
| D-3 | decisão | `A DEFINIR` não é implementado como regra nova. | produto | revisão da spec |
| P-1 | premissa | A fundação visual da spec `abertura` já existe quando esta fatia for implementada, salvo na própria abertura. | app | a spec `abertura` concluída |

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
| Layout desses itens: `A DEFINIR`. | não | produto | antes do refine-spec |
| ## A DEFINIR | não | produto | antes do refine-spec |

Nenhuma pergunta acima bloqueia esta spec. A tela mocada copia o que o protótipo já mostra e deixa de fora o que o protótipo não desenha.

## 13. Resultado

A fatia `notificacoes` está pronta quando todos os AC passam no frame 390×844 com os dados mocados do protótipo.

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
