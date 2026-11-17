# Inserir lugar no roteiro

- Slug: `inserir-no-roteiro`
- Status: `em execução`
- Data: 2026-11-16
- Última atualização: 2026-11-17
- Responsável: produto
- Repositório: `mayahtrip-app`
- Docs relacionados: `.docs/BUSINESS/11-inserir-no-roteiro.md`, `.docs/BUSINESS/BUSINESS.md`, `.docs/DESIGN.md`, `.docs/prototype`
- Specs relacionadas: `pagina-do-lugar`
- ADRs relacionados: nenhum

## 1. Contexto

Fato: o protótipo em `.docs/prototype` (16 nov 2026, frame 390×844) e `11-inserir-no-roteiro.md` já descrevem esta feature. O app Flutter em `mayahtrip-app` ainda não tem essa tela.

Quem sente: quem for usar o app e quem for comparar a tela com o protótipo. Sem esta fatia, o comportamento existe só no HTML.

Premissa, não fato: os dados continuam mocados, iguais aos do protótipo. Não há API nesta fila.

## 2. Necessidade de negócio

O app público precisa desta tela idêntica ao protótipo antes de qualquer outra entrega da mesma área. O sucesso é a pessoa cumprir o fluxo abaixo e a inspeção no frame 390×844 não achar diferença de layout, espaçamento, alinhamento ou animação.

## 3. Objetivo e resultado observável

Folha que escolhe viagem e dia e acrescenta a parada. O assistente de viagem nova e a tela do roteiro não são redefinidos.

## 4. Usuários e permissões

| Persona/papel | O que pode fazer | Restrições |
| --- | --- | --- |
| Jean Lucas, sessão mocada | Cumprir o fluxo desta fatia como no protótipo | Dados fixos do protótipo |
| Convidado | Só o que `modo-convidado` libera | Fora desta spec, exceto na própria spec `modo-convidado` |
| Dono, Viajante supremo, Viajante experiente, Assistente júnior | O que `11-inserir-no-roteiro.md` e BUSINESS.md §4.3 permitem nesta tela | Papel que a tela não menciona não ganha permissão nova |

## 5. Escopo

### 5.1 Dentro do escopo

- Folha que escolhe viagem e dia e acrescenta a parada. O assistente de viagem nova e a tela do roteiro não são redefinidos.
- Flutter em `mayahtrip-app`, com os dados mocados do protótipo.
- Reutilizar tokens, fontes e movimento definidos na spec `abertura`, sem redefini-los.

### 5.2 Fora de escopo

- As outras fatias: `abertura`, `sign-in`, `sign-up`, `confirm-account`, `forgot-password`, `reset-password`, `inicio`, `notificacoes`, `busca`, `pagina-do-lugar`, `explorar`, `comentarios-curtidas`, `avaliar-parada`, `acoes-rapidas`, `nova-viagem`, `carteira`, `viagem-capa`, `roteiro-lista`, `roteiro-mapa`, `detalhe-da-parada`, `adicionar-parada`, `gastos`, `novo-gasto`, `mala`, `lista-de-compras`, `documentos-links`, `compartilhar-viagem`, `maya`, `perfil`, `minhas-publicacoes`, `minhas-midias`, `mencoes`, `seguidores`, `perfil-publico`, `privacidade-bloqueios`, `onde-ja-estive`, `aparencia`, `editar-perfil`, `idioma-moeda`, `modo-convidado`.
- API real, painel, site de planos e cobrança em loja.
- Item marcado `A DEFINIR` que o protótipo não desenha. Não inventar a regra.
- O painel lateral do HTML do protótipo.

## 6. Comportamento esperado

Recorte: Folha que escolhe viagem e dia e acrescenta a parada. O assistente de viagem nova e a tela do roteiro não são redefinidos.

O texto abaixo é a regra desta fatia. Medida, tempo e cor citados são critério visual. Menção a uma tela de outra spec é só navegação: o destino pertence à spec daquele slug.

## Origem
Botão “+ Roteiro” no feed e “Inserir em um roteiro” na página do lugar.

## Folha
- Cabeçalho “Inserir no roteiro” / subtítulo com o nome do lugar.
- **VIAGEM** (kicker): carrossel de chips de viagem (padding 8/14 px, raio 18 px): miniatura 40 px (raio 12) + nome (13 px/700) + datas (12 px). Selecionada: borda 2 px `#2B207F`, fundo `#F8F7FF`. No fim, chip **+ Nova** (56 px) → assistente de viagem.
- **DIA**: chips de dia (mín. 86 px): “Dia N” + “{data} · {nº de paradas}”. Selecionado: fundo `#15122E`, texto branco.
- **Dica** (fundo `#F1FFD1`, texto `#2C3A00`, ícone faísca em quadrado `#15122E`): 
  - se já existe parada do mesmo bairro no dia: “Fica perto de **{parada}**, que já está neste dia. Encaixamos logo depois.”
  - senão: “Neste dia você passa por {bairro da 1ª parada}. Colocamos no fim da tarde.” (ou “lugares livres” se o dia está vazio).
- Botão **Adicionar ao Dia N** (54 px).

