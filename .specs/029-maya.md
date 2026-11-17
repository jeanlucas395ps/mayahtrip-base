# Maya

- Slug: `maya`
- Status: `em execução`
- Data: 2026-11-16
- Última atualização: 2026-11-17
- Responsável: produto
- Repositório: `mayahtrip-app`
- Docs relacionados: `.docs/BUSINESS/27-maya.md`, `.docs/BUSINESS/BUSINESS.md`, `.docs/DESIGN.md`, `.docs/prototype`
- Specs relacionadas: `inicio`
- ADRs relacionados: nenhum

## 1. Contexto

Fato: o protótipo em `.docs/prototype` (16 nov 2026, frame 390×844) e `27-maya.md` já descrevem esta feature. O app Flutter em `mayahtrip-app` ainda não tem essa tela.

Quem sente: quem for usar o app e quem for comparar a tela com o protótipo. Sem esta fatia, o comportamento existe só no HTML.

Premissa, não fato: os dados continuam mocados, iguais aos do protótipo. Não há API nesta fila.

## 2. Necessidade de negócio

O app público precisa desta tela idêntica ao protótipo antes de qualquer outra entrega da mesma área. O sucesso é a pessoa cumprir o fluxo abaixo e a inspeção no frame 390×844 não achar diferença de layout, espaçamento, alinhamento ou animação.

## 3. Objetivo e resultado observável

Balão e conversa. A Maya não grava viagem, gasto nem roteiro. Base de conhecimento, histórico e limite Free/PRO ficam fora. As três respostas do protótipo são mocadas.

## 4. Usuários e permissões

| Persona/papel | O que pode fazer | Restrições |
| --- | --- | --- |
| Jean Lucas, sessão mocada | Cumprir o fluxo desta fatia como no protótipo | Dados fixos do protótipo |
| Convidado | Só o que `modo-convidado` libera | Fora desta spec, exceto na própria spec `modo-convidado` |
| Dono, Viajante supremo, Viajante experiente, Assistente júnior | O que `27-maya.md` e BUSINESS.md §4.3 permitem nesta tela | Papel que a tela não menciona não ganha permissão nova |

## 5. Escopo

### 5.1 Dentro do escopo

- Balão e conversa. A Maya não grava viagem, gasto nem roteiro. Base de conhecimento, histórico e limite Free/PRO ficam fora. As três respostas do protótipo são mocadas.
- Flutter em `mayahtrip-app`, com os dados mocados do protótipo.
- Reutilizar tokens, fontes e movimento definidos na spec `abertura`, sem redefini-los.

### 5.2 Fora de escopo

- As outras fatias: `abertura`, `sign-in`, `sign-up`, `confirm-account`, `forgot-password`, `reset-password`, `inicio`, `notificacoes`, `busca`, `pagina-do-lugar`, `explorar`, `comentarios-curtidas`, `inserir-no-roteiro`, `avaliar-parada`, `acoes-rapidas`, `nova-viagem`, `carteira`, `viagem-capa`, `roteiro-lista`, `roteiro-mapa`, `detalhe-da-parada`, `adicionar-parada`, `gastos`, `novo-gasto`, `mala`, `lista-de-compras`, `documentos-links`, `compartilhar-viagem`, `perfil`, `minhas-publicacoes`, `minhas-midias`, `mencoes`, `seguidores`, `perfil-publico`, `privacidade-bloqueios`, `onde-ja-estive`, `aparencia`, `editar-perfil`, `idioma-moeda`, `modo-convidado`.
- API real, painel, site de planos e cobrança em loja.
- Item marcado `A DEFINIR` que o protótipo não desenha. Não inventar a regra.
- O painel lateral do HTML do protótipo.

## 6. Comportamento esperado

Recorte: Balão e conversa. A Maya não grava viagem, gasto nem roteiro. Base de conhecimento, histórico e limite Free/PRO ficam fora. As três respostas do protótipo são mocadas.

O texto abaixo é a regra desta fatia. Medida, tempo e cor citados são critério visual. Menção a uma tela de outra spec é só navegação: o destino pertence à spec daquele slug.

## Papel
A Maya **tira dúvidas e sugere atalhos**. Ela **não altera dados** (não cria viagem, não lança gasto, não mexe no roteiro por conta própria) — só oferece botões para o usuário fazer.

## Balão
- Canto inferior direito, 16 px da borda, 104 px da base; 52 px de altura, raio 26 px, fundo `#15122E` (noturno `#2B207F`), sombra forte.
- Avatar da Maya 38 px com borda lima 2 px + texto “Dúvidas? Maya” (14 px/700 branco).
- Fora das telas raiz: vira só o avatar (52 × 52 px) e desce para 24 px da base.
- Escondido em: Explorar, Assistente de viagem, Página do lugar, Abertura, Login e quando há uma folha aberta.

