# Onde já estive

- Slug: `onde-ja-estive`
- Status: `rascunho`
- Data: 2026-11-16
- Última atualização: 2026-11-16
- Responsável: produto
- Repositório: `mayahtrip-app`
- Docs relacionados: `.docs/BUSINESS/32-onde-ja-estive.md`, `.docs/BUSINESS/BUSINESS.md`, `.docs/DESIGN.md`, `.docs/prototype`
- Specs relacionadas: `perfil`
- ADRs relacionados: nenhum

## 1. Contexto

Fato: o protótipo em `.docs/prototype` (16 nov 2026, frame 390×844) e `32-onde-ja-estive.md` já descrevem esta feature. O app Flutter em `mayahtrip-app` ainda não tem essa tela.

Quem sente: quem for usar o app e quem for comparar a tela com o protótipo. Sem esta fatia, o comportamento existe só no HTML.

Premissa, não fato: os dados continuam mocados, iguais aos do protótipo. Não há API nesta fila.

## 2. Necessidade de negócio

O app público precisa desta tela idêntica ao protótipo antes de qualquer outra entrega da mesma área. O sucesso é a pessoa cumprir o fluxo abaixo e a inspeção no frame 390×844 não achar diferença de layout, espaçamento, alinhamento ou animação.

## 3. Objetivo e resultado observável

Mapa-múndi Equal Earth com world.json e bandeiras circle-flags. Marcar, planejar e os percentuais.

## 4. Usuários e permissões

| Persona/papel | O que pode fazer | Restrições |
| --- | --- | --- |
| Jean Lucas, sessão mocada | Cumprir o fluxo desta fatia como no protótipo | Dados fixos do protótipo |
| Convidado | Só o que `modo-convidado` libera | Fora desta spec, exceto na própria spec `modo-convidado` |
| Dono, Viajante supremo, Viajante experiente, Assistente júnior | O que `32-onde-ja-estive.md` e BUSINESS.md §4.3 permitem nesta tela | Papel que a tela não menciona não ganha permissão nova |

## 5. Escopo

### 5.1 Dentro do escopo

- Mapa-múndi Equal Earth com world.json e bandeiras circle-flags. Marcar, planejar e os percentuais.
- Flutter em `mayahtrip-app`, com os dados mocados do protótipo.
- Reutilizar tokens, fontes e movimento definidos na spec `abertura`, sem redefini-los.

### 5.2 Fora de escopo

- As outras fatias: `abertura`, `sign-in`, `sign-up`, `confirm-account`, `forgot-password`, `reset-password`, `inicio`, `notificacoes`, `busca`, `pagina-do-lugar`, `explorar`, `comentarios-curtidas`, `inserir-no-roteiro`, `avaliar-parada`, `acoes-rapidas`, `nova-viagem`, `carteira`, `viagem-capa`, `roteiro-lista`, `roteiro-mapa`, `detalhe-da-parada`, `adicionar-parada`, `gastos`, `novo-gasto`, `mala`, `lista-de-compras`, `documentos-links`, `compartilhar-viagem`, `maya`, `perfil`, `minhas-publicacoes`, `minhas-midias`, `mencoes`, `seguidores`, `perfil-publico`, `privacidade-bloqueios`, `aparencia`, `editar-perfil`, `idioma-moeda`, `modo-convidado`.
- API real, painel, site de planos e cobrança em loja.
- Item marcado `A DEFINIR` que o protótipo não desenha. Não inventar a regra.
- O painel lateral do HTML do protótipo.

## 6. Comportamento esperado

Recorte: Mapa-múndi Equal Earth com world.json e bandeiras circle-flags. Marcar, planejar e os percentuais.

O texto abaixo é a regra desta fatia. Medida, tempo e cor citados são critério visual. Menção a uma tela de outra spec é só navegação: o destino pertence à spec daquele slug.

## Objetivo
Mostrar os países já visitados e os planejados, com percentuais do mundo e por continente.

## Acesso
Perfil → indicadores Continentes/Países/Cidades, mini mapa, Configurações → Lugares onde já estive.

## Layout
1. Topo: voltar · “Onde já estive” · botão “+” → marcar país.
2. Kicker roxo “SEU MAPA”; percentual em editorial **64 px** + “do mundo” (28 px `#5E5A73`); linha 13 px “N de 195 países visitados · com as próximas viagens, X%”.
3. **Mapa-múndi** (projeção Equal Earth, raio 26 px, fundo `#EEF0F7`):
   - Visitado `#2B207F` · Planejado `#C9FF27` com contorno `#9ACC1F` · Demais `#DAD7E3`; contornos brancos.
   - Arrastar move; roda do mouse/pinça e botões ( + / − / globo para centralizar ) aproximam de 1× a 6× (passo 1,5×, 350 ms).
   - Toque num país → folha do país.
