# Layout do roteiro em lista

- Slug: `layout-roteiro-lista`
- Status: `em execução` — inspecionada parcialmente em 2026-11-18 (`mayahtrip-app`, build web 390×844); achado e corrigido singular/plural de "parada" (ver D-3), substituído emoji solto por ícone do design system e adicionado o link "Ver mais" que faltava (ver D-4); estados base, parada feita e dia livre verificados, rolagem (`-parte2`/`-parte3`) não verificada
- Responsável: produto
- Repositório: `mayahtrip-app`
- Docs relacionados: `.docs/BUSINESS/17-roteiro-lista.md`, `.docs/BUSINESS/BUSINESS.md`, `.docs/DESIGN.md`, `.docs/prototype`, `.docs/prototype/screens/README.md`
- Specs relacionadas: `roteiro-lista`, `layout-abertura`
- ADRs relacionados: nenhum

## 1. Contexto

Fato: o app Flutter já tem esta área, e a spec `roteiro-lista` descreve o comportamento. Os prints em `.docs/prototype/screens/` (16 nov 2026, 390×844 pt, densidade 2x) e o protótipo em `.docs/prototype` são o gabarito visual. Hoje o layout falha nesta tela: espaçamento, alinhamento e organização não batem com o print. O app também não ocupa 100% da altura, e sobra faixa em cima e embaixo.

Quem sente: quem abre esta tela no aparelho e quem compara o app com o print.

Premissa, não fato: os dados continuam os mocados do protótipo. Esta fatia não liga API.

## 2. Necessidade de negócio

O roteiro em lista, os trechos rolados, a parada feita e o dia livre. Sem o ajuste, a tela continua diferente do protótipo mesmo com o fluxo certo. O sucesso é a inspeção no frame 390×844, em claro e em noturno, não achar diferença visual de elemento, espaçamento ou borda da tela.

## 3. Objetivo e resultado observável

Esta tela fica visualmente igual aos prints nomeados, elemento a elemento, e o fundo encosta no topo e na base da tela.

## 4. Usuários e permissões

| Persona/papel | O que pode fazer | Restrições |
| --- | --- | --- |
| Jean Lucas, sessão mocada | Ver esta tela como no print e cumprir o fluxo já definido em `roteiro-lista` | Não ganha ação nova |
| Convidado | Só o que `roteiro-lista` e `modo-convidado` já permitem | Esta fatia não libera permissão |
| Dono, Viajante supremo, Viajante experiente, Assistente júnior | O que `roteiro-lista` já permite nesta tela | Papel que a tela não menciona não ganha permissão nova |

## 5. Escopo

### 5.1 Dentro do escopo

- O roteiro em lista, os trechos rolados, a parada feita e o dia livre.
- Comparar e corrigir espaçamento, alinhamento, ordem dos blocos, tamanho, raio e cor até coincidir com cada print desta fatia, em claro e em noturno.
- A tela ocupa 100% da altura física: sem faixa em cima e sem faixa embaixo.
- Flutter em `mayahtrip-app`, com os dados mocados do protótipo.
- Medidas de referência em `.docs/DESIGN.md` (frame 390×844, margem, ritmo e componentes). Onde o print desta tela for mais específico, vale o print.

### 5.2 Fora de escopo

- As outras fatias desta fila: `layout-abertura`, `layout-sign-in`, `layout-sign-up`, `layout-confirm-account`, `layout-forgot-password`, `layout-reset-password`, `layout-modo-convidado`, `layout-inicio`, `layout-notificacoes`, `layout-busca`, `layout-pagina-do-lugar`, `layout-explorar`, `layout-comentarios-curtidas`, `layout-inserir-no-roteiro`, `layout-avaliar-parada`, `layout-acoes-rapidas`, `layout-nova-viagem`, `layout-carteira`, `layout-viagem-capa`, `layout-roteiro-mapa`, `layout-detalhe-da-parada`, `layout-adicionar-parada`, `layout-gastos`, `layout-novo-gasto`, `layout-mala`, `layout-lista-de-compras`, `layout-documentos-links`, `layout-compartilhar-viagem`, `layout-maya`, `layout-perfil`, `layout-minhas-publicacoes`, `layout-minhas-midias`, `layout-mencoes`, `layout-seguidores`, `layout-perfil-publico`, `layout-privacidade-bloqueios`, `layout-onde-ja-estive`, `layout-aparencia`, `layout-editar-perfil`, `layout-idioma-moeda`.
- Mudar o fluxo, o texto de regra ou a permissão da spec `roteiro-lista`. Esta fatia só muda a aparência.
- API real, painel, site de planos e cobrança em loja.
- O painel lateral do HTML do protótipo.
- Estado que nenhum print desta fatia mostra. Não inventar essa tela.
- Item marcado `A DEFINIR` que o print não desenha.

## 6. Comportamento esperado