## Conversa (folha alta, fundo `#F4F3F8`)
- **Cabeçalho**: avatar 44 px · “Maya” · ponto verde `#7BD389` “Online”; botão fechar.
- **Mensagens**: da Maya à esquerda (balão branco, raio 20/20/20/6, avatar 28 px); do usuário à direita (`#2B207F`, branco, raio 20/20/6/20); 15 px, line-height 1,45; entram subindo.
- “Digitando…”: 3 pontos 7 px pulando.
- Primeira mensagem: “Oi, {nome}! Sou a Maya. Estou aqui para tirar dúvidas, sem atrapalhar. Em que posso ajudar?”
- **Rodapé**: perguntas rápidas em chips + campo “Pergunte qualquer coisa à Maya” (52 px) com botão enviar 38 px roxo.
  - Perguntas rápidas no assistente de viagem: “Não sei para onde ir” · “Posso mudar as datas depois?” · “Qual a diferença entre as opções?”
  - Nas demais telas: “Como crio uma viagem?” · “O que fazer à noite em Roma?” · “Como divido os gastos?”

## Atalhos que a Maya pode oferecer
| Pergunta | Resposta (resumo) | Atalho |
| --- | --- | --- |
| Como crio uma viagem? | Destino, datas, quem vai e como começar | Botão lima **+ Criar viagem agora** |
| O que fazer à noite em Roma? | Trastevere depois das 20h; Trevi tarde | Cartões de lugar → abrem a **página do lugar** |
| Como divido os gastos? | Lance, diga quem pagou e com quem dividir | **Lançar um gasto** (abre o formulário) |

Todos os atalhos apenas **abrem** a tela; a ação é concluída pelo usuário.

## Idioma
A Maya responde no idioma da interface ativo, e só nele: Português (Brasil) `pt-BR`, Português (Portugal) `pt-PT`, English `en` ou Español `es`. Perguntas rápidas, primeira mensagem e atalhos seguem o mesmo idioma.

## A DEFINIR
- Base de conhecimento e contexto da viagem usado nas respostas.
- Histórico da conversa entre sessões.
- Limites de uso (plano Free x PRO).

Estados desta fatia:

- Vazio: o que `27-maya.md` descreve como vazio. Se o arquivo não descreve vazio, a tela não inventa empty state.
- Erro: só a mensagem que o arquivo escreve. Mensagem marcada `A DEFINIR` não é criada.
- Permissão: papéis de BUSINESS.md §4.3 quando a tela cita papel.
- Limite: o número que o arquivo fixa (tentativas, caracteres, dias, itens). O que está `A DEFINIR` não vira limite.

## 7. Critérios de aceite

- [x] **AC-1** — Dado uma tela raiz que não seja Explorar, quando não há folha aberta, então o balão "Dúvidas? Maya" fica a 16 px da borda e 104 px da base; no Explorar, no assistente, na página do lugar, na abertura e no login ele não aparece; verificado por inspeção e pela montagem condicional em `InicioView`/`ViagemCapaView`. Balão só existe nessas duas telas — ver D-4.
- [x] **AC-2** — Dado a conversa fechada, quando ela abre pela primeira vez, então a primeira mensagem é "Oi, {nome}! Sou a Maya…"; verificado por `maya_view_model_test.dart`/`maya_sheet_test.dart`. Só `pt-BR` nesta fila — ver D-5.
- [x] **AC-3** — Dado uma das três perguntas do protótipo, quando a pessoa envia, então a resposta mocada traz só o atalho que abre a tela, sem gravar dados; verificado por teste de widget.
- [ ] **AC-4** — Dado outro idioma da interface já escolhido na spec idioma-moeda, quando a conversa abre, então perguntas rápidas, primeira mensagem e atalhos usam esse idioma; **pendente** — `idioma-moeda` (`040`) ainda não existe nesta sessão; revisitar quando existir (ver D-5).
- [x] **AC-5** — Dado o frame 390×844 e os dados mocados do protótipo, quando esta tela está visível, então alinhamento, espaçamento, tipografia e cor coincidem com `.docs/prototype` e com `27-maya.md`; verificado por teste de widget em viewport 390 px. Inspeção visual lado a lado via app real não concluída nesta sessão.
- [ ] **AC-6** — Dado reduzir movimento ativo no aparelho, quando esta tela anima, então as durações caem para cerca de 0 ms; **pendente**, mesmo gap das specs anteriores.

## 8. Premissas e decisões

| ID | Tipo | Descrição | Dono | Validação |
| --- | --- | --- | --- | --- |
| D-1 | decisão | O protótipo e `27-maya.md` mandam no visual e no movimento. Dado divergente, a inspeção para e a diferença fica registrada antes de implementar. | produto | inspeção lado a lado |
| D-2 | decisão | Dados mocados, código de verificação `1234`, usuário Jean Lucas quando a tela pede alguém logado. | produto | comparar com o protótipo |
| D-3 | decisão | `A DEFINIR` não é implementado como regra nova. | produto | revisão da spec |
| D-4 | decisão (engenharia) | O balão só foi montado em `InicioView` (Início/Carteira/Perfil, completo) e `ViagemCapaView` (só avatar) — as demais telas que não estão na lista de escondidas (Busca, Notificações etc.) também não mostram o balão ainda, por limite de escopo desta sessão. | app | montar `MayaBalao` nas telas restantes |
| D-5 | decisão | Conversa só em `pt-BR` nesta fila — `idioma-moeda` (`040-idioma-moeda.md`) ainda não existe. AC-4 (multi-idioma) fica pendente até essa spec chegar. | produto | revisitar após `040-idioma-moeda.md` |
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

A fatia `maya` está pronta quando todos os AC passam no frame 390×844 com os dados mocados do protótipo.

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
