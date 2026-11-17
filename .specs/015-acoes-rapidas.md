# Ações rápidas

- Slug: `acoes-rapidas`
- Status: `em execução`
- Data: 2026-11-16
- Última atualização: 2026-11-17
- Responsável: produto
- Repositório: `mayahtrip-app`
- Docs relacionados: `.docs/BUSINESS/13-acoes-rapidas.md`, `.docs/BUSINESS/BUSINESS.md`, `.docs/DESIGN.md`, `.docs/prototype`
- Specs relacionadas: `inicio`
- ADRs relacionados: nenhum

## 1. Contexto

Fato: o protótipo em `.docs/prototype` (16 nov 2026, frame 390×844) e `13-acoes-rapidas.md` já descrevem esta feature. O app Flutter em `mayahtrip-app` ainda não tem essa tela.

Quem sente: quem for usar o app e quem for comparar a tela com o protótipo. Sem esta fatia, o comportamento existe só no HTML.

Premissa, não fato: os dados continuam mocados, iguais aos do protótipo. Não há API nesta fila.

## 2. Necessidade de negócio

O app público precisa desta tela idêntica ao protótipo antes de qualquer outra entrega da mesma área. O sucesso é a pessoa cumprir o fluxo abaixo e a inspeção no frame 390×844 não achar diferença de layout, espaçamento, alinhamento ou animação.

## 3. Objetivo e resultado observável

Folha do botão +. Os destinos (gasto, viagem, parada, publicar) são outras specs. Publicar sem contexto usa o lugar fixo do protótipo.

## 4. Usuários e permissões

| Persona/papel | O que pode fazer | Restrições |
| --- | --- | --- |
| Jean Lucas, sessão mocada | Cumprir o fluxo desta fatia como no protótipo | Dados fixos do protótipo |
| Convidado | Só o que `modo-convidado` libera | Fora desta spec, exceto na própria spec `modo-convidado` |
| Dono, Viajante supremo, Viajante experiente, Assistente júnior | O que `13-acoes-rapidas.md` e BUSINESS.md §4.3 permitem nesta tela | Papel que a tela não menciona não ganha permissão nova |

## 5. Escopo

### 5.1 Dentro do escopo

- Folha do botão +. Os destinos (gasto, viagem, parada, publicar) são outras specs. Publicar sem contexto usa o lugar fixo do protótipo.
- Flutter em `mayahtrip-app`, com os dados mocados do protótipo.
- Reutilizar tokens, fontes e movimento definidos na spec `abertura`, sem redefini-los.

### 5.2 Fora de escopo

- As outras fatias: `abertura`, `sign-in`, `sign-up`, `confirm-account`, `forgot-password`, `reset-password`, `inicio`, `notificacoes`, `busca`, `pagina-do-lugar`, `explorar`, `comentarios-curtidas`, `inserir-no-roteiro`, `avaliar-parada`, `nova-viagem`, `carteira`, `viagem-capa`, `roteiro-lista`, `roteiro-mapa`, `detalhe-da-parada`, `adicionar-parada`, `gastos`, `novo-gasto`, `mala`, `lista-de-compras`, `documentos-links`, `compartilhar-viagem`, `maya`, `perfil`, `minhas-publicacoes`, `minhas-midias`, `mencoes`, `seguidores`, `perfil-publico`, `privacidade-bloqueios`, `onde-ja-estive`, `aparencia`, `editar-perfil`, `idioma-moeda`, `modo-convidado`.
- API real, painel, site de planos e cobrança em loja.
- Item marcado `A DEFINIR` que o protótipo não desenha. Não inventar a regra.
- O painel lateral do HTML do protótipo.

## 6. Comportamento esperado

Recorte: Folha do botão +. Os destinos (gasto, viagem, parada, publicar) são outras specs. Publicar sem contexto usa o lugar fixo do protótipo.

O texto abaixo é a regra desta fatia. Medida, tempo e cor citados são critério visual. Menção a uma tela de outra spec é só navegação: o destino pertence à spec daquele slug.

## Acesso
Botão central **+** da barra inferior.