Recorte visual: O roteiro em lista, os trechos rolados, a parada feita e o dia livre.

O comportamento (o que o toque faz, vazio de regra, erro de regra e permissão) permanece o da spec `roteiro-lista`. Aqui a regra é a forma.


Esta tela usa a tela cheia decidida em `layout-abertura`. O fundo encosta no topo e na base. O conteúdo e o cromado ficam onde o print os coloca em relação a essas bordas.

Prints desta fatia, cada um em claro e em noturno:

- `17-roteiro-lista.png` em `.docs/prototype/screens/claro/` e o mesmo arquivo em `noturno/`.
- `17-roteiro-lista-parte2.png` em `.docs/prototype/screens/claro/` e o mesmo arquivo em `noturno/`.
- `17-roteiro-lista-parte3.png` em `.docs/prototype/screens/claro/` e o mesmo arquivo em `noturno/`.
- `17-roteiro-parada-feita.png` em `.docs/prototype/screens/claro/` e o mesmo arquivo em `noturno/`.
- `17-roteiro-dia-livre.png` em `.docs/prototype/screens/claro/` e o mesmo arquivo em `noturno/`.

Um sufixo `-parteN` é a mesma tela rolada, não outra feature. A rolagem até esse trecho mostra o mesmo enquadramento do print.

Conferência, elemento a elemento, em cada print:

- presença e ordem dos blocos;
- margem lateral, espaço entre blocos e respiro até a status bar e até a base;
- alinhamento de texto, imagem, botão e ícone;
- tamanho, raio, divisória e cor já definidos no print e em `DESIGN.md`.

Diferença de qualquer item acima reprova a fatia. Tema noturno usa o print em `noturno/`, não uma inversão inventada.

## 7. Critérios de aceite

- [ ] **AC-1** — Dado esta tela aberta num aparelho com status bar e indicador de início, quando ela aparece, então o fundo encosta no topo e na base físicos, sem faixa da cor do sistema; verificado por inspeção no aparelho — não feito nesta entrega.
- [x] **AC-2** — Dado o frame 390×844, quando esta tela é comparada ao print, então não há elemento a mais, elemento faltando ou bloco fora da ordem do print; verificado por inspeção lado a lado (D-3, D-4).
- [x] **AC-3** — Dado o frame 390×844 em claro e em noturno, quando a tela está no estado de `17-roteiro-lista.png`, então espaçamento, alinhamento, ordem, tamanho, raio e cor de cada elemento visível coincidem com esse print; verificado por inspeção lado a lado com `.docs/prototype/screens/claro/17-roteiro-lista.png` e `noturno/17-roteiro-lista.png`.
- [ ] **AC-4** — Dado o frame 390×844 em claro e em noturno, quando a tela está no estado de `17-roteiro-lista-parte2.png`, então espaçamento, alinhamento, ordem, tamanho, raio e cor de cada elemento visível coincidem com esse print; verificado por inspeção lado a lado com `.docs/prototype/screens/claro/17-roteiro-lista-parte2.png` e `noturno/17-roteiro-lista-parte2.png` — não verificado nesta entrega.
- [ ] **AC-5** — Dado o frame 390×844 em claro e em noturno, quando a tela está no estado de `17-roteiro-lista-parte3.png`, então espaçamento, alinhamento, ordem, tamanho, raio e cor de cada elemento visível coincidem com esse print; verificado por inspeção lado a lado com `.docs/prototype/screens/claro/17-roteiro-lista-parte3.png` e `noturno/17-roteiro-lista-parte3.png` — não verificado nesta entrega.
- [x] **AC-6** — Dado o frame 390×844 em claro e em noturno, quando a tela está no estado de `17-roteiro-parada-feita.png`, então espaçamento, alinhamento, ordem, tamanho, raio e cor de cada elemento visível coincidem com esse print; verificado por inspeção lado a lado com `.docs/prototype/screens/claro/17-roteiro-parada-feita.png` e `noturno/17-roteiro-parada-feita.png`.
- [x] **AC-7** — Dado o frame 390×844 em claro e em noturno, quando a tela está no estado de `17-roteiro-dia-livre.png`, então espaçamento, alinhamento, ordem, tamanho, raio e cor de cada elemento visível coincidem com esse print; verificado por inspeção lado a lado com `.docs/prototype/screens/claro/17-roteiro-dia-livre.png` e `noturno/17-roteiro-dia-livre.png`.
- [x] **AC-8** — Dado o fluxo já definido na spec `roteiro-lista`, quando a pessoa usa esta tela, então as ações continuam as dessa spec; verificado por percorrer o fluxo sem exigir passo novo (533 testes automatizados do app inteiro continuam passando).

## 8. Premissas e decisões

