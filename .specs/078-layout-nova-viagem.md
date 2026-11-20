# Layout de nova viagem

- Slug: `layout-nova-viagem`
- Status: `em execução` — inspecionada parcialmente em 2026-11-18 (`mayahtrip-app`, build web 390×844); achado e corrigido gap grande no passo 1 (ver D-3); só o passo 1 (`14-nova-viagem-1-destino.png`) foi verificado, os demais 13 estados ficam para a próxima entrega
- Data: 2026-11-18
- Última atualização: 2026-11-18
- Responsável: produto
- Repositório: `mayahtrip-app`
- Docs relacionados: `.docs/BUSINESS/14-nova-viagem.md`, `.docs/BUSINESS/BUSINESS.md`, `.docs/DESIGN.md`, `.docs/prototype`, `.docs/prototype/screens/README.md`
- Specs relacionadas: `nova-viagem`, `layout-abertura`
- ADRs relacionados: nenhum

## 1. Contexto

Fato: o app Flutter já tem esta área, e a spec `nova-viagem` descreve o comportamento. Os prints em `.docs/prototype/screens/` (16 nov 2026, 390×844 pt, densidade 2x) e o protótipo em `.docs/prototype` são o gabarito visual. Hoje o layout falha nesta tela: espaçamento, alinhamento e organização não batem com o print. O app também não ocupa 100% da altura, e sobra faixa em cima e embaixo.

Quem sente: quem abre esta tela no aparelho e quem compara o app com o print.

Premissa, não fato: os dados continuam os mocados do protótipo. Esta fatia não liga API.

## 2. Necessidade de negócio

Os passos de nova viagem, da escolha do destino até a geração. Sem o ajuste, a tela continua diferente do protótipo mesmo com o fluxo certo. O sucesso é a inspeção no frame 390×844, em claro e em noturno, não achar diferença visual de elemento, espaçamento ou borda da tela.

## 3. Objetivo e resultado observável

Esta tela fica visualmente igual aos prints nomeados, elemento a elemento, e o fundo encosta no topo e na base da tela.

## 4. Usuários e permissões

| Persona/papel | O que pode fazer | Restrições |
| --- | --- | --- |
| Jean Lucas, sessão mocada | Ver esta tela como no print e cumprir o fluxo já definido em `nova-viagem` | Não ganha ação nova |
| Convidado | Só o que `nova-viagem` e `modo-convidado` já permitem | Esta fatia não libera permissão |
| Dono, Viajante supremo, Viajante experiente, Assistente júnior | O que `nova-viagem` já permite nesta tela | Papel que a tela não menciona não ganha permissão nova |

## 5. Escopo

### 5.1 Dentro do escopo

- Os passos de nova viagem, da escolha do destino até a geração.
- Comparar e corrigir espaçamento, alinhamento, ordem dos blocos, tamanho, raio e cor até coincidir com cada print desta fatia, em claro e em noturno.
- A tela ocupa 100% da altura física: sem faixa em cima e sem faixa embaixo.
- Flutter em `mayahtrip-app`, com os dados mocados do protótipo.
- Medidas de referência em `.docs/DESIGN.md` (frame 390×844, margem, ritmo e componentes). Onde o print desta tela for mais específico, vale o print.

### 5.2 Fora de escopo

- As outras fatias desta fila: `layout-abertura`, `layout-sign-in`, `layout-sign-up`, `layout-confirm-account`, `layout-forgot-password`, `layout-reset-password`, `layout-modo-convidado`, `layout-inicio`, `layout-notificacoes`, `layout-busca`, `layout-pagina-do-lugar`, `layout-explorar`, `layout-comentarios-curtidas`, `layout-inserir-no-roteiro`, `layout-avaliar-parada`, `layout-acoes-rapidas`, `layout-carteira`, `layout-viagem-capa`, `layout-roteiro-lista`, `layout-roteiro-mapa`, `layout-detalhe-da-parada`, `layout-adicionar-parada`, `layout-gastos`, `layout-novo-gasto`, `layout-mala`, `layout-lista-de-compras`, `layout-documentos-links`, `layout-compartilhar-viagem`, `layout-maya`, `layout-perfil`, `layout-minhas-publicacoes`, `layout-minhas-midias`, `layout-mencoes`, `layout-seguidores`, `layout-perfil-publico`, `layout-privacidade-bloqueios`, `layout-onde-ja-estive`, `layout-aparencia`, `layout-editar-perfil`, `layout-idioma-moeda`.
- Mudar o fluxo, o texto de regra ou a permissão da spec `nova-viagem`. Esta fatia só muda a aparência.
- API real, painel, site de planos e cobrança em loja.
- O painel lateral do HTML do protótipo.
- Estado que nenhum print desta fatia mostra. Não inventar essa tela.
- Item marcado `A DEFINIR` que o print não desenha.

