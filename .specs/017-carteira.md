# Carteira de viagens

- Slug: `carteira`
- Status: `em execução`
- Data: 2026-11-16
- Última atualização: 2026-11-17
- Responsável: produto
- Repositório: `mayahtrip-app`
- Docs relacionados: `.docs/BUSINESS/15-carteira-de-viagens.md`, `.docs/BUSINESS/BUSINESS.md`, `.docs/DESIGN.md`, `.docs/prototype`
- Specs relacionadas: `inicio`
- ADRs relacionados: nenhum

## 1. Contexto

Fato: o protótipo em `.docs/prototype` (16 nov 2026, frame 390×844) e `15-carteira-de-viagens.md` já descrevem esta feature. O app Flutter em `mayahtrip-app` ainda não tem essa tela.

Quem sente: quem for usar o app e quem for comparar a tela com o protótipo. Sem esta fatia, o comportamento existe só no HTML.

Premissa, não fato: os dados continuam mocados, iguais aos do protótipo. Não há API nesta fila.

## 2. Necessidade de negócio

O app público precisa desta tela idêntica ao protótipo antes de qualquer outra entrega da mesma área. O sucesso é a pessoa cumprir o fluxo abaixo e a inspeção no frame 390×844 não achar diferença de layout, espaçamento, alinhamento ou animação.

## 3. Objetivo e resultado observável

Lista, filtros, cartão e a animação de entrada. A capa da viagem é outra spec.

## 4. Usuários e permissões

| Persona/papel | O que pode fazer | Restrições |
| --- | --- | --- |
| Jean Lucas, sessão mocada | Cumprir o fluxo desta fatia como no protótipo | Dados fixos do protótipo |
| Convidado | Só o que `modo-convidado` libera | Fora desta spec, exceto na própria spec `modo-convidado` |
| Dono, Viajante supremo, Viajante experiente, Assistente júnior | O que `15-carteira-de-viagens.md` e BUSINESS.md §4.3 permitem nesta tela | Papel que a tela não menciona não ganha permissão nova |

## 5. Escopo

### 5.1 Dentro do escopo

- Lista, filtros, cartão e a animação de entrada. A capa da viagem é outra spec.
- Flutter em `mayahtrip-app`, com os dados mocados do protótipo.
- Reutilizar tokens, fontes e movimento definidos na spec `abertura`, sem redefini-los.

### 5.2 Fora de escopo

- As outras fatias: `abertura`, `sign-in`, `sign-up`, `confirm-account`, `forgot-password`, `reset-password`, `inicio`, `notificacoes`, `busca`, `pagina-do-lugar`, `explorar`, `comentarios-curtidas`, `inserir-no-roteiro`, `avaliar-parada`, `acoes-rapidas`, `nova-viagem`, `viagem-capa`, `roteiro-lista`, `roteiro-mapa`, `detalhe-da-parada`, `adicionar-parada`, `gastos`, `novo-gasto`, `mala`, `lista-de-compras`, `documentos-links`, `compartilhar-viagem`, `maya`, `perfil`, `minhas-publicacoes`, `minhas-midias`, `mencoes`, `seguidores`, `perfil-publico`, `privacidade-bloqueios`, `onde-ja-estive`, `aparencia`, `editar-perfil`, `idioma-moeda`, `modo-convidado`.
- API real, painel, site de planos e cobrança em loja.
- Item marcado `A DEFINIR` que o protótipo não desenha. Não inventar a regra.
- O painel lateral do HTML do protótipo.

## 6. Comportamento esperado

Recorte: Lista, filtros, cartão e a animação de entrada. A capa da viagem é outra spec.

O texto abaixo é a regra desta fatia. Medida, tempo e cor citados são critério visual. Menção a uma tela de outra spec é só navegação: o destino pertence à spec daquele slug.

## Objetivo
Listar todas as viagens do usuário, com filtros por momento e status visível em cada cartão.

## Animação de entrada (toda vez que se toca na aba Carteira)
1. Fundo da tela; uma **carteira** 260 × 180 px surge (escala 0,7 + 20 px → normal, mola, 550 ms):
   - Fundo traseiro `#1E1760`, raio 32 px, 160 px de altura.
   - Até **3 cartões de viagem** (204 × 124 px, raio 18 px, foto + nome editorial 24 px + datas), empilhados 6 px um do outro.
   - Frente `#2B207F` (116 px, raio 30 px) com costura tracejada branca 22%, kicker lima “CARTEIRA” e “{N} viagens” (editorial 22 px); fecho lima 70 × 46 px na lateral direita com botão `#15122E`.
2. Aos **520 ms**, os cartões sobem para fora da carteira (78 px + 30 px por cartão) em leque (±5°), 70 ms entre eles.
3. Aos **1250 ms**, a carteira some (escala 0,85) e cada cartão voa e se transforma no cartão real da lista (posição, tamanho, raio 24 px), 700 ms, 60 ms entre eles.
4. Aos **2050 ms** a lista aparece (350 ms) e a sobreposição some; removida aos 2500 ms.
- Os cartões da animação respeitam o filtro ativo.

## Layout
- Kicker roxo “{N} VIAGENS” + título h1 “Carteira de viagens”; botão primário **+ Nova** (42 px) → assistente.
- **Filtros** (chips): **Todas · N** (padrão) · **Próximas · N** · **Rascunhos · N**.
  - Próximas = viagens *acontecendo agora* + *futuras*.
  - Rascunhos = viagens **com duração e sem data**.