| ID | Tipo | Descrição | Dono | Validação |
| --- | --- | --- | --- | --- |
| P-1 | premissa | O gabarito é o print 390×844 em claro e em noturno, mais o protótipo que gerou esse print. A spec `roteiro-lista` continua dona do fluxo. Dependência desta fatia: `layout-abertura`. | produto | `.docs/prototype/screens/README.md` e a spec `roteiro-lista` |

| D-1 | decisão | Vale a decisão D-1 de `layout-abertura`: esta tela também encosta no topo e na base físicos, sem faixa de sistema. Não se redefine a regra aqui. | produto | Inspeção desta tela contra o print, no frame 390×844 e no aparelho |
| D-2 | decisão | Vale a decisão D-2 de `layout-abertura`: só aparência. Fluxo permanece na spec de comportamento. | produto | Conferência com a spec de comportamento |
| D-3 | correção | "${paradas.length} paradas" no cabeçalho do dia e no chip do seletor de dias não tratava singular ("1 paradas"); Roma tem um dia com 1 parada só, o que expôs o erro gramatical. Corrigido nos dois lugares (`roteiro_lista_view.dart`). | app | revisão gramatical, viagem "Roma" dia 3 |
| D-4 | correção | A linha de dicas de cada parada usava o emoji solto "💡" em vez do ícone do design system (`DESIGN_SYSTEM.md` proíbe emoji solto na UI) e não tinha o link "Ver mais" com chevron que o print mostra ao final da linha (o cartão inteiro já abre o detalhe da parada ao toque; o link é só a pista visual que faltava). Trocado por `MayahTripIconData.bulb` e adicionado "Ver mais" + `chevronRight` em `cores.linkRoxo`. | app | print `noturno/17-roteiro-lista.png`, `.docs/AGENTS.md` regra de não usar emoji solto |
| D-5 | divergência, não corrigida | O botão "⚡ Otimizar" (aparece só quando o dia tem 3+ paradas; nenhuma viagem mocada atual tem isso) também usa um emoji solto em vez de ícone do design system. Não existe ícone de raio em `MayahTripIconData`, e não é escopo desta fatia desenhar um SVG novo (mesma regra de não inventar asset já registrada em `077-layout-acoes-rapidas.md` D-3). Não verificado visualmente nesta entrega por falta de um dia com 3+ paradas nos dados mocados. | produto/app | `lib/ui/features/roteiro_lista/views/roteiro_lista_view.dart:195` |

## 9. Impactos

| Área | Impacto |
| --- | --- |
| Arquitetura/contratos | Nenhum contrato de API. Só a apresentação Flutter desta tela. |
| Dados | Continuam mocados, iguais ao protótipo. |
| UI/UX e acessibilidade | Espaçamento, ordem e tela cheia desta tela. Alvo de toque e contraste não podem piorar em relação ao print. |
| Segurança | não se aplica: não há sessão, segredo nem permissão nova. |
| Observabilidade | não se aplica: não há evento novo. |

## 10. Plano de testes

- Widget/unitário: não se aplica como prova visual. A prova é a inspeção contra o print.
- Integração: não se aplica. Não há API nesta fatia.
- Manual no frame 390×844: abrir cada print listado, em claro e em noturno, ao lado da tela e marcar elemento fora de lugar, espaço diferente ou faixa em cima ou embaixo.
- Casos de borda: trecho rolado (`-parteN`), vazio e erro somente quando houver print com esse nome nesta fatia. Aparelho mais alto que 844 pt continua sem faixa de sistema; o fundo da própria tela preenche a altura.

## 11. Riscos e rollback

| Risco | Probabilidade | Impacto | Mitigação |
| --- | --- | --- | --- |
| O ajuste visual muda um toque ou esconde um controle | média | alto | AC do fluxo: a spec `roteiro-lista` continua valendo. Se um controle sumir, a fatia não está pronta. |
| Corrigir a tela cheia nesta tela reabre faixa nas outras | média | médio | A regra mora em `layout-abertura`. Cada fatia prova só a própria tela. |

- Rollback: reverter a apresentação desta tela para a revisão anterior do app, sem mexer na spec `roteiro-lista`.
- Critério para abortar: o print e a spec `roteiro-lista` exigem dois layouts incompatíveis no mesmo estado e ninguém escolheu qual vale. Aí a pergunta deixa de ser só registro e a implementação desta fatia para.

## 12. Perguntas em aberto

| Pergunta | Bloqueante? | Dono | Prazo |
| --- | --- | --- | --- |
| Se um detalhe do print divergir do texto de `BUSINESS/17-roteiro-lista.md` só na aparência, o print vence, pela decisão D-2. Algum detalhe dessa tela deve ser exceção? | não | produto | antes do `refine-spec` |

## 13. Resultado

A tela fica igual aos prints desta fatia, em claro e em noturno, e o fundo encosta no topo e na base, sem mudar o fluxo da spec `roteiro-lista`.

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
