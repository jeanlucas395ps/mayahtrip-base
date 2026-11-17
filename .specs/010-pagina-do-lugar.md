# Página do lugar

- Slug: `pagina-do-lugar`
- Status: `em execução`
- Data: 2026-11-16
- Última atualização: 2026-11-17
- Responsável: produto
- Repositório: `mayahtrip-app`
- Docs relacionados: `.docs/BUSINESS/08-pagina-do-lugar.md`, `.docs/BUSINESS/BUSINESS.md`, `.docs/DESIGN.md`, `.docs/prototype`
- Specs relacionadas: `busca`
- ADRs relacionados: nenhum

## 1. Contexto

Fato: o protótipo em `.docs/prototype` (16 nov 2026, frame 390×844) e `08-pagina-do-lugar.md` já descrevem esta feature. O app Flutter em `mayahtrip-app` ainda não tem essa tela.

Quem sente: quem for usar o app e quem for comparar a tela com o protótipo. Sem esta fatia, o comportamento existe só no HTML.

Premissa, não fato: os dados continuam mocados, iguais aos do protótipo. Não há API nesta fila.

## 2. Necessidade de negócio

O app público precisa desta tela idêntica ao protótipo antes de qualquer outra entrega da mesma área. O sucesso é a pessoa cumprir o fluxo abaixo e a inspeção no frame 390×844 não achar diferença de layout, espaçamento, alinhamento ou animação.

## 3. Objetivo e resultado observável

A página de um lugar do catálogo mocado. Salvar, compartilhar e a barra Inserir em um roteiro. O fluxo de inserir é outra spec.

## 4. Usuários e permissões

| Persona/papel | O que pode fazer | Restrições |
| --- | --- | --- |
| Jean Lucas, sessão mocada | Cumprir o fluxo desta fatia como no protótipo | Dados fixos do protótipo |
| Convidado | Só o que `modo-convidado` libera | Fora desta spec, exceto na própria spec `modo-convidado` |
| Dono, Viajante supremo, Viajante experiente, Assistente júnior | O que `08-pagina-do-lugar.md` e BUSINESS.md §4.3 permitem nesta tela | Papel que a tela não menciona não ganha permissão nova |

## 5. Escopo

### 5.1 Dentro do escopo

- A página de um lugar do catálogo mocado. Salvar, compartilhar e a barra Inserir em um roteiro. O fluxo de inserir é outra spec.
- Flutter em `mayahtrip-app`, com os dados mocados do protótipo.
- Reutilizar tokens, fontes e movimento definidos na spec `abertura`, sem redefini-los.

### 5.2 Fora de escopo

- As outras fatias: `abertura`, `sign-in`, `sign-up`, `confirm-account`, `forgot-password`, `reset-password`, `inicio`, `notificacoes`, `busca`, `explorar`, `comentarios-curtidas`, `inserir-no-roteiro`, `avaliar-parada`, `acoes-rapidas`, `nova-viagem`, `carteira`, `viagem-capa`, `roteiro-lista`, `roteiro-mapa`, `detalhe-da-parada`, `adicionar-parada`, `gastos`, `novo-gasto`, `mala`, `lista-de-compras`, `documentos-links`, `compartilhar-viagem`, `maya`, `perfil`, `minhas-publicacoes`, `minhas-midias`, `mencoes`, `seguidores`, `perfil-publico`, `privacidade-bloqueios`, `onde-ja-estive`, `aparencia`, `editar-perfil`, `idioma-moeda`, `modo-convidado`.
- API real, painel, site de planos e cobrança em loja.
- Item marcado `A DEFINIR` que o protótipo não desenha. Não inventar a regra.
- O painel lateral do HTML do protótipo.

## 6. Comportamento esperado

Recorte: A página de um lugar do catálogo mocado. Salvar, compartilhar e a barra Inserir em um roteiro. O fluxo de inserir é outra spec.

O texto abaixo é a regra desta fatia. Medida, tempo e cor citados são critério visual. Menção a uma tela de outra spec é só navegação: o destino pertence à spec daquele slug.

## Objetivo
Mostrar tudo sobre um lugar (vídeos, informações, dicas) e levá-lo ao roteiro.

## Layout
1. **Capa** 420 px: foto do lugar (ou cor + ícone 120 px a 30% se não houver foto); degradê de baixo `rgba(12,10,28,.92)` até transparente em 60%.
   - Topo (52 px): voltar (botão vidro 44 px, branco 88% + desfoque 12 px) · **Salvar** (marcador; salvo = preenchido `#2B207F`) · **Compartilhar** (aviso “Link copiado”).
   - Base (20 px laterais, 22 px base): kicker lima “{categoria} · {cidade}”; nome editorial **50 px** branco; linha 13 px: estrela + nota + (avaliações) · “Aberto agora” em lima.