## 6. Comportamento esperado

Recorte visual: Os passos de nova viagem, da escolha do destino até a geração.

O comportamento (o que o toque faz, vazio de regra, erro de regra e permissão) permanece o da spec `nova-viagem`. Aqui a regra é a forma.


Esta tela usa a tela cheia decidida em `layout-abertura`. O fundo encosta no topo e na base. O conteúdo e o cromado ficam onde o print os coloca em relação a essas bordas.

Prints desta fatia, cada um em claro e em noturno:

- `14-nova-viagem-1-destino.png` em `.docs/prototype/screens/claro/` e o mesmo arquivo em `noturno/`.
- `14-nova-viagem-1-destino-escolhido.png` em `.docs/prototype/screens/claro/` e o mesmo arquivo em `noturno/`.
- `14-nova-viagem-1-busca.png` em `.docs/prototype/screens/claro/` e o mesmo arquivo em `noturno/`.
- `14-nova-viagem-2-datas.png` em `.docs/prototype/screens/claro/` e o mesmo arquivo em `noturno/`.
- `14-nova-viagem-2-sem-data.png` em `.docs/prototype/screens/claro/` e o mesmo arquivo em `noturno/`.
- `14-nova-viagem-3-quem-vai.png` em `.docs/prototype/screens/claro/` e o mesmo arquivo em `noturno/`.
- `14-nova-viagem-4-como-comecar.png` em `.docs/prototype/screens/claro/` e o mesmo arquivo em `noturno/`.
- `14-nova-viagem-4-como-comecar-parte2.png` em `.docs/prototype/screens/claro/` e o mesmo arquivo em `noturno/`.
- `14-nova-viagem-4-comunidade.png` em `.docs/prototype/screens/claro/` e o mesmo arquivo em `noturno/`.
- `14-nova-viagem-4-mais-de-14-dias.png` em `.docs/prototype/screens/claro/` e o mesmo arquivo em `noturno/`.
- `14-nova-viagem-gerando.png` em `.docs/prototype/screens/claro/` e o mesmo arquivo em `noturno/`.

Um sufixo `-parteN` é a mesma tela rolada, não outra feature. A rolagem até esse trecho mostra o mesmo enquadramento do print.

Conferência, elemento a elemento, em cada print:

- presença e ordem dos blocos;
- margem lateral, espaço entre blocos e respiro até a status bar e até a base;
- alinhamento de texto, imagem, botão e ícone;
- tamanho, raio, divisória e cor já definidos no print e em `DESIGN.md`.

Diferença de qualquer item acima reprova a fatia. Tema noturno usa o print em `noturno/`, não uma inversão inventada.

## 7. Critérios de aceite

