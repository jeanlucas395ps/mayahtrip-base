# Gastos e divisão

- Slug: `gastos`
- Status: `rascunho`
- Data: 2026-11-16
- Última atualização: 2026-11-16
- Responsável: produto
- Repositório: `mayahtrip-app`
- Docs relacionados: `.docs/BUSINESS/21-gastos.md`, `.docs/BUSINESS/BUSINESS.md`, `.docs/DESIGN.md`, `.docs/prototype`
- Specs relacionadas: `viagem-capa`
- ADRs relacionados: nenhum

## 1. Contexto

Fato: o protótipo em `.docs/prototype` (16 nov 2026, frame 390×844) e `21-gastos.md` já descrevem esta feature. O app Flutter em `mayahtrip-app` ainda não tem essa tela.

Quem sente: quem for usar o app e quem for comparar a tela com o protótipo. Sem esta fatia, o comportamento existe só no HTML.

Premissa, não fato: os dados continuam mocados, iguais aos do protótipo. Não há API nesta fila.

## 2. Necessidade de negócio

O app público precisa desta tela idêntica ao protótipo antes de qualquer outra entrega da mesma área. O sucesso é a pessoa cumprir o fluxo abaixo e a inspeção no frame 390×844 não achar diferença de layout, espaçamento, alinhamento ou animação.

## 3. Objetivo e resultado observável

Aba Gastos: resumo, saldo, categorias e lista. Lançar é a spec novo-gasto. Divisão desigual, editar, excluir e orçamento editável continuam fora.

## 4. Usuários e permissões

| Persona/papel | O que pode fazer | Restrições |
| --- | --- | --- |
| Jean Lucas, sessão mocada | Cumprir o fluxo desta fatia como no protótipo | Dados fixos do protótipo |
| Convidado | Só o que `modo-convidado` libera | Fora desta spec, exceto na própria spec `modo-convidado` |
| Dono, Viajante supremo, Viajante experiente, Assistente júnior | O que `21-gastos.md` e BUSINESS.md §4.3 permitem nesta tela | Papel que a tela não menciona não ganha permissão nova |

## 5. Escopo

### 5.1 Dentro do escopo

- Aba Gastos: resumo, saldo, categorias e lista. Lançar é a spec novo-gasto. Divisão desigual, editar, excluir e orçamento editável continuam fora.
- Flutter em `mayahtrip-app`, com os dados mocados do protótipo.
- Reutilizar tokens, fontes e movimento definidos na spec `abertura`, sem redefini-los.

### 5.2 Fora de escopo

- As outras fatias: `abertura`, `sign-in`, `sign-up`, `confirm-account`, `forgot-password`, `reset-password`, `inicio`, `notificacoes`, `busca`, `pagina-do-lugar`, `explorar`, `comentarios-curtidas`, `inserir-no-roteiro`, `avaliar-parada`, `acoes-rapidas`, `nova-viagem`, `carteira`, `viagem-capa`, `roteiro-lista`, `roteiro-mapa`, `detalhe-da-parada`, `adicionar-parada`, `novo-gasto`, `mala`, `lista-de-compras`, `documentos-links`, `compartilhar-viagem`, `maya`, `perfil`, `minhas-publicacoes`, `minhas-midias`, `mencoes`, `seguidores`, `perfil-publico`, `privacidade-bloqueios`, `onde-ja-estive`, `aparencia`, `editar-perfil`, `idioma-moeda`, `modo-convidado`.
- API real, painel, site de planos e cobrança em loja.
- Item marcado `A DEFINIR` que o protótipo não desenha. Não inventar a regra.
- O painel lateral do HTML do protótipo.

## 6. Comportamento esperado

Recorte: Aba Gastos: resumo, saldo, categorias e lista. Lançar é a spec novo-gasto. Divisão desigual, editar, excluir e orçamento editável continuam fora.

O texto abaixo é a regra desta fatia. Medida, tempo e cor citados são critério visual. Menção a uma tela de outra spec é só navegação: o destino pertence à spec daquele slug.

## Resumo do grupo (bloco `#2B207F`, raio 26 px, padding 18 px)
- “Gasto do grupo” (13 px `#D4CEFC`) · “N pessoas”.
- Total gasto em editorial **52 px** (42 px se o valor for longo) + “de {orçamento}”.
- Barra 8 px (trilho branco 16%, preenchimento lima) + “X% usado · dentro do orçamento” / “acima do orçamento”.
- Botão lima **+ Novo gasto** (largura total) → `22-novo-gasto.md`.

## Saldo (cartão, só com 2+ pessoas e algum gasto)
- Avatares (40 px) das outras pessoas.
| Situação | Texto | Ação |
| --- | --- | --- |
| Saldo ≈ 0 (< 0,50) | “Contas em dia” / “Ninguém deve nada a ninguém” | etiqueta lima “✓ Quitado” |
| 2 pessoas, te devem | “{Nome} te deve {valor}” / “Toque em acertar quando receber” | **Acertar** |
| 2 pessoas, você deve | “Você deve {valor} a {Nome}” / “Pague e marque como acertado” | **Acertar** |
| 3+ pessoas | “Você tem a receber {valor}” ou “Você deve {valor}” / “Dividido entre N pessoas” | **Acertar** |
- **Acertar** cria um lançamento “Acerto: {quem paga} → {quem recebe}” no grupo “Acertos” que zera o saldo; aviso “Contas acertadas” + **Desfazer**. Acertos não entram no total gasto nem nas categorias.

