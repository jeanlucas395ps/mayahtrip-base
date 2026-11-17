# Lista de compras

- Slug: `lista-de-compras`
- Status: `rascunho`
- Data: 2026-11-16
- Última atualização: 2026-11-16
- Responsável: produto
- Repositório: `mayahtrip-app`
- Docs relacionados: `.docs/BUSINESS/24-lista-de-compras.md`, `.docs/BUSINESS/BUSINESS.md`, `.docs/DESIGN.md`, `.docs/prototype`
- Specs relacionadas: `viagem-capa`
- ADRs relacionados: nenhum

## 1. Contexto

Fato: o protótipo em `.docs/prototype` (16 nov 2026, frame 390×844) e `24-lista-de-compras.md` já descrevem esta feature. O app Flutter em `mayahtrip-app` ainda não tem essa tela.

Quem sente: quem for usar o app e quem for comparar a tela com o protótipo. Sem esta fatia, o comportamento existe só no HTML.

Premissa, não fato: os dados continuam mocados, iguais aos do protótipo. Não há API nesta fila.

## 2. Necessidade de negócio

O app público precisa desta tela idêntica ao protótipo antes de qualquer outra entrega da mesma área. O sucesso é a pessoa cumprir o fluxo abaixo e a inspeção no frame 390×844 não achar diferença de layout, espaçamento, alinhamento ou animação.

## 3. Objetivo e resultado observável

Aba Compras. Abrir link, dono do item e virar gasto ficam fora.

## 4. Usuários e permissões

| Persona/papel | O que pode fazer | Restrições |
| --- | --- | --- |
| Jean Lucas, sessão mocada | Cumprir o fluxo desta fatia como no protótipo | Dados fixos do protótipo |
| Convidado | Só o que `modo-convidado` libera | Fora desta spec, exceto na própria spec `modo-convidado` |
| Dono, Viajante supremo, Viajante experiente, Assistente júnior | O que `24-lista-de-compras.md` e BUSINESS.md §4.3 permitem nesta tela | Papel que a tela não menciona não ganha permissão nova |

## 5. Escopo

### 5.1 Dentro do escopo

- Aba Compras. Abrir link, dono do item e virar gasto ficam fora.
- Flutter em `mayahtrip-app`, com os dados mocados do protótipo.
- Reutilizar tokens, fontes e movimento definidos na spec `abertura`, sem redefini-los.

### 5.2 Fora de escopo

- As outras fatias: `abertura`, `sign-in`, `sign-up`, `confirm-account`, `forgot-password`, `reset-password`, `inicio`, `notificacoes`, `busca`, `pagina-do-lugar`, `explorar`, `comentarios-curtidas`, `inserir-no-roteiro`, `avaliar-parada`, `acoes-rapidas`, `nova-viagem`, `carteira`, `viagem-capa`, `roteiro-lista`, `roteiro-mapa`, `detalhe-da-parada`, `adicionar-parada`, `gastos`, `novo-gasto`, `mala`, `documentos-links`, `compartilhar-viagem`, `maya`, `perfil`, `minhas-publicacoes`, `minhas-midias`, `mencoes`, `seguidores`, `perfil-publico`, `privacidade-bloqueios`, `onde-ja-estive`, `aparencia`, `editar-perfil`, `idioma-moeda`, `modo-convidado`.
- API real, painel, site de planos e cobrança em loja.
- Item marcado `A DEFINIR` que o protótipo não desenha. Não inventar a regra.
- O painel lateral do HTML do protótipo.

## 6. Comportamento esperado

Recorte: Aba Compras. Abrir link, dono do item e virar gasto ficam fora.

O texto abaixo é a regra desta fatia. Medida, tempo e cor citados são critério visual. Menção a uma tela de outra spec é só navegação: o destino pertence à spec daquele slug.

## Objetivo
Organizar o que precisa ser comprado antes ou durante a viagem, com preço previsto e loja/link. Substitui a antiga aba Galeria.

