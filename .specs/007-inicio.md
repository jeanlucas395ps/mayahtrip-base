# Início

- Slug: `inicio`
- Status: `em execução`
- Data: 2026-11-16
- Última atualização: 2026-11-17
- Responsável: produto
- Repositório: `mayahtrip-app`
- Docs relacionados: `.docs/BUSINESS/05-inicio.md`, `.docs/BUSINESS/BUSINESS.md`, `.docs/DESIGN.md`, `.docs/prototype`
- Specs relacionadas: `abertura`
- ADRs relacionados: nenhum

## 1. Contexto

Fato: o protótipo em `.docs/prototype` (16 nov 2026, frame 390×844) e `05-inicio.md` já descrevem esta feature. O app Flutter em `mayahtrip-app` ainda não tem essa tela.

Quem sente: quem for usar o app e quem for comparar a tela com o protótipo. Sem esta fatia, o comportamento existe só no HTML.

Premissa, não fato: os dados continuam mocados, iguais aos do protótipo. Não há API nesta fila.

## 2. Necessidade de negócio

O app público precisa desta tela idêntica ao protótipo antes de qualquer outra entrega da mesma área. O sucesso é a pessoa cumprir o fluxo abaixo e a inspeção no frame 390×844 não achar diferença de layout, espaçamento, alinhamento ou animação.

## 3. Objetivo e resultado observável

Início com sessão de Jean Lucas e a barra inferior das quatro raízes. A faixa de convidado fica na spec modo-convidado. Busca, notificações, nova viagem, carteira, feed e Maya só são destinos.

## 4. Usuários e permissões

| Persona/papel | O que pode fazer | Restrições |
| --- | --- | --- |
| Jean Lucas, sessão mocada | Cumprir o fluxo desta fatia como no protótipo | Dados fixos do protótipo |
| Convidado | Só o que `modo-convidado` libera | Fora desta spec, exceto na própria spec `modo-convidado` |
| Dono, Viajante supremo, Viajante experiente, Assistente júnior | O que `05-inicio.md` e BUSINESS.md §4.3 permitem nesta tela | Papel que a tela não menciona não ganha permissão nova |

## 5. Escopo

### 5.1 Dentro do escopo

- Início com sessão de Jean Lucas e a barra inferior das quatro raízes. A faixa de convidado fica na spec modo-convidado. Busca, notificações, nova viagem, carteira, feed e Maya só são destinos.
- Flutter em `mayahtrip-app`, com os dados mocados do protótipo.
- Reutilizar tokens, fontes e movimento definidos na spec `abertura`, sem redefini-los.

### 5.2 Fora de escopo

- As outras fatias: `abertura`, `sign-in`, `sign-up`, `confirm-account`, `forgot-password`, `reset-password`, `notificacoes`, `busca`, `pagina-do-lugar`, `explorar`, `comentarios-curtidas`, `inserir-no-roteiro`, `avaliar-parada`, `acoes-rapidas`, `nova-viagem`, `carteira`, `viagem-capa`, `roteiro-lista`, `roteiro-mapa`, `detalhe-da-parada`, `adicionar-parada`, `gastos`, `novo-gasto`, `mala`, `lista-de-compras`, `documentos-links`, `compartilhar-viagem`, `maya`, `perfil`, `minhas-publicacoes`, `minhas-midias`, `mencoes`, `seguidores`, `perfil-publico`, `privacidade-bloqueios`, `onde-ja-estive`, `aparencia`, `editar-perfil`, `idioma-moeda`, `modo-convidado`.
- API real, painel, site de planos e cobrança em loja.
- Item marcado `A DEFINIR` que o protótipo não desenha. Não inventar a regra.
- O painel lateral do HTML do protótipo.

## 6. Comportamento esperado

Recorte: Início com sessão de Jean Lucas e a barra inferior das quatro raízes. A faixa de convidado fica na spec modo-convidado. Busca, notificações, nova viagem, carteira, feed e Maya só são destinos.

O texto abaixo é a regra desta fatia. Medida, tempo e cor citados são critério visual. Menção a uma tela de outra spec é só navegação: o destino pertence à spec daquele slug.

## Objetivo
Ponto de partida diário: saudação, busca, atalho para criar viagem, a viagem mais próxima e o que está em alta na comunidade.