4. Legenda: “● Já visitei · N” e “● Vou visitar · N” + “Toque num país”.
5. **Por continente** (cartão): para cada continente, “**v** de total · %” + selo lima “+N planejado(s)”; barra 10 px com visitados (roxo) e planejados (lima). Ordenados por (visitados + planejados).
   | Continente | Total de países |
   | --- | --- |
   | Europa | 44 |
   | Ásia (inclui Rússia e Turquia) | 48 |
   | África | 54 |
   | América do Norte | 23 |
   | América do Sul | 12 |
   | Oceania | 14 |
6. **Já visitei** (lista): **bandeira circular 42 px** com selo roxo ✓ · nome do país · “{continente} · {origens}” · seta.
7. **Próximos destinos** — mesma lista com selo lima de calendário.
8. Botão **+ Marcar país onde já estive**.

## Folha do país
- Bandeira 56 px · nome · continente.
- Caixa de status: “Você já esteve aqui” (fundo `#EBE8FF`, ícone ✓ em roxo) / “Está nas suas próximas viagens” (fundo `#F1FFD1`, ícone calendário lima) / “Ainda não visitado” — com as origens (ex.: “Paris · mai 2026”, “Marcado por você”).
- Ação: **✓ Já estive aqui** (marca manualmente) · **Remover dos visitados** (só se foi marcado manualmente) · se veio de viagem: “Vem de uma viagem passada. Para remover, edite a viagem.”
- **+ Planejar viagem para cá** → assistente.

## Folha “Marcar países”
Busca + lista alfabética, no idioma da interface ativo (`pt-BR`, `pt-PT`, `en` ou `es`), de todos os países: bandeira 32 px · nome · continente · caixa de seleção. Países que vêm de viagem não podem ser desmarcados (aviso “Já vem de uma viagem sua”).

## Regras de cálculo
1. **Visitado** = país de viagem com data já passada **ou** marcado manualmente.
2. **Planejado** = país de viagem futura que ainda não foi visitado.
3. Percentual do mundo = visitados ÷ **195** (mínimo exibido 1%). Com planejados = (visitados + planejados) ÷ 195.
4. Bandeiras: biblioteca **circle-flags** (licença MIT), formato circular.

Estados desta fatia:

- Vazio: o que `32-onde-ja-estive.md` descreve como vazio. Se o arquivo não descreve vazio, a tela não inventa empty state.
- Erro: só a mensagem que o arquivo escreve. Mensagem marcada `A DEFINIR` não é criada.
- Permissão: papéis de BUSINESS.md §4.3 quando a tela cita papel.
- Limite: o número que o arquivo fixa (tentativas, caracteres, dias, itens). O que está `A DEFINIR` não vira limite.

## 7. Critérios de aceite

- [ ] **AC-1** — Dado países de viagens passadas e marcas manuais, quando a tela abre, então visitados ÷ 195 aparecem em editorial de 64 px, com mínimo exibido de 1%; verificado por teste de widget.
- [ ] **AC-2** — Dado o mapa, quando a pessoa aproxima, então o zoom vai de 1× a 6× em passos de 1,5× e 350 ms, e arrastar move o mapa; verificado por teste de widget.
- [ ] **AC-3** — Dado um país que veio de viagem passada, quando a pessoa tenta desmarcar na lista, então o aviso diz “Já vem de uma viagem sua” e a marca permanece; verificado por teste de widget.
- [ ] **AC-4** — Dado um país marcado só à mão, quando a pessoa remove dos visitados, então ele deixa de contar como visitado; verificado por teste de widget.
- [ ] **AC-5** — Dado a lista de países, quando o idioma da interface muda, então os nomes seguem pt-BR, pt-PT, en ou es; verificado por teste de widget.
- [ ] **AC-6** — Dado o frame 390×844 e os dados mocados do protótipo, quando esta tela está visível, então alinhamento, espaçamento, tipografia e cor coincidem com `.docs/prototype` e com `32-onde-ja-estive.md`; verificado por inspeção lado a lado.
- [ ] **AC-7** — Dado reduzir movimento ativo no aparelho, quando esta tela anima, então as durações caem para cerca de 0 ms; verificado por inspeção.

## 8. Premissas e decisões

| ID | Tipo | Descrição | Dono | Validação |
| --- | --- | --- | --- | --- |
| D-1 | decisão | O protótipo e `32-onde-ja-estive.md` mandam no visual e no movimento. Dado divergente, a inspeção para e a diferença fica registrada antes de implementar. | produto | inspeção lado a lado |
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
| Nenhuma nesta fatia. | não | — | — |

Nenhuma pergunta acima bloqueia esta spec. A tela mocada copia o que o protótipo já mostra e deixa de fora o que o protótipo não desenha.

## 13. Resultado

A fatia `onde-ja-estive` está pronta quando todos os AC passam no frame 390×844 com os dados mocados do protótipo.

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

- `perfil` em `030-perfil.md`
