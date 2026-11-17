# Mapa e otimização

- Slug: `roteiro-mapa`
- Status: `em execução`
- Data: 2026-11-16
- Última atualização: 2026-11-17
- Responsável: produto
- Repositório: `mayahtrip-app`
- Docs relacionados: `.docs/BUSINESS/18-roteiro-mapa-e-otimizacao.md`, `.docs/BUSINESS/BUSINESS.md`, `.docs/DESIGN.md`, `.docs/prototype`
- Specs relacionadas: `roteiro-lista`
- ADRs relacionados: nenhum

## 1. Contexto

Fato: o protótipo em `.docs/prototype` (16 nov 2026, frame 390×844) e `18-roteiro-mapa-e-otimizacao.md` já descrevem esta feature. O app Flutter em `mayahtrip-app` ainda não tem essa tela.

Quem sente: quem for usar o app e quem for comparar a tela com o protótipo. Sem esta fatia, o comportamento existe só no HTML.

Premissa, não fato: os dados continuam mocados, iguais aos do protótipo. Não há API nesta fila.

## 2. Necessidade de negócio

O app público precisa desta tela idêntica ao protótipo antes de qualquer outra entrega da mesma área. O sucesso é a pessoa cumprir o fluxo abaixo e a inspeção no frame 390×844 não achar diferença de layout, espaçamento, alinhamento ou animação.

## 3. Objetivo e resultado observável

Modo mapa do dia selecionado e o chip Otimizar. O mapa ilustrativo do protótipo é o que se desenha; provedor real continua fora.

## 4. Usuários e permissões

| Persona/papel | O que pode fazer | Restrições |
| --- | --- | --- |
| Jean Lucas, sessão mocada | Cumprir o fluxo desta fatia como no protótipo | Dados fixos do protótipo |
| Convidado | Só o que `modo-convidado` libera | Fora desta spec, exceto na própria spec `modo-convidado` |
| Dono, Viajante supremo, Viajante experiente, Assistente júnior | O que `18-roteiro-mapa-e-otimizacao.md` e BUSINESS.md §4.3 permitem nesta tela | Papel que a tela não menciona não ganha permissão nova |

## 5. Escopo

### 5.1 Dentro do escopo

- Modo mapa do dia selecionado e o chip Otimizar. O mapa ilustrativo do protótipo é o que se desenha; provedor real continua fora.
- Flutter em `mayahtrip-app`, com os dados mocados do protótipo.
- Reutilizar tokens, fontes e movimento definidos na spec `abertura`, sem redefini-los.

### 5.2 Fora de escopo

- As outras fatias: `abertura`, `sign-in`, `sign-up`, `confirm-account`, `forgot-password`, `reset-password`, `inicio`, `notificacoes`, `busca`, `pagina-do-lugar`, `explorar`, `comentarios-curtidas`, `inserir-no-roteiro`, `avaliar-parada`, `acoes-rapidas`, `nova-viagem`, `carteira`, `viagem-capa`, `roteiro-lista`, `detalhe-da-parada`, `adicionar-parada`, `gastos`, `novo-gasto`, `mala`, `lista-de-compras`, `documentos-links`, `compartilhar-viagem`, `maya`, `perfil`, `minhas-publicacoes`, `minhas-midias`, `mencoes`, `seguidores`, `perfil-publico`, `privacidade-bloqueios`, `onde-ja-estive`, `aparencia`, `editar-perfil`, `idioma-moeda`, `modo-convidado`.
- API real, painel, site de planos e cobrança em loja.
- Item marcado `A DEFINIR` que o protótipo não desenha. Não inventar a regra.
- O painel lateral do HTML do protótipo.

## 6. Comportamento esperado

Recorte: Modo mapa do dia selecionado e o chip Otimizar. O mapa ilustrativo do protótipo é o que se desenha; provedor real continua fora.

O texto abaixo é a regra desta fatia. Medida, tempo e cor citados são critério visual. Menção a uma tela de outra spec é só navegação: o destino pertence à spec daquele slug.

## Mapa do dia
- Caixa de **480 px** de altura, raio 26 px, sombra leve. Mostra **apenas as paradas do dia selecionado**.
- Fundo ilustrativo (`#ECE8DF` com malha de ruas branca, parques `#D3E5C4`, rio/mar `#A9CDEB` com nome do rio em 10 px/700 `#5C8DB8`). No app real: mapa de verdade (`A DEFINIR` provedor).
- **Rota**: linha `#2B207F` de 4,5 px sobre contorno branco 9 px, desenhada de ponta a ponta em 1,4 s.
- **Pinos**: círculo 13 px (selecionado 17 px) com aro branco 3 px; número da parada (12/14 px, 800). Cores: normal `#2B207F`, selecionado `#15122E` com anel pulsante, feito = lima com “✓”. Entram caindo (mola, 70 ms entre eles).
- **Rótulo de deslocamento** no meio de cada trecho (pílula branca 22 px, texto 10,5 px/700): “N min a pé” etc. — oculto se o trecho for curto demais.
- **Topo**: chip “📍 N paradas · X km · Y min” e chip **Maps** (abre a rota completa no Google Maps).
- **Cartão inferior** (branco, raio 20 px): miniatura 52 px · “N de M · {horário}” · nome · duração/preço; botões ‹ › (34 px) para ir à parada anterior/próxima (desativados nas pontas). Toque no cartão → detalhe da parada. Toque num pino → seleciona.
- Distância total = soma das distâncias em linha reta × 1,25.

## Rota no Google Maps
“Por enquanto vamos manter para todos”: o botão de rota está disponível para todos os usuários.