- [ ] **AC-1** — Dado esta tela aberta num aparelho com status bar e indicador de início, quando ela aparece, então o fundo encosta no topo e na base físicos, sem faixa da cor do sistema; verificado por inspeção no aparelho — não feito nesta entrega.
- [x] **AC-2** — Dado o frame 390×844, quando esta tela é comparada ao print, então não há elemento a mais, elemento faltando ou bloco fora da ordem do print; verificado por inspeção lado a lado (só passo 1, ver D-3).
- [x] **AC-3** — Dado o frame 390×844 em claro e em noturno, quando a tela está no estado de `14-nova-viagem-1-destino.png`, então espaçamento, alinhamento, ordem, tamanho, raio e cor de cada elemento visível coincidem com esse print; verificado por inspeção lado a lado com `.docs/prototype/screens/claro/14-nova-viagem-1-destino.png` e `noturno/14-nova-viagem-1-destino.png`.
- [ ] **AC-4** — Dado o frame 390×844 em claro e em noturno, quando a tela está no estado de `14-nova-viagem-1-destino-escolhido.png`, então espaçamento, alinhamento, ordem, tamanho, raio e cor de cada elemento visível coincidem com esse print; verificado por inspeção lado a lado com `.docs/prototype/screens/claro/14-nova-viagem-1-destino-escolhido.png` e `noturno/14-nova-viagem-1-destino-escolhido.png` — não verificado nesta entrega.
- [ ] **AC-5** — Dado o frame 390×844 em claro e em noturno, quando a tela está no estado de `14-nova-viagem-1-busca.png`, então espaçamento, alinhamento, ordem, tamanho, raio e cor de cada elemento visível coincidem com esse print; verificado por inspeção lado a lado com `.docs/prototype/screens/claro/14-nova-viagem-1-busca.png` e `noturno/14-nova-viagem-1-busca.png` — não verificado nesta entrega.
- [ ] **AC-6** — Dado o frame 390×844 em claro e em noturno, quando a tela está no estado de `14-nova-viagem-2-datas.png`, então espaçamento, alinhamento, ordem, tamanho, raio e cor de cada elemento visível coincidem com esse print; verificado por inspeção lado a lado com `.docs/prototype/screens/claro/14-nova-viagem-2-datas.png` e `noturno/14-nova-viagem-2-datas.png` — não verificado nesta entrega.
- [ ] **AC-7** — Dado o frame 390×844 em claro e em noturno, quando a tela está no estado de `14-nova-viagem-2-sem-data.png`, então espaçamento, alinhamento, ordem, tamanho, raio e cor de cada elemento visível coincidem com esse print; verificado por inspeção lado a lado com `.docs/prototype/screens/claro/14-nova-viagem-2-sem-data.png` e `noturno/14-nova-viagem-2-sem-data.png` — não verificado nesta entrega.
- [ ] **AC-8** — Dado o frame 390×844 em claro e em noturno, quando a tela está no estado de `14-nova-viagem-3-quem-vai.png`, então espaçamento, alinhamento, ordem, tamanho, raio e cor de cada elemento visível coincidem com esse print; verificado por inspeção lado a lado com `.docs/prototype/screens/claro/14-nova-viagem-3-quem-vai.png` e `noturno/14-nova-viagem-3-quem-vai.png` — não verificado nesta entrega.
- [ ] **AC-9** — Dado o frame 390×844 em claro e em noturno, quando a tela está no estado de `14-nova-viagem-4-como-comecar.png`, então espaçamento, alinhamento, ordem, tamanho, raio e cor de cada elemento visível coincidem com esse print; verificado por inspeção lado a lado com `.docs/prototype/screens/claro/14-nova-viagem-4-como-comecar.png` e `noturno/14-nova-viagem-4-como-comecar.png` — não verificado nesta entrega.
- [ ] **AC-10** — Dado o frame 390×844 em claro e em noturno, quando a tela está no estado de `14-nova-viagem-4-como-comecar-parte2.png`, então espaçamento, alinhamento, ordem, tamanho, raio e cor de cada elemento visível coincidem com esse print; verificado por inspeção lado a lado com `.docs/prototype/screens/claro/14-nova-viagem-4-como-comecar-parte2.png` e `noturno/14-nova-viagem-4-como-comecar-parte2.png` — não verificado nesta entrega.
- [ ] **AC-11** — Dado o frame 390×844 em claro e em noturno, quando a tela está no estado de `14-nova-viagem-4-comunidade.png`, então espaçamento, alinhamento, ordem, tamanho, raio e cor de cada elemento visível coincidem com esse print; verificado por inspeção lado a lado com `.docs/prototype/screens/claro/14-nova-viagem-4-comunidade.png` e `noturno/14-nova-viagem-4-comunidade.png` — não verificado nesta entrega.
- [ ] **AC-12** — Dado o frame 390×844 em claro e em noturno, quando a tela está no estado de `14-nova-viagem-4-mais-de-14-dias.png`, então espaçamento, alinhamento, ordem, tamanho, raio e cor de cada elemento visível coincidem com esse print; verificado por inspeção lado a lado com `.docs/prototype/screens/claro/14-nova-viagem-4-mais-de-14-dias.png` e `noturno/14-nova-viagem-4-mais-de-14-dias.png` — não verificado nesta entrega.
- [ ] **AC-13** — Dado o frame 390×844 em claro e em noturno, quando a tela está no estado de `14-nova-viagem-gerando.png`, então espaçamento, alinhamento, ordem, tamanho, raio e cor de cada elemento visível coincidem com esse print; verificado por inspeção lado a lado com `.docs/prototype/screens/claro/14-nova-viagem-gerando.png` e `noturno/14-nova-viagem-gerando.png` — não verificado nesta entrega.
- [x] **AC-14** — Dado o fluxo já definido na spec `nova-viagem`, quando a pessoa usa esta tela, então as ações continuam as dessa spec; verificado por percorrer o fluxo sem exigir passo novo (19 testes automatizados continuam passando, incluindo os de offline/SQLite).