## Por categoria
- Cabeçalho “Por categoria” + link **Exportar** (`A DEFINIR` formato).
- Barra empilhada 12 px (segmentos raio 6, espaço 3 px) na cor de cada categoria, ordenada do maior para o menor.
- Legenda em **uma coluna**: bolinha 10 px da cor · ícone da categoria 15 px · nome · % (40 px) · valor (mín. 84 px).
- As 10 categorias e ícones estão em `BUSINESS.md` §4.6.

## Dica de hospedagem
Se há gastos e nenhum de Hospedagem: caixa `#F1FFD1` “Ainda falta **hospedagem**. Quem foi gastou em média **{valor}** por 2 noites.” + chip **Adicionar estimativa** (cria “Hospedagem (estimativa)” no grupo “Planejado”, dividida entre todos; aviso “Estimativa adicionada ao orçamento”). Origem da média: `A DEFINIR`.

## Lista de gastos
- Agrupada por **quando**: “Antes da viagem”, cada dia (“5 dez”…), “Depois da viagem”, “Acertos”, “Planejado”. Kicker 11 px por grupo; mais recentes primeiro.
- Linha: ícone da categoria (42 px) · descrição (13 px/700) · “{quem} pagou · dividido por N” · valor (13 px/700) · “te devem {X}” (`#3A6B00`) ou “você deve {X}” (`#962A10`).
- Acerto: ícone check em `#EEFFC2`, texto “Pagamento entre vocês”.
- Lançamento novo pisca com halo lima.
- Vazio: “Nenhum gasto ainda” / “Lance o primeiro e a divisão é automática.”

## Regras
1. Divisão igualitária entre as pessoas marcadas.
2. Valores exibidos na moeda de exibição (ver `35`), convertidos pelo câmbio do dia.
3. Viajante experiente e supremo veem e editam; **Assistente júnior não vê esta aba**.
4. Gasto lançado por outra pessoa gera notificação (app + push) para quem participa da divisão.

## A DEFINIR
- Divisão por valores/percentuais diferentes.
- Editar e excluir gasto.
- Definição/edição do orçamento.

Estados desta fatia:

- Vazio: o que `21-gastos.md` descreve como vazio. Se o arquivo não descreve vazio, a tela não inventa empty state.
- Erro: só a mensagem que o arquivo escreve. Mensagem marcada `A DEFINIR` não é criada.
- Permissão: papéis de BUSINESS.md §4.3 quando a tela cita papel.
- Limite: o número que o arquivo fixa (tentativas, caracteres, dias, itens). O que está `A DEFINIR` não vira limite.

## 7. Critérios de aceite

- [ ] **AC-1** — Dado gastos mocados, quando a aba abre, então o total e a barra mostram a porcentagem do orçamento e o texto dentro ou acima do orçamento; verificado por teste de widget.
- [ ] **AC-2** — Dado duas pessoas e saldo diferente de zero, quando a pessoa toca Acertar, então surge o lançamento no grupo Acertos, o saldo zera e o aviso oferece Desfazer; o acerto não entra no total nem nas categorias; verificado por teste de widget.
- [ ] **AC-3** — Dado a divisão, quando um gasto é exibido, então a parte é igual entre as pessoas marcadas e o valor está na moeda de exibição; verificado por teste de widget.
- [ ] **AC-4** — Dado Assistente júnior, quando a viagem abre, então a aba Gastos não existe; verificado por teste de widget.
- [ ] **AC-5** — Dado nenhum gasto de Hospedagem, quando há outros gastos, então a dica oferece Adicionar estimativa e o lançamento cai no grupo Planejado; verificado por teste de widget.
- [ ] **AC-6** — Dado o frame 390×844 e os dados mocados do protótipo, quando esta tela está visível, então alinhamento, espaçamento, tipografia e cor coincidem com `.docs/prototype` e com `21-gastos.md`; verificado por inspeção lado a lado.
- [ ] **AC-7** — Dado reduzir movimento ativo no aparelho, quando esta tela anima, então as durações caem para cerca de 0 ms; verificado por inspeção.

## 8. Premissas e decisões

| ID | Tipo | Descrição | Dono | Validação |
| --- | --- | --- | --- | --- |
| D-1 | decisão | O protótipo e `21-gastos.md` mandam no visual e no movimento. Dado divergente, a inspeção para e a diferença fica registrada antes de implementar. | produto | inspeção lado a lado |
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
| Cabeçalho “Por categoria” + link **Exportar** (`A DEFINIR` formato). | não | produto | antes do refine-spec |
| Se há gastos e nenhum de Hospedagem: caixa `#F1FFD1` “Ainda falta **hospedagem**. Quem foi gastou em média **{valor}** por 2 noites.” + chip **Adicionar estimativa** (cria “Hospedagem (estimativa)” no grupo “Planejado”, dividida entre todos; aviso “Estimativa adicionada ao orçamento”). Origem da média: `A DEFINIR`. | não | produto | antes do refine-spec |
| ## A DEFINIR | não | produto | antes do refine-spec |

Nenhuma pergunta acima bloqueia esta spec. A tela mocada copia o que o protótipo já mostra e deixa de fora o que o protótipo não desenha.

## 13. Resultado

A fatia `gastos` está pronta quando todos os AC passam no frame 390×844 com os dados mocados do protótipo.

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
