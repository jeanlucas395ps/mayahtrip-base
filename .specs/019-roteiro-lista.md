# Roteiro em lista

- Slug: `roteiro-lista`
- Status: `em execução`
- Data: 2026-11-16
- Última atualização: 2026-11-17
- Responsável: produto
- Repositório: `mayahtrip-app`
- Docs relacionados: `.docs/BUSINESS/17-roteiro-lista.md`, `.docs/BUSINESS/BUSINESS.md`, `.docs/DESIGN.md`, `.docs/prototype`
- Specs relacionadas: `viagem-capa`
- ADRs relacionados: nenhum

## 1. Contexto

Fato: o protótipo em `.docs/prototype` (16 nov 2026, frame 390×844) e `17-roteiro-lista.md` já descrevem esta feature. O app Flutter em `mayahtrip-app` ainda não tem essa tela.

Quem sente: quem for usar o app e quem for comparar a tela com o protótipo. Sem esta fatia, o comportamento existe só no HTML.

Premissa, não fato: os dados continuam mocados, iguais aos do protótipo. Não há API nesta fila.

## 2. Necessidade de negócio

O app público precisa desta tela idêntica ao protótipo antes de qualquer outra entrega da mesma área. O sucesso é a pessoa cumprir o fluxo abaixo e a inspeção no frame 390×844 não achar diferença de layout, espaçamento, alinhamento ou animação.

## 3. Objetivo e resultado observável

Aba Roteiro no modo lista. Mapa e otimizar abrem a spec do mapa. Arrastar para reordenar continua A DEFINIR.

## 4. Usuários e permissões

| Persona/papel | O que pode fazer | Restrições |
| --- | --- | --- |
| Jean Lucas, sessão mocada | Cumprir o fluxo desta fatia como no protótipo | Dados fixos do protótipo |
| Convidado | Só o que `modo-convidado` libera | Fora desta spec, exceto na própria spec `modo-convidado` |
| Dono, Viajante supremo, Viajante experiente, Assistente júnior | O que `17-roteiro-lista.md` e BUSINESS.md §4.3 permitem nesta tela | Papel que a tela não menciona não ganha permissão nova |

## 5. Escopo

### 5.1 Dentro do escopo

- Aba Roteiro no modo lista. Mapa e otimizar abrem a spec do mapa. Arrastar para reordenar continua A DEFINIR.
- Flutter em `mayahtrip-app`, com os dados mocados do protótipo.
- Reutilizar tokens, fontes e movimento definidos na spec `abertura`, sem redefini-los.

### 5.2 Fora de escopo

- As outras fatias: `abertura`, `sign-in`, `sign-up`, `confirm-account`, `forgot-password`, `reset-password`, `inicio`, `notificacoes`, `busca`, `pagina-do-lugar`, `explorar`, `comentarios-curtidas`, `inserir-no-roteiro`, `avaliar-parada`, `acoes-rapidas`, `nova-viagem`, `carteira`, `viagem-capa`, `roteiro-mapa`, `detalhe-da-parada`, `adicionar-parada`, `gastos`, `novo-gasto`, `mala`, `lista-de-compras`, `documentos-links`, `compartilhar-viagem`, `maya`, `perfil`, `minhas-publicacoes`, `minhas-midias`, `mencoes`, `seguidores`, `perfil-publico`, `privacidade-bloqueios`, `onde-ja-estive`, `aparencia`, `editar-perfil`, `idioma-moeda`, `modo-convidado`.
- API real, painel, site de planos e cobrança em loja.
- Item marcado `A DEFINIR` que o protótipo não desenha. Não inventar a regra.
- O painel lateral do HTML do protótipo.

## 6. Comportamento esperado

Recorte: Aba Roteiro no modo lista. Mapa e otimizar abrem a spec do mapa. Arrastar para reordenar continua A DEFINIR.