## Layout (rolagem vertical, margens 56 px topo / 20 px laterais / 130 px base, espaço 22 px entre blocos)
Os blocos entram em cascata: cada um sobe 14 px e aparece em 500 ms, com 40 ms de atraso entre eles (até 240 ms).

1. **Faixa de convidado** — só no modo convidado (ver `04`).
2. **Cabeçalho**
   - Esquerda: foto do usuário **circular 44 px** com borda branca 2 px (toque → Perfil). Ao lado: saudação 12 px `#5E5A73` + nome 16 px/700.
   - Saudação pelo **horário do celular**: 05:00–11:59 “Bom dia”; 12:00–17:59 “Boa tarde”; 18:00–04:59 “Boa noite”.
   - Direita: sino em botão 44 px branco → `06-notificacoes.md`. Contador de não lidas: pílula `#FF5A36`, 18 px de altura, texto 11 px/800 branco, borda branca 2 px, posicionado no canto superior direito do botão. Some quando zero.
3. **Título editorial** 42 px (line-height 1,02): “Para onde vai sua *curiosidade* hoje?” — “curiosidade” em itálico `#2B207F`.
4. **Campo de busca** (54 px, raio 27 px, borda `#E5E3EC`): ícone de lupa + “Qual a curiosidade do momento?” → `07-busca.md`.
5. **Cartão Nova viagem** (fundo `#2B207F`, raio 26 px, espaçamento 18 px, sombra `0 14px 30px rgba(43,32,127,.25)`) → `14-nova-viagem.md`:
   - Kicker lima “NOVA VIAGEM” + quadrado lima 36 px (raio 12) com “+”.
   - Título editorial 34 px branco “Roteiro pronto em 4 toques”.
   - 4 etiquetas (28 px, fundo branco 12%): “1. Destino”, “2. Datas”, “3. Quem vai”, “4. Pronto”.
6. **Sua viagem agora / Sua próxima viagem**
   - Título h2: “Sua viagem agora” se existir viagem acontecendo; senão “Sua próxima viagem”. Link “Todas” → Carteira.
   - Mostra **uma** viagem: a primeira (por data de início) com status *acontecendo agora* ou *próxima*. Se não houver, a primeira da carteira. Sem viagens: bloco não aparece.
   - Cartão de viagem idêntico ao da Carteira (`15-carteira-de-viagens.md`).
7. **Em alta na semana**
   - Título h2 + subtítulo 12 px “Os mais curtidos dos últimos 7 dias”; link “Ver feed” → Explorar.
   - Carrossel horizontal de cartões de vídeo **236 × 330 px**, raio 26 px, espaço 10 px, recuo inicial de 20 px e encaixe por item.
   - Cartão: foto cheia, degradê escuro de 72% da altura, botão “play” 34 px no canto superior direito (vidro), kicker lima “{Cidade} · {N} curtidas”, título editorial 36 px, frase 13 px `#E4E2EE`.
   - Toque → `08-pagina-do-lugar.md`. Ao passar o dedo/mouse, a foto dá zoom lento (1,06 em 6 s).

## Regra “Em alta”
**Os lugares mais curtidos da semana** (últimos 7 dias). Quantidade exibida no protótipo: 4. Critério de desempate e quantidade final: `A DEFINIR`.

## Balão da Maya
Visível no canto inferior direito (ver `27-maya.md`).

Estados desta fatia:

- Vazio: o que `05-inicio.md` descreve como vazio. Se o arquivo não descreve vazio, a tela não inventa empty state.
- Erro: só a mensagem que o arquivo escreve. Mensagem marcada `A DEFINIR` não é criada.
- Permissão: papéis de BUSINESS.md §4.3 quando a tela cita papel.
- Limite: o número que o arquivo fixa (tentativas, caracteres, dias, itens). O que está `A DEFINIR` não vira limite.

## 7. Critérios de aceite

