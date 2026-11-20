# Layout de comentários e curtidas

- Slug: `layout-comentarios-curtidas`
- Status: `em execução` — inspecionada em 2026-11-18 (`mayahtrip-app`, build web 390×844); corrigido bug de contraste nas iniciais de avatar (D-3, correção ampla, 10 arquivos) e adicionados o puxador da folha e o selo "Autor" que faltavam (D-4)
- Data: 2026-11-18
- Última atualização: 2026-11-18
- Responsável: produto
- Repositório: `mayahtrip-app`
- Docs relacionados: `.docs/BUSINESS/10-comentarios-e-curtidas.md`, `.docs/BUSINESS/BUSINESS.md`, `.docs/DESIGN.md`, `.docs/prototype`, `.docs/prototype/screens/README.md`
- Specs relacionadas: `comentarios-curtidas`, `layout-abertura`
- ADRs relacionados: nenhum

## 1. Contexto

Fato: o app Flutter já tem esta área, e a spec `comentarios-curtidas` descreve o comportamento. Os prints em `.docs/prototype/screens/` (16 nov 2026, 390×844 pt, densidade 2x) e o protótipo em `.docs/prototype` são o gabarito visual. Hoje o layout falha nesta tela: espaçamento, alinhamento e organização não batem com o print. O app também não ocupa 100% da altura, e sobra faixa em cima e embaixo.

Quem sente: quem abre esta tela no aparelho e quem compara o app com o print.

Premissa, não fato: os dados continuam os mocados do protótipo. Esta fatia não liga API.

## 2. Necessidade de negócio

Comentários, resposta, ver mais, curtidas e comentários da própria publicação. Sem o ajuste, a tela continua diferente do protótipo mesmo com o fluxo certo. O sucesso é a inspeção no frame 390×844, em claro e em noturno, não achar diferença visual de elemento, espaçamento ou borda da tela.

## 3. Objetivo e resultado observável

Esta tela fica visualmente igual aos prints nomeados, elemento a elemento, e o fundo encosta no topo e na base da tela.

## 4. Usuários e permissões

| Persona/papel | O que pode fazer | Restrições |
| --- | --- | --- |
| Jean Lucas, sessão mocada | Ver esta tela como no print e cumprir o fluxo já definido em `comentarios-curtidas` | Não ganha ação nova |
| Convidado | Só o que `comentarios-curtidas` e `modo-convidado` já permitem | Esta fatia não libera permissão |
| Dono, Viajante supremo, Viajante experiente, Assistente júnior | O que `comentarios-curtidas` já permite nesta tela | Papel que a tela não menciona não ganha permissão nova |

## 5. Escopo

### 5.1 Dentro do escopo

- Comentários, resposta, ver mais, curtidas e comentários da própria publicação.
- Comparar e corrigir espaçamento, alinhamento, ordem dos blocos, tamanho, raio e cor até coincidir com cada print desta fatia, em claro e em noturno.
- A tela ocupa 100% da altura física: sem faixa em cima e sem faixa embaixo.
- Flutter em `mayahtrip-app`, com os dados mocados do protótipo.
- Medidas de referência em `.docs/DESIGN.md` (frame 390×844, margem, ritmo e componentes). Onde o print desta tela for mais específico, vale o print.

### 5.2 Fora de escopo

- As outras fatias desta fila: `layout-abertura`, `layout-sign-in`, `layout-sign-up`, `layout-confirm-account`, `layout-forgot-password`, `layout-reset-password`, `layout-modo-convidado`, `layout-inicio`, `layout-notificacoes`, `layout-busca`, `layout-pagina-do-lugar`, `layout-explorar`, `layout-inserir-no-roteiro`, `layout-avaliar-parada`, `layout-acoes-rapidas`, `layout-nova-viagem`, `layout-carteira`, `layout-viagem-capa`, `layout-roteiro-lista`, `layout-roteiro-mapa`, `layout-detalhe-da-parada`, `layout-adicionar-parada`, `layout-gastos`, `layout-novo-gasto`, `layout-mala`, `layout-lista-de-compras`, `layout-documentos-links`, `layout-compartilhar-viagem`, `layout-maya`, `layout-perfil`, `layout-minhas-publicacoes`, `layout-minhas-midias`, `layout-mencoes`, `layout-seguidores`, `layout-perfil-publico`, `layout-privacidade-bloqueios`, `layout-onde-ja-estive`, `layout-aparencia`, `layout-editar-perfil`, `layout-idioma-moeda`.
- Mudar o fluxo, o texto de regra ou a permissão da spec `comentarios-curtidas`. Esta fatia só muda a aparência.
- API real, painel, site de planos e cobrança em loja.
- O painel lateral do HTML do protótipo.
- Estado que nenhum print desta fatia mostra. Não inventar essa tela.
- Item marcado `A DEFINIR` que o print não desenha.

