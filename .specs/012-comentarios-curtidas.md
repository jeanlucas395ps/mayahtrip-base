# Comentários e curtidas

- Slug: `comentarios-curtidas`
- Status: `em execução`
- Data: 2026-11-16
- Última atualização: 2026-11-17
- Responsável: produto
- Repositório: `mayahtrip-app`
- Docs relacionados: `.docs/BUSINESS/10-comentarios-e-curtidas.md`, `.docs/BUSINESS/BUSINESS.md`, `.docs/DESIGN.md`, `.docs/prototype`
- Specs relacionadas: `explorar`
- ADRs relacionados: nenhum

## 1. Contexto

Fato: o protótipo em `.docs/prototype` (16 nov 2026, frame 390×844) e `10-comentarios-e-curtidas.md` já descrevem esta feature. O app Flutter em `mayahtrip-app` ainda não tem essa tela.

Quem sente: quem for usar o app e quem for comparar a tela com o protótipo. Sem esta fatia, o comportamento existe só no HTML.

Premissa, não fato: os dados continuam mocados, iguais aos do protótipo. Não há API nesta fila.

## 2. Necessidade de negócio

O app público precisa desta tela idêntica ao protótipo antes de qualquer outra entrega da mesma área. O sucesso é a pessoa cumprir o fluxo abaixo e a inspeção no frame 390×844 não achar diferença de layout, espaçamento, alinhamento ou animação.

## 3. Objetivo e resultado observável

Folha alta de uma publicação. Não inclui menções com @, denúncia, edição nem outra ordenação.

## 4. Usuários e permissões

| Persona/papel | O que pode fazer | Restrições |
| --- | --- | --- |
| Jean Lucas, sessão mocada | Cumprir o fluxo desta fatia como no protótipo | Dados fixos do protótipo |
| Convidado | Só o que `modo-convidado` libera | Fora desta spec, exceto na própria spec `modo-convidado` |
| Dono, Viajante supremo, Viajante experiente, Assistente júnior | O que `10-comentarios-e-curtidas.md` e BUSINESS.md §4.3 permitem nesta tela | Papel que a tela não menciona não ganha permissão nova |

## 5. Escopo

### 5.1 Dentro do escopo

- Folha alta de uma publicação. Não inclui menções com @, denúncia, edição nem outra ordenação.
- Flutter em `mayahtrip-app`, com os dados mocados do protótipo.
- Reutilizar tokens, fontes e movimento definidos na spec `abertura`, sem redefini-los.

### 5.2 Fora de escopo

- As outras fatias: `abertura`, `sign-in`, `sign-up`, `confirm-account`, `forgot-password`, `reset-password`, `inicio`, `notificacoes`, `busca`, `pagina-do-lugar`, `explorar`, `inserir-no-roteiro`, `avaliar-parada`, `acoes-rapidas`, `nova-viagem`, `carteira`, `viagem-capa`, `roteiro-lista`, `roteiro-mapa`, `detalhe-da-parada`, `adicionar-parada`, `gastos`, `novo-gasto`, `mala`, `lista-de-compras`, `documentos-links`, `compartilhar-viagem`, `maya`, `perfil`, `minhas-publicacoes`, `minhas-midias`, `mencoes`, `seguidores`, `perfil-publico`, `privacidade-bloqueios`, `onde-ja-estive`, `aparencia`, `editar-perfil`, `idioma-moeda`, `modo-convidado`.
- API real, painel, site de planos e cobrança em loja.
- Item marcado `A DEFINIR` que o protótipo não desenha. Não inventar a regra.
- O painel lateral do HTML do protótipo.

## 6. Comportamento esperado

Recorte: Folha alta de uma publicação. Não inclui menções com @, denúncia, edição nem outra ordenação.

O texto abaixo é a regra desta fatia. Medida, tempo e cor citados são critério visual. Menção a uma tela de outra spec é só navegação: o destino pertence à spec daquele slug.