## Regras
1. Viagem pré-selecionada: a primeira cujo destino inclui a cidade do lugar; senão a primeira da lista. Dia pré-selecionado: primeiro dia daquela cidade.
2. A parada entra no **fim do dia**, com horário = última parada + 2 h (máximo 22:00) ou 10:00 se o dia está vazio; deslocamento padrão “~10 min a pé”.
3. A parada nova pisca com halo lima (1,4 s) ao abrir o roteiro.
4. Aviso: “{lugar} no Dia N · {viagem}” + **Ver** (abre a viagem naquele dia).
5. Convidado → convite para criar conta.
6. Papel “Assistente júnior” não pode inserir (só visualiza). Como a viagem aparece para ele nessa lista: `A DEFINIR`.

Estados desta fatia:

- Vazio: o que `11-inserir-no-roteiro.md` descreve como vazio. Se o arquivo não descreve vazio, a tela não inventa empty state.
- Erro: só a mensagem que o arquivo escreve. Mensagem marcada `A DEFINIR` não é criada.
- Permissão: papéis de BUSINESS.md §4.3 quando a tela cita papel.
- Limite: o número que o arquivo fixa (tentativas, caracteres, dias, itens). O que está `A DEFINIR` não vira limite.

## 7. Critérios de aceite

- [x] **AC-1** — Dado um lugar e a carteira mocada, quando a folha abre, então a viagem pré-selecionada é a primeira cujo destino inclui a cidade, senão a primeira da lista, e o dia é o primeiro dessa cidade; verificado por `test/ui/features/inserir_no_roteiro/inserir_no_roteiro_view_model_test.dart` e `inserir_no_roteiro_sheet_test.dart`.
- [x] **AC-2** — Dado um dia com paradas, quando a pessoa confirma, então a parada entra no fim com horário da última + 2 h, no máximo 22:00, ou 10:00 se o dia está vazio; verificado pelos mesmos testes. "Deslocamento ~10 min a pé" não é renderizado nesta fila: o modelo `ParadaRoteiro` desta spec só guarda `lugarId`/`horario` (o resto do roteiro, incluindo deslocamento entre paradas, é de `roteiro-lista`/`roteiro-mapa`, fora de escopo) — pendência registrada, não `A DEFINIR` inventado.
- [x] **AC-3** — Dado a parada inserida, então o aviso "{lugar} no Dia N · {viagem}" oferece Ver; verificado por `inserir_no_roteiro_sheet_test.dart`. O halo lima de 1,4 s ao abrir o roteiro não é verificável nesta fila — a tela de roteiro (`roteiro-lista`) ainda não existe; "Ver" abre um `DestinoPlaceholder` rotulado.
- [x] **AC-4** — Dado o papel Assistente júnior, quando a lista de viagens é montada para inserir, então essa viagem não oferece a ação de inserir; verificado por `inserir_no_roteiro_view_model_test.dart`/`inserir_no_roteiro_sheet_test.dart` (botão "Adicionar ao Dia N" desabilitado).
- [x] **AC-5** — Dado o frame 390×844 e os dados mocados do protótipo, quando esta tela está visível, então alinhamento, espaçamento, tipografia e cor coincidem com `.docs/prototype` e com `11-inserir-no-roteiro.md`; verificado por mineração de `S.trips[].days[].acts[]` do protótipo (sintra/londres/parislx/roma) e teste de widget em viewport 390 px. Inspeção visual lado a lado via app real não concluída nesta sessão.
- [ ] **AC-6** — Dado reduzir movimento ativo no aparelho, quando esta tela anima, então as durações caem para cerca de 0 ms; **pendente**, mesmo gap das specs anteriores.

## 8. Premissas e decisões

| ID | Tipo | Descrição | Dono | Validação |
| --- | --- | --- | --- | --- |
| D-1 | decisão | O protótipo e `11-inserir-no-roteiro.md` mandam no visual e no movimento. Dado divergente, a inspeção para e a diferença fica registrada antes de implementar. | produto | inspeção lado a lado |
| D-2 | decisão | Dados mocados, código de verificação `1234`, usuário Jean Lucas quando a tela pede alguém logado. | produto | comparar com o protótipo |
| D-3 | decisão | `A DEFINIR` não é implementado como regra nova. | produto | revisão da spec |
| P-1 | premissa | A fundação visual da spec `abertura` já existe quando esta fatia for implementada, salvo na própria abertura. | app | a spec `abertura` concluída |
| D-4 | decisão (engenharia) | `Viagem` ganhou `dias`/`paradas` mínimos (`DiaRoteiro`/`ParadaRoteiro`: cidade, data, lugarId, horário) só para esta spec funcionar — não modela o roteiro inteiro (deslocamento, "done", mapa), que pertence a `roteiro-lista`/`roteiro-mapa`. | app | `lib/data/models/viagem.dart` |

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
| 6. Papel “Assistente júnior” não pode inserir (só visualiza). Como a viagem aparece para ele nessa lista: `A DEFINIR`. | não | produto | antes do refine-spec |

Nenhuma pergunta acima bloqueia esta spec. A tela mocada copia o que o protótipo já mostra e deixa de fora o que o protótipo não desenha.

## 13. Resultado

A fatia `inserir-no-roteiro` está pronta quando todos os AC passam no frame 390×844 com os dados mocados do protótipo.

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

- `pagina-do-lugar` em `010-pagina-do-lugar.md`
