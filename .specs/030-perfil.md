# Perfil

- Slug: `perfil`
- Status: `rascunho`
- Data: 2026-11-16
- Última atualização: 2026-11-16
- Responsável: produto
- Repositório: `mayahtrip-app`
- Docs relacionados: `.docs/BUSINESS/28-perfil.md`, `.docs/BUSINESS/BUSINESS.md`, `.docs/DESIGN.md`, `.docs/prototype`
- Specs relacionadas: `inicio`
- ADRs relacionados: nenhum

## 1. Contexto

Fato: o protótipo em `.docs/prototype` (16 nov 2026, frame 390×844) e `28-perfil.md` já descrevem esta feature. O app Flutter em `mayahtrip-app` ainda não tem essa tela.

Quem sente: quem for usar o app e quem for comparar a tela com o protótipo. Sem esta fatia, o comportamento existe só no HTML.

Premissa, não fato: os dados continuam mocados, iguais aos do protótipo. Não há API nesta fila.

## 2. Necessidade de negócio

O app público precisa desta tela idêntica ao protótipo antes de qualquer outra entrega da mesma área. O sucesso é a pessoa cumprir o fluxo abaixo e a inspeção no frame 390×844 não achar diferença de layout, espaçamento, alinhamento ou animação.

## 3. Objetivo e resultado observável

Perfil de Jean com sessão: capa, jornada resumida, abas com o recorte do perfil, plano e configurações. As telas cheias de publicações, social, mapa, aparência, edição e idioma são outras specs. O botão do plano só abre o destino; o site não é construído aqui.

## 4. Usuários e permissões

| Persona/papel | O que pode fazer | Restrições |
| --- | --- | --- |
| Jean Lucas, sessão mocada | Cumprir o fluxo desta fatia como no protótipo | Dados fixos do protótipo |
| Convidado | Só o que `modo-convidado` libera | Fora desta spec, exceto na própria spec `modo-convidado` |
| Dono, Viajante supremo, Viajante experiente, Assistente júnior | O que `28-perfil.md` e BUSINESS.md §4.3 permitem nesta tela | Papel que a tela não menciona não ganha permissão nova |

## 5. Escopo

### 5.1 Dentro do escopo

- Perfil de Jean com sessão: capa, jornada resumida, abas com o recorte do perfil, plano e configurações. As telas cheias de publicações, social, mapa, aparência, edição e idioma são outras specs. O botão do plano só abre o destino; o site não é construído aqui.
- Flutter em `mayahtrip-app`, com os dados mocados do protótipo.
- Reutilizar tokens, fontes e movimento definidos na spec `abertura`, sem redefini-los.

### 5.2 Fora de escopo

- As outras fatias: `abertura`, `sign-in`, `sign-up`, `confirm-account`, `forgot-password`, `reset-password`, `inicio`, `notificacoes`, `busca`, `pagina-do-lugar`, `explorar`, `comentarios-curtidas`, `inserir-no-roteiro`, `avaliar-parada`, `acoes-rapidas`, `nova-viagem`, `carteira`, `viagem-capa`, `roteiro-lista`, `roteiro-mapa`, `detalhe-da-parada`, `adicionar-parada`, `gastos`, `novo-gasto`, `mala`, `lista-de-compras`, `documentos-links`, `compartilhar-viagem`, `maya`, `minhas-publicacoes`, `minhas-midias`, `mencoes`, `seguidores`, `perfil-publico`, `privacidade-bloqueios`, `onde-ja-estive`, `aparencia`, `editar-perfil`, `idioma-moeda`, `modo-convidado`.
- API real, painel, site de planos e cobrança em loja.
- Item marcado `A DEFINIR` que o protótipo não desenha. Não inventar a regra.
- O painel lateral do HTML do protótipo.

## 6. Comportamento esperado

Recorte: Perfil de Jean com sessão: capa, jornada resumida, abas com o recorte do perfil, plano e configurações. As telas cheias de publicações, social, mapa, aparência, edição e idioma são outras specs. O botão do plano só abre o destino; o site não é construído aqui.