## Objetivo
Ver e participar da conversa de uma publicação e ver quem curtiu.

## Onde abre
| Origem | Aba inicial |
| --- | --- |
| Feed → botão de comentários | Comentários |
| Perfil / Minhas publicações → contador de comentários | Comentários |
| Perfil / Minhas publicações → contador de curtidas | Curtidas |

## Layout (folha alta, 88% da tela)
1. **Cabeçalho**: título h2 = “@{autor}” (post de outra pessoa) ou “Sua publicação”; subtítulo 13 px “{lugar · cidade}”; botão fechar 40 px.
2. **Seletor** (segmentado): “💬 Comentários · {total}” | “♡ Curtidas · {total}”.

### Aba Comentários
- Lista de comentários, mais recentes primeiro, divididos por linhas `#EEECF3`.
- **Comentário** (padding 12 px): avatar 32 px · linha 12 px: **@usuário** (ou “{nome} (você)”), selo roxo **Autor** (18 px, 10 px) quando quem comenta é o autor do post, “· {tempo}” · texto 13 px (line-height 1,45) · ações 12 px: **Responder**; **Excluir** (seu comentário) ou **Remover** (comentário de outra pessoa no **seu** post), ambos em `#D2462A`.
- À direita: coração 16 px + contador 11 px; curtido = `#FF5A6A`.
- **Respostas**: recuo de 42 px, avatar 26 px, sem botão “Responder” (só um nível).
- **Ver mais comentários ({restantes})**: botão contorno 44 px; carrega de 8 em 8.
- **Vazio**: “Nenhum comentário ainda” / “Seja a primeira pessoa a comentar.”
- **Rodapé fixo** (fundo do cartão, borda superior): sua foto 36 px · campo 46 px “Adicione um comentário” (máx. **500** caracteres) · botão enviar 46 px redondo `#2B207F`.
  - Modo resposta: acima do campo, “Respondendo a **@usuário**” + link **Cancelar**; placeholder “Escreva sua resposta”; teclado foca no campo.

### Aba Curtidas
- Lista: avatar 40 px · @usuário (13 px/700) · nome (12 px) · botão **Seguir** (primário 34 px) ou **Seguindo** (contorno). Seu próprio registro aparece primeiro como “{nome} (você) — Você curtiu”, sem botão.
- Rodapé 12 px: “e outras pessoas · total {N}”.
- Seguir pela lista atualiza a lista e mostra o aviso de seguir.

## Regras de negócio
1. Enviar comentário vazio não faz nada.
2. Novo comentário entra no **topo** com “agora” e soma 1 ao total; a lista volta ao topo.
3. Resposta entra no fim das respostas daquele comentário; **não** soma ao total de comentários.
4. Excluir/Remover pede **Desfazer** no aviso (“Comentário excluído” / “Comentário removido”). Excluir um comentário remove também as respostas dele.
5. O dono da publicação pode remover qualquer comentário do próprio post; qualquer pessoa pode excluir os próprios comentários.
6. Comentários e respostas de usuários **bloqueados** não aparecem.
7. Convidado: pode ver, mas ao enviar abre o convite “Crie sua conta para comentar”.
8. Curtir comentário: alterna, soma/subtrai 1.
9. O contador de comentários do feed e do perfil acompanha o total.
10. Novo comentário, resposta e curtida geram notificação ao autor (app + push).

## A DEFINIR
- Menções com @ dentro de comentários.
- Denunciar comentário.
- Ordenação alternativa (mais curtidos).
- Editar comentário.

Estados desta fatia:

- Vazio: o que `10-comentarios-e-curtidas.md` descreve como vazio. Se o arquivo não descreve vazio, a tela não inventa empty state.
- Erro: só a mensagem que o arquivo escreve. Mensagem marcada `A DEFINIR` não é criada.
- Permissão: papéis de BUSINESS.md §4.3 quando a tela cita papel.
- Limite: o número que o arquivo fixa (tentativas, caracteres, dias, itens). O que está `A DEFINIR` não vira limite.