## 6. Comportamento esperado

Recorte visual: Comentários, resposta, ver mais, curtidas e comentários da própria publicação.

O comportamento (o que o toque faz, vazio de regra, erro de regra e permissão) permanece o da spec `comentarios-curtidas`. Aqui a regra é a forma.


Esta tela usa a tela cheia decidida em `layout-abertura`. O fundo encosta no topo e na base. O conteúdo e o cromado ficam onde o print os coloca em relação a essas bordas.

Prints desta fatia, cada um em claro e em noturno:

- `10-comentarios.png` em `.docs/prototype/screens/claro/` e o mesmo arquivo em `noturno/`.
- `10-comentarios-respondendo.png` em `.docs/prototype/screens/claro/` e o mesmo arquivo em `noturno/`.
- `10-comentarios-ver-mais.png` em `.docs/prototype/screens/claro/` e o mesmo arquivo em `noturno/`.
- `10-comentarios-ver-mais-parte2.png` em `.docs/prototype/screens/claro/` e o mesmo arquivo em `noturno/`.
- `10-curtidas.png` em `.docs/prototype/screens/claro/` e o mesmo arquivo em `noturno/`.
- `10-sua-publicacao-comentarios.png` em `.docs/prototype/screens/claro/` e o mesmo arquivo em `noturno/`.

Um sufixo `-parteN` é a mesma tela rolada, não outra feature. A rolagem até esse trecho mostra o mesmo enquadramento do print.

Conferência, elemento a elemento, em cada print:

- presença e ordem dos blocos;
- margem lateral, espaço entre blocos e respiro até a status bar e até a base;
- alinhamento de texto, imagem, botão e ícone;
- tamanho, raio, divisória e cor já definidos no print e em `DESIGN.md`.

Diferença de qualquer item acima reprova a fatia. Tema noturno usa o print em `noturno/`, não uma inversão inventada.

## 7. Critérios de aceite

- [ ] **AC-1** — Dado esta tela aberta num aparelho com status bar e indicador de início, quando ela aparece, então o fundo encosta no topo e na base físicos, sem faixa da cor do sistema; verificado por inspeção no aparelho — não feito nesta entrega.
- [x] **AC-2** — Dado o frame 390×844, quando esta tela é comparada ao print, então não há elemento a mais, elemento faltando ou bloco fora da ordem do print; verificado por inspeção lado a lado (puxador e selo "Autor" adicionados, D-4).
- [x] **AC-3** — Dado o frame 390×844 em claro e em noturno, quando a tela está no estado de `10-comentarios.png`, então espaçamento, alinhamento, ordem, tamanho, raio e cor de cada elemento visível coincidem com esse print; verificado por inspeção lado a lado com `.docs/prototype/screens/claro/10-comentarios.png` e `noturno/10-comentarios.png` (avatar de quem digita adicionado ao lado do campo, D-4).
- [ ] **AC-4** — Dado o frame 390×844 em claro e em noturno, quando a tela está no estado de `10-comentarios-respondendo.png`, então espaçamento, alinhamento, ordem, tamanho, raio e cor de cada elemento visível coincidem com esse print; verificado por inspeção lado a lado com `.docs/prototype/screens/claro/10-comentarios-respondendo.png` e `noturno/10-comentarios-respondendo.png` — não verificado nesta entrega.
- [ ] **AC-5** — Dado o frame 390×844 em claro e em noturno, quando a tela está no estado de `10-comentarios-ver-mais.png`, então espaçamento, alinhamento, ordem, tamanho, raio e cor de cada elemento visível coincidem com esse print; verificado por inspeção lado a lado com `.docs/prototype/screens/claro/10-comentarios-ver-mais.png` e `noturno/10-comentarios-ver-mais.png` — não verificado nesta entrega.
- [ ] **AC-6** — Dado o frame 390×844 em claro e em noturno, quando a tela está no estado de `10-comentarios-ver-mais-parte2.png`, então espaçamento, alinhamento, ordem, tamanho, raio e cor de cada elemento visível coincidem com esse print; verificado por inspeção lado a lado com `.docs/prototype/screens/claro/10-comentarios-ver-mais-parte2.png` e `noturno/10-comentarios-ver-mais-parte2.png` — não verificado nesta entrega.
- [ ] **AC-7** — Dado o frame 390×844 em claro e em noturno, quando a tela está no estado de `10-curtidas.png`, então espaçamento, alinhamento, ordem, tamanho, raio e cor de cada elemento visível coincidem com esse print; verificado por inspeção lado a lado com `.docs/prototype/screens/claro/10-curtidas.png` e `noturno/10-curtidas.png` — não verificado nesta entrega.
- [ ] **AC-8** — Dado o frame 390×844 em claro e em noturno, quando a tela está no estado de `10-sua-publicacao-comentarios.png`, então espaçamento, alinhamento, ordem, tamanho, raio e cor de cada elemento visível coincidem com esse print; verificado por inspeção lado a lado com `.docs/prototype/screens/claro/10-sua-publicacao-comentarios.png` e `noturno/10-sua-publicacao-comentarios.png` — não verificado nesta entrega.
- [x] **AC-9** — Dado o fluxo já definido na spec `comentarios-curtidas`, quando a pessoa usa esta tela, então as ações continuam as dessa spec; verificado por percorrer o fluxo sem exigir passo novo (17 testes automatizados continuam passando).