- Lista de cartões, espaço 14 px.
- Ao final: link tracejado “Clonar uma viagem da comunidade” / “Use o roteiro de quem já foi como ponto de partida” → Explorar.

## Cartão de viagem
- Branco, raio 24 px, sombra `0 1px 2px rgba(21,18,46,.05), 0 12px 32px rgba(21,18,46,.07)`.
- **Imagem** 150 px (foto do destino ou cor sólida da viagem).
- **Selo de status** (24 px, raio 8 px, 12 px/700):
  | Status | Posição | Visual | Texto |
  | --- | --- | --- | --- |
  | Acontecendo agora | sup. esquerdo (14 px) | fundo lima, texto `#15122E`, ponto 7 px pulsando (opacidade 1 ↔ 0,25 em 1,4 s) | “Acontecendo agora” |
  | Próxima | sup. esquerdo | fundo `#15122E`, texto lima | “Em N dias” |
  | Concluída | sup. esquerdo | fundo `#15122E`, texto lima | “Concluída” |
  | Rascunho | **inf. direito** (14 px) | fundo branco, texto `#15122E`, ícone de lápis 12 px | “Rascunho” |
- Viagem com mais de uma cidade: selo branco 90% “N cidades” no canto superior direito.
- **Corpo** (16/18 px): nome editorial 32 px; linha 13 px “{datas} · N dias · N paradas”; avatares dos participantes (32 px, sobrepostos −9 px).
- **3 mini-indicadores** (grade 3 colunas, fundo `#F4F3F8`, raio 14 px): Gastos (valor, barra = % do orçamento), Mala (“X de Y”, barra = % pronto), Docs (“N salvos”, barra cheia verde `#9ACC1F` se houver docs). Barras 4 px.
- Toque → `16-viagem-capa-e-abas.md`.

## Ordenação
Por data de início crescente; rascunhos no fim.

## Estados vazios
- Sem viagens: ícone de mala em bloco `#EBE8FF` 56 px, “Nenhuma viagem ainda” / “Comece pelo destino. São só 4 toques.” + botão **+ Criar viagem**.
- Filtro sem resultado: “Nenhum rascunho” / “Rascunhos são viagens com duração, mas ainda sem data.” ou “Nenhuma viagem próxima” / “Crie uma viagem para ela aparecer aqui.”

## A DEFINIR
- Filtro para viagens concluídas (hoje só aparecem em “Todas”).
- Como transformar um rascunho em viagem com data (editar viagem).

Estados desta fatia:

- Vazio: o que `15-carteira-de-viagens.md` descreve como vazio. Se o arquivo não descreve vazio, a tela não inventa empty state.
- Erro: só a mensagem que o arquivo escreve. Mensagem marcada `A DEFINIR` não é criada.
- Permissão: papéis de BUSINESS.md §4.3 quando a tela cita papel.
- Limite: o número que o arquivo fixa (tentativas, caracteres, dias, itens). O que está `A DEFINIR` não vira limite.

## 7. Critérios de aceite

- [x] **AC-1** — Dado a aba Carteira, quando ela é tocada, então a animação da carteira segue os marcos 0, 520 ms, 1250 ms, 2050 ms e 2500 ms de BUSINESS/15; verificado por `test/ui/features/carteira/carteira_view_test.dart` com `AnimationController` real avançado por `tester.pump`.
- [x] **AC-2** — Dado viagens mocadas, quando o filtro Próximas está ativo, então entram acontecendo agora e futuras; Rascunhos mostra só duração sem data; verificado por `carteira_view_test.dart` e `carteira_view_model_test.dart`.
- [x] **AC-3** — Dado a lista, quando ela ordena, então a data de início crescente vem primeiro e os rascunhos ficam no fim; verificado pelos mesmos testes.
- [x] **AC-4** — Dado um cartão, quando a pessoa toca, então abre a capa da viagem; verificado por `carteira_view_test.dart` (callback `onAbrirViagem`) e pela integração real em `inicio_view.dart` (abre `ViagemCapaView`, spec `016-viagem-capa.md`).
- [x] **AC-5** — Dado uma viagem acontecendo, quando o cartão aparece, então o selo lima "Acontecendo agora" fica no canto superior esquerdo com o ponto pulsante; o rascunho usa selo "Rascunho" no canto inferior direito; já implementado e testado desde `007-inicio.md` (o mesmo `ViagemCard` é reaproveitado aqui).
- [x] **AC-6** — Dado o frame 390×844 e os dados mocados do protótipo, quando esta tela está visível, então alinhamento, espaçamento, tipografia e cor coincidem com `.docs/prototype` e com `15-carteira-de-viagens.md`; verificado por teste de widget em viewport 390 px. Inspeção visual lado a lado via app real não concluída nesta sessão.
- [ ] **AC-7** — Dado reduzir movimento ativo no aparelho, quando esta tela anima, então as durações caem para cerca de 0 ms; **pendente**, mesmo gap das specs anteriores.

## 8. Premissas e decisões

| ID | Tipo | Descrição | Dono | Validação |
| --- | --- | --- | --- | --- |
| D-1 | decisão | O protótipo e `15-carteira-de-viagens.md` mandam no visual e no movimento. Dado divergente, a inspeção para e a diferença fica registrada antes de implementar. | produto | inspeção lado a lado |
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
| ## A DEFINIR | não | produto | antes do refine-spec |

Nenhuma pergunta acima bloqueia esta spec. A tela mocada copia o que o protótipo já mostra e deixa de fora o que o protótipo não desenha.

## 13. Resultado

A fatia `carteira` está pronta quando todos os AC passam no frame 390×844 com os dados mocados do protótipo.

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