## Folha
- Título “O que vamos fazer?”.
- **Destaque — Novo gasto**: bloco `#2B207F`, raio 22 px, padding 18 px, texto branco; ícone de carteira 24 px em quadrado lima 52 px (raio 18); “Novo gasto” (h3) / “Registre em segundos. Divisão automática.” (13 px `#D4CEFC`); seta → `22-novo-gasto.md`.
- Lista (linhas com divisória, padding 14 px vertical); ícones em quadrado **48 px raio 16, fundo `#2B207F`, ícone lima 22 px** com sombra `0 4px 10px rgba(43,32,127,.18)`:
  1. **Nova viagem** — “4 toques e o roteiro está pronto” → `14-nova-viagem.md`.
  2. **Adicionar parada** — “Buscar lugar e escolher o dia” → `20-adicionar-parada.md`.
  3. **Publicar vídeo ou review** — “Ajude quem vai depois de você” → `12-avaliar-parada.md`.
  - Título h3, subtítulo 13 px `#5E5A73`, seta `#9A97AB`.

## Regras
- Convidado: Novo gasto, Adicionar parada e Publicar pedem conta; Nova viagem abre o assistente, mas o botão final pede conta.
- “Publicar vídeo ou review” sem contexto: qual parada é avaliada? No protótipo abre um lugar fixo. Regra real (escolher lugar/parada primeiro): `A DEFINIR`.

Estados desta fatia:

- Vazio: o que `13-acoes-rapidas.md` descreve como vazio. Se o arquivo não descreve vazio, a tela não inventa empty state.
- Erro: só a mensagem que o arquivo escreve. Mensagem marcada `A DEFINIR` não é criada.
- Permissão: papéis de BUSINESS.md §4.3 quando a tela cita papel.
- Limite: o número que o arquivo fixa (tentativas, caracteres, dias, itens). O que está `A DEFINIR` não vira limite.

## 7. Critérios de aceite

- [x] **AC-1** — Dado uma tela raiz, quando a pessoa toca o + da barra, então a folha "O que vamos fazer?" abre com Novo gasto em destaque e as três linhas Nova viagem, Adicionar parada e Publicar; verificado por `test/ui/features/acoes_rapidas/acoes_rapidas_sheet_test.dart` e por `test/ui/features/inicio/inicio_view_test.dart` (botão central da barra).
- [x] **AC-2** — Dado a folha, quando a pessoa toca cada linha, então o destino é a spec correspondente e a folha fecha; verificado por `acoes_rapidas_sheet_test.dart`. "Novo gasto" (`22-novo-gasto.md`) e "Adicionar parada" (`20-adicionar-parada.md`) abrem `DestinoPlaceholder` (fora de escopo desta fila); "Nova viagem" também é placeholder (`14-nova-viagem.md`, fora de escopo); só "Publicar vídeo ou review" abre uma tela real (`avaliar-parada`, spec 014, desta mesma fila).
- [x] **AC-3** — Dado Publicar vídeo ou review, quando não há parada de contexto, então abre a avaliação do lugar fixo do protótipo; verificado por `acoes_rapidas_sheet_test.dart`. O lugar fixo minerado do protótipo (`A.publish:()=>openPublish('trevi')`) é `trevi` (Fontana di Trevi) — a pergunta em aberto original ("qual lugar?") está respondida pelo próprio protótipo, não era de fato `A DEFINIR`.
- [x] **AC-4** — Dado o frame 390×844 e os dados mocados do protótipo, quando esta tela está visível, então alinhamento, espaçamento, tipografia e cor coincidem com `.docs/prototype` e com `13-acoes-rapidas.md`; verificado por mineração de `A.actions`/`SCREENS` do protótipo e teste de widget em viewport 390 px. Inspeção visual lado a lado via app real não concluída nesta sessão.
- [ ] **AC-5** — Dado reduzir movimento ativo no aparelho, quando esta tela anima, então as durações caem para cerca de 0 ms; **pendente**, mesmo gap das specs anteriores.

## 8. Premissas e decisões

| ID | Tipo | Descrição | Dono | Validação |
| --- | --- | --- | --- | --- |
| D-1 | decisão | O protótipo e `13-acoes-rapidas.md` mandam no visual e no movimento. Dado divergente, a inspeção para e a diferença fica registrada antes de implementar. | produto | inspeção lado a lado |
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
| “Publicar vídeo ou review” sem contexto: qual parada é avaliada? No protótipo abre um lugar fixo. Regra real (escolher lugar/parada primeiro): `A DEFINIR`. | não | produto | antes do refine-spec |

Nenhuma pergunta acima bloqueia esta spec. A tela mocada copia o que o protótipo já mostra e deixa de fora o que o protótipo não desenha.

## 13. Resultado

A fatia `acoes-rapidas` está pronta quando todos os AC passam no frame 390×844 com os dados mocados do protótipo.

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