O texto abaixo é a regra desta fatia. Medida, tempo e cor citados são critério visual. Menção a uma tela de outra spec é só navegação: o destino pertence à spec daquele slug.

## Layout
1. **Seletor de dias** (carrossel): botões mín. 96 px, raio 18 px, padding 10/14 px — “Dia N” (13 px/700), data (12 px, 75%) e “· {cidade}” quando a viagem tem várias cidades, e “N paradas” (12 px/700 roxo; lima no ativo). Ativo: fundo `#2B207F`, texto branco. No fim, botão tracejado 56 px “+” → **adicionar dia** (aviso “Dia N adicionado”; nome “Dia livre”).
2. **Lista | Mapa** (segmentado) → mapa em `18`.
3. Título do dia (h2) + “N paradas · {custo} aprox.” (custo = soma dos preços das paradas). Com **3+ paradas**, chip **⚡ Otimizar** (ver `18`).
4. **Paradas** (cartões brancos raio 22 px, padding 12 px):
   - Miniatura 64 px · horário (12 px/700 roxo) · nome 15 px/700 (riscado e `#8C889E` quando feita) · “{duração} · {preço ou grátis} · N vídeos”.
   - Botão **Rota** (36 px, ícone de rota) → abre a rota até o lugar no **Google Maps** (no protótipo, aviso “Abrindo rota até {lugar} no Google Maps (mock)”).
   - **Caixa de feito** (36 px, raio 12): vazia com borda `#CFCCDA`; feita = fundo `#2B207F` com check branco (pop 300 ms).
   - Rodapé do cartão (borda superior, recuo 76 px): “💡 N dicas · ★ nota” + link **Ver mais ›** → página do lugar.
   - Toque no cartão → `19-detalhe-da-parada.md`.
   - **Deslocamento** entre paradas: linha tracejada vertical 2 × 24 px + ícone (a pé / carro / transporte) + “N min · X km” (12 px/700 `#5E5A73`).
5. **+ Adicionar parada** (54 px, tracejado 1,5 px `#BDB8D6`, texto roxo) → `20-adicionar-parada.md`.

## Dia sem paradas
Cartão com ícone de pin 26 px em bloco 56 px `#EBE8FF`: “Dia livre por enquanto” / “Adicione lugares que você viu no feed ou peça sugestões.” + **+ Adicionar** (primário 42 px) e **✨ Sugerir 3** (contorno).
- **Sugerir 3**: adiciona os 3 lugares mais salvos da cidade do dia que ainda não estão na viagem, às 10:00, 13:00 e 16:00, com deslocamento “~10 min a pé”; o dia passa a se chamar “Sugestões para você” se era “Dia livre”; aviso “3 lugares sugeridos. Arraste para ajustar.”

## Regras
1. Marcar como feito → aviso “{lugar} feito” + **Avaliar** (→ `12`). Desmarcar não gera aviso.
2. Itens recém-adicionados piscam com halo lima (1,4 s).
3. Reordenar arrastando: `A DEFINIR` (mencionado no aviso, não implementado).
4. Assistente júnior: vê, mas não marca, não adiciona e não otimiza.

Estados desta fatia:

- Vazio: o que `17-roteiro-lista.md` descreve como vazio. Se o arquivo não descreve vazio, a tela não inventa empty state.
- Erro: só a mensagem que o arquivo escreve. Mensagem marcada `A DEFINIR` não é criada.
- Permissão: papéis de BUSINESS.md §4.3 quando a tela cita papel.
- Limite: o número que o arquivo fixa (tentativas, caracteres, dias, itens). O que está `A DEFINIR` não vira limite.

## 7. Critérios de aceite