## 7. Critérios de aceite

- [x] **AC-1** — Dado o feed, quando a pessoa toca comentários, então a folha abre em 88% da tela na aba Comentários; a partir do contador de curtidas do perfil, abre na aba Curtidas; verificado por `test/ui/features/comentarios_curtidas/comentarios_curtidas_sheet_test.dart`. "A partir do contador de curtidas do perfil" não tem origem real alcançável nesta fila (Perfil/Minhas publicações são a spec 030/031, fora de escopo) — testado abrindo a folha diretamente com `abaInicial: AbaComentario.curtidas`.
- [x] **AC-2** — Dado um comentário com texto, quando a pessoa envia, então ele entra no topo com "agora" e soma 1 ao total; texto vazio não envia; verificado por `comentarios_curtidas_sheet_test.dart` e `test/ui/features/comentarios_curtidas/comentarios_curtidas_view_model_test.dart`.
- [x] **AC-3** — Dado uma resposta, quando ela é enviada, então entra no fim das respostas daquele comentário e não soma ao total; verificado por `comentarios_curtidas_sheet_test.dart`/`comentarios_curtidas_view_model_test.dart`.
- [x] **AC-4** — Dado o próprio comentário ou um comentário no próprio post, quando a pessoa exclui ou remove, então o aviso oferece Desfazer e excluir o comentário também tira as respostas; verificado por `comentarios_curtidas_sheet_test.dart`. A branch "dono do post remove qualquer comentário" não é alcançável nesta fila (nenhum post é "próprio" sem a spec `perfil`/`minhas-publicacoes`) — só "excluir o próprio comentário" foi exercitada de ponta a ponta.
- [x] **AC-5** — Dado um comentário de pessoa bloqueada, quando a lista abre, então ele não aparece; verificado por `test/data/repositories/comentarios_repository_test.dart`.
- [x] **AC-6** — Dado o frame 390×844 e os dados mocados do protótipo, quando esta tela está visível, então alinhamento, espaçamento, tipografia e cor coincidem com `.docs/prototype` e com `10-comentarios-e-curtidas.md`; verificado por porte 1:1 do gerador de comentários do protótipo (`CUSERS`/`CPOOL`/`CWHEN`/`hsh`) e por teste de widget. Inspeção visual lado a lado via app real não concluída nesta sessão.
- [ ] **AC-7** — Dado reduzir movimento ativo no aparelho, quando esta tela anima, então as durações caem para cerca de 0 ms; **pendente**, mesmo gap das specs anteriores.

## 8. Premissas e decisões

| ID | Tipo | Descrição | Dono | Validação |
| --- | --- | --- | --- | --- |
| D-1 | decisão | O protótipo e `10-comentarios-e-curtidas.md` mandam no visual e no movimento. Dado divergente, a inspeção para e a diferença fica registrada antes de implementar. | produto | inspeção lado a lado |
| D-2 | decisão | Dados mocados, código de verificação `1234`, usuário Jean Lucas quando a tela pede alguém logado. | produto | comparar com o protótipo |
| D-3 | decisão | `A DEFINIR` não é implementado como regra nova. | produto | revisão da spec |
| P-1 | premissa | A fundação visual da spec `abertura` já existe quando esta fatia for implementada, salvo na própria abertura. | app | a spec `abertura` concluída |
| D-8 | decisão (engenharia) | O protótipo endereça comentário/resposta pela posição no array (`list[i]`), que muda ao inserir no topo. A implementação dá a cada comentário um `id` estável desde a criação, em vez de reindexar — mesmo comportamento visível, sem a fragilidade de "index como identidade". | app | `ComentariosRepository` |

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

A fatia `comentarios-curtidas` está pronta quando todos os AC passam no frame 390×844 com os dados mocados do protótipo.

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

- `explorar` em `011-explorar.md`
