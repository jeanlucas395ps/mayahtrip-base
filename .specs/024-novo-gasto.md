# Lançar gasto

- Slug: `novo-gasto`
- Status: `em execução`
- Data: 2026-11-16
- Última atualização: 2026-11-17
- Responsável: produto
- Repositório: `mayahtrip-app`
- Docs relacionados: `.docs/BUSINESS/22-novo-gasto.md`, `.docs/BUSINESS/BUSINESS.md`, `.docs/DESIGN.md`, `.docs/prototype`
- Specs relacionadas: `gastos`
- ADRs relacionados: nenhum

## 1. Contexto

Fato: o protótipo em `.docs/prototype` (16 nov 2026, frame 390×844) e `22-novo-gasto.md` já descrevem esta feature. O app Flutter em `mayahtrip-app` ainda não tem essa tela.

Quem sente: quem for usar o app e quem for comparar a tela com o protótipo. Sem esta fatia, o comportamento existe só no HTML.

Premissa, não fato: os dados continuam mocados, iguais aos do protótipo. Não há API nesta fila.

## 2. Necessidade de negócio

O app público precisa desta tela idêntica ao protótipo antes de qualquer outra entrega da mesma área. O sucesso é a pessoa cumprir o fluxo abaixo e a inspeção no frame 390×844 não achar diferença de layout, espaçamento, alinhamento ou animação.

## 3. Objetivo e resultado observável

Folha de um gasto. Foto de recibo e moedas além de EUR, BRL, USD e GBP ficam fora.

## 4. Usuários e permissões

| Persona/papel | O que pode fazer | Restrições |
| --- | --- | --- |
| Jean Lucas, sessão mocada | Cumprir o fluxo desta fatia como no protótipo | Dados fixos do protótipo |
| Convidado | Só o que `modo-convidado` libera | Fora desta spec, exceto na própria spec `modo-convidado` |
| Dono, Viajante supremo, Viajante experiente, Assistente júnior | O que `22-novo-gasto.md` e BUSINESS.md §4.3 permitem nesta tela | Papel que a tela não menciona não ganha permissão nova |

## 5. Escopo

### 5.1 Dentro do escopo

- Folha de um gasto. Foto de recibo e moedas além de EUR, BRL, USD e GBP ficam fora.
- Flutter em `mayahtrip-app`, com os dados mocados do protótipo.
- Reutilizar tokens, fontes e movimento definidos na spec `abertura`, sem redefini-los.

### 5.2 Fora de escopo

- As outras fatias: `abertura`, `sign-in`, `sign-up`, `confirm-account`, `forgot-password`, `reset-password`, `inicio`, `notificacoes`, `busca`, `pagina-do-lugar`, `explorar`, `comentarios-curtidas`, `inserir-no-roteiro`, `avaliar-parada`, `acoes-rapidas`, `nova-viagem`, `carteira`, `viagem-capa`, `roteiro-lista`, `roteiro-mapa`, `detalhe-da-parada`, `adicionar-parada`, `gastos`, `mala`, `lista-de-compras`, `documentos-links`, `compartilhar-viagem`, `maya`, `perfil`, `minhas-publicacoes`, `minhas-midias`, `mencoes`, `seguidores`, `perfil-publico`, `privacidade-bloqueios`, `onde-ja-estive`, `aparencia`, `editar-perfil`, `idioma-moeda`, `modo-convidado`.
- API real, painel, site de planos e cobrança em loja.
- Item marcado `A DEFINIR` que o protótipo não desenha. Não inventar a regra.
- O painel lateral do HTML do protótipo.

## 6. Comportamento esperado

Recorte: Folha de um gasto. Foto de recibo e moedas além de EUR, BRL, USD e GBP ficam fora.

O texto abaixo é a regra desta fatia. Medida, tempo e cor citados são critério visual. Menção a uma tela de outra spec é só navegação: o destino pertence à spec daquele slug.

## Acesso
Ações rápidas (destaque), “+ Novo gasto” na aba Gastos, botão Gasto no detalhe da parada, Maya.

## Folha (ordem de cima para baixo)
1. Título “Novo gasto”.
2. **Valor primeiro**: chip de moeda (32 px, “EUR ▾”) + valor em editorial **54 px** (“€ 0”). Abaixo, quando a moeda difere da moeda de exibição: “≈ {valor convertido} no câmbio de hoje”.
3. **EM QUAL VIAGEM?** — chips de viagem (obrigatório escolher; pré-selecionada a viagem aberta ou a primeira).
4. **Quando** — chips 32 px: **📅 Antes da viagem**, cada dia da viagem (datas), **✓ Depois da viagem**. Padrão: o dia aberto no roteiro; fora da viagem, “Antes da viagem”.
5. **Categoria** — chips 34 px com ícone (10 categorias). Padrão: Alimentação.
6. Descrição (opcional, 44 px).
7. **Pagou** — chips com cada participante (padrão: você).
8. **Dividir** — chips com ✓ (padrão: todos). Pelo menos 1 sempre marcado. À direita: “{valor} cada”.
9. **Teclado numérico** próprio (3 colunas, teclas 46 px, raio 16, fundo `#F4F3F8`, número 22 px/600): 1–9, “,” , 0, ⌫.
10. Botão **Salvar em {viagem}** (52 px), desativado enquanto o valor for 0.