O texto abaixo é a regra desta fatia. Medida, tempo e cor citados são critério visual. Menção a uma tela de outra spec é só navegação: o destino pertence à spec daquele slug.

## Layout (rolagem; 120 px de folga na base)
1. **Capa** 200 px (foto) com degradê escuro no topo. Topo (52 px): etiqueta branca 90% “📍 {cidade, país}” (30 px) e botão vidro “⋯” → menu do perfil.
2. **Foto do usuário** — **circular 104 px**, borda 5 px na cor do fundo, sombra `0 8px 24px rgba(21,18,46,.18)`, sobrepondo a capa em 52 px. Selo lima 32 px com câmera no canto inferior direito. Toque → escolher nova foto (ver `34`).
3. À direita da foto: **✏️ Editar perfil** (contorno 40 px) + **Compartilhar** (ícone 40 px, aviso “Link do perfil copiado”).
4. Nome editorial **36 px**; “@usuário · Viajante curioso” (13 px); bio (13 px, line-height 1,5); link (roxo, ícone de link).
5. Contadores (14 px): **seguidores** e **seguindo** (toque → `30-social.md`), **posts** (sem toque).
6. **Jornada até aqui** (cartão, padding 16 px):
   - Título h2 + link “↗ Divulgar” (aviso “Cartão da jornada copiado para compartilhar”).
   - Grade 3 × 2 (espaço 8 px). Cada indicador: borda `#E5E3EC`, raio 18 px, padding 12 px; **ícone padronizado** em quadrado 32 px (raio 11) **`#2B207F` com ícone lima 16 px** e sombra roxa; número h2 20 px à direita; rótulo 12 px/700 `#5E5A73` abaixo. Ao passar o dedo/mouse, o ícone gira −6° e cresce 6% (mola).
     | Ícone | Indicador | Regra | Toque |
     | --- | --- | --- | --- |
     | globo | Continentes | Continentes com país visitado | Onde já estive |
     | bandeira | Países | Países visitados | Onde já estive |
     | prédio | Cidades | Cidades de viagens passadas | Onde já estive |
     | pin | Lugares | Paradas visitadas (`A DEFINIR` regra) | — |
     | rota | Km viajados | `A DEFINIR` regra | — |
     | carteira | Viagens | Viagens na carteira + passadas | — |
   - **Mini mapa-múndi** (fundo `#F0EEF6`, raio 18 px) com países visitados/planejados (ver `32`) e etiqueta “X% do mundo · N planejados”. Toque → Onde já estive.
7. **Abas** (segmentado): **Publicações · Mídia · Menções**.
   - Publicações: **até 3** cartões; se houver mais, botão “Ver mais N publicações ›” → `29`.
   - Mídia: grade 3 colunas (proporção 4:5, espaço 4 px, raio 18 px no conjunto) com **até 9** itens; vídeos com duração. Mais de 9 → “Ver todas as N mídias ›”.
   - Menções: **até 5**; mais → “Ver todas as N menções ›”.
8. **Plano** (bloco `#2B207F`, raio 22 px): coroa em quadrado lima 44 px · nome do plano vigente · uma linha de apoio · botão lima. Free: “Conheça os benefícios do plano PRO” e **Ver PRO**. PRO: “Seu plano está ativo” e **Gerenciar plano**. Os dois botões abrem o site de planos no navegador do aparelho (`WEB/01`). O app não cobra.
9. **Configurações** (cartão):
   - **Aparência** com segmentado Automático · Claro · Noturno (ver `33`).
   - Lugares onde já estive → `32` · Privacidade e bloqueios → `31` · Preferências de viagem (`A DEFINIR`) · Meus documentos (`A DEFINIR`) · **Idioma e moeda** (mostra “Minha localização” ou “Personalizado”) → `35` · Notificações → `06`.
   - **Sair** (vermelho `#D2462A`) → encerra a sessão e volta ao login.