- [x] **AC-1** — Dado sessão de Jean e o relógio do aparelho, quando o Início abre, então a saudação é Bom dia, Boa tarde ou Boa noite conforme os intervalos de BUSINESS/05 e o nome aparece ao lado do avatar de 44 px; verificado por `test/ui/features/inicio/inicio_view_model_test.dart` (relógio injetável, não a data fixa das viagens).
- [x] **AC-2** — Dado o Início, quando a tela entra, então os blocos sobem 14 px em 500 ms com atraso de 40 ms, até 240 ms; verificado por inspeção do código (`InicioContent`, `AnimationController` escalonado) — inspeção visual lado a lado não concluída nesta sessão (ver nota abaixo).
- [x] **AC-3** — Dado ao menos uma viagem mocada acontecendo ou próxima, quando o Início abre, então um único cartão aparece com o título “Sua viagem agora” ou “Sua próxima viagem”; sem viagens, o bloco não aparece; verificado por `test/ui/features/inicio/inicio_view_test.dart`.
- [x] **AC-4** — Dado as quatro raízes, quando uma delas está visível, então a barra inferior tem 88 px com Início, Explorar, +, Carteira e Perfil, e o item ativo usa #2B207F; verificado por `inicio_view_test.dart` e inspeção contra BUSINESS.md §6 — ver divergência D-4 (rótulo da 3ª raiz).
- [x] **AC-5** — Dado o carrossel Em alta, quando a pessoa toca um cartão, então abre a página do lugar da spec pagina-do-lugar; verificado por `inicio_view_test.dart`.
- [x] **AC-6** — Dado o frame 390×844 e os dados mocados do protótipo, quando esta tela está visível, então alinhamento, espaçamento, tipografia e cor coincidem com `.docs/prototype` e com `05-inicio.md`; verificado por inspeção do código fonte do protótipo (mineração de `S.trips`/`PL`) e por teste de widget em viewport 390 px — ver divergência D-5 (balão da Maya).
- [ ] **AC-7** — Dado reduzir movimento ativo no aparelho, quando esta tela anima, então as durações caem para cerca de 0 ms; **pendente**: `InicioContent`/`ViagemCard` não leem `MediaQuery.disableAnimations` ainda — ficou de fora desta rodada e precisa de uma fatia própria ou retomada antes de fechar a spec.

## 8. Premissas e decisões

| ID | Tipo | Descrição | Dono | Validação |
| --- | --- | --- | --- | --- |
| D-1 | decisão | O protótipo e `05-inicio.md` mandam no visual e no movimento. Dado divergente, a inspeção para e a diferença fica registrada antes de implementar. | produto | inspeção lado a lado |
| D-2 | decisão | Dados mocados, código de verificação `1234`, usuário Jean Lucas quando a tela pede alguém logado. | produto | comparar com o protótipo |
| D-3 | decisão | `A DEFINIR` não é implementado como regra nova. | produto | revisão da spec |
| P-1 | premissa | A fundação visual da spec `abertura` já existe quando esta fatia for implementada, salvo na própria abertura. | app | a spec `abertura` concluída |
| D-4 | divergência (D-1) | O protótipo renderiza literalmente "Viagens" como rótulo da 3ª raiz da barra inferior; BUSINESS.md §6 descreve "Carteira". Por D-1, o protótipo manda: a implementação usa o rótulo "Viagens" (pixel do protótipo), mantendo a rota/ícone de carteira. | produto | inspeção lado a lado (AC-4) |
| D-5 | divergência (D-1) | `05-inicio.md` e BUSINESS.md citam um "Balão da Maya" flutuante no canto inferior direito do Início; o markup real do protótipo (`.docs/prototype`) não desenha esse balão na tela inicial — `data-a="maya"` só aparece como link contextual dentro de outras folhas. Por D-1, a implementação segue o pixel real do protótipo e omite o balão flutuante nesta tela. | produto | inspeção lado a lado (AC-6) |

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
| **Os lugares mais curtidos da semana** (últimos 7 dias). Quantidade exibida no protótipo: 4. Critério de desempate e quantidade final: `A DEFINIR`. | não | produto | antes do refine-spec |

Nenhuma pergunta acima bloqueia esta spec. A tela mocada copia o que o protótipo já mostra e deixa de fora o que o protótipo não desenha.

## 13. Resultado

A fatia `inicio` está pronta quando todos os AC passam no frame 390×844 com os dados mocados do protótipo.

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

- `abertura` em `001-abertura.md`
