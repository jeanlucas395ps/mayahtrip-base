# Layout da abertura

- Slug: `layout-abertura`
- Status: `em execução` — inspecionada em 2026-11-18 (`mayahtrip-app`, build web 390×844 comparado lado a lado com os prints); AC-1 (aparelho físico) não verificado nesta entrega
- Data: 2026-11-18
- Última atualização: 2026-11-18
- Responsável: produto
- Repositório: `mayahtrip-app`
- Docs relacionados: `.docs/BUSINESS/00-abertura.md`, `.docs/BUSINESS/BUSINESS.md`, `.docs/DESIGN.md`, `.docs/prototype`, `.docs/prototype/screens/README.md`
- Specs relacionadas: `abertura`, `layout-abertura`
- ADRs relacionados: nenhum

## 1. Contexto

Fato: o app Flutter já tem esta área, e a spec `abertura` descreve o comportamento. Os prints em `.docs/prototype/screens/` (16 nov 2026, 390×844 pt, densidade 2x) e o protótipo em `.docs/prototype` são o gabarito visual. Hoje o layout falha nesta tela: espaçamento, alinhamento e organização não batem com o print. O app também não ocupa 100% da altura, e sobra faixa em cima e embaixo.

Quem sente: quem abre esta tela no aparelho e quem compara o app com o print.

Premissa, não fato: os dados continuam os mocados do protótipo. Esta fatia não liga API.

## 2. Necessidade de negócio

A abertura, com a marca e a entrada no app. Sem o ajuste, a tela continua diferente do protótipo mesmo com o fluxo certo. O sucesso é a inspeção no frame 390×844, em claro e em noturno, não achar diferença visual de elemento, espaçamento ou borda da tela.

## 3. Objetivo e resultado observável

Esta tela fica visualmente igual aos prints nomeados, elemento a elemento, e o fundo encosta no topo e na base da tela.

## 4. Usuários e permissões

| Persona/papel | O que pode fazer | Restrições |
| --- | --- | --- |
| Jean Lucas, sessão mocada | Ver esta tela como no print e cumprir o fluxo já definido em `abertura` | Não ganha ação nova |
| Convidado | Só o que `abertura` e `modo-convidado` já permitem | Esta fatia não libera permissão |
| Dono, Viajante supremo, Viajante experiente, Assistente júnior | O que `abertura` já permite nesta tela | Papel que a tela não menciona não ganha permissão nova |

## 5. Escopo

### 5.1 Dentro do escopo

- A abertura, com a marca e a entrada no app.
- Comparar e corrigir espaçamento, alinhamento, ordem dos blocos, tamanho, raio e cor até coincidir com cada print desta fatia, em claro e em noturno.
- A tela ocupa 100% da altura física: sem faixa em cima e sem faixa embaixo.
- Flutter em `mayahtrip-app`, com os dados mocados do protótipo.
- Medidas de referência em `.docs/DESIGN.md` (frame 390×844, margem, ritmo e componentes). Onde o print desta tela for mais específico, vale o print.

### 5.2 Fora de escopo

- As outras fatias desta fila: `layout-sign-in`, `layout-sign-up`, `layout-confirm-account`, `layout-forgot-password`, `layout-reset-password`, `layout-modo-convidado`, `layout-inicio`, `layout-notificacoes`, `layout-busca`, `layout-pagina-do-lugar`, `layout-explorar`, `layout-comentarios-curtidas`, `layout-inserir-no-roteiro`, `layout-avaliar-parada`, `layout-acoes-rapidas`, `layout-nova-viagem`, `layout-carteira`, `layout-viagem-capa`, `layout-roteiro-lista`, `layout-roteiro-mapa`, `layout-detalhe-da-parada`, `layout-adicionar-parada`, `layout-gastos`, `layout-novo-gasto`, `layout-mala`, `layout-lista-de-compras`, `layout-documentos-links`, `layout-compartilhar-viagem`, `layout-maya`, `layout-perfil`, `layout-minhas-publicacoes`, `layout-minhas-midias`, `layout-mencoes`, `layout-seguidores`, `layout-perfil-publico`, `layout-privacidade-bloqueios`, `layout-onde-ja-estive`, `layout-aparencia`, `layout-editar-perfil`, `layout-idioma-moeda`.
- Mudar o fluxo, o texto de regra ou a permissão da spec `abertura`. Esta fatia só muda a aparência.
- API real, painel, site de planos e cobrança em loja.
- O painel lateral do HTML do protótipo.
- Estado que nenhum print desta fatia mostra. Não inventar essa tela.
- Item marcado `A DEFINIR` que o print não desenha.

## 6. Comportamento esperado

Recorte visual: A abertura, com a marca e a entrada no app.

O comportamento (o que o toque faz, vazio de regra, erro de regra e permissão) permanece o da spec `abertura`. Aqui a regra é a forma.


A abertura é a primeira tela e carrega a regra de tela cheia para o resto da fila. As specs seguintes não redesenham essa regra. Cada uma só prova que a própria tela a cumpre.

No frame 390×844 e no aparelho:
- o fundo chega na borda física de cima e na de baixo;
- não sobra uma faixa vazia da cor do sistema;
- texto, botão e marca ficam na mesma relação com as bordas que em `00-abertura.png`, em claro e em noturno.