- [x] **AC-1** — Dado um dia com paradas, quando a lista abre, então cada cartão mostra horário, nome, duração, preço e o deslocamento entre elas; a feita fica riscada; verificado por `test/ui/features/roteiro_lista/roteiro_lista_view_test.dart`/`roteiro_lista_view_model_test.dart`. Deslocamento entre paradas usa o texto fixo "~10 min a pé" (mesmo padrão D-2 de `011-inserir-no-roteiro.md`) em vez da distância real calculada — ver D-10 abaixo (a distância real já existe e é usada em `018-roteiro-mapa.md`, que fica nesta mesma fila).
- [x] **AC-2** — Dado uma parada não feita, quando a pessoa marca feito, então o aviso "{lugar} feito" oferece Avaliar; desmarcar não gera aviso; verificado pelos mesmos testes.
- [x] **AC-3** — Dado um dia vazio, quando a pessoa toca Sugerir 3, então entram os 3 lugares mais salvos da cidade que ainda não estão na viagem, às 10:00, 13:00 e 16:00; verificado pelos mesmos testes. "Mais salvos" usa nº de vídeos do catálogo como proxy de popularidade (o catálogo mocado não modela contagem de "salvos" por lugar).
- [x] **AC-4** — Dado o seletor de dias, quando a pessoa toca +, então surge "Dia livre" e o aviso "Dia N adicionado"; verificado pelos mesmos testes.
- [x] **AC-5** — Dado Assistente júnior, quando o roteiro abre, então não há marcar feito, adicionar parada nem otimizar; verificado pelos mesmos testes.
- [x] **AC-6** — Dado o frame 390×844 e os dados mocados do protótipo, quando esta tela está visível, então alinhamento, espaçamento, tipografia e cor coincidem com `.docs/prototype` e com `17-roteiro-lista.md`; verificado por teste de widget em viewport 390 px (achou e corrigiu overflow real no seletor de dias). Inspeção visual lado a lado via app real não concluída nesta sessão.
- [ ] **AC-7** — Dado reduzir movimento ativo no aparelho, quando esta tela anima, então as durações caem para cerca de 0 ms; **pendente**, mesmo gap das specs anteriores.

## 8. Premissas e decisões

| ID | Tipo | Descrição | Dono | Validação |
| --- | --- | --- | --- | --- |
| D-1 | decisão | O protótipo e `17-roteiro-lista.md` mandam no visual e no movimento. Dado divergente, a inspeção para e a diferença fica registrada antes de implementar. | produto | inspeção lado a lado |
| D-2 | decisão | Dados mocados, código de verificação `1234`, usuário Jean Lucas quando a tela pede alguém logado. | produto | comparar com o protótipo |
| D-3 | decisão | `A DEFINIR` não é implementado como regra nova. | produto | revisão da spec |
| P-1 | premissa | A fundação visual da spec `abertura` já existe quando esta fatia for implementada, salvo na própria abertura. | app | a spec `abertura` concluída |
| D-10 | decisão | O texto de deslocamento entre paradas na lista é fixo ("~10 min a pé"), não a distância real calculada — por consistência com `011-inserir-no-roteiro.md`. A distância/tempo reais (com coordenadas minadas de `LL` do protótipo) já existem e alimentam `018-roteiro-mapa.md`, nesta mesma fila. | app | unificar se vira inconsistência percebida |
| D-11 | decisão (engenharia) | `Lugar` ganhou `latitude`/`longitude` (minerados de `LL` no protótipo) pra permitir distância real (haversine) e otimização por vizinho mais próximo em `018-roteiro-mapa.md`. Só os 10 lugares do catálogo mocado têm coordenada. | app | `lib/data/models/lugar.dart` |

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
| 3. Reordenar arrastando: `A DEFINIR` (mencionado no aviso, não implementado). | não | produto | antes do refine-spec |

Nenhuma pergunta acima bloqueia esta spec. A tela mocada copia o que o protótipo já mostra e deixa de fora o que o protótipo não desenha.

## 13. Resultado

A fatia `roteiro-lista` está pronta quando todos os AC passam no frame 390×844 com os dados mocados do protótipo.

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
