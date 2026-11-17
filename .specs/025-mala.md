# Mala

- Slug: `mala`
- Status: `rascunho`
- Data: 2026-11-16
- Última atualização: 2026-11-16
- Responsável: produto
- Repositório: `mayahtrip-app`
- Docs relacionados: `.docs/BUSINESS/23-mala.md`, `.docs/BUSINESS/BUSINESS.md`, `.docs/DESIGN.md`, `.docs/prototype`
- Specs relacionadas: `viagem-capa`
- ADRs relacionados: nenhum

## 1. Contexto

Fato: o protótipo em `.docs/prototype` (16 nov 2026, frame 390×844) e `23-mala.md` já descrevem esta feature. O app Flutter em `mayahtrip-app` ainda não tem essa tela.

Quem sente: quem for usar o app e quem for comparar a tela com o protótipo. Sem esta fatia, o comportamento existe só no HTML.

Premissa, não fato: os dados continuam mocados, iguais aos do protótipo. Não há API nesta fila.

## 2. Necessidade de negócio

O app público precisa desta tela idêntica ao protótipo antes de qualquer outra entrega da mesma área. O sucesso é a pessoa cumprir o fluxo abaixo e a inspeção no frame 390×844 não achar diferença de layout, espaçamento, alinhamento ou animação.

## 3. Objetivo e resultado observável

Aba Mala compartilhada da viagem. Remover, editar e mala individual ficam fora. A lista exibida é a do protótipo para a viagem aberta.

## 4. Usuários e permissões

| Persona/papel | O que pode fazer | Restrições |
| --- | --- | --- |
| Jean Lucas, sessão mocada | Cumprir o fluxo desta fatia como no protótipo | Dados fixos do protótipo |
| Convidado | Só o que `modo-convidado` libera | Fora desta spec, exceto na própria spec `modo-convidado` |
| Dono, Viajante supremo, Viajante experiente, Assistente júnior | O que `23-mala.md` e BUSINESS.md §4.3 permitem nesta tela | Papel que a tela não menciona não ganha permissão nova |

## 5. Escopo

### 5.1 Dentro do escopo

- Aba Mala compartilhada da viagem. Remover, editar e mala individual ficam fora. A lista exibida é a do protótipo para a viagem aberta.
- Flutter em `mayahtrip-app`, com os dados mocados do protótipo.
- Reutilizar tokens, fontes e movimento definidos na spec `abertura`, sem redefini-los.

### 5.2 Fora de escopo

- As outras fatias: `abertura`, `sign-in`, `sign-up`, `confirm-account`, `forgot-password`, `reset-password`, `inicio`, `notificacoes`, `busca`, `pagina-do-lugar`, `explorar`, `comentarios-curtidas`, `inserir-no-roteiro`, `avaliar-parada`, `acoes-rapidas`, `nova-viagem`, `carteira`, `viagem-capa`, `roteiro-lista`, `roteiro-mapa`, `detalhe-da-parada`, `adicionar-parada`, `gastos`, `novo-gasto`, `lista-de-compras`, `documentos-links`, `compartilhar-viagem`, `maya`, `perfil`, `minhas-publicacoes`, `minhas-midias`, `mencoes`, `seguidores`, `perfil-publico`, `privacidade-bloqueios`, `onde-ja-estive`, `aparencia`, `editar-perfil`, `idioma-moeda`, `modo-convidado`.
- API real, painel, site de planos e cobrança em loja.
- Item marcado `A DEFINIR` que o protótipo não desenha. Não inventar a regra.
- O painel lateral do HTML do protótipo.

## 6. Comportamento esperado

Recorte: Aba Mala compartilhada da viagem. Remover, editar e mala individual ficam fora. A lista exibida é a do protótipo para a viagem aberta.

O texto abaixo é a regra desta fatia. Medida, tempo e cor citados são critério visual. Menção a uma tela de outra spec é só navegação: o destino pertence à spec daquele slug.

## Layout
1. **Progresso** (cartão): “X de Y prontos” (h3) · à direita “{viagem} · {clima}” (12 px) · barra 8 px roxa.
2. **Sugestão** (enquanto não aceita): caixa `#F1FFD1` com ícone faísca em `#15122E`: “Pelo clima e pelo roteiro, sugerimos **4 itens** que faltam.” + chip **Adicionar** → cria o grupo “Sugestões da Maya” no topo (ex.: Guarda-chuva compacto — “Março tem chuva em 1 a cada 4 dias”; Garrafa reutilizável; Moedas para a Fontana di Trevi; Cópia digital do passaporte). Aviso “4 itens adicionados”. A caixa some depois.
3. **Grupos** (kicker + “x/y” à direita), cada um num cartão: caixa de seleção 30 px (raio 10) + nome 15 px/600 (riscado e `#8C889E` quando pronto) + observação opcional 12 px.
4. Campo “Adicionar item à mala” (50 px) + botão “+” 50 × 50 px.