## 8. Premissas e decisões

| ID | Tipo | Descrição | Dono | Validação |
| --- | --- | --- | --- | --- |
| P-1 | premissa | O gabarito é o print 390×844 em claro e em noturno, mais o protótipo que gerou esse print. A spec `nova-viagem` continua dona do fluxo. Dependência desta fatia: `layout-abertura`. | produto | `.docs/prototype/screens/README.md` e a spec `nova-viagem` |

| D-1 | decisão | Vale a decisão D-1 de `layout-abertura`: esta tela também encosta no topo e na base físicos, sem faixa de sistema. Não se redefine a regra aqui. | produto | Inspeção desta tela contra o print, no frame 390×844 e no aparelho |
| D-2 | decisão | Vale a decisão D-2 de `layout-abertura`: só aparência. Fluxo permanece na spec de comportamento. | produto | Conferência com a spec de comportamento |
| D-3 | correção (ampla) | `CidadePopular` (passo 1) não tinha campo de foto — todo cartão renderizava como retângulo roxo sólido sem imagem, e o 1º cartão (Roma) tinha o mesmo tamanho dos demais. O print mostra foto real em cada cidade com asset minerado (Roma/Londres/Paris/Lisboa) e o 1º cartão em destaque, largura cheia; cidades sem foto minerada (ex. Barcelona) mostram cor sólida no print, então esse fallback foi preservado. Adicionado `fotoAsset` a `CidadePopular`, plumbing de imagem com gradiente de legibilidade em `_CartaoCidade`, e separação do 1º cartão num cartão "grande" fora da grade 2 colunas. | app | print `noturno/14-nova-viagem-1-destino.png` |
| D-4 | divergência, não corrigida | Só os 4 primeiros destinos de `cidadesPopulares` (Roma, Londres, Paris, Lisboa) têm foto real minerada em `assets/photos/`; os outros 9 (Barcelona, Florença, Nova York, Rio de Janeiro, Buenos Aires, Porto, Amsterdã, Tóquio, Cidade do México) continuam com o fallback de cor sólida, que é o mesmo comportamento do protótipo para a cidade sem foto visível no print (Barcelona), mas não há como confirmar se as outras 8 também usam fallback no protótipo real pois não aparecem nos prints minerados. Não inventada foto nova. | produto/app | prints `14-nova-viagem-1-destino*.png` |

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
| O ajuste visual muda um toque ou esconde um controle | média | alto | AC do fluxo: a spec `nova-viagem` continua valendo. Se um controle sumir, a fatia não está pronta. |
| Corrigir a tela cheia nesta tela reabre faixa nas outras | média | médio | A regra mora em `layout-abertura`. Cada fatia prova só a própria tela. |

- Rollback: reverter a apresentação desta tela para a revisão anterior do app, sem mexer na spec `nova-viagem`.
- Critério para abortar: o print e a spec `nova-viagem` exigem dois layouts incompatíveis no mesmo estado e ninguém escolheu qual vale. Aí a pergunta deixa de ser só registro e a implementação desta fatia para.

## 12. Perguntas em aberto

| Pergunta | Bloqueante? | Dono | Prazo |
| --- | --- | --- | --- |
| Se um detalhe do print divergir do texto de `BUSINESS/14-nova-viagem.md` só na aparência, o print vence, pela decisão D-2. Algum detalhe dessa tela deve ser exceção? | não | produto | antes do `refine-spec` |

## 13. Resultado

A tela fica igual aos prints desta fatia, em claro e em noturno, e o fundo encosta no topo e na base, sem mudar o fluxo da spec `nova-viagem`.

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