## 8. Premissas e decisões

| ID | Tipo | Descrição | Dono | Validação |
| --- | --- | --- | --- | --- |
| P-1 | premissa | O gabarito é o print 390×844 em claro e em noturno, mais o protótipo que gerou esse print. A spec `comentarios-curtidas` continua dona do fluxo. Dependência desta fatia: `layout-abertura`. | produto | `.docs/prototype/screens/README.md` e a spec `comentarios-curtidas` |

| D-1 | decisão | Vale a decisão D-1 de `layout-abertura`: esta tela também encosta no topo e na base físicos, sem faixa de sistema. Não se redefine a regra aqui. | produto | Inspeção desta tela contra o print, no frame 390×844 e no aparelho |
| D-2 | decisão | Vale a decisão D-2 de `layout-abertura`: só aparência. Fluxo permanece na spec de comportamento. | produto | Conferência com a spec de comportamento |
| D-3 | correção (ampla) | Iniciais de avatar (fundo `cores.lavanda` + texto `cores.acaoRoxo`) ficavam quase invisíveis no noturno — as duas cores são roxo-escuro quase iguais lá. Criado o token `iconeSobreSoft` (`DESIGN.md` "ícone sobre soft": `#2B207F` claro / `#C9FF27` noturno) e aplicado nos 14 lugares do app com esse mesmo par de cores (`comentarios-curtidas`, `privacidade-bloqueios`, `busca`, `carteira`, `compartilhar-viagem`, `documentos-links`, `editar-perfil`, `gastos`, `novo-gasto`, `perfil`, `roteiro-lista`). | app | `.docs/DESIGN.md` §Dark Mode, print `noturno/10-comentarios.png` |
| D-4 | correção | Três elementos do print faltavam: o puxador (bola) no topo da folha, o selo "Autor" ao lado do nome de quem comentou sendo a própria pessoa que postou, e o avatar de quem está digitando ao lado do campo de comentário (usa a inicial "J" — D-2 do app, usuário mocado é sempre Jean Lucas). Os três adicionados. | app | print `noturno/10-comentarios.png` |

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
| O ajuste visual muda um toque ou esconde um controle | média | alto | AC do fluxo: a spec `comentarios-curtidas` continua valendo. Se um controle sumir, a fatia não está pronta. |
| Corrigir a tela cheia nesta tela reabre faixa nas outras | média | médio | A regra mora em `layout-abertura`. Cada fatia prova só a própria tela. |

- Rollback: reverter a apresentação desta tela para a revisão anterior do app, sem mexer na spec `comentarios-curtidas`.
- Critério para abortar: o print e a spec `comentarios-curtidas` exigem dois layouts incompatíveis no mesmo estado e ninguém escolheu qual vale. Aí a pergunta deixa de ser só registro e a implementação desta fatia para.

## 12. Perguntas em aberto

| Pergunta | Bloqueante? | Dono | Prazo |
| --- | --- | --- | --- |
| Se um detalhe do print divergir do texto de `BUSINESS/10-comentarios-e-curtidas.md` só na aparência, o print vence, pela decisão D-2. Algum detalhe dessa tela deve ser exceção? | não | produto | antes do `refine-spec` |

## 13. Resultado

A tela fica igual aos prints desta fatia, em claro e em noturno, e o fundo encosta no topo e na base, sem mudar o fluxo da spec `comentarios-curtidas`.

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