## Regras do teclado
- Máximo 7 dígitos e 2 casas decimais; uma vírgula só; “0” inicial é substituído.
- Quando a folha abre com valor sugerido (ex.: preço da parada), o primeiro dígito digitado substitui o valor.
- Moeda: o chip alterna EUR → BRL → USD → GBP. Moeda inicial = moeda de exibição.

## Ao salvar
- Cria o gasto (descrição vazia vira o nome da categoria), muda a viagem para a aba Gastos e fecha.
- Aviso: “Salvo em {viagem} · {Nome} te deve {X}” ou “· você deve {X} a {Nome}” (em viagens de 2 pessoas). Fora da viagem: ação **Ver**.
- Trocar de viagem recalcula participantes, pagador e “quando”.

## A DEFINIR
- Anexar foto do recibo.
- Outras moedas além das 4.

Estados desta fatia:

- Vazio: o que `22-novo-gasto.md` descreve como vazio. Se o arquivo não descreve vazio, a tela não inventa empty state.
- Erro: só a mensagem que o arquivo escreve. Mensagem marcada `A DEFINIR` não é criada.
- Permissão: papéis de BUSINESS.md §4.3 quando a tela cita papel.
- Limite: o número que o arquivo fixa (tentativas, caracteres, dias, itens). O que está `A DEFINIR` não vira limite.

## 7. Critérios de aceite

- [x] **AC-1** — Dado a folha, quando o valor é 0, então Salvar fica desativado; com valor maior que 0 e viagem escolhida, salva; verificado por `novo_gasto_view_model_test.dart`/`novo_gasto_sheet_test.dart`.
- [x] **AC-2** — Dado o teclado, quando a pessoa digita, então há no máximo 7 dígitos inteiros e 2 casas decimais, uma vírgula, e o zero inicial é substituído; verificado por teste de widget.
- [x] **AC-3** — Dado a folha aberta com valor sugerido da parada, quando o primeiro dígito (ou vírgula/⌫) entra, então ele substitui o valor; verificado por teste de widget.
- [x] **AC-4** — Dado um gasto salvo, quando a folha fecha, então a viagem está na aba Gastos, a descrição vazia vira o nome da categoria e o aviso diz quem deve (só em viagens de 2 pessoas); verificado por teste de widget. A troca de aba acontece no chamador (`ViagemCapaView`/`AcoesRapidasSheet`), não na folha — ver D-4.
- [x] **AC-5** — Dado o frame 390×844 e os dados mocados do protótipo, quando esta tela está visível, então alinhamento, espaçamento, tipografia e cor coincidem com `.docs/prototype` e com `22-novo-gasto.md`; verificado por teste de widget em viewport 390 px (achou e corrigiu overflow real na linha "Dividir"). Inspeção visual lado a lado via app real não concluída nesta sessão.
- [ ] **AC-6** — Dado reduzir movimento ativo no aparelho, quando esta tela anima, então as durações caem para cerca de 0 ms; **pendente**, mesmo gap das specs anteriores.

## 8. Premissas e decisões

| ID | Tipo | Descrição | Dono | Validação |
| --- | --- | --- | --- | --- |
| D-1 | decisão | O protótipo e `22-novo-gasto.md` mandam no visual e no movimento. Dado divergente, a inspeção para e a diferença fica registrada antes de implementar. | produto | inspeção lado a lado |
| D-2 | decisão | Dados mocados, código de verificação `1234`, usuário Jean Lucas quando a tela pede alguém logado. | produto | comparar com o protótipo |
| D-3 | decisão | `A DEFINIR` não é implementado como regra nova. | produto | revisão da spec |
| D-4 | decisão (engenharia) | A folha devolve o `Gasto` criado; é o chamador (`ViagemCapaView`, `AcoesRapidasSheet`, folha de `021-detalhe-da-parada.md`) quem decide trocar pra aba Gastos — a folha de novo gasto não conhece `ViagemCapaViewModel`. | app | `lib/ui/features/novo_gasto/views/novo_gasto_sheet.dart` |
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

A fatia `novo-gasto` está pronta quando todos os AC passam no frame 390×844 com os dados mocados do protótipo.

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

- `gastos` em `023-gastos.md`
