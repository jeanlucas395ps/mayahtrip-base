# Avaliar parada

- Slug: `avaliar-parada`
- Status: `em execução`
- Data: 2026-11-16
- Última atualização: 2026-11-17
- Responsável: produto
- Repositório: `mayahtrip-app`
- Docs relacionados: `.docs/BUSINESS/12-avaliar-parada.md`, `.docs/BUSINESS/BUSINESS.md`, `.docs/DESIGN.md`, `.docs/prototype`
- Specs relacionadas: `pagina-do-lugar`
- ADRs relacionados: nenhum

## 1. Contexto

Fato: o protótipo em `.docs/prototype` (16 nov 2026, frame 390×844) e `12-avaliar-parada.md` já descrevem esta feature. O app Flutter em `mayahtrip-app` ainda não tem essa tela.

Quem sente: quem for usar o app e quem for comparar a tela com o protótipo. Sem esta fatia, o comportamento existe só no HTML.

Premissa, não fato: os dados continuam mocados, iguais aos do protótipo. Não há API nesta fila.

## 2. Necessidade de negócio

O app público precisa desta tela idêntica ao protótipo antes de qualquer outra entrega da mesma área. O sucesso é a pessoa cumprir o fluxo abaixo e a inspeção no frame 390×844 não achar diferença de layout, espaçamento, alinhamento ou animação.

## 3. Objetivo e resultado observável

Publicar avaliação com mídia e nota. Limite de mídia, reordenação, moderação e substituição de avaliação anterior continuam fora.

## 4. Usuários e permissões

| Persona/papel | O que pode fazer | Restrições |
| --- | --- | --- |
| Jean Lucas, sessão mocada | Cumprir o fluxo desta fatia como no protótipo | Dados fixos do protótipo |
| Convidado | Só o que `modo-convidado` libera | Fora desta spec, exceto na própria spec `modo-convidado` |
| Dono, Viajante supremo, Viajante experiente, Assistente júnior | O que `12-avaliar-parada.md` e BUSINESS.md §4.3 permitem nesta tela | Papel que a tela não menciona não ganha permissão nova |

## 5. Escopo

### 5.1 Dentro do escopo

- Publicar avaliação com mídia e nota. Limite de mídia, reordenação, moderação e substituição de avaliação anterior continuam fora.
- Flutter em `mayahtrip-app`, com os dados mocados do protótipo.
- Reutilizar tokens, fontes e movimento definidos na spec `abertura`, sem redefini-los.

### 5.2 Fora de escopo

- As outras fatias: `abertura`, `sign-in`, `sign-up`, `confirm-account`, `forgot-password`, `reset-password`, `inicio`, `notificacoes`, `busca`, `pagina-do-lugar`, `explorar`, `comentarios-curtidas`, `inserir-no-roteiro`, `acoes-rapidas`, `nova-viagem`, `carteira`, `viagem-capa`, `roteiro-lista`, `roteiro-mapa`, `detalhe-da-parada`, `adicionar-parada`, `gastos`, `novo-gasto`, `mala`, `lista-de-compras`, `documentos-links`, `compartilhar-viagem`, `maya`, `perfil`, `minhas-publicacoes`, `minhas-midias`, `mencoes`, `seguidores`, `perfil-publico`, `privacidade-bloqueios`, `onde-ja-estive`, `aparencia`, `editar-perfil`, `idioma-moeda`, `modo-convidado`.
- API real, painel, site de planos e cobrança em loja.
- Item marcado `A DEFINIR` que o protótipo não desenha. Não inventar a regra.
- O painel lateral do HTML do protótipo.

## 6. Comportamento esperado

Recorte: Publicar avaliação com mídia e nota. Limite de mídia, reordenação, moderação e substituição de avaliação anterior continuam fora.

O texto abaixo é a regra desta fatia. Medida, tempo e cor citados são critério visual. Menção a uma tela de outra spec é só navegação: o destino pertence à spec daquele slug.

## Objetivo
O usuário pode **avaliar qualquer parada** publicando **1 ou mais fotos ou vídeos**, uma **nota** e uma **legenda**. A avaliação vira uma publicação no perfil e alimenta a página do lugar e o feed.

## Onde abre
- Detalhe da parada → botão **★ Avaliar esta parada**.
- Aviso “{lugar} feito” → ação **Avaliar** (após marcar uma parada como feita).
- Ações rápidas → **Publicar vídeo ou review**.

## Layout (folha alta)
1. Cabeçalho “Avaliar parada” / “{lugar} · {cidade}”.
2. **FOTOS E VÍDEOS · {N}** (kicker): fila horizontal de miniaturas **96 × 128 px**, raio 16 px:
   - Foto: imagem cortada. Vídeo: quadro do vídeo + selo “▶ Vídeo”.
   - A **primeira** mídia recebe o selo lima **Capa**.
   - Botão ✕ (26 px, `rgba(21,18,46,.7)`) no canto remove a mídia.
   - Último item: área tracejada (2 px `#CFCCDA`) “+ Adicionar fotos ou vídeos” que abre a galeria do celular com **seleção múltipla** (fotos e vídeos).
   - Sem mídia: dica 12 px “Adicione pelo menos 1 foto ou vídeo. A primeira mídia vira a capa.”