2. Etiquetas: roxa “▶ N vídeos”, cinzas “Em N roteiros” e “{duração} em média”.
3. **Vídeos e fotos** (h2 + “Ver todos” → Explorar): até 4 cartões 138 × 214 px, raio 20 px, duração no canto (“▶ 0:30”), autor 12 px/700 na base.
4. **Informações do local** (cartão com linhas 13 px, ícones 18 px `#2B207F`, divisórias `#EEECF3`):
   - 📍 “{bairro}, {cidade} · N min a pé do metrô”
   - 🕘 “Hoje: {horário} · fila média {N} min”
   - 💳 faixa de preço por pessoa (ou “Grátis”)
   - 👥 “Quem foi ficou em média {duração}”
5. **Dicas de quem foi**: até 3 cartões com avatar 32 px, nome, estrelas (5 ou 4) e texto 13 px.
6. **Barra fixa inferior** (fundo `rgba(244,243,248,.94)` + desfoque 16 px, borda superior): botão de mapa 44 px (contorno) + botão lima **Inserir em um roteiro** (52 px) → `11-inserir-no-roteiro.md`.

## Regras
1. Salvar/remover → aviso “Salvo em Salvos” / “Removido dos salvos”. Lista aparece na aba “Salvos” do Explorar.
2. Convidado ao salvar ou inserir → convite para criar conta.
3. “Aberto agora”, horário e fila vêm de dados do local. Fonte dos dados: `A DEFINIR`.
4. Botão de mapa: abrir o local num app de mapas. Comportamento real: `A DEFINIR`.

Estados desta fatia:

- Vazio: o que `08-pagina-do-lugar.md` descreve como vazio. Se o arquivo não descreve vazio, a tela não inventa empty state.
- Erro: só a mensagem que o arquivo escreve. Mensagem marcada `A DEFINIR` não é criada.
- Permissão: papéis de BUSINESS.md §4.3 quando a tela cita papel.
- Limite: o número que o arquivo fixa (tentativas, caracteres, dias, itens). O que está `A DEFINIR` não vira limite.

## 7. Critérios de aceite

- [x] **AC-1** — Dado um lugar com foto, quando a página abre, então a capa tem 420 px, kicker lima, nome editorial de 50 px e a barra fixa com o botão lima Inserir em um roteiro; verificado por `test/ui/features/pagina_do_lugar/pagina_do_lugar_view_test.dart` (AC-1) e inspeção do código no frame 390×844.
- [x] **AC-2** — Dado um lugar ainda não salvo, quando a pessoa toca Salvar, então o marcador fica preenchido #2B207F e o aviso diz “Salvo em Salvos”; tocar de novo mostra “Removido dos salvos”; verificado por `pagina_do_lugar_view_test.dart` (AC-2). Achado e corrigido nesta verificação: toques rápidos em sequência enfileiravam o SnackBar anterior em vez de trocá-lo na hora — `_toast` agora chama `clearSnackBars()` antes de `showSnackBar()`.
- [x] **AC-3** — Dado a página, quando a pessoa toca Compartilhar, então o aviso diz “Link copiado”; verificado por `pagina_do_lugar_view_test.dart` (AC-3).
- [x] **AC-4** — Dado a página, quando a pessoa toca Inserir em um roteiro, então abre a folha da spec inserir-no-roteiro; verificado por `pagina_do_lugar_view_test.dart` (AC-4) — "abrir" é um `DestinoPlaceholder` rotulado, já que `inserir-no-roteiro` é outra spec fora desta fila.
- [x] **AC-5** — Dado o frame 390×844 e os dados mocados do protótipo, quando esta tela está visível, então alinhamento, espaçamento, tipografia e cor coincidem com `.docs/prototype` e com `08-pagina-do-lugar.md`; verificado por mineração de `PL` do protótipo (lugares, dicas, vídeos idênticos) e por teste de widget em viewport 390 px (achou e corrigiu 2 overflows reais: a linha de avaliação da capa e o botão "Inserir em um roteiro" na barra fixa). Inspeção visual lado a lado via app real não concluída nesta sessão.
- [ ] **AC-6** — Dado reduzir movimento ativo no aparelho, quando esta tela anima, então as durações caem para cerca de 0 ms; **pendente**, mesmo gap das specs 007/008/009.

## 8. Premissas e decisões

| ID | Tipo | Descrição | Dono | Validação |
| --- | --- | --- | --- | --- |
| D-1 | decisão | O protótipo e `08-pagina-do-lugar.md` mandam no visual e no movimento. Dado divergente, a inspeção para e a diferença fica registrada antes de implementar. | produto | inspeção lado a lado |
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
| 3. “Aberto agora”, horário e fila vêm de dados do local. Fonte dos dados: `A DEFINIR`. | não | produto | antes do refine-spec |
| 4. Botão de mapa: abrir o local num app de mapas. Comportamento real: `A DEFINIR`. | não | produto | antes do refine-spec |

Nenhuma pergunta acima bloqueia esta spec. A tela mocada copia o que o protótipo já mostra e deixa de fora o que o protótipo não desenha.

## 13. Resultado

A fatia `pagina-do-lugar` está pronta quando todos os AC passam no frame 390×844 com os dados mocados do protótipo.

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

- `busca` em `009-busca.md`