## Cartão de publicação
- Cabeçalho: sua foto 34 px · nome · “{lugar} · {cidade} · {mês ano}” · estrelas (nota) · botão “⋯” (34 px) → menu da publicação (`29`).
- Mídia 220 px; vídeo mostra duração; várias mídias mostram “1/N”; arquivada mostra “Arquivado”.
- Legenda 13 px; rodapé 12 px: **♡ curtidas** (toque → aba Curtidas de `10`), **💬 comentários** (toque → aba Comentários de `10`), “🔖 Salvo por N”.

## Menu do perfil (⋯)
Compartilhar perfil · Copiar link do perfil · Privacidade e bloqueios.

## Regras
- Convidado não acessa o Perfil (convite para criar conta).
- Removidos do perfil: botões “Meu mapa”, selo “Explorador”, selo verificado.

Estados desta fatia:

- Vazio: o que `28-perfil.md` descreve como vazio. Se o arquivo não descreve vazio, a tela não inventa empty state.
- Erro: só a mensagem que o arquivo escreve. Mensagem marcada `A DEFINIR` não é criada.
- Permissão: papéis de BUSINESS.md §4.3 quando a tela cita papel.
- Limite: o número que o arquivo fixa (tentativas, caracteres, dias, itens). O que está `A DEFINIR` não vira limite.

## 7. Critérios de aceite

- [ ] **AC-1** — Dado o perfil, quando ele abre, então a capa tem 200 px, a foto circular 104 px sobrepõe 52 px e os contadores de seguidores e seguindo navegam para a spec seguidores; verificado por inspeção e teste de widget.
- [ ] **AC-2** — Dado mais de 3 publicações, quando a aba Publicações do perfil mostra a prévia, então aparecem até 3 cartões e o botão Ver mais abre a spec minhas-publicacoes; mídia até 9 e menções até 5 seguem a mesma regra; verificado por teste de widget.
- [ ] **AC-3** — Dado o bloco do plano, quando a pessoa toca Ver PRO ou Gerenciar plano, então o app pede a abertura do site de planos no navegador e não mostra cobrança; verificado por teste de widget.
- [ ] **AC-4** — Dado Sair, quando a pessoa confirma o toque, então a sessão local acaba e o app volta ao login; verificado por teste de widget.
- [ ] **AC-5** — Dado o frame 390×844 e os dados mocados do protótipo, quando esta tela está visível, então alinhamento, espaçamento, tipografia e cor coincidem com `.docs/prototype` e com `28-perfil.md`; verificado por inspeção lado a lado.
- [ ] **AC-6** — Dado reduzir movimento ativo no aparelho, quando esta tela anima, então as durações caem para cerca de 0 ms; verificado por inspeção.

## 8. Premissas e decisões

| ID | Tipo | Descrição | Dono | Validação |
| --- | --- | --- | --- | --- |
| D-1 | decisão | O protótipo e `28-perfil.md` mandam no visual e no movimento. Dado divergente, a inspeção para e a diferença fica registrada antes de implementar. | produto | inspeção lado a lado |
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
| pin | Lugares | Paradas visitadas (`A DEFINIR` regra) | — | não | produto | antes do refine-spec |
| rota | Km viajados | `A DEFINIR` regra | — | não | produto | antes do refine-spec |
| Lugares onde já estive → `32` · Privacidade e bloqueios → `31` · Preferências de viagem (`A DEFINIR`) · Meus documentos (`A DEFINIR`) · **Idioma e moeda** (mostra “Minha localização” ou “Personalizado”) → `35` · Notificações → `06`. | não | produto | antes do refine-spec |

Nenhuma pergunta acima bloqueia esta spec. A tela mocada copia o que o protótipo já mostra e deixa de fora o que o protótipo não desenha.

## 13. Resultado

A fatia `perfil` está pronta quando todos os AC passam no frame 390×844 com os dados mocados do protótipo.

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