3. **SUA NOTA**: 5 estrelas em botões 52 × 52 px (raio 16, fundo `#F4F3F8`); selecionadas `#F5A524`, demais `#D5D3DE`. Começa **sem nota**.
4. **LEGENDA**: área de texto (3 linhas, máx. **500** caracteres) “Conte como foi e deixe uma dica para quem vai depois”.
5. **Etiquetas** opcionais (múltipla escolha, chips): Melhor horário · Vale o preço · Fila grande · Romântico · Bom para crianças.
6. Botão **Publicar avaliação** (54 px). Desativado (opacidade 45%) até ter **≥ 1 mídia e nota**. Abaixo, motivo: “Falta adicionar mídia e dar uma nota” / “Falta adicionar pelo menos 1 foto ou vídeo” / “Falta dar uma nota”.

## Regras de negócio
1. Obrigatórios: pelo menos 1 mídia e nota de 1 a 5. Legenda e etiquetas são opcionais (sem legenda, publica “Sem legenda.”).
2. Ao publicar: fecha a folha, cria a publicação no topo de “Publicações” do perfil (curtidas 0, comentários 0, data do mês atual) e mostra “Avaliação publicada em {lugar}” + **Ver** (abre o Perfil).
3. Cartão da publicação: capa = primeira foto (se a primeira mídia for vídeo, mostra duração; se houver mais de uma mídia, selo “1/N”).
4. Convidado → convite “Crie sua conta para avaliar paradas”.
5. Avaliar não depende de a parada estar marcada como feita.

## A DEFINIR
- Máximo de mídias por avaliação, tamanho máximo e duração máxima de vídeo.
- Reordenar mídias / escolher outra capa.
- Moderação antes de publicar.
- Se uma nova avaliação do mesmo lugar substitui ou soma à anterior.

Estados desta fatia:

- Vazio: o que `12-avaliar-parada.md` descreve como vazio. Se o arquivo não descreve vazio, a tela não inventa empty state.
- Erro: só a mensagem que o arquivo escreve. Mensagem marcada `A DEFINIR` não é criada.
- Permissão: papéis de BUSINESS.md §4.3 quando a tela cita papel.
- Limite: o número que o arquivo fixa (tentativas, caracteres, dias, itens). O que está `A DEFINIR` não vira limite.

## 7. Critérios de aceite

- [x] **AC-1** — Dado a folha sem mídia ou sem nota, quando ela abre, então Publicar fica com opacidade 45% e o texto diz o que falta; verificado por `test/ui/features/avaliar_parada/avaliar_parada_sheet_test.dart` e `avaliar_parada_view_model_test.dart` (os 3 motivos: só mídia, só nota, os dois).
- [x] **AC-2** — Dado ao menos uma mídia e uma nota de 1 a 5, quando a pessoa publica, então a folha fecha, a publicação entra no topo com curtidas 0 e a primeira mídia é a capa; verificado pelos mesmos testes. "Entra no topo de Publicações" é o `AvaliacoesRepository`; a tela "Publicações"/"Perfil" de verdade é `030-perfil.md`/`031-minhas-publicacoes.md`, fora de escopo — o aviso "Ver" abre um `DestinoPlaceholder`.
- [x] **AC-3** — Dado mídias escolhidas, quando a primeira é marcada, então ela recebe o selo lima Capa e o ✕ a remove da fila; verificado por `avaliar_parada_sheet_test.dart`/`avaliar_parada_view_model_test.dart`. Sem galeria real nesta fila mocada (D-2): cada toque em "+ Adicionar" cria uma mídia mocada (alternando foto/vídeo), não abre o seletor do sistema.
- [x] **AC-4** — Dado legenda vazia, quando a pessoa publica com mídia e nota, então a publicação mostra "Sem legenda."; verificado por `avaliar_parada_sheet_test.dart`.
- [x] **AC-5** — Dado o frame 390×844 e os dados mocados do protótipo, quando esta tela está visível, então alinhamento, espaçamento, tipografia e cor coincidem com `.docs/prototype` e com `12-avaliar-parada.md`; verificado por teste de widget em viewport 390 px. Inspeção visual lado a lado via app real não concluída nesta sessão.
- [ ] **AC-6** — Dado reduzir movimento ativo no aparelho, quando esta tela anima, então as durações caem para cerca de 0 ms; **pendente**, mesmo gap das specs anteriores.

## 8. Premissas e decisões

| ID | Tipo | Descrição | Dono | Validação |
| --- | --- | --- | --- | --- |
| D-1 | decisão | O protótipo e `12-avaliar-parada.md` mandam no visual e no movimento. Dado divergente, a inspeção para e a diferença fica registrada antes de implementar. | produto | inspeção lado a lado |
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

A fatia `avaliar-parada` está pronta quando todos os AC passam no frame 390×844 com os dados mocados do protótipo.

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

- `pagina-do-lugar` em `010-pagina-do-lugar.md`
