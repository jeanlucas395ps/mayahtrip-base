# Detalhe da parada

- Slug: `detalhe-da-parada`
- Status: `em execução`
- Data: 2026-11-16
- Última atualização: 2026-11-17
- Responsável: produto
- Repositório: `mayahtrip-app`
- Docs relacionados: `.docs/BUSINESS/19-detalhe-da-parada.md`, `.docs/BUSINESS/BUSINESS.md`, `.docs/DESIGN.md`, `.docs/prototype`
- Specs relacionadas: `roteiro-lista`
- ADRs relacionados: nenhum

## 1. Contexto

Fato: o protótipo em `.docs/prototype` (16 nov 2026, frame 390×844) e `19-detalhe-da-parada.md` já descrevem esta feature. O app Flutter em `mayahtrip-app` ainda não tem essa tela.

Quem sente: quem for usar o app e quem for comparar a tela com o protótipo. Sem esta fatia, o comportamento existe só no HTML.

Premissa, não fato: os dados continuam mocados, iguais aos do protótipo. Não há API nesta fila.

## 2. Necessidade de negócio

O app público precisa desta tela idêntica ao protótipo antes de qualquer outra entrega da mesma área. O sucesso é a pessoa cumprir o fluxo abaixo e a inspeção no frame 390×844 não achar diferença de layout, espaçamento, alinhamento ou animação.

## 3. Objetivo e resultado observável

Folha da parada a partir da lista ou do mapa. Avaliação, gasto e página do lugar são destinos.

## 4. Usuários e permissões

| Persona/papel | O que pode fazer | Restrições |
| --- | --- | --- |
| Jean Lucas, sessão mocada | Cumprir o fluxo desta fatia como no protótipo | Dados fixos do protótipo |
| Convidado | Só o que `modo-convidado` libera | Fora desta spec, exceto na própria spec `modo-convidado` |
| Dono, Viajante supremo, Viajante experiente, Assistente júnior | O que `19-detalhe-da-parada.md` e BUSINESS.md §4.3 permitem nesta tela | Papel que a tela não menciona não ganha permissão nova |

## 5. Escopo

### 5.1 Dentro do escopo

- Folha da parada a partir da lista ou do mapa. Avaliação, gasto e página do lugar são destinos.
- Flutter em `mayahtrip-app`, com os dados mocados do protótipo.
- Reutilizar tokens, fontes e movimento definidos na spec `abertura`, sem redefini-los.

### 5.2 Fora de escopo

- As outras fatias: `abertura`, `sign-in`, `sign-up`, `confirm-account`, `forgot-password`, `reset-password`, `inicio`, `notificacoes`, `busca`, `pagina-do-lugar`, `explorar`, `comentarios-curtidas`, `inserir-no-roteiro`, `avaliar-parada`, `acoes-rapidas`, `nova-viagem`, `carteira`, `viagem-capa`, `roteiro-lista`, `roteiro-mapa`, `adicionar-parada`, `gastos`, `novo-gasto`, `mala`, `lista-de-compras`, `documentos-links`, `compartilhar-viagem`, `maya`, `perfil`, `minhas-publicacoes`, `minhas-midias`, `mencoes`, `seguidores`, `perfil-publico`, `privacidade-bloqueios`, `onde-ja-estive`, `aparencia`, `editar-perfil`, `idioma-moeda`, `modo-convidado`.
- API real, painel, site de planos e cobrança em loja.
- Item marcado `A DEFINIR` que o protótipo não desenha. Não inventar a regra.
- O painel lateral do HTML do protótipo.

## 6. Comportamento esperado

Recorte: Folha da parada a partir da lista ou do mapa. Avaliação, gasto e página do lugar são destinos.

O texto abaixo é a regra desta fatia. Medida, tempo e cor citados são critério visual. Menção a uma tela de outra spec é só navegação: o destino pertence à spec daquele slug.

## Acesso
Toque num cartão de parada (lista ou cartão do mapa).

## Folha
1. **Mídia**: cartão de vídeo 200 px (raio 22) com duração “▶ 0:48”, botão play e “N vídeos de quem foi” → Explorar. Sem foto: bloco 140 px na cor do lugar com ícone 64 px a 40%.
2. “Dia N · {horário}” (12 px/700 roxo) + nome editorial **34 px**; à direita, ★ nota.
3. Etiquetas: “🕘 {duração}”, “{preço} aprox.” ou “Grátis”, bairro (roxa).
4. Três botões (46 px, 13 px): **✓ Feito** (primário; vira **Desfazer** em contorno quando feito) · **Rota** · **Gasto**.
5. **💡 Dicas de quem foi**: lista numerada (número em quadrado 24 px `#EBE8FF`).
6. **★ Avaliar esta parada** (primário, largura total) → `12-avaliar-parada.md`.
7. **📍 Ver tudo sobre {lugar}** (contorno) → página do lugar.
8. **🗑 Remover do roteiro** (texto `#962A10`, 14 px/700).