## Lista padrão (43 itens, 7 grupos)
- **Documentos**: RG ou CNH, Passaporte, Cartão de crédito/débito
- **Roupas**: Camisetas, Calças, Roupa íntima, Tênis/Sapatos confortáveis, Meias, Jaqueta/Casaco, Gorro e cachecol
- **Cuidados pessoais**: Escova de dentes, Pasta de dentes, Shampoo, Desodorante, Hidratante
- **Eletrônicos**: Celular, Carregador de celular, Power bank, Fone de ouvido, Adaptador de tomada
- **Farmácia**: Analgésicos, Medicamentos de uso contínuo, Band-aid
- **Acessórios**: Mochila pequena, Garrafa de água, Cadeado, Guarda-chuva
- **Outros**: Almofada de pescoço, Saco de roupa suja, Lanches

> Viagens criadas pelo assistente começam com uma lista curta (ver `14`). Qual lista usar como padrão definitivo: `A DEFINIR`.

## Regras
1. Marcar/desmarcar atualiza contador e barra. Ao completar tudo: aviso “Mala completa. Boa viagem!”.
2. Item novo entra no **último grupo**; o campo continua focado; aviso “Item adicionado”.
3. A mala é **compartilhada** pelo grupo (uma lista por viagem). Mala individual por pessoa: `A DEFINIR`.
4. Remover/editar item: `A DEFINIR`.
5. Sugestões são geradas a partir de clima e roteiro (não alteram nada sem o toque em “Adicionar”).

Estados desta fatia:

- Vazio: o que `23-mala.md` descreve como vazio. Se o arquivo não descreve vazio, a tela não inventa empty state.
- Erro: só a mensagem que o arquivo escreve. Mensagem marcada `A DEFINIR` não é criada.
- Permissão: papéis de BUSINESS.md §4.3 quando a tela cita papel.
- Limite: o número que o arquivo fixa (tentativas, caracteres, dias, itens). O que está `A DEFINIR` não vira limite.

## 7. Critérios de aceite

- [ ] **AC-1** — Dado itens da mala, quando a pessoa marca ou desmarca, então o contador e a barra atualizam; ao completar todos, o aviso diz “Mala completa. Boa viagem!”; verificado por teste de widget.
- [ ] **AC-2** — Dado a sugestão ainda não aceita, quando a pessoa toca Adicionar, então o grupo Sugestões da Maya entra no topo com os 4 itens e a caixa some; verificado por teste de widget.
- [ ] **AC-3** — Dado um nome no campo, quando a pessoa adiciona, então o item entra no último grupo, o campo segue focado e o aviso diz “Item adicionado”; verificado por teste de widget.
- [ ] **AC-4** — Dado o frame 390×844 e os dados mocados do protótipo, quando esta tela está visível, então alinhamento, espaçamento, tipografia e cor coincidem com `.docs/prototype` e com `23-mala.md`; verificado por inspeção lado a lado.
- [ ] **AC-5** — Dado reduzir movimento ativo no aparelho, quando esta tela anima, então as durações caem para cerca de 0 ms; verificado por inspeção.

## 8. Premissas e decisões

| ID | Tipo | Descrição | Dono | Validação |
| --- | --- | --- | --- | --- |
| D-1 | decisão | O protótipo e `23-mala.md` mandam no visual e no movimento. Dado divergente, a inspeção para e a diferença fica registrada antes de implementar. | produto | inspeção lado a lado |
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
| Viagens criadas pelo assistente começam com uma lista curta (ver `14`). Qual lista usar como padrão definitivo: `A DEFINIR`. | não | produto | antes do refine-spec |
| 3. A mala é **compartilhada** pelo grupo (uma lista por viagem). Mala individual por pessoa: `A DEFINIR`. | não | produto | antes do refine-spec |
| 4. Remover/editar item: `A DEFINIR`. | não | produto | antes do refine-spec |

Nenhuma pergunta acima bloqueia esta spec. A tela mocada copia o que o protótipo já mostra e deixa de fora o que o protótipo não desenha.

## 13. Resultado

A fatia `mala` está pronta quando todos os AC passam no frame 390×844 com os dados mocados do protótipo.

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