Prints desta fatia, cada um em claro e em noturno:

- `00-abertura.png` em `.docs/prototype/screens/claro/` e o mesmo arquivo em `noturno/`.

Um sufixo `-parteN` é a mesma tela rolada, não outra feature. A rolagem até esse trecho mostra o mesmo enquadramento do print.

Conferência, elemento a elemento, em cada print:

- presença e ordem dos blocos;
- margem lateral, espaço entre blocos e respiro até a status bar e até a base;
- alinhamento de texto, imagem, botão e ícone;
- tamanho, raio, divisória e cor já definidos no print e em `DESIGN.md`.

Diferença de qualquer item acima reprova a fatia. Tema noturno usa o print em `noturno/`, não uma inversão inventada.

## 7. Critérios de aceite

- [ ] **AC-1** — Dado esta tela aberta num aparelho com status bar e indicador de início, quando ela aparece, então o fundo encosta no topo e na base físicos, sem faixa da cor do sistema; verificado por inspeção no aparelho — não feito nesta entrega (D-2).
- [x] **AC-2** — Dado o frame 390×844, quando esta tela é comparada ao print, então não há elemento a mais, elemento faltando ou bloco fora da ordem do print; verificado por inspeção lado a lado com os arquivos listados no comportamento (build web 390×844, `Scaffold` já preenche 100% do frame sem faixa visível).
- [x] **AC-3** — Dado o frame 390×844 em claro e em noturno, quando a tela está no estado de `00-abertura.png`, então espaçamento, alinhamento, ordem, tamanho, raio e cor de cada elemento visível coincidem com esse print; verificado por inspeção lado a lado com `.docs/prototype/screens/claro/00-abertura.png` e `noturno/00-abertura.png` — posição vertical do bloco central (~44-60% da altura) e da barra (~92%) batem; fundo `#120F2A` igual nos dois temas, como no protótipo (a abertura não muda de tema, D-1 de `001-abertura.md`).
- [x] **AC-4** — Dado o fluxo já definido na spec `abertura`, quando a pessoa usa esta tela, então as ações continuam as dessa spec; verificado por percorrer o fluxo sem exigir passo novo (nenhum código mudou nesta fatia).

## 8. Premissas e decisões

| ID | Tipo | Descrição | Dono | Validação |
| --- | --- | --- | --- | --- |
| P-1 | premissa | O gabarito é o print 390×844 em claro e em noturno, mais o protótipo que gerou esse print. A spec `abertura` continua dona do fluxo. Dependência desta fatia: nenhuma. | produto | `.docs/prototype/screens/README.md` e a spec `abertura` |
| D-2 | decisão | Inspeção feita via build Flutter Web (`flutter build web`) num iframe 390×844 (sem escala de densidade), não num aparelho físico iOS/Android. Prova layout, espaçamento e cor; não prova status bar/indicador de início reais nem diferenças de renderização nativa. AC-1 (tela cheia no aparelho físico) fica pendente de inspeção manual num device de verdade. | app | inspeção manual num aparelho, quando disponível |

| D-1 | decisão | O app ocupa 100% da altura física. O fundo da tela, ou a foto que o print faz sangrar, encosta no topo e na base. Não há faixa da cor do sistema acima da status bar nem abaixo do indicador de início. A status bar e o indicador de início ficam por cima do fundo, no lugar em que o print já os mostra. Uma margem extra de "safe area" que o print não tem é falha desta fatia. | produto | Inspeção no frame 390×844 e no aparelho, contra `00-abertura.png` |
| D-2 | decisão | Esta fila só corrige aparência: espaçamento, alinhamento, ordem visual, tamanho, raio, cor e o que ocupa a tela. O que o toque faz continua na spec de comportamento citada. Se o print e essa spec discordarem no visual, vale o print em 390×844. Se discordarem no fluxo, vale a spec de comportamento, e o caso fica como pergunta não bloqueante. | produto | Conferência desta spec com a spec de comportamento e com o print |

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
| O ajuste visual muda um toque ou esconde um controle | média | alto | AC do fluxo: a spec `abertura` continua valendo. Se um controle sumir, a fatia não está pronta. |
| Corrigir a tela cheia nesta tela reabre faixa nas outras | média | médio | A regra mora em `layout-abertura`. Cada fatia prova só a própria tela. |

- Rollback: reverter a apresentação desta tela para a revisão anterior do app, sem mexer na spec `abertura`.
- Critério para abortar: o print e a spec `abertura` exigem dois layouts incompatíveis no mesmo estado e ninguém escolheu qual vale. Aí a pergunta deixa de ser só registro e a implementação desta fatia para.

## 12. Perguntas em aberto

| Pergunta | Bloqueante? | Dono | Prazo |
| --- | --- | --- | --- |
| Se um detalhe do print divergir do texto de `BUSINESS/00-abertura.md` só na aparência, o print vence, pela decisão D-2. Algum detalhe dessa tela deve ser exceção? | não | produto | antes do `refine-spec` |

## 13. Resultado

A tela fica igual aos prints desta fatia, em claro e em noturno, e o fundo encosta no topo e na base, sem mudar o fluxo da spec `abertura`.

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