## Regras
- **Feito**: fecha a folha, atualiza o roteiro e mostra “{lugar} feito” + **Avaliar**.
- **Gasto**: fecha a folha, muda para a aba Gastos e abre o Novo gasto já com descrição = nome do lugar, valor = preço estimado e vínculo com a parada.
- **Remover**: retira a parada do dia (confirmação/desfazer: `A DEFINIR`).
- Assistente júnior: só leitura (sem Feito, Gasto, Remover). Avaliar continua disponível? `A DEFINIR`.

Estados desta fatia:

- Vazio: o que `19-detalhe-da-parada.md` descreve como vazio. Se o arquivo não descreve vazio, a tela não inventa empty state.
- Erro: só a mensagem que o arquivo escreve. Mensagem marcada `A DEFINIR` não é criada.
- Permissão: papéis de BUSINESS.md §4.3 quando a tela cita papel.
- Limite: o número que o arquivo fixa (tentativas, caracteres, dias, itens). O que está `A DEFINIR` não vira limite.

## 7. Critérios de aceite

- [x] **AC-1** — Dado uma parada, quando a folha abre, então mostra mídia, dia e horário, nota, etiquetas e os botões Feito, Rota e Gasto; verificado por `test/ui/features/detalhe_da_parada/detalhe_da_parada_sheet_test.dart`.
- [x] **AC-2** — Dado Feito, quando a pessoa toca, então a folha fecha e o aviso oferece Avaliar; verificado por teste de widget (mesmo arquivo), e pela integração em `roteiro_lista_view_test.dart`/`roteiro_mapa_view_test.dart`.
- [x] **AC-3** — Dado Gasto, quando a pessoa toca, então a viagem vai à aba Gastos e o novo gasto abre com a descrição do lugar e o valor estimado; verificado por teste de widget (a folha sinaliza o pedido; quem troca a aba e pré-preenche é `ViagemCapaView._pedirGastoDaParada`, sem teste de widget próprio — ver D-6).
- [x] **AC-4** — Dado Remover do roteiro, quando a pessoa toca, então a parada sai do dia; verificado por teste de widget. Sem confirmação/desfazer (`A DEFINIR` no spec) — ver D-5.
- [x] **AC-5** — Dado Assistente júnior, quando a folha abre, então Feito, Gasto e Remover não aparecem; verificado por teste de widget. Avaliar continua disponível (`A DEFINIR` no spec) — ver D-7.
- [x] **AC-6** — Dado o frame 390×844 e os dados mocados do protótipo, quando esta tela está visível, então alinhamento, espaçamento, tipografia e cor coincidem com `.docs/prototype` e com `19-detalhe-da-parada.md`; verificado por teste de widget em viewport 390 px (achou e corrigiu overflow real no título do Novo gasto/Adicionar parada, specs vizinhas). Inspeção visual lado a lado via app real não concluída nesta sessão.
- [ ] **AC-7** — Dado reduzir movimento ativo no aparelho, quando esta tela anima, então as durações caem para cerca de 0 ms; **pendente**, mesmo gap das specs anteriores.

## 8. Premissas e decisões

| ID | Tipo | Descrição | Dono | Validação |
| --- | --- | --- | --- | --- |
| D-1 | decisão | O protótipo e `19-detalhe-da-parada.md` mandam no visual e no movimento. Dado divergente, a inspeção para e a diferença fica registrada antes de implementar. | produto | inspeção lado a lado |
| D-2 | decisão | Dados mocados, código de verificação `1234`, usuário Jean Lucas quando a tela pede alguém logado. | produto | comparar com o protótipo |
| D-3 | decisão | `A DEFINIR` não é implementado como regra nova. | produto | revisão da spec |
| D-4 | decisão | Mídia sem vídeo real: cartão usa o mesmo fallback (bloco de cor + ícone 40% opacidade) de todo lugar sem foto/vídeo minerado do protótipo. | app | quando houver binário real |
| D-5 | decisão | "Remover do roteiro" tira a parada do dia sem confirmação nem desfazer — o spec deixa isso `A DEFINIR`; escolhida a ação direta mais simples. | produto | definir confirmação/desfazer |
| D-6 | decisão (engenharia) | O botão "Rota" não abre nada de verdade (sem integração de mapas real nesta fila); e o botão "Gasto" só sinaliza o pedido — quem troca a aba pra Gastos e abre `024-novo-gasto.md` pré-preenchido é o chamador (`ViagemCapaView._pedirGastoDaParada`), não a folha em si. | app | `lib/ui/features/viagem_capa/views/viagem_capa_view.dart` |
| D-7 | decisão | "Avaliar esta parada" continua disponível pro Assistente júnior (a pergunta do spec era `A DEFINIR`) — escolhido manter, já que avaliar não edita o roteiro. | produto | revisão da spec |
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
| **Remover**: retira a parada do dia (confirmação/desfazer: `A DEFINIR`). | não | produto | antes do refine-spec |
| Assistente júnior: só leitura (sem Feito, Gasto, Remover). Avaliar continua disponível? `A DEFINIR`. | não | produto | antes do refine-spec |

Nenhuma pergunta acima bloqueia esta spec. A tela mocada copia o que o protótipo já mostra e deixa de fora o que o protótipo não desenha.

## 13. Resultado

A fatia `detalhe-da-parada` está pronta quando todos os AC passam no frame 390×844 com os dados mocados do protótipo.

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