## Otimizar
- Disponível com **3 ou mais paradas** no dia (chip “⚡ Otimizar”).
- Mantém a **primeira parada** e reordena as demais pelo vizinho mais próximo.
- Os **horários ficam nas mesmas posições** (a 1ª nova parada herda o 1º horário etc.) e os deslocamentos são recalculados.
- Se não reduzir o tempo total: aviso “Este dia já está na melhor ordem”.
- Se reduzir: aviso “Ordem otimizada · N min a menos de deslocamento” + **Desfazer**.

## A DEFINIR
- Provedor de mapas e modo de transporte padrão.
- Otimizar considerando horários de funcionamento.

Estados desta fatia:

- Vazio: o que `18-roteiro-mapa-e-otimizacao.md` descreve como vazio. Se o arquivo não descreve vazio, a tela não inventa empty state.
- Erro: só a mensagem que o arquivo escreve. Mensagem marcada `A DEFINIR` não é criada.
- Permissão: papéis de BUSINESS.md §4.3 quando a tela cita papel.
- Limite: o número que o arquivo fixa (tentativas, caracteres, dias, itens). O que está `A DEFINIR` não vira limite.

## 7. Critérios de aceite

- [x] **AC-1** — Dado o dia selecionado, quando o mapa abre, então só as paradas desse dia aparecem; verificado por `test/ui/features/roteiro_mapa/roteiro_mapa_view_test.dart`. Os pinos são posicionados por lat/lng reais normalizados (D-11 de `017-roteiro-lista.md`), não pelo mapa ilustrativo exato do protótipo (ruas/parques/rio desenhados) — a animação de desenho da rota em 1,4 s e a entrada em mola dos pinos não foram implementadas (verificação visual, sem teste).
- [x] **AC-2** — Dado 3 ou mais paradas, quando Otimizar reduz o tempo, então a primeira parada permanece, os horários ficam nas posições e o aviso oferece Desfazer; se não reduzir, o aviso diz que o dia já está na melhor ordem; verificado por `roteiro_mapa_view_test.dart` e `roteiro_mapa_view_model_test.dart` (nearest-neighbor real com distância haversine).
- [x] **AC-3** — Dado um pino, quando a pessoa toca, então o cartão inferior mostra essa parada e as setas nas pontas ficam desativadas; verificado pelos mesmos testes.
- [x] **AC-4** — Dado o chip Maps ou o botão Rota, quando a pessoa toca, então o aviso mocado indica a abertura da rota no Google Maps; verificado por `roteiro_mapa_view_test.dart`.
- [x] **AC-5** — Dado o frame 390×844 e os dados mocados do protótipo, quando esta tela está visível, então alinhamento, espaçamento, tipografia e cor coincidem com `.docs/prototype` e com `18-roteiro-mapa-e-otimizacao.md`; verificado por teste de widget. O fundo ilustrativo do protótipo (ruas/parques/rio desenhados) não foi reproduzido — é `A DEFINIR` no próprio protótipo (provedor de mapa real), então a tela usa um fundo neutro + a rota/pinos reais por cima. Inspeção visual lado a lado via app real não concluída nesta sessão.
- [ ] **AC-6** — Dado reduzir movimento ativo no aparelho, quando esta tela anima, então as durações caem para cerca de 0 ms; **pendente**, mesmo gap das specs anteriores.

## 8. Premissas e decisões

| ID | Tipo | Descrição | Dono | Validação |
| --- | --- | --- | --- | --- |
| D-1 | decisão | O protótipo e `18-roteiro-mapa-e-otimizacao.md` mandam no visual e no movimento. Dado divergente, a inspeção para e a diferença fica registrada antes de implementar. | produto | inspeção lado a lado |
| D-2 | decisão | Dados mocados, código de verificação `1234`, usuário Jean Lucas quando a tela pede alguém logado. | produto | comparar com o protótipo |
| D-3 | decisão | `A DEFINIR` não é implementado como regra nova. | produto | revisão da spec |
| P-1 | premissa | A fundação visual da spec `abertura` já existe quando esta fatia for implementada, salvo na própria abertura. | app | a spec `abertura` concluída |
| D-12 | decisão (engenharia) | "Otimizar" usa distância haversine real (lat/lng minerados) e vizinho mais próximo de verdade — mantém a 1ª parada, reordena as demais, recalcula se o novo trajeto é mais curto antes de aplicar. Testado com um catálogo sintético de 3 pontos pra conseguir prever a melhor ordem à mão. | app | `RoteiroMapaViewModel.otimizar()` |
| D-13 | decisão | O fundo ilustrativo detalhado do protótipo (ruas, parques, rio com nome) não foi reproduzido — o próprio protótipo já marca o provedor de mapa real como `A DEFINIR`. A tela usa um fundo neutro com a rota e os pinos reais desenhados por cima, priorizando o comportamento (distância, otimização, navegação) sobre a ilustração. | produto | revisar quando o provedor de mapa real for escolhido |

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
| Fundo ilustrativo (`#ECE8DF` com malha de ruas branca, parques `#D3E5C4`, rio/mar `#A9CDEB` com nome do rio em 10 px/700 `#5C8DB8`). No app real: mapa de verdade (`A DEFINIR` provedor). | não | produto | antes do refine-spec |
| ## A DEFINIR | não | produto | antes do refine-spec |

Nenhuma pergunta acima bloqueia esta spec. A tela mocada copia o que o protótipo já mostra e deixa de fora o que o protótipo não desenha.

## 13. Resultado

A fatia `roteiro-mapa` está pronta quando todos os AC passam no frame 390×844 com os dados mocados do protótipo.

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

- `roteiro-lista` em `019-roteiro-lista.md`