## Layout (aba “Compras” da viagem)
1. **Resumo** (cartão, padding 16 px): “X de Y comprados” (h3) · “Total previsto {valor}” (12 px) · barra 8 px roxa (% comprados) · “Falta comprar: **{valor dos itens pendentes}**” (some quando zero).
2. **Lista** (cartão): cada item com
   - caixa de seleção 30 px (comprado = roxa com check);
   - nome 15 px/600 (riscado e `#8C889E` quando comprado);
   - linha 12 px: loja (ou “Sem loja”) + “· link salvo” quando há link;
   - preço 13 px/700 (ou “—” sem preço);
   - botão ✕ 32 px para remover.
   - Vazio: “Nada na lista ainda. Adicione o que precisa comprar antes ou durante a viagem.”
3. **Adicionar** (formulário):
   - Linha 1: “O que comprar” (50 px, flexível) + “Preço” (110 px, teclado decimal, placeholder com o símbolo da moeda de exibição, ex.: “€ 0,00”).
   - Linha 2: “Loja ou link (opcional)” (46 px) + botão primário **+ Adicionar** (46 px).

## Regras
1. Nome obrigatório; preço e loja opcionais. Aviso “Item adicionado à lista de compras”.
2. O preço é digitado na **moeda de exibição** e guardado convertido; aceita “1.234,56”.
3. Se o campo “Loja ou link” parece um link (começa com http(s) ou contém .com/.pt/.br), salva como link e mostra “Link · link salvo”.
4. Remover mostra “{item} removido” + **Desfazer** (volta na mesma posição).
5. A lista é compartilhada pelo grupo. Quem pode editar segue os papéis (`26`).

## A DEFINIR
- Abrir o link salvo (navegador interno ou externo).
- Atribuir item a uma pessoa / quem comprou.
- Transformar item comprado em gasto automaticamente.

Estados desta fatia:

- Vazio: o que `24-lista-de-compras.md` descreve como vazio. Se o arquivo não descreve vazio, a tela não inventa empty state.
- Erro: só a mensagem que o arquivo escreve. Mensagem marcada `A DEFINIR` não é criada.
- Permissão: papéis de BUSINESS.md §4.3 quando a tela cita papel.
- Limite: o número que o arquivo fixa (tentativas, caracteres, dias, itens). O que está `A DEFINIR` não vira limite.

## 7. Critérios de aceite

- [ ] **AC-1** — Dado itens comprados e pendentes, quando a aba abre, então o resumo mostra X de Y, o total previsto e a soma que falta; verificado por teste de widget.
- [ ] **AC-2** — Dado nome vazio, quando a pessoa toca Adicionar, então nada entra; com nome, o item entra e o aviso confirma; verificado por teste de widget.
- [ ] **AC-3** — Dado um texto que começa com http ou contém .com, .pt ou .br, quando o item é salvo, então o campo vira link e a linha mostra “Link · link salvo”; verificado por teste de widget.
- [ ] **AC-4** — Dado um item, quando a pessoa remove, então o aviso oferece Desfazer e o item volta na mesma posição; verificado por teste de widget.
- [ ] **AC-5** — Dado o frame 390×844 e os dados mocados do protótipo, quando esta tela está visível, então alinhamento, espaçamento, tipografia e cor coincidem com `.docs/prototype` e com `24-lista-de-compras.md`; verificado por inspeção lado a lado.
- [ ] **AC-6** — Dado reduzir movimento ativo no aparelho, quando esta tela anima, então as durações caem para cerca de 0 ms; verificado por inspeção.

## 8. Premissas e decisões

| ID | Tipo | Descrição | Dono | Validação |
| --- | --- | --- | --- | --- |
| D-1 | decisão | O protótipo e `24-lista-de-compras.md` mandam no visual e no movimento. Dado divergente, a inspeção para e a diferença fica registrada antes de implementar. | produto | inspeção lado a lado |
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

A fatia `lista-de-compras` está pronta quando todos os AC passam no frame 390×844 com os dados mocados do protótipo.

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

- `viagem-capa` em `018-viagem-capa.md`
